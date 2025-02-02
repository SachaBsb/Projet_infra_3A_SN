#!/bin/bash


###################
# CLEAN WORKSPACE #
###################
# virsh list --all
# virsh destroy <vm_name>
# virsh undefine <vm_name>


# Stop script on any error 
set -e

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


#################
# Run terraform #
#################
echo "Running Terraform to set up infrastructure"
terraform init
terraform apply -auto-approve || {
    echo "Error: Terraform apply failed"
}

####################
# Update inventory #
####################
echo "Updating inventory"
master_ip=$(jq -r '.outputs.master_ip.value' terraform.tfstate)     # getting VMs ip addresses from terraform.tfstate 
worker_ips=$(jq -r '.outputs.worker_ips.value[]' terraform.tfstate)

worker_index=1

cat <<EOF > inventory
[master]
master_vm ansible_host=$vm_ip ansible_user=ubuntu ansible_ssh_private_key_file=/home/lousteau/.ssh/id_rsa_terraform

[workers]
EOF
for ip in $worker_ips; do
  echo "worker$worker_index ansible_host=$ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa_terraform" >> inventory
  worker_index=$((worker_index + 1))  # Increment the worker index
done

echo "Inventory updated successfully."


#####################
# Ansible playbooks #
#####################
echo "Install required packages in VMs"
ansible-playbook -i inventory ansible/install_java_requirements.yml

# Copy files in VM
echo "Copy files in VMs"
scp script/compile_wordcount.sh script/create_jar.sh script/run_wordcount.sh ubuntu@$vm_ip:/home/ubuntu/script/
echo "Files copied successfully"


# echo "Run wordcount"
# ansible-playbook -i inventory ansible/run_java_wordcount.yml


