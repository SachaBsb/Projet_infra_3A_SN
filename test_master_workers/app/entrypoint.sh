#!/bin/bash
# Exécuter le script PySpark

echo "Début de l'exécution de entrypoint.sh"

# Lancer le script avec PySpark
spark-submit /app/wordcount.py /app/data.txt

# Maintenir le conteneur actif
tail -f /dev/null
