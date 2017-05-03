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

IFS=, read -a mstr_names <<< "$(echo $mstr_names | sed "s/u'//g"|tr -d "[] '")"
IFS=, read -a mstr_ips <<< "$(echo $mstr_ips | sed "s/u'//g"|tr -d "[] '")"
IFS=, read -a etcd_names <<< "$(echo $etcd_names | sed "s/u'//g"|tr -d "[] '")"
IFS=, read -a etcd_ips <<< "$(echo $etcd_ips | sed "s/u'//g"|tr -d "[] '")"
IFS=, read -a node_names <<< "$(echo $node_names | sed "s/u'//g"|tr -d "[] '")"
IFS=, read -a node_ips <<< "$(echo $node_ips | sed "s/u'//g"|tr -d "[] '")"

# Clear out the inventory file
echo "" > /opt/kargo/inventory/inventory.cfg
for (( i = 0; i < ${#mstr_names[@]}; i++ ));
do
  echo "${mstr_names[$i]} ansible_ssh_host=${mstr_ips[$i]} ansible_user=centos" >> /opt/kargo/inventory/inventory.cfg
done
for (( i = 0; i < ${#etcd_names[@]}; i++ ));
do
  echo "${etcd_names[$i]} ansible_ssh_host=${etcd_ips[$i]} ansible_user=centos" >> /opt/kargo/inventory/inventory.cfg
done
for (( i = 0; i < ${#node_names[@]}; i++ ));
do
  echo "${node_names[$i]} ansible_ssh_host=${node_ips[$i]} ansible_user=centos" >> /opt/kargo/inventory/inventory.cfg
done
echo "" >> /opt/kargo/inventory/inventory.cfg
echo "" >> /opt/kargo/inventory/inventory.cfg

# master nodes
echo "[kube-master]" >> /opt/kargo/inventory/inventory.cfg
for (( i = 0; i < ${#mstr_names[@]}; i++ ));
do
  echo "${mstr_names[$i]}" >> /opt/kargo/inventory/inventory.cfg
done
echo "" >> /opt/kargo/inventory/inventory.cfg
# etcd nodes
echo "[etcd]" >> /opt/kargo/inventory/inventory.cfg
for (( i = 0; i < ${#etcd_names[@]}; i++ ));
do
  echo "${etcd_names[$i]}" >> /opt/kargo/inventory/inventory.cfg
done
echo "" >> /opt/kargo/inventory/inventory.cfg
# kube nodes
echo "[kube-node]" >> /opt/kargo/inventory/inventory.cfg
for (( i = 0; i < ${#node_names[@]}; i++ ));
do
  echo "${node_names[$i]}" >> /opt/kargo/inventory/inventory.cfg
done
echo "" >> /opt/kargo/inventory/inventory.cfg
echo "[k8s-cluster:children]" >> /opt/kargo/inventory/inventory.cfg
echo "kube-node" >> /opt/kargo/inventory/inventory.cfg
echo "kube-master" >> /opt/kargo/inventory/inventory.cfg

# Insert Script Here
echo "Success" > $heat_outputs_path.status
