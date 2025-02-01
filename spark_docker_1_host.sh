cd mac
echo "==============================="
echo "Initializing Terraform..."
echo "==============================="
echo
terraform init

echo "==============================="
echo "Applying Terraform configuration..."
echo "==============================="
echo
terraform apply -auto-approve

echo "==============================="
echo "Project started."
echo "Waiting for 'wordcount-container' to start..."
echo "==============================="
echo
while ! docker ps --format '{{.Names}}' | grep -q '^wordcount-container$'; do
    sleep 2
done

echo "==============================="
echo "Streaming logs from 'wordcount-container' (around 30 seconds)"
echo "==============================="
echo
docker logs -f wordcount-container &  # Afficher les logs en direct en arrière-plan
LOGS_PID=$!  # Récupérer l'ID du processus des logs

# Attendre que le conteneur s'arrête
while docker ps --format '{{.Names}}' | grep -q '^wordcount-container$'; do
    sleep 2
done

# Arrêter le streaming des logs
kill $LOGS_PID 2>/dev/null
echo
echo "==============================="
echo "Wordcount process completed."
echo "You can check the logs!"
echo "==============================="
echo
read -p "Do you want to clear the project? (y/n) " choice
if [ "$choice" = "y" ]; then
    terraform destroy -auto-approve
    echo "==============================="
    echo "Project cleared."
    echo "==============================="
else
    echo "==============================="
    echo "Project kept."
    echo "==============================="
fi
