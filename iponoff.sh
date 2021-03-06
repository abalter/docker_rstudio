#!/bin/bash
#
# enable/disable external ip address
#
set -eu -o pipefail

VMNAME=$(curl -s -S \
   -H Metadata-Flavor:Google \
   http://metadata/computeMetadata/v1/instance/hostname | cut -d. -f1)

VMZONE=$(curl -s -S \
   -H Metadata-Flavor:Google \
   http://metadata/computeMetadata/v1/instance/zone | cut -d/ -f4)

VMPROJECT=$(curl -s -S \
   -H Metadata-Flavor:Google \
   http://metadata/computeMetadata/v1/project/project-id)


runWithDelay()
{
    echo "run with delay $1"
    ### Sleep for $1 seconds, then run rest of commands
    sleep "$1";
    shift;
    "${@}";
}

showContext()
{
    echo "showContext"
    ### Show machine info
    echo "NAME $VMNAME"
    echo "PROJECT $VMPROJECT"
    echo "ZONE $VMZONE"
}

disableNetwork()
{
    echo "disableNetwork"
    ### Run command to disable network in background.
    cmd="gcloud compute instances --project ${VMPROJECT} delete-access-config ${VMNAME} --zone=${VMZONE}"
    echo $cmd
    nohup gcloud compute instances --project ${VMPROJECT} delete-access-config ${VMNAME} --zone=${VMZONE} --access-config-name="External NAT"  &> iponoff.log & 
}

enableNetwork()
{
    echo "enableNetwork $timeout"
    ### Run command to enable network in the background
    ### sleep for $timeout minutes
    ### disable networ (in background)
    cmd="gcloud compute instances --project ${VMPROJECT} add-access-config ${VMNAME} --zone=${VMZONE} --access-config-name=\"External NAT\""
    echo $cmd
    nohup gcloud compute instances --project ${VMPROJECT} add-access-config ${VMNAME} --zone=${VMZONE} --access-config-name="External NAT" &
    runWithDelay  $((60*timeout)) disableNetwork &
}

showUsage()
{
echo "
Turn IP address on for TIMEOUT minutes or turn off.

USAGE: 
    $(basename $0) [ -e TIMEOUT | -d ]

OPTIONS:
    -e TIMEOUT: Enable IP address for a number of minutes, the
                smaller of 30 or TIMEOUT.
    -d:         Disable IP address.
    -h:         Show this message.
" >&2
}


while getopts ":e:dh" flag; do
    case "${flag}" in

        e)
            timeout=${OPTARG}
            if [[ timeout -gt 30 ]]; then
                echo "Timeout cannot exceed 30min"
                timeout=30
            fi
            showContext
            echo "$VMNAME: enabling external IP address"
            echo "Network will turn off in $timeout minutes..."
            enableNetwork 
            exit 0
            ;;

        d)
            echo "$VMNAME: disabling external IP address"
            showContext
            disableNetwork 
            exit 0
            ;;

         h)
            showUsage
            exit 0
            ;;

        /?)
            showUsage
            exit 1
            ;;
    esac
done
showUsage
exit 1

