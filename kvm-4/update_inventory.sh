#!/bin/bash

# Paths to files
TFSTATE_FILE="terraform.tfstate"
INVENTORY_FILE="inventory"

# Extract IPs from tfstate
VM_IPS=$(jq -r '.outputs.vm_ips.value[]' "$TFSTATE_FILE")

# Define inventory groups
MASTER_GROUP="[master]"
WORKER_GROUP="[worker]"

# Clear and create a new inventory file
echo "[INFO] Updating inventory file..."
echo "$MASTER_GROUP" > "$INVENTORY_FILE"

# Add master VM (first IP)
MASTER_IP=$(echo "$VM_IPS" | head -n 1)
echo "master_vm_0 ansible_host=$MASTER_IP ansible_user=ubuntu ansible_ssh_private_key_file=/home/lousteau/.ssh/id_rsa_terraform ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> "$INVENTORY_FILE"

# Add worker VMs
echo "$WORKER_GROUP" >> "$INVENTORY_FILE"
WORKER_IPS=$(echo "$VM_IPS" | tail -n +2)
WORKER_INDEX=1

for IP in $WORKER_IPS; do
  echo "worker_vm${WORKER_INDEX}_${WORKER_INDEX} ansible_host=$IP ansible_user=ubuntu ansible_ssh_private_key_file=/home/lousteau/.ssh/id_rsa_terraform ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> "$INVENTORY_FILE"
  WORKER_INDEX=$((WORKER_INDEX + 1))
done

echo "[INFO] Inventory file updated successfully!"
