#!/bin/bash

echo "Generating SSH key"
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa_terraform -N "" || {
    echo "Error: Failed to generate SSH key"
    exit 1
}

echo "SSH key generated successfully"

echo "Show public key to add to cloudinit"
cat ~/.ssh/id_rsa.pub || {
    echo "Error: Failed to show public key"
    exit 1
}

echo "Show public key to add to cloudinit"
# ssh-copy-id -i ~/.ssh/id_rsa_terraform.pub ubuntu@<IP>
# ssh-copy-id -i ~/.ssh/id_rsa_terraform.pub ubuntu@<IP>
# ssh-copy-id -i ~/.ssh/id_rsa_terraform.pub ubuntu@<IP>


# ssh-keygen -f ~/.ssh/known_hosts -R 192.168.123.100
# ssh-keygen -f ~/.ssh/known_hosts -R 192.168.123.101
# ssh-keygen -f ~/.ssh/known_hosts -R 192.168.123.102