#!/bin/bash

# Mettre à jour les paquets
apt-get update -y

# Installer Python, Pip, et OpenSSH
apt-get install -y python3 python3-pip openssh-server default-jdk

# Configurer SSH
mkdir -p /var/run/sshd
echo "root:rootpassword" | chpasswd
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
service ssh start

# Installer PySpark
pip3 install pyspark
