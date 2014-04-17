#!/bin/bash

####
#### AGENT I/O INSTALLATION FOLLOWS
####
#### MUST be run as root
####

apt-get install nginx -y
apt-get install unzip -y

# mail setup
aptitude remove exim4 && aptitude install postfix && postfix stop
aptitude install dovecot-core dovecot-imapd
# aptitude install dovecot-common # might not be necessary

# not sure how this gets installed, but we don't need to keep it
apt-get uninstall whoopsie

# get mongodb from the official mongodb repository, we want 2.6 or later
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | 
tee /etc/apt/sources.list.d/mongodb.list
apt-get update
apt-get install mongodb-org

adduser --system -disabled-login control 
addgroup control

# replace /home/control 
rm -rf /home/control
cp -r AgentKit/services/control /home/control

cd /home/control
mkdir -p nginx/logs
mkdir -p var
mkdir -p workers
chown -R control /home/control
chgrp -R control /home/control

cp upstart/agentio-control.conf /etc/init
initctl start agentio-control

#cd /home/control/control
#nush tools/setup.nu
#/usr/sbin/nginx 
#cd ..

