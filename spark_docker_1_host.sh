cd mac
terraform init
terraform apply -auto-approve
echo "Project started."
echo "Execute "docker logs wordcount-container" to see the results"
read -p "Do you want to clear the project? (y/n) " choice
if [ "$choice" = "y" ]; then
    terraform destroy -auto-approve
    echo "Project cleared."
else
    echo "Project kept."
fi
