#!/bin/bash

echo "Stopping Libvirt service..."
sudo systemctl stop libvirtd

echo "Removing Libvirt and QEMU..."
sudo apt remove --purge -y libvirt* qemu-kvm
sudo apt autoremove -y
sudo apt autoclean

echo "Removing Terraform..."
sudo rm -rf /usr/local/bin/terraform
sudo apt remove -y terraform

echo "Cleaning up old VM images and volumes..."
sudo rm -rf /var/lib/libvirt/images/*
sudo rm -rf ~/Desktop/Projets/learn-terraform-docker-container/kvm-v3/pool
sudo rm -rf /var/lib/libvirt/pool/*

echo "Uninstallation completed!"
