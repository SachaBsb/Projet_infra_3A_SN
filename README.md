
# Projet avec docker

## 1 - Cluster spark sur une machine avec docker

### Prérequis
docker, ansible, terraform

### Ce que fait le projet
Crée un cluster spark avec docker et terraform sur une machine qui contient 1 driver, 1 master, 2 workers.
Le projet se trouve dans /mac.

### Executer le projet
Lancer cette commande dans le terminal : 
spark_docker_1_host.sh

(si il manque de droit chmod +x spark_docker_1_host.sh)

Pour vérifier que cela a fonctionné on a les résultats dans les logs du driver "wordcount-container", on peut aussi regarder les logs des workers et du master.
docker logs wordcount-container  
docker logs spark_master
docker logs spark_worker_1
docker logs spark_worker_2

## 2 - Cluster spark sur deux machines avec docker
(Les prérequis du projet étant difficile à atteindre, ce projet n'est pas éxecutable facilement, une démo à était faite mardi 28 février)

### Prérequis
Ce projet est fait pour la configuration suivante : 
1 machine mac M1 arm64
1 machine dualboot linux amd64

Pour le lancer il faut que les deux ordinateurs soient sur le même réseau.
Etant donné qu'on utilise docker sur mac il faut utiliser ce script sur le mac.
https://github.com/chipmk/docker-mac-net-connect/blob/main/README.md#docker-mac-net-connect

Il faut configurer les routes entre les hôtes.

Sur hôte mac
sudo route -n add 172.15.0.0/16 172.20.10.6

sur hôte linux
sudo ip route add 172.16.0.0/16 via 172.20.10.8 dev wlp1s0
sudo ip route add 10.33.33.2 via 172.20.10.8 dev wlp1s0

Enfin il faut connecter les deux hôtes en ssh.

### Ce que fait le projet
Le projet crée un cluster spark docker terraform et ansible deux machines qui éxecutent le programme wordcount.

### Executer le projet
Lancer ces commandes dans le terminal : 
cd victor/intern
ansible-playbook -i inventory.ini play.yml  

Pour détruire l'infrastructure : 
ansible-playbook -i inventory.ini destroy.yml  

## 3 - Cluster spark sur une machine avec plus d'Ansible et moins de Docker

### Prérequis
1 machine de préférence arm64 (le projet fonctionne avec cette architecture mais devrait fonctionner avec amd64)
Docker, ansible, terraform

### Ce que fait le projet
Le projet crée un cluster spark docker terraform et ansible une machine en utilisant ansible pour configurer la quasi-totalité des machines ubuntu. Il affiche à la fin le résultat de wordcount sur input.txt

### Executer le projet
cd victor/kaska
./start.sh
(génère une nouvelle clé ssh utilisé pour connecter ansible à la machine hôte)

start.sh
(lance tout les playbooks)
Pour le setup se fait en copiant des dossiers du répertoire kaska au répertoire tmp/spoon_project. Ce répertoire est créé si il n'existe pas.

destroy.sh
(détruit l'infrastructure)

L'éxecution du projet peut durer jusqu'à 10 minutes (Si mauvaise connection)


# Projet avec KVM

## Introduction 
Ce projet permet d'exécuter un wordcount sur des machines virtuelles en utilisant Terraform, KVM/Libvirt et Ansible. 

Il repose sur une structure commune et propose deux versions d'avancement :

- kvm-2 : Déploie une unique VM, configure son environnement et exécute un wordcount sur celle-ci.

- kvm-4 : Déploie plusieurs VMs connectées en réseau, avec un master et des workers, afin de distribuer les tâches. L'objectif final est d'exécuter un wordcount en parallèle sur plusieurs machines.

## Comment utiliser le projet : 

### 1. Prérequis et initialisation : 
Pour installer le necessaire afin de lancer le projet, on commence par cloner le git, puis on suit les instructions suivante : 
    
- Commandes à lancer : 
    ```
    # On clone le projet puis on se place dans le repository crée :
    git clone https://github.com/SachaBsb/Projet_infra_3A_SN.git
    cd Projet_infra_3A_SN

    # Installation des dépendances
    chmod +x install_dependencies.sh
    sudo ./install_dependencies.sh
    ```

📌 Ce que fait ce script : 

✅ Met à jour le système
✅ Installe Terraform, KVM, Libvirt, Ansible, jq et d'autres outils
✅ Ajoute l'utilisateur au groupe libvirt
✅ Vérifie que KVM est activé
✅ Démarre et active Libvirt et le réseau par défaut

### 2. Lancer le projet : 
Pour lancer le projet, on se place dans le dossier dont le nom correspond à la version du projet que l'on souhaite lancer (kvm-2 ou kvm-4) puis on suit les instructions suivantes : 
    
```
chmod +x setup_x_run.sh
./setup_x_run.sh
```

📌 Ce que fait ce script : 

✅ Initialise Terraform et applique la configuration \
✅ Met à jour l’inventaire Ansible \
✅ Lance les playbooks Ansible 

### 3. Tester le projet
Ensuite, pour effectuer les tests/vérifications  

#### 3.1 Tester kvm-2
Après lancement de setup_x_run.sh, pour vérifier les résultats du wordcount, on suit les instructions suivantes : 

```
# Se connecter à la VM : 
ssh -i /path/to/private_key ubuntu@ 

# Observer le résultat du wordcount
cat wordcount/output/part-00000
cat wordcount/output/part-00001

```

📌 Ce que fait ce script : 

✅ Vérifie la connexion aux VMs avec Ansible ping

#### 3.2 Tester kvm-4
Après lancement de setup_x_run.sh, pour vérifier la bonne connections entre les différentes VM du réseau, on suit les instructions suivantes : 

```
ansible -i inventory all -m ping
```

📌 Ce que fait ce script : 

✅ Vérifie la connexion aux VMs avec Ansible ping

### 4. Nettoyer l'environnement après utilisation du projet
Lancer la commande : 
```
chmod +x cleanup.sh
./cleanup.sh
```

# Structure du projet :
## Les principaux fichiers : 
- main.tf : Structure du projet, initialisation des vms 
- inventory : Inventaire mis à jours par un script et répertoriant les adresses ip des vms et les clés ssh
- setup_x_run.sh : Lancement du projet
- input.txt : texte sur lequel le wordcount est effectué

## Brève explication des différents dossiers/versions 
Les dossiers contenant des versions fonctionnelles du projet (kvm-2, kvm-4) sont directement présents dans le dossier kvm, les autres versions dans lesquels nous pu effectuer des tests sont disponible dans le dossier kvm/archives. Ces versions du projet dans l'archive ne sont pas à tester mais peuvent permettre (au même titre que le journal de bord diary.md) de comprendre la démarche et les différentes étapes lors de l'avancement du projet.

### kvm : 

Réseau de VMs en local qui communiquent entre elles et effectuent un wordcount (non basé sur java/spark)

### kvm-2 : 

Une VM crée avec terraform/kvm qui effectue un wordcount avec java/spark installé via ansible

### kvm-v3

Tentative de réseau de VMs

### kvm-4

Un réseau de VMs en local qui se ping mais qui après configuration via playbook rate   


## Explication des contenus des dossiers kvm 
Chaque version du projet utilisant kvm sont basés sur la même architecture : 
Des dossiers pour centraliser certaines solutions : 
- ansible

    Les fichiers yaml

    - Configuration des vms (cloudinit.yml) avec attribution des clés ssh
    - Installation des ressources necessaires 
    - Lancement des 

- script 

    Tous les scripts necessaires

    - cleanup.sh
    - ssh_key_gen