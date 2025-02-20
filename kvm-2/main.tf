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
  user_data = file("ansible/cloudinit.yml")
}

resource "libvirt_volume" "vm_base" {
  name   = var.vm_name
  pool   = "default"
  source = var.vm_image
  format = "qcow2"
}

resource "libvirt_volume" "vm_disk" {
  name           = "vm-disk.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.vm_base.id
  size           = 20 * 1024 * 1024 * 1024
  format         = "qcow2"
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }
  
  network_interface {
    network_name = var.vm_network
    wait_for_lease = true
  }
 
  cloudinit = libvirt_cloudinit_disk.vm_cloudinit.id

}

output "vm_ip" {
  value = libvirt_domain.vm.network_interface[0].addresses[0]
}


