#!/bin/bash
trap 'echo "Failed" > $heat_outputs_path.status; exit;' ERR

cat > /opt/kargo/openrc.sh << EOF
[Docker]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

echo "Success" > $heat_outputs_path.status
