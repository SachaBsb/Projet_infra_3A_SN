#!/bin/bash


# Stop script on any error 
set -e

# # REFRESH SSH KEY
# ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa_terraform -N ""

# Run terraform
echo "Running Terraform to set up infrastructure"
terraform init
terraform apply -auto-approve || {
    echo "Error: Terraform apply failed"
}

####################
# Update inventory #
####################
# Call update_inventory.sh to generate the inventory
./update_inventory.sh || {
  echo "Error: Failed to update Ansible inventory."
  exit 1
}

# #####################
# # Ansible playbooks #
# #####################
# echo "Install required packages in VMs"
# ansible-playbook -i inventory ansible/master_config.yml

# # Copy files in VM
# echo "Copy files in VMs"
# scp script/compile_wordcount.sh script/create_jar.sh script/run_wordcount.sh ubuntu@$vm_ip:/home/ubuntu/script/
# echo "Files copied successfully"


# echo "Run wordcount"
# ansible-playbook -i inventory ansible/run_java_wordcount.yml


