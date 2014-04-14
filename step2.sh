#!/bin/bash

#### AGENT I/O INSTALLATION FOLLOWS

sudo apt-get install nginx -y
sudo apt-get install mongodb -y
sudo apt-get install unzip -y

sudo adduser --system -disabled-login control 
sudo addgroup control

# replace /home/control 
sudo rm -rf /home/control
sudo cp -r AgentKit/services/control /home/control

cd /home/control
sudo mkdir -p nginx/logs
sudo mkdir -p var
sudo mkdir -p workers
sudo chown -R control /home/control
sudo chgrp -R control /home/control

sudo cp upstart/agentio-control.conf /etc/init
sudo initctl start agentio-control

cd /home/control/control
#sudo nush tools/setup.nu
#sudo /usr/sbin/nginx 
cd ..

# not sure how this gets installed, but we don't need to keep it
sudo apt-get uninstall whoopsie
