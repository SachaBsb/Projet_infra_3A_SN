#!/bin/bash


# Stop script on any error 
set -e

# Run terraform
echo "Running Terraform to set up infrastructure"
terraform init
terraform apply -auto-approve || {
    echo "Error: Terraform apply failed"
}

# Update inventory
echo "Updating inventory"
vm_ip=$(jq -r '.outputs.vm_ip.value' terraform.tfstate)
cat <<EOF > inventory
[all]
my-first-vm ansible_host=$vm_ip ansible_user=ubuntu ansible_ssh_private_key_file=/home/lousteau/.ssh/id_rsa_terraform
EOF

echo "Inventory updated successfully."


# Copie files in VM
echo "Copy files in VMs"
scp compile_wordcount.sh create_jar.sh run_wordcount.sh ubuntu@$vm_ip:home/ubuntu/scripts
echo "Files copied successfully"

# Ansible playbooks
echo "Install required packages in VMs"
ansible-playbook -i inventory ansible/install_java_requirements.yml
echo "Run wordcount"
ansible-playbook -i inventory ansible/run_java_wordcount.yml


