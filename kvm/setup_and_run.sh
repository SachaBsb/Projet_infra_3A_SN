#!/bin/bash

# Stop script on any error
set -e

echo "Configuring libvirt permissions..."

# Add current user to libvirt group
if ! groups $(whoami) | grep -qw libvirt; then
  echo "Adding $(whoami) to the libvirt group..."
  sudo usermod -aG libvirt $(whoami)
  echo "You need to log out and log back in for group changes to take effect."
else
  echo "$(whoami) is already in the libvirt group."
fi

# Ensure libvirt service is running
echo "Ensuring libvirt service is running..."
sudo systemctl restart libvirtd
sudo systemctl enable libvirtd

# Test virsh access
if ! virsh list --all >/dev/null 2>&1; then
  echo "Error: Unable to access libvirt. Check your permissions or libvirt service."
  exit 1
fi
echo "Libvirt is configured and accessible."



echo "Running Terraform to set up infrastructure..."
# Run Terraform commands
terraform init
terraform apply -auto-approve || {
  echo "Error: Terraform apply failed."
  exit 1
}

echo "Updating Ansible inventory..."
# Call update_inventory.sh to generate the inventory
./update_inventory.sh || {
  echo "Error: Failed to update Ansible inventory."
  exit 1
}


echo "Activating Python virtual environment..."
# Activate the virtual environment - if no venv created use python3 -m venv projet-infra-venv
source projet-infra-env/bin/activate || {
  echo "Error: Unable to activate the virtual environment. Ensure 'project-env' exists."
  exit 1
}    

echo "Running Ansible playbooks..."
# Run Ansible playbooks
ansible-playbook -i inventory worker.yml || {
  echo "Error: Ansible worker playbook failed."
  exit 1
}
ansible-playbook -i inventory master.yml || {
  echo "Error: Ansible master playbook failed."
  exit 1
}

echo "Project setup and execution completed successfully!"
