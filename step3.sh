
# remote commands to set up an agent

ssh root@beta.agent.io /home/control/bin/mkadmin tim 1234

scp agent.crt root@beta.agent.io:/home/control/etc/agent.crt
scp agent.key root@beta.agent.io:/home/control/etc/agent.key

ssh root@beta.agent.io /usr/sbin/nginx -s stop
ssh root@beta.agent.io /home/control/bin/prime-nginx
