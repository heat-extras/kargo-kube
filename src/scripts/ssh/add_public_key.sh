#!/bin/bash
trap 'echo "Failed" > $heat_outputs_path.status; exit;' ERR

# Add pub ssh key to server

echo $ssh_pub_key >> /home/centos/.ssh/authorized_keys
chmod 700 /home/centos/.ssh && chmod 600 /home/centos/.ssh/*
chown -R centos /home/centos/.ssh

echo "Success" > $heat_outputs_path.status
