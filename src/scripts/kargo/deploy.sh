#!/bin/bash
trap 'echo "Failed" > $heat_outputs_path.status; exit;' ERR
cd /opt/kargo

su - centos << EOF
cd /opt/kargo
/usr/bin/ansible-playbook -i /opt/kargo/inventory/inventory.cfg cluster.yml -b -v --private-key=/home/centos/.ssh/id_rsa
EOF
# Insert Script Here
echo "Success" > $heat_outputs_path.status
