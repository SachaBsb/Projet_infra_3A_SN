terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Image Docker Spark
resource "docker_image" "pyspark" {
  name         = "bitnami/spark:3.3.0"
  keep_locally = false
}

# Conteneur pour exécuter WordCount avec PySpark
resource "docker_container" "wordcount" {
  image = docker_image.pyspark.name
  name  = "wordcount-container"

  # Monter un volume pour les fichiers locaux
  mounts {
    source = "${abspath("${path.module}/app")}" # Utilise un chemin absolu dynamique
    target = "/app"
    type   = "bind"
  }

  # Commande pour exécuter le script PySpark
  command = [
    "/app/entrypoint.sh"
  ]
}
