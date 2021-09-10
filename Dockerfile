FROM rocker/rstudio:latest

SHELL ["/bin/bash", "-c"]
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install stuff
RUN apt update && apt install -y vim

# create user balter
RUN groupadd -g 1012 balter
RUN useradd -rm -d /home/balter -s /bin/bash -u 1011 -g 1012 balter
RUN usermod -a -G sudo balter
#RUN usermod -a -G rstudio balter
RUN usermod -a -G sudo rstudio
RUN chpasswd <<<balter:weakpass
# configure r executable and restart server
RUN echo "rsession-which-r=/home/balter/conda/bin/R" > /etc/rstudio/rserver.conf
RUN service rstudio-server restart



