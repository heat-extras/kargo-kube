#!/bin/bash

trap 'echo "Failed" > $heat_outputs_path.status; exit;' ERR

if [ "$http_proxy" = "none" ]; then
  unset http_proxy
else
  export HTTP_PROXY=$http_proxy
fi

if [ "$https_proxy" = "none" ]; then
  unset https_proxy
else
  export HTTPS_PROXY=$https_proxy
fi

# Install git
yum install -y git python2-pip
pip install https://pypi.python.org/packages/2.7/J/Jinja2/Jinja2-2.8-py2.py3-none-any.whl

cd /opt
git clone https://github.com/kubernetes-incubator/kargo.git
chown -R centos:centos /opt/kargo
# Insert Script Here
echo "Success" > $heat_outputs_path.status
