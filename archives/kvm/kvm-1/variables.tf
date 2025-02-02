variable "master_name" {
  default = "kvm_master_vm"
}

variable "worker_count" {
  default = 2
}

variable "worker_prefix" {
  default = "kvm_worker_vm"
}

variable "vm_memory" {
  default = 1024
}

variable "vm_vcpu" {
  default = 1
}

variable "vm_image" {
  default = "/var/lib/libvirt/images/ubuntu-base.qcow2"
}

variable "vm_network" {
  default = "default"
}
