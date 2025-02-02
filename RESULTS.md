# Presentation de l'architecture : 
Plusieurs dossiers, chacun pour des étapes différentes du projet.



## ubuntu :
On a tous les deux commencé le projet avec docker avant de venir vous voir, pour des raisons d’OS (Mac et windows dualboot que j’ai dualbooté pour avoir une session ubuntu).

J’ai continué avec terraform/kvm/ansible et victor a continué avec docker

## kvm : 
J’ai fais plusieurs vms qui faisaient un wordcount qui fonctionnait utilisant un wordcount python (sans pyspark), le projet me semblait terminé mais j’ai recommencé pour utiliser spark/java.


## kvm-2 
### Ce que j'ai fais : 
Une vm sur laquelle tout est installé avec ansible/terraform et qui run un wordcount. 


### Pb rencontrés :
Image de taille insuffisante pour tout télécharger, j’ai testé d’autres images mais rien ne fonctionnait, il fallait finalement faire une extension d’image, utiliser l’image comme base et créer les disk à partir de ces bases dont j’étend l’espace de stockage.

### Solutions : 
Utiliser des scripts pour tout automatiser


### Resultat d'un wordcount sur une machine bien configurée : 
```
kvm-2$ ./setup_x_run.sh 
Running Terraform to set up infrastructure

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of dmacvicar/libvirt from the dependency lock file
- Using previously-installed dmacvicar/libvirt v0.7.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
libvirt_cloudinit_disk.vm_cloudinit: Refreshing state... [id=/var/lib/libvirt/images/vm-cloudinit;8407060c-83fb-442c-b942-f675eecd6762]
libvirt_volume.vm_base: Refreshing state... [id=/var/lib/libvirt/images/lonely-vm]
libvirt_volume.vm_disk: Refreshing state... [id=/var/lib/libvirt/images/vm-disk.qcow2]
libvirt_domain.vm: Refreshing state... [id=563935c5-c20f-4e68-9405-53f5b49278be]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

vm_ip = "192.168.123.209"
Updating inventory
Inventory updated successfully.
Install required packages in VMs

PLAY [Set up Java and Apache Spark for WordCount] *******************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
The authenticity of host '192.168.123.209 (192.168.123.209)' can't be established.
ED25519 key fingerprint is SHA256:XZiQFuZjKL7UYmgSXB+1dNTaA2DKwahs7LuwDORuR5o.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [my-first-vm]

TASK [Wait for apt lock to be released] *****************************************************************************************************************************************
changed: [my-first-vm]

TASK [Kill any existing apt-get processes] **************************************************************************************************************************************
changed: [my-first-vm]

TASK [Update apt package index] *************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Create directory for Spark installation] **********************************************************************************************************************************
changed: [my-first-vm]

TASK [Install OpenJDK] **********************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Extract JDK] **************************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Download Spark] ***********************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Extract Spark archive] ****************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Set up Spark environment variables in .bashrc] ****************************************************************************************************************************
changed: [my-first-vm]

TASK [Reload .bashrc] ***********************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Create directory for WordCount] *******************************************************************************************************************************************
changed: [my-first-vm]

TASK [Create directory for Scripts] *********************************************************************************************************************************************
changed: [my-first-vm]

TASK [Copy WordCount Java file to VM] *******************************************************************************************************************************************
changed: [my-first-vm]

TASK [Copy input file to VM] ****************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Install Maven (optional, for dependency management)] **********************************************************************************************************************
changed: [my-first-vm]

TASK [Set up environment variables in .bashrc] **********************************************************************************************************************************
changed: [my-first-vm]

TASK [Verify Java installation] *************************************************************************************************************************************************
changed: [my-first-vm]

PLAY RECAP **********************************************************************************************************************************************************************
my-first-vm                : ok=18   changed=17   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Copy files in VMs
compile_wordcount.sh                                                                                                                           100%  351    44.6KB/s   00:00    
create_jar.sh                                                                                                                                  100%  325     1.0MB/s   00:00    
run_wordcount.sh                                                                                                                               100%  766     2.0MB/s   00:00    
Files copied successfully
Run wordcount

PLAY [Manage WordCount in VM] ***************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************
ok: [my-first-vm]

TASK [Change ownership of wordcount and script directories] *********************************************************************************************************************
changed: [my-first-vm] => (item=/home/ubuntu/wordcount)
ok: [my-first-vm] => (item=/home/ubuntu/script)

TASK [Set correct permissions for wordcount and script directories] *************************************************************************************************************
changed: [my-first-vm] => (item=/home/ubuntu/wordcount)
changed: [my-first-vm] => (item=/home/ubuntu/script)

TASK [Compile WordCount Java program] *******************************************************************************************************************************************
changed: [my-first-vm]

TASK [Create WordCount JAR file] ************************************************************************************************************************************************
changed: [my-first-vm]

TASK [Run WordCount program] ****************************************************************************************************************************************************
changed: [my-first-vm]

PLAY RECAP **********************************************************************************************************************************************************************
my-first-vm                : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

lousteau@lousteau-Zenbook-UX425QA-UM425QA:~/Desktop/Projets/learn-terraform-docker-container/kvm-2$ ssh -i ~/.ssh/id_rsa_terraform ubuntu@192.168.123.209
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-130-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Jan 28 09:17:51 UTC 2025

  System load:  0.35               Processes:             95
  Usage of /:   15.3% of 19.20GB   Users logged in:       0
  Memory usage: 7%                 IPv4 address for ens3: 192.168.123.209
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

28 updates can be applied immediately.
21 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

2 additional security updates can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm

New release '24.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Tue Jan 28 09:17:21 2025 from 192.168.123.1
ubuntu@ubuntu:~$ cat wordcount/output/part-00000
(men,1)
(call,1)
(high,1)
(is,1)
(agreeable,1)
(am,1)
(girl,1)
(have,1)
(draw,1)
(how,1)
(will,1)
(think,1)
(as,2)
(we,1)
(none,1)
(neat,1)
(over,1)
(outlived,1)
(servants,1)
(any,1)
(case,1)
(passed,1)
ubuntu@ubuntu:~$ cat wordcount/output/part-00001
(begin,1)
(horrible,1)
(it,1)
(water,1)
(you,2)
(kindness,1)
(sing,1)
(manor,1)
(if,1)
(quit,1)
(distrusts,1)
(do,2)
(ask,1)
(mr,1)
(no,1)
(household,1)
(help,1)
(to,1)
(at,2)
(small,1)
(object,1)
(wish,1)
(side,1)
(for,1)
(eagerness,1)
(polite,1)
(promotion,1)
(bed,1)
(shade,1)
(delicate,1)
(resources,1)
```

# kvm-3 : 
En me basant sur les deux tentatives kvm précédente je pensais aller vite, mais j’ai commencé à avoir des problèmes, je ne sais pas si c’est lié à un terraform destroy ou aux connections ssh de victor, dans tout les cas mon pc a finit bien en galèrer, je pouvais plus continuer, j’avais les mêmes erreurs en boucle, des problemes de permissions d'accès aux volumes, de volumes persistants créants des conflits, j’ai passé du temps à vouloir les régler et j’ai finalement décidé de tout réinstaller, et de creer des scripts pour tout clean (volumes, domaines) après utilisation de terraform.

J’ai donc tout supprimé, tout retéléchargé et j’ai recommencé à partir de kvm-2


# kvm-4 : 
Resultat d'une interconnexion de plusieurs VMs : 
```
kvm-4$ ./setup_x_run.sh 
Running Terraform to set up infrastructure

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of dmacvicar/libvirt from the dependency lock file
- Using previously-installed dmacvicar/libvirt v0.7.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # libvirt_cloudinit_disk.vm_cloudinit[0] will be created
  + resource "libvirt_cloudinit_disk" "vm_cloudinit" {
      + id        = (known after apply)
      + name      = "master_vm_0_cloudinit"
      + pool      = "default"
      + user_data = <<-EOT
            #cloud-config
            users:
              - name: ubuntu
                ssh-authorized-keys:
                  # - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyNvxuY/AHDT6AOeo7vgymv0d4UCaER6FHQPSxEDfX/s7xVc7xnwyHMcjhNcDs9Jeqjp0lPlbwsGcz8kwLS4/CASXKNUaP7d5S+8FzVaqJZi84HG51AxvYBwPUSG8xvkjpJiJqkGgVdyaWRhbphsif0NX++Fp96brm4XK9vVB0kprHkHEbIeKynxTi+OjLiEZ1VAACtRJQ0gfnAPKnCLvg/9Ch1cXQJmVx+nAC/y2MPNVLU1YI4jlaVuy33bnDt7Ywkt44/b8rTuAbBYfSTslvgtO3ukfhjfiNxR/SxKt3ehawYHLs/npZT7qv1WjwxLXC+GDFgqVsdA/oONBZgn+R
                  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7661M97CH5HaGJlULTXsBn/xCGTJfUdAk2paGd/JtVqWPDZ13U8qH/DCwvi9zrpLgsFArYrc4ue4FxidG2Ne5Ul+LSTlOp+fL3GqGyJnRkrKD54Xd+lDrmuZ0vOC+msVdTc7YCVgW+hSgH4TOBpz61hyNm2naqABksOQFpS4mqlHqxLNSvTLhgQtlzQr+vhYMZoVFCGAMXN8tFdPqeKzxeCbmVOPsI/wPd4UXnJhu5plBID3jdr7DypB481faK5fyVmlXQtmTeKSZsaOX5UglB4Ldx+7+mNRh1O5raa9ABOaNDHwU8+doZwuPuqi/FX6KuCtvcyv6bHi0Oyu/Poyj+ACP1MVQzP788PGGS8MYCky0uxLP85k2kf1mSAVknGpKJPfer72Ma2nc04GH1XobtEMYvGozti2p2UkbsUngBgitBDiOk5wo/24PsM7jYgHPjfj4tKKKwLrmzd8bugwqIZXA6mjynduEa1qf0rod/YU/hRzRNcKArOyVknmNZGHTGNO1wdkUojnICFK7+CnhVcE8EQY6eCTEmaZcksJ7RTmbaq5Q2hRJvFyxuTH79jv4wGXsSxAOFlUsWwFfReZFZ6r0BHahbJP/mHV+f5Aw0+twTDLCsGbLxnd6oS1GlmEk4Lr157JgsiOmrLsl6i/h4zHtROPhN5EBu4oT1WECrQ==
                sudo: ['ALL=(ALL) NOPASSWD:ALL']
                groups: sudo
                shell: /bin/bash
                passwored: ubuntu
            
            password: ubuntu
            chpasswd:
              expire: false
            ssh_pwauth: true
            packages:
              - qemu-guest-agent
            
            network:
              version: 2
              ethernets:
                vnet9:
                  dhcp4: false
                  addresses:
                    - 192.168.123.100/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
                vnet11:
                  dhcp4: false
                  addresses:
                    - 192.168.123.101/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
                vnet10:
                  dhcp4: false
                  addresses:
                    - 192.168.123.102/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
        EOT
    }

  # libvirt_cloudinit_disk.vm_cloudinit[1] will be created
  + resource "libvirt_cloudinit_disk" "vm_cloudinit" {
      + id        = (known after apply)
      + name      = "worker_vm1_1_cloudinit"
      + pool      = "default"
      + user_data = <<-EOT
            #cloud-config
            users:
              - name: ubuntu
                ssh-authorized-keys:
                  # - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyNvxuY/AHDT6AOeo7vgymv0d4UCaER6FHQPSxEDfX/s7xVc7xnwyHMcjhNcDs9Jeqjp0lPlbwsGcz8kwLS4/CASXKNUaP7d5S+8FzVaqJZi84HG51AxvYBwPUSG8xvkjpJiJqkGgVdyaWRhbphsif0NX++Fp96brm4XK9vVB0kprHkHEbIeKynxTi+OjLiEZ1VAACtRJQ0gfnAPKnCLvg/9Ch1cXQJmVx+nAC/y2MPNVLU1YI4jlaVuy33bnDt7Ywkt44/b8rTuAbBYfSTslvgtO3ukfhjfiNxR/SxKt3ehawYHLs/npZT7qv1WjwxLXC+GDFgqVsdA/oONBZgn+R
                  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7661M97CH5HaGJlULTXsBn/xCGTJfUdAk2paGd/JtVqWPDZ13U8qH/DCwvi9zrpLgsFArYrc4ue4FxidG2Ne5Ul+LSTlOp+fL3GqGyJnRkrKD54Xd+lDrmuZ0vOC+msVdTc7YCVgW+hSgH4TOBpz61hyNm2naqABksOQFpS4mqlHqxLNSvTLhgQtlzQr+vhYMZoVFCGAMXN8tFdPqeKzxeCbmVOPsI/wPd4UXnJhu5plBID3jdr7DypB481faK5fyVmlXQtmTeKSZsaOX5UglB4Ldx+7+mNRh1O5raa9ABOaNDHwU8+doZwuPuqi/FX6KuCtvcyv6bHi0Oyu/Poyj+ACP1MVQzP788PGGS8MYCky0uxLP85k2kf1mSAVknGpKJPfer72Ma2nc04GH1XobtEMYvGozti2p2UkbsUngBgitBDiOk5wo/24PsM7jYgHPjfj4tKKKwLrmzd8bugwqIZXA6mjynduEa1qf0rod/YU/hRzRNcKArOyVknmNZGHTGNO1wdkUojnICFK7+CnhVcE8EQY6eCTEmaZcksJ7RTmbaq5Q2hRJvFyxuTH79jv4wGXsSxAOFlUsWwFfReZFZ6r0BHahbJP/mHV+f5Aw0+twTDLCsGbLxnd6oS1GlmEk4Lr157JgsiOmrLsl6i/h4zHtROPhN5EBu4oT1WECrQ==
                sudo: ['ALL=(ALL) NOPASSWD:ALL']
                groups: sudo
                shell: /bin/bash
                passwored: ubuntu
            
            password: ubuntu
            chpasswd:
              expire: false
            ssh_pwauth: true
            packages:
              - qemu-guest-agent
            
            network:
              version: 2
              ethernets:
                vnet9:
                  dhcp4: false
                  addresses:
                    - 192.168.123.100/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
                vnet11:
                  dhcp4: false
                  addresses:
                    - 192.168.123.101/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
                vnet10:
                  dhcp4: false
                  addresses:
                    - 192.168.123.102/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
        EOT
    }

  # libvirt_cloudinit_disk.vm_cloudinit[2] will be created
  + resource "libvirt_cloudinit_disk" "vm_cloudinit" {
      + id        = (known after apply)
      + name      = "worker_vm2_2_cloudinit"
      + pool      = "default"
      + user_data = <<-EOT
            #cloud-config
            users:
              - name: ubuntu
                ssh-authorized-keys:
                  # - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyNvxuY/AHDT6AOeo7vgymv0d4UCaER6FHQPSxEDfX/s7xVc7xnwyHMcjhNcDs9Jeqjp0lPlbwsGcz8kwLS4/CASXKNUaP7d5S+8FzVaqJZi84HG51AxvYBwPUSG8xvkjpJiJqkGgVdyaWRhbphsif0NX++Fp96brm4XK9vVB0kprHkHEbIeKynxTi+OjLiEZ1VAACtRJQ0gfnAPKnCLvg/9Ch1cXQJmVx+nAC/y2MPNVLU1YI4jlaVuy33bnDt7Ywkt44/b8rTuAbBYfSTslvgtO3ukfhjfiNxR/SxKt3ehawYHLs/npZT7qv1WjwxLXC+GDFgqVsdA/oONBZgn+R
                  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7661M97CH5HaGJlULTXsBn/xCGTJfUdAk2paGd/JtVqWPDZ13U8qH/DCwvi9zrpLgsFArYrc4ue4FxidG2Ne5Ul+LSTlOp+fL3GqGyJnRkrKD54Xd+lDrmuZ0vOC+msVdTc7YCVgW+hSgH4TOBpz61hyNm2naqABksOQFpS4mqlHqxLNSvTLhgQtlzQr+vhYMZoVFCGAMXN8tFdPqeKzxeCbmVOPsI/wPd4UXnJhu5plBID3jdr7DypB481faK5fyVmlXQtmTeKSZsaOX5UglB4Ldx+7+mNRh1O5raa9ABOaNDHwU8+doZwuPuqi/FX6KuCtvcyv6bHi0Oyu/Poyj+ACP1MVQzP788PGGS8MYCky0uxLP85k2kf1mSAVknGpKJPfer72Ma2nc04GH1XobtEMYvGozti2p2UkbsUngBgitBDiOk5wo/24PsM7jYgHPjfj4tKKKwLrmzd8bugwqIZXA6mjynduEa1qf0rod/YU/hRzRNcKArOyVknmNZGHTGNO1wdkUojnICFK7+CnhVcE8EQY6eCTEmaZcksJ7RTmbaq5Q2hRJvFyxuTH79jv4wGXsSxAOFlUsWwFfReZFZ6r0BHahbJP/mHV+f5Aw0+twTDLCsGbLxnd6oS1GlmEk4Lr157JgsiOmrLsl6i/h4zHtROPhN5EBu4oT1WECrQ==
                sudo: ['ALL=(ALL) NOPASSWD:ALL']
                groups: sudo
                shell: /bin/bash
                passwored: ubuntu
            
            password: ubuntu
            chpasswd:
              expire: false
            ssh_pwauth: true
            packages:
              - qemu-guest-agent
            
            network:
              version: 2
              ethernets:
                vnet9:
                  dhcp4: false
                  addresses:
                    - 192.168.123.100/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
                vnet11:
                  dhcp4: false
                  addresses:
                    - 192.168.123.101/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
                vnet10:
                  dhcp4: false
                  addresses:
                    - 192.168.123.102/24
                  gateway4: 192.168.123.1
                  nameservers:
                    addresses:
                      - 8.8.8.8
                      - 8.8.4.4
        EOT
    }

  # libvirt_domain.vm[0] will be created
  + resource "libvirt_domain" "vm" {
      + arch        = (known after apply)
      + autostart   = (known after apply)
      + cloudinit   = (known after apply)
      + emulator    = (known after apply)
      + fw_cfg_name = "opt/com.coreos/config"
      + id          = (known after apply)
      + machine     = (known after apply)
      + memory      = 4096
      + name        = "master_vm_0"
      + qemu_agent  = false
      + running     = true
      + vcpu        = 1

      + disk {
          + scsi      = false
          + volume_id = (known after apply)
        }

      + network_interface {
          + addresses      = (known after apply)
          + hostname       = (known after apply)
          + mac            = (known after apply)
          + network_id     = (known after apply)
          + network_name   = "default"
          + wait_for_lease = true
        }
    }

  # libvirt_domain.vm[1] will be created
  + resource "libvirt_domain" "vm" {
      + arch        = (known after apply)
      + autostart   = (known after apply)
      + cloudinit   = (known after apply)
      + emulator    = (known after apply)
      + fw_cfg_name = "opt/com.coreos/config"
      + id          = (known after apply)
      + machine     = (known after apply)
      + memory      = 4096
      + name        = "worker_vm1_1"
      + qemu_agent  = false
      + running     = true
      + vcpu        = 1

      + disk {
          + scsi      = false
          + volume_id = (known after apply)
        }

      + network_interface {
          + addresses      = (known after apply)
          + hostname       = (known after apply)
          + mac            = (known after apply)
          + network_id     = (known after apply)
          + network_name   = "default"
          + wait_for_lease = true
        }
    }

  # libvirt_domain.vm[2] will be created
  + resource "libvirt_domain" "vm" {
      + arch        = (known after apply)
      + autostart   = (known after apply)
      + cloudinit   = (known after apply)
      + emulator    = (known after apply)
      + fw_cfg_name = "opt/com.coreos/config"
      + id          = (known after apply)
      + machine     = (known after apply)
      + memory      = 4096
      + name        = "worker_vm2_2"
      + qemu_agent  = false
      + running     = true
      + vcpu        = 1

      + disk {
          + scsi      = false
          + volume_id = (known after apply)
        }

      + network_interface {
          + addresses      = (known after apply)
          + hostname       = (known after apply)
          + mac            = (known after apply)
          + network_id     = (known after apply)
          + network_name   = "default"
          + wait_for_lease = true
        }
    }

  # libvirt_volume.vm_base will be created
  + resource "libvirt_volume" "vm_base" {
      + format = "qcow2"
      + id     = (known after apply)
      + name   = "base_volume"
      + pool   = "default"
      + size   = (known after apply)
      + source = "/var/lib/libvirt/images/ubuntu-base.qcow2"
    }

  # libvirt_volume.vm_disk[0] will be created
  + resource "libvirt_volume" "vm_disk" {
      + base_volume_id = (known after apply)
      + format         = "qcow2"
      + id             = (known after apply)
      + name           = "master_vm_0_disk.qcow2"
      + pool           = "default"
      + size           = 21474836480
    }

  # libvirt_volume.vm_disk[1] will be created
  + resource "libvirt_volume" "vm_disk" {
      + base_volume_id = (known after apply)
      + format         = "qcow2"
      + id             = (known after apply)
      + name           = "worker_vm1_1_disk.qcow2"
      + pool           = "default"
      + size           = 21474836480
    }

  # libvirt_volume.vm_disk[2] will be created
  + resource "libvirt_volume" "vm_disk" {
      + base_volume_id = (known after apply)
      + format         = "qcow2"
      + id             = (known after apply)
      + name           = "worker_vm2_2_disk.qcow2"
      + pool           = "default"
      + size           = 21474836480
    }

Plan: 10 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vm_ips = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
libvirt_volume.vm_base: Creating...
libvirt_cloudinit_disk.vm_cloudinit[0]: Creating...
libvirt_cloudinit_disk.vm_cloudinit[1]: Creating...
libvirt_cloudinit_disk.vm_cloudinit[2]: Creating...
libvirt_volume.vm_base: Creation complete after 1s [id=/var/lib/libvirt/images/base_volume]
libvirt_volume.vm_disk[1]: Creating...
libvirt_volume.vm_disk[2]: Creating...
libvirt_volume.vm_disk[0]: Creating...
libvirt_cloudinit_disk.vm_cloudinit[1]: Creation complete after 1s [id=/var/lib/libvirt/images/worker_vm1_1_cloudinit;8af7fa0b-a927-45e8-b056-8e73dbafecc0]
libvirt_cloudinit_disk.vm_cloudinit[2]: Creation complete after 1s [id=/var/lib/libvirt/images/worker_vm2_2_cloudinit;b7556038-2ecb-4652-ab71-ba6a82927ff4]
libvirt_cloudinit_disk.vm_cloudinit[0]: Creation complete after 1s [id=/var/lib/libvirt/images/master_vm_0_cloudinit;c8e5eea6-024e-439a-90a3-e5b1a6bd55e9]
libvirt_volume.vm_disk[1]: Creation complete after 0s [id=/var/lib/libvirt/images/worker_vm1_1_disk.qcow2]
libvirt_volume.vm_disk[0]: Creation complete after 0s [id=/var/lib/libvirt/images/master_vm_0_disk.qcow2]
libvirt_volume.vm_disk[2]: Creation complete after 0s [id=/var/lib/libvirt/images/worker_vm2_2_disk.qcow2]
libvirt_domain.vm[0]: Creating...
libvirt_domain.vm[2]: Creating...
libvirt_domain.vm[1]: Creating...
libvirt_domain.vm[2]: Still creating... [10s elapsed]
libvirt_domain.vm[1]: Still creating... [10s elapsed]
libvirt_domain.vm[0]: Still creating... [10s elapsed]
libvirt_domain.vm[1]: Still creating... [20s elapsed]
libvirt_domain.vm[0]: Still creating... [20s elapsed]
libvirt_domain.vm[2]: Still creating... [20s elapsed]
libvirt_domain.vm[2]: Creation complete after 26s [id=758426a5-a762-4660-a1a7-78518cb53da5]
libvirt_domain.vm[0]: Creation complete after 27s [id=349646ab-4229-4b00-9e85-0765eee46a48]
libvirt_domain.vm[1]: Creation complete after 27s [id=45812a66-a9ce-4c73-b304-127f2a1b300b]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

vm_ips = [
  "192.168.123.213",
  "192.168.123.141",
  "192.168.123.82",
]
[INFO] Updating inventory file...
[INFO] Inventory file updated successfully!
lousteau@lousteau-Zenbook-UX425QA-UM425QA:~/Desktop/Projets/learn-terraform-docker-container/kvm-4$ ssh -i ~/.ssh/id_rsa_terraform ubuntu@192.168.123.213
The authenticity of host '192.168.123.213 (192.168.123.213)' can't be established.
ED25519 key fingerprint is SHA256:KRPj7KvOhTSJYfeo4zVIXD/Ar81ez9rjkDMf47j2/DU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.123.213' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-130-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Jan 28 09:25:19 UTC 2025

  System load:  0.23              Processes:             91
  Usage of /:   8.7% of 19.20GB   Users logged in:       0
  Memory usage: 6%                IPv4 address for ens3: 192.168.123.213
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

28 updates can be applied immediately.
21 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ubuntu:~$ exit
logout
Connection to 192.168.123.213 closed.
lousteau@lousteau-Zenbook-UX425QA-UM425QA:~/Desktop/Projets/learn-terraform-docker-container/kvm-4$ ansible -i inventory all -m ping
master_vm_0 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
worker_vm1_1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
worker_vm2_2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

# Recap sur ce qui a été fait : 
1. Un réseau de VMs en local qui communiquent entre elles et effectuent un wordcount (non basé sur java/spark)
2. Une VM crée avec terraform/kvm qui effectue un wordcount avec java/spark installé via ansible
3. Un réseau de VMs en local qui se ping mais qui après configuration via playbook rate 

# Recap sur les pbs rencontrés : 
1. Probleme d'adresses ips
    - Test de mettre des adresses ips statiques
    - Script pour update l'inventory 

2. Plusieurs problemes
```
Domain already exists


Failed to connect to the host via ssh: No route to host
```
    Bcp de solutions testée : 
    - supprimer domaines/volumes
    - réinstaller tout (terraform/ansible/image volumes)
    - faire un script pour automatiser le clean de tout (volumes/) 
3. VM disk de taille trop faible
    - tentative d'utiliser d'autres volumes
    - etendre la taille des disks alloués aux VMs

4. Problèmes liés aux clés ssh : 
    - script ssh pour regenerer les clés et les exporter vers les VMs


# Lecons tirées : 
Configuration avec .sh importante
Bien prendre note de toutes les résolutions d'erreurs faites pour pouvoir les automatiser
Compréhension de terraform/libvirt/ansible

# Pour aller plus loin : 
Regler ce probleme de clés ou meme recommencer depuis le début, en reinitialisant tout mon pc, en recommancant avec un code propre, directement avec des scripts pour lancer/stopper les programmes.

Faire la partie shdl ou autre solution.
