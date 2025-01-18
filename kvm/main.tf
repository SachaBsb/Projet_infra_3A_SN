terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_cloudinit_disk" "vm_cloudinit" {
  name      = "vm-cloudinit"
  user_data = file("cloudinit.yaml")
}

# MASTER
resource "libvirt_volume" "master_disk" {
  name   = var.master_name
  pool   = "default"
  source = var.vm_image
  format = "qcow2"
}

resource "libvirt_domain" "master" {
  name   = var.master_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.master_disk.id
  }

  network_interface {
    network_name   = var.vm_network
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.master_cloudinit.id
}

resource "libvirt_cloudinit_disk" "master_cloudinit" {
  name      = "master-cloudinit"
  user_data = file("cloudinit-master.yaml")
}


# WORKERS
resource "libvirt_volume" "worker_disks" {
  count  = var.worker_count
  name   = "${var.worker_prefix}-${count.index}"
  pool   = "default"
  source = var.vm_image
  format = "qcow2"
}

resource "libvirt_domain" "workers" {
  count = var.worker_count
  name  = "${var.worker_prefix}-${count.index}"
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.worker_disks[count.index].id
  }

  network_interface {
    network_name   = var.vm_network
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.worker_cloudinit[count.index].id
}

resource "libvirt_cloudinit_disk" "worker_cloudinit" {
  count    = var.worker_count
  name     = "${var.worker_prefix}-${count.index}-cloudinit"
  user_data = file("cloudinit-worker.yaml")
}

# OUTPUT POUR LES IPs       Todo : Gestion dynamique des IPs 
output "master_ip" {
  value = libvirt_domain.master.network_interface[0].addresses[0]
}

output "worker_ips" {
  value = [for worker in libvirt_domain.workers : worker.network_interface[0].addresses[0]]
}
