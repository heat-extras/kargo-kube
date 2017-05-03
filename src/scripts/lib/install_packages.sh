#!/bin/bash
trap 'echo "Failed" > $heat_outputs_path.status; exit;' ERR

yum -y install git-core

# Insert Script Here
echo "Success" > $heat_outputs_path.status
