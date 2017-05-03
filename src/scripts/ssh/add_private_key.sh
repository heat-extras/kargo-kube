#!/bin/bash
trap 'echo "Failed" > $heat_outputs_path.status; exit;' ERR

# Add pvt ssh key to server

echo "$ssh_pvt_key" >> /home/centos/.ssh/id_rsa
chmod 700 /home/centos/.ssh && chmod 600 /home/centos/.ssh/*
chown -R centos /home/centos/.ssh

echo "$ssh_pvt_key" >> /root/.ssh/id_rsa
chmod 700 /root/.ssh && chmod 600 /root/.ssh/*
chown -R root /root/.ssh

echo "Success" > $heat_outputs_path.status
