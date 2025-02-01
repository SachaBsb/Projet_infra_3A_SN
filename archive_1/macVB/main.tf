resource "null_resource" "vagrant_vm" {
  provisioner "local-exec" {
    command = <<EOT
      vagrant init hashicorp/bionic64
      vagrant up --provider virtualbox
    EOT
  }
}

output "vagrant_vm_status" {
  value = "VirtualBox VM created with Vagrant!"
}
