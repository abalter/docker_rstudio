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
echo "NAME $VMNAME"
echo "PROJECT $VMPROJECT"
echo "ZONE $VMZONE"
while getopts ":ad" flag; do
    case "${flag}" in
        a)
           echo "$VMNAME: enabling external IP address"
           gcloud compute instances --project $VMPROJECT add-access-config "$VMNAME" --zone="$VMZONE"
           exit 0
           ;;
        d)
           echo "$VMNAME: disabling external IP address"
           gcloud compute instances --project $VMPROJECT delete-access-config "$VMNAME" --zone="$VMZONE"
           exit 0
           ;;
    esac
done
echo "script usage: $(basename $0) [-a] [-d]" >&2
exit 1

