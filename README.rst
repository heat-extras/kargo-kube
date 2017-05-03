========
kargo-kube
========

Overview
========
This set of templates uses the heat-lib library of files to deploy a kubernetes
cluster onto an openstack cloud.

You will need to make sure you have the openstack pythoin client installed and
have access to an openstack cloud.

to deploy the cluster you should run the following command.

openstack stack create -t src/kargo-kube.yaml -e src/library.yaml \
-e heat-lib/env/rhel_library.yaml -e ../environment.yaml test-stack --wait

your environment file should look like this:

.. code-block:: yaml
  :caption: environment.yaml
  :name: environemnt-yaml

parameters:
  external_network: ext_float
  dns_nameservers:
    - 8.8.8.8
    - 8.8.4.4
  key: ssh-key
  deployhost_flavor: m1.small
  deployhost_image: CentOS-7-x86_64-GenericCloud
  master_flavor: m1.small
  master_image: CentOS-7-x86_64-GenericCloud
  etcd_flavor: m1.small
  etcd_image: CentOS-7-x86_64-GenericCloud
  node_flavor: m1.small
  node_image: CentOS-7-x86_64-GenericCloud
  server_policy: affinity


  you can now deploy your stack.

  If you want to test the stack do the following.
  determine your master controller ip addresses

.. code::
  openstack server list

  Search for the floating Ip addresses for a
  master server

  ssh to the master.

  Run the following commands

kubectl get pods --all-namespaces 


.. code-block:: bash

kubectl create namespace sock-shop
kubectl apply -n sock-shop -f "https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true"


  kubectl create namespace sock-shop
  git clone https://github.com/microservices-demo/microservices-demo
  cd microservices-demo
  kubectl apply -n sock-shop -f deploy/kubernetes/manifests



To view the shop in your browser you can run the following command to find out the external
port for the service

.. code::

kubectl describe svc front-end -n sock-shop


The output should look like this

.. code-block::

Name:                   front-end
Namespace:              sock-shop
Labels:                 name=front-end
Selector:               name=front-end
Type:                   NodePort
IP:                     XX.XX.XX.XX
Port:                   <unset> 80/TCP
NodePort:               <unset> 30001/TCP
Endpoints:              <none>
Session Affinity:       None

Now connect to any of the nodes ipaddresses with the port to see the shop
e.g. http://xx.xx.xx.xx:300001

To scale up the nodes in the cluster just edit the kargo-kube.yaml file and
increase the node count in the file here.

.. code-block::

node_cluster:
  description: Deploys the node servers
  type: HeatLib::Cluster::Basic
  properties:
    count: 5
    name: node
    key: { get_param: key }


once done then run

.. code-block::

openstack stack update -t src/kargo-kube.yaml -e src/library.yaml \
-e heat-lib/env/rhel_library.yaml -e ../environment.yaml test-stack --wait
