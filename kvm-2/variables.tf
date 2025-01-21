variable "vm_name" {
  default = "test-vm"
}

variable "vm_memory" {
  default = 4096
}

variable "vm_vcpu" {
  default = 2
}

variable "vm_image" {
  # default = "/var/lib/libvirt/images/ubuntu-22.04.qcow2"
  default = "/var/lib/libvirt/images/ubuntu-base.qcow2"
}

variable "vm_network" {
  default = "default"
}
