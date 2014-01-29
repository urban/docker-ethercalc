# Ethercalc
#
# VERSION 0.1

# use the ubuntu base image provided by dotCloud
FROM ubuntu
MAINTAINER Urban "http://urbanfaubion.com"

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# install ethercalc dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-software-properties git python g++ make libssl-dev pkg-config build-essential redis-server

# install node.js
RUN add-apt-repository ppa:chris-lea/node.js
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y nodejs

# install ethercalc
RUN (cd /opt && git clone https://github.com/audreyt/ethercalc.git ethercalc && cd ethercalc && npm install)

# install supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor

# add supervisor settings
ADD supervisor.conf /etc/supervisor/supervisor.conf

# expose ethercalc
EXPOSE  6379 6967

# environment variable
ENV     PORT 6967

# start ethercalc using supervisor
CMD ["supervisord", "-c", "/etc/supervisor/supervisor.conf", "-n"]