#!/bin/bash

# Update system
echo "Updating system packages..."
sudo apt update

# Install Libvirt and QEMU
echo "Installing Libvirt and QEMU..."
sudo apt install -y libvirt-daemon-system libvirt-daemon libvirt-clients qemu-kvm

# Start and enable Libvirt service
echo "Starting and enabling Libvirt service..."
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# Verify Libvirt
echo "Verifying Libvirt installation..."
sudo systemctl status libvirtd
virsh list --all

# Download and install Terraform
echo "Downloading and installing Terraform..."
TERRAFORM_VERSION="1.5.6" # Change to the desired version
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
sudo mv terraform /usr/local/bin/
rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Verify Terraform installation
echo "Verifying Terraform installation..."
terraform version

echo "Reinstallation completed!"
