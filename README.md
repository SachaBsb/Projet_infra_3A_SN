
### 14/01/2025 : 
On a commencé le projet avec terraform/docker pour contourner le pb de kvm qui ne fonctionne pas sur mac, mais Boris nous a dit qu'il veut qu'on utilise kvm, même si c'est sur une seule machine.

A terme, on veut aussi une vm qui heberge un site pour lancer le wordcount et voir les résultats.


importer l'image ubuntu : 
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

## Les différents types de fichiers et leurs raison d'être : 
main.tf : Définit la configuration principale pour Terraform, y compris les ressources à créer (VMs, volumes, etc.). \
cloudinit.yaml : Configure automatiquement les VMs lors de leur démarrage initial (utilisateurs, logiciels, scripts). \
terraform.tfvars : Fournit les valeurs spécifiques aux variables définies dans variables.tf. \
variables.tf : Définit les variables utilisées dans main.tf pour rendre la configuration modulaire et réutilisable. \
playbook.yaml : Automatiser les tâches de configuration et déploiement sur les VMs avec Ansible (installation de logiciels, déploiement de scripts). \


## Virsh
Verifier avec terraform les vm crées : 
`virsh list` \
Voir leurs adresses ip : 
`virsh domifaddr <nom_de_la_vm>`
## Ansible 
Commande pour lancer le playbook : `ansible-playbook -i inventory wordcount.yml`

Commande pour générer une clé SSH pour ne pas toujours avoir à rentrer le login/password
`ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa_terraform -N ""`
Il faut ensuite mettre le contenu de la clé publique générée dans cloudinit.yaml (ssh-authorized-keys) puis le path de la clé privée dans inventory.sh

J'essaie de créer une machine avec terraform/kvm et libvirt comme provider et qu'elle soit configurée avec ansible pour faire un wordcount.

C'est bon, j'ai réussi à mettre une adresse ip à ma vm, je vais maintenant pouvoir tester ansible.

Ansible fonctionne ! J'ai pu faire un wordcount sur une vm. 
Difficultés rencontrées : 

Il va maintenant falloir faire en sorte que le
