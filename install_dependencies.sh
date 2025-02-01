#!/bin/bash

# Fonction pour afficher les logs en couleur
log() {
    echo -e "\e[32m[INFO] $1\e[0m"
}

error() {
    echo -e "\e[31m[ERROR] $1\e[0m"
}

# Vérification des droits administrateurs
if [[ $EUID -ne 0 ]]; then
   error "Ce script doit être exécuté en tant que root (utilise sudo)"
   exit 1
fi

log "Mise à jour du système..."
apt update && apt upgrade -y

log "Installation des paquets nécessaires..."
apt install -y \
    git \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    terraform \
    ansible \
    jq \
    python3-pip \
    virt-manager

log "Ajout de l'utilisateur au groupe libvirt..."
usermod -aG libvirt $(whoami)
newgrp libvirt

log "Vérification de KVM..."
if ! kvm-ok; then
    error "KVM n'est pas activé sur cette machine. Activez la virtualisation dans le BIOS."
    exit 1
fi

log "Démarrage et activation de libvirtd..."
systemctl enable --now libvirtd
systemctl restart libvirtd

log "Vérification de l’état du réseau libvirt..."
virsh net-list --all
virsh net-start default
virsh net-autostart default

echo "installation du volume : ubuntu-base.qcow2"
wget -O /var/lib/libvirt/images/ubuntu-base.qcow2 https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img