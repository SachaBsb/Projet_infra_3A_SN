#!/bin/bash

# Fonction pour vérifier si une commande a échoué
check_error() {
    if [ $? -ne 0 ]; then
        echo "Erreur : La commande précédente a échoué."
        exit 1
    fi
}

# Configurer l'environnement
echo "0. Configurer l'environnement..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/0_setup.yml
check_error

# Appliquer les configurations Terraform
echo "1. Appliquer les configurations Terraform..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/1_terraform.yml
check_error

# Installer Java
echo "2. Installer Java..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/2_install_java.yml
check_error

# Installer Spark
echo "3. Installer Spark..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/3_install_spark.yml
check_error

# Installer Python...
echo "4. Installer python etc..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/4_install_final.yml
check_error

# Entrypoint
echo "5. Entrypoint..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/5_launch.yml
check_error

echo "Redémarrage complet ! Toutes les étapes ont été exécutées avec succès."


