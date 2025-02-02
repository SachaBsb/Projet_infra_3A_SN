variable "vm_names" {
  default = ["master_vm", "worker_vm1", "worker_vm2"]
}

variable "vm_base_name" {
  default = "base_volume"
}

variable "vm_count" {
  default = 3
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

# variable "network_ips" { # master and 2 worker nodes
#   type = list(string)
#   default = ["192.168.123.100", "192.168.123.101", "192.168.123.102"]
# }
