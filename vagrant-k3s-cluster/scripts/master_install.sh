#!/bin/sh

# Add current node in  /etc/hosts
echo "127.0.1.1 $(hostname)" >> /etc/hosts

# Get current IP adress to launch k3S
current_ip=$(/sbin/ip -o -4 addr list enp0s8 | awk '{print $4}' | cut -d/ -f1)

# If we are on first node, launch k3s with cluster-init, else we join the existing cluster
if [ $(hostname) = "kubemaster1" ]
then
    export INSTALL_K3S_EXEC="server --cluster-init --tls-san $(hostname) --bind-address=${current_ip} --advertise-address=${current_ip} --node-ip=${current_ip} --no-deploy=traefik"
    export INSTALL_K3S_VERSION="v1.16.15+k3s1"
    sh /home/packer/k3s
else
    echo "10.0.0.11  kubemaster1" >> /etc/hosts
    scp -o StrictHostKeyChecking=no root@kubemaster1:/var/lib/rancher/k3s/server/token /tmp/token
    export INSTALL_K3S_EXEC="server --server https://kubemaster1:6443 --token-file /tmp/token --tls-san $(hostname) --bind-address=${current_ip} --advertise-address=${current_ip} --node-ip=${current_ip} --no-deploy=traefik"
    export INSTALL_K3S_VERSION="v1.16.15+k3s1"
    sh /home/packer/k3s
fi

# Wait for node to be ready and disable deployments on it
sleep 15
kubectl taint --overwrite node $(hostname) node-role.kubernetes.io/master=true:NoSchedule