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
