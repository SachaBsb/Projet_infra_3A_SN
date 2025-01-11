#!/bin/bash
# Exécuter le script Python

echo "Début de l'exécution de entrypoint.sh"

python3 /app/wordcount.py /app/data.txt

# Maintenir le conteneur actif
tail -f /dev/null
