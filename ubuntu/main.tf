terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Define the Nginx image resource
resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

# Create two containers using count
resource "docker_container" "nginx" {
  count = 4 # Create 2 containers

  image = docker_image.nginx.image_id
  name  = "tutorial-${count.index}" # Unique name for each container

  ports {
    internal = 80
    external = 8000 + count.index # Unique external port for each container
  }
}
