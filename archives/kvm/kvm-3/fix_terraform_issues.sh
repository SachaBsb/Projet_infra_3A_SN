#!/bin/bash

POOL_DIR="/home/lousteau/Desktop/Projets/learn-terraform-docker-container/kvm-v3/pool"
MASTER_DISK="$POOL_DIR/master_vm_disk.qcow2"
WORKER_DISK0="$POOL_DIR/worker_vm0_disk.qcow2"
WORKER_DISK1="$POOL_DIR/worker_vm1_disk.qcow2"

check_and_set_permissions() {
  local file=$1
  if [ -f "$file" ]; then
    echo "Setting ownership and permissions for $file"
    sudo chown libvirt-qemu:kvm "$file"
    sudo chmod 660 "$file"
  else
    echo "File $file does not exist"
  fi
}

remove_existing_domains() {
  echo "Removing existing libvirt domains"
  sudo virsh destroy master_vm || true
  sudo virsh undefine master_vm || true
  sudo virsh destroy worker_vm0 || true
  sudo virsh undefine worker_vm0 || true
  sudo virsh destroy worker_vm1 || true
  sudo virsh undefine worker_vm1 || true
}

remove_existing_volumes() {
  echo "Removing existing libvirt volumes"
  sudo virsh vol-delete --pool vm_pool master_vm_disk.qcow2 || true
  sudo virsh vol-delete --pool vm_pool worker_vm0_disk.qcow2 || true
  sudo virsh vol-delete --pool vm_pool worker_vm1_disk.qcow2 || true
}

echo "Setting ownership and permissions for $POOL_DIR"
sudo chown -R libvirt-qemu:kvm "$POOL_DIR"
sudo chmod -R 755 "$POOL_DIR"

# Check and set permissions for the disk files
check_and_set_permissions "$MASTER_DISK"
check_and_set_permissions "$WORKER_DISK0"
check_and_set_permissions "$WORKER_DISK1"

# Remove existing domains
remove_existing_domains

# Remove existing volumes
remove_existing_volumes

# Restart the libvirt service
echo "Restarting libvirt service"
sudo systemctl restart libvirtd

# Verify libvirt service status
echo "Verifying libvirt service status"
sudo systemctl status libvirtd

echo "Permissions, domain and volume removal, and service restart completed. You can now run 'terraform apply' again."
