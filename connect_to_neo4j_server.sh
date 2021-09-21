

#PROJECT_ID=psjh-eacri-data
PROJECT_ID=psjh-238522
NETWORK=projects/phs-205720/global/networks/psjh-connect
SUBNET=projects/phs-205720/regions/us-east1/subnetworks/mgmt01
ZONE=us-east1-b
NEO4J_IMAGE=neo4j-enterprise-1-4-2-2-apoc
VM_NAME=balter-neo4j-2

VM_NAME=$1

# ssh into the vm in the psjh-eacri-biggraph project using
# the internal ip address over the IAP proxy and port
# forward Neo4j ports over the tunnel
#
# Neo4j documented ports
#    HTTP  7473
#    HTTPS 7474
#    Bolt  7687
#
# the "--" is an alternative to using the "--ssh-flag" argument

cmd="
gcloud beta compute ssh \
  --zone ${ZONE} \
  --project ${PROJECT_ID} \
  ${VM_NAME} \
  --tunnel-through-iap \
  -- \
  -L 7473:localhost:7473 \
  -L 7474:localhost:7474 \
  -L 7687:localhost:7687
"

echo $cmd

$cmd

