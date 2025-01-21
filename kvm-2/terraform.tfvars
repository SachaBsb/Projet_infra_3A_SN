vm_name    = "ubuntu-vm"
vm_memory  = 4096
vm_vcpu    = 1
vm_image   = "/var/lib/libvirt/images/ubuntu-22.04.qcow2" # another image volume, hoping it provides a larger disk for the vm
# vm_image   = "/var/lib/libvirt/images/ubuntu-base.qcow2"
vm_network = "default"
