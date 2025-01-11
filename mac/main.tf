terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Image Docker Python
resource "docker_image" "python" {
  name         = "python:3.9-slim"
  keep_locally = false
}

resource "docker_container" "wordcount" {
  image = docker_image.python.name
  name  = "wordcount-container"

  # Monter un volume pour les fichiers locaux
  mounts {
    source = "${abspath("${path.module}/app")}" # Utilise un chemin absolu dynamique
    target = "/app"
    type   = "bind"
  }

  # Commande pour exécuter le script Python
  command = [
    "/app/entrypoint.sh"
  ]
}
