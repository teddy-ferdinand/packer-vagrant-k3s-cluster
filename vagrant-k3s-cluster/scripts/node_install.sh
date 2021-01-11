#!/bin/sh
# Add current node in  /etc/hosts
echo "127.0.1.1 $(hostname)" >> /etc/hosts

# Add kubemaster1 in  /etc/hosts
echo "10.0.0.11  kubemaster1" >> /etc/hosts

# Get current IP adress to launch k3S
current_ip=$(/sbin/ip -o -4 addr list enp0s8 | awk '{print $4}' | cut -d/ -f1)

# Launch k3s as agent
scp -o StrictHostKeyChecking=no root@kubemaster1:/var/lib/rancher/k3s/server/token /tmp/token
export INSTALL_K3S_EXEC="agent --server https://kubemaster1:6443 --token-file /tmp/token --node-ip=${current_ip}"
export INSTALL_K3S_VERSION="v1.16.15+k3s1"
sh /home/packer/k3s
