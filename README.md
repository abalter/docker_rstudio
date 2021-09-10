# Docker Rstudio
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

To use, run `./build && ./run`, after which, you need only to use `.run`
