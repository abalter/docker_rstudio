# Docker Rstudio
## Introduction
I created this recipe to use  on Google Cloud Platform virtual machines. My goal is to be able to launch a 
docker container running RStudio Server with the following:

1. There is a directory `/home/$USER` mapped to my `/home/$USER` directory on the host
1. The container server is configured to use my conda instance for the R executable. This requires adding
   `r-session-which=/home/$USER/conda/bin/R` to the file `/etc/rstudio/rserver.conf`
1. The container is not exposed to the internet for security
1. Internet access to/from the host can be turned on and off

This way:

1. I can limit exposure to my data and conda instance
1. I can limit exposure to sensitive data I might be processing in RStudio

Right now, it "works"

## Prerequisites
1. You can create a VM in GCP
1. You have a directory on that machine at `/home/$USER` that contains a miniconda instance at
   `/home/${USER}/conda`
1. You have installed R into that conda instance such that `which R` ---> `/home/${USER}/conda/bin/R`.

## Usage Instructions
To build the container, run `./build`. To run the container, run `./run`. to access the container, run

`gcloud beta compute ssh --zone ${gcp_zone} ${gcp_vm_name} --project ${gcp_project} --tunnel-through-iap -- -L 8787:localhost:8787`
