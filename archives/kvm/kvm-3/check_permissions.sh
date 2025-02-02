#!/bin/bash

# Define the paths to the files and directories
POOL_DIR="/home/lousteau/Desktop/Projets/learn-terraform-docker-container/kvm-v3/pool"
MASTER_DISK="$POOL_DIR/master_vm_disk.qcow2"
WORKER_DISK0="$POOL_DIR/worker_vm0_disk.qcow2"
WORKER_DISK1="$POOL_DIR/worker_vm1_disk.qcow2"

# Function to check and set permissions
check_and_set_permissions() {
  local file=$1

  if [ -e "$file" ]; then
    echo "Checking permissions for $file"
    ls -l "$file"

    echo "Setting ownership and permissions for $file"
    sudo chown $(whoami):$(whoami) "$file"
    sudo chmod 644 "$file"
  else
    echo "$file does not exist"
  fi
}

# Check and set permissions for the pool directory
echo "Checking permissions for $POOL_DIR"
ls -ld "$POOL_DIR"

echo "Setting ownership and permissions for $POOL_DIR"
sudo chown -R $(whoami):$(whoami) "$POOL_DIR"
sudo chmod -R 755 "$POOL_DIR"

# Check and set permissions for the disk files
check_and_set_permissions "$MASTER_DISK"
check_and_set_permissions "$WORKER_DISK0"
check_and_set_permissions "$WORKER_DISK1"

# Restart the libvirt service
echo "Restarting libvirt service"
sudo systemctl restart libvirtd

echo "Permissions and service restart completed. You can now run 'terraform apply' again."