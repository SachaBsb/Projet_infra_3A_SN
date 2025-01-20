terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"  # Correct provider source
      version = "0.7.1"              # Optional, specify the version you need
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}


resource "libvirt_cloudinit_disk" "vm_cloudinit" {
  name      = "vm-cloudinit"
  user_data = file("cloudinit.yml")
}

resource "libvirt_volume" "vm_disk" {
  name   = var.vm_name
  pool   = "default"
  source = var.vm_image
  format = "qcow2"
}

resource "libvirt_volume" "extra_disk" {
  name   = "extra-disk"
  pool   = "default"
  size   = 10 # GB for the new storage volume
  format = "qcow2"
}

resource "libvirt_domain" "vm" {
  name   = var.vm_name
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.vm_disk.id
  }
  
  disk {
    volume_id = libvirt_volume.extra_disk.id  # Add the new storage volume
  }

  network_interface {
    network_name = var.vm_network
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }
}

