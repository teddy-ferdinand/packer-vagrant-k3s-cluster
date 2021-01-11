#!/bin/sh
# Deploy keys to allow all nodes to connect each others as root
mkdir /root/.ssh/
mv /tmp/id_rsa*  /root/.ssh/

chmod 400 /root/.ssh/id_rsa*
chown root:root  /root/.ssh/id_rsa*

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 400 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys

# Install updates and curl
apt update
apt install -y curl
# Apt cleanup.
apt autoremove -y
apt update

#  Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Download k3s
curl -L https://get.k3s.io -o /home/packer/k3s
chmod +x /home/packer/k3s

# Download Traefik
curl -L https://github.com/containous/traefik/releases/download/v2.2.11/traefik_v2.2.11_linux_amd64.tar.gz -o /home/packer/traefik.tar.gz
cd /home/packer
tar xvfz ./traefik.tar.gz
rm ./traefik.tar.gz
chmod +x /home/packer/traefik