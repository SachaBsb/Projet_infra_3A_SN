#!/bin/bash

# Extract IP addresses from terraform.tfstate
master_ip=$(jq -r '.outputs.master_ip.value' terraform.tfstate)
worker_ips=$(jq -r '.outputs.worker_ips.value[]' terraform.tfstate)

# Generate inventory
cat <<EOF > inventory
[master_vm]
master ansible_host=$master_ip ansible_user=ubuntu ansible_ssh_private_key_file=/home/lousteau/.ssh/id_rsa_terraform


[workers_vm]
$(for ip in $worker_ips; do echo "worker ansible_host=$ip ansible_user=ubuntu ansible_ssh_private_key_file=/home/lousteau/.ssh/id_rsa_terraform
"; done)
EOF

echo "Inventory updated successfully."
