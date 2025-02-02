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
  count     = var.vm_count
  name      = "${var.vm_names[count.index]}_${count.index}_cloudinit"
  user_data = file("ansible/cloudinit.yml")
}

resource "libvirt_volume" "vm_base" {
  name   = var.vm_base_name
  pool   = "default"
  source = var.vm_image
  format = "qcow2"
}

resource "libvirt_volume" "vm_disk" {
  count          = var.vm_count
  name           = "${var.vm_names[count.index]}_${count.index}_disk.qcow2"
  pool           = "default"
  base_volume_id = libvirt_volume.vm_base.id
  size           = 20 * 1024 * 1024 * 1024
  format         = "qcow2"
}

resource "libvirt_domain" "vm" {
  count  = var.vm_count
  name   = "${var.vm_names[count.index]}_${count.index}"
  memory = var.vm_memory
  vcpu   = var.vm_vcpu

  disk {
    volume_id = libvirt_volume.vm_disk[count.index].id
  }
  
  network_interface {
    network_name = var.vm_network
    wait_for_lease = true
    # addresses = [var.network_ips[count.index]]
  }

 
  cloudinit = libvirt_cloudinit_disk.vm_cloudinit[count.index].id

}

output "vm_ips" {
  value = [for vm in libvirt_domain.vm : vm.network_interface[0].addresses[0]]
}

