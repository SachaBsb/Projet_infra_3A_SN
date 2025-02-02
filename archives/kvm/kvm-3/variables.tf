
variable "vm_pool_name" { 
  default = "vm_pool"
}

variable "vm_pool_path" { 
  default = "/home/lousteau/Desktop/Projets/learn-terraform-docker-container/kvm-v3/pool"
}

variable "vm_base_name" {
  default = "vm_volume_base"
}

variable "master_name" {
  default = "MasterVm"
}

variable "worker_prefix" {
  default = "WorkerVm"
}

variable "worker_count" {
  default = 2
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
