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

resource "libvirt_pool" "vm_pool" {
  name = var.vm_pool_name
  type = "dir"
  path = var.vm_pool_path
}

resource "libvirt_volume" "vm_base" {
  name   = var.vm_base_name
  pool   = libvirt_pool.vm_pool.name
  source = var.vm_image
  format = "qcow2"
}

##########
# MASTER #
##########
resource "libvirt_cloudinit_disk" "master_vm_cloudinit" {
  name      = "master_vm_cloudinit"
  user_data = file("ansible/master_cloudinit.yml")
}

resource "libvirt_volume" "master_vm_disk" {
  name           = "master_vm_disk.qcow2"
  pool           = libvirt_pool.vm_pool.name
  base_volume_id = libvirt_volume.vm_base.id
  size           = 20 * 1024 * 1024 * 1024
  format         = "qcow2"
}

resource "libvirt_domain" "master_vm" {
  name   = var.master_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.master_vm_disk.id
  }
  
  network_interface {
    network_name = var.vm_network
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.master_vm_cloudinit.id

/*   console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
 */  
}

###########
# WORKERS #
###########
resource "libvirt_cloudinit_disk" "worker_vm_cloudinit" {
  count = var.worker_count
  name      = "${var.worker_prefix}${count.index}_cloudinit"
  user_data = file("ansible/worker_cloudinit.yml")
}

resource "libvirt_volume" "worker_vm_disk" {
  count          = var.worker_count
  name           = "${var.worker_prefix}${count.index}_disk.qcow2"
  pool           = libvirt_pool.vm_pool.name
  base_volume_id = libvirt_volume.vm_base.id
  size           = 20 * 1024 * 1024 * 1024
  format         = "qcow2"
}

resource "libvirt_domain" "workers" {
  count  = var.worker_count
  name   = "${var.worker_prefix}${count.index}"
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.worker_vm_disk[count.index].id
  }
  
  network_interface {
    network_name = var.vm_network
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.worker_vm_cloudinit[count.index].id

/*   console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
 */  
}

output "master_ip" {
  value = libvirt_domain.master_vm.network_interface[0].addresses[0]
}

output "worker_ips" {
  value = [for worker in libvirt_domain.workers : worker.network_interface[0].addresses[0]]
}


