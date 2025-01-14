
### 14/01/2025 : 
On a commencé le projet avec terraform/docker pour contourner le pb de kvm qui ne fonctionne pas sur mac, mais Boris nous a dit qu'il veut qu'on utilise kvm, même si c'est sur une seule machine.

A terme, on veut aussi une vm qui heberge un site pour lancer le wordcount et voir les résultats.


importer l'image ubuntu : 
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

## Virsh
Verifier avec terraform les vm crées : 
`virsh list` \
Voir leurs adresses ip : 
`virsh domifaddr <nom_de_la_vm>`
## Ansible 
Commande pour lancer le playbook : `ansible-playbook -i inventory wordcount.yml`
J'essaie de créer une machine avec terraform/kvm et libvirt comme provider et qu'elle soit configurée avec ansible pour faire un wordcount.

C'est bon, j'ai réussi à mettre une adresse ip à ma vm, je vais maintenant pouvoir tester ansible.

