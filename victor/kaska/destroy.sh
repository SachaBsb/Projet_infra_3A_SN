# Détruire les ressources Terraform
echo "Détruire les ressources Terraform..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/terraform_destroy.yml
