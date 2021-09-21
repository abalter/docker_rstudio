FROM rocker/rstudio:latest

SHELL ["/bin/bash", "-c"]
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# collect build args
ARG USER
ARG UID
ARG GID

# install stuff
RUN apt update && apt install -y \ 
	vim \
	iputils-ping \
	wget

# create user $USER
RUN groupadd -g $GID $USER
RUN useradd -rm -d /home/$USER -s /bin/bash -u $UID -g $GID $USER
RUN usermod -a -G sudo $USER
RUN chpasswd <<<$USER:weakpass


COPY iponoff.sh /home/balter


