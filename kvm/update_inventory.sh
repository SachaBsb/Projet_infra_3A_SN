#!/bin/bash

# Extract IP addresses from terraform.tfstate
master_ip=$(jq -r '.outputs.master_ip.value' terraform.tfstate)
worker_ips=$(jq -r '.outputs.worker_ips.value[]' terraform.tfstate)

# Initialize worker index
worker_index=1

# Generate inventory
cat <<EOF > inventory
[master]
master ansible_host=$master_ip ansible_user=ubuntu ansible_ssh_private_key_file=/home/lousteau/.ssh/id_rsa_terraform

[workers]
EOF
# Loop through worker IPs and increment the worker index
for ip in $worker_ips; do
  echo "worker$worker_index ansible_host=$ip ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa_terraform" >> inventory
  worker_index=$((worker_index + 1))  # Increment the worker index
done


echo "Inventory updated successfully."
