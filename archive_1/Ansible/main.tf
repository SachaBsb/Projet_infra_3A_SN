terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  count = 1 # Vous pouvez augmenter le nombre de conteneurs ici
  name  = "nginx_container_${count.index}"
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = 8080 + count.index
  }

  # Utiliser docker cp pour copier le fichier dans le conteneur
  provisioner "local-exec" {
    command = "docker cp init.sh nginx_container_${count.index}:/init.sh && docker exec nginx_container_${count.index} bash /init.sh"
  }
}
resource "local_file" "ansible_inventory" {
  content = <<EOT
[nginx]
%{ for i in range(length(docker_container.nginx)) }
nginx_container_${i} ansible_host=127.0.0.1 ansible_port=${8080 + i} ansible_connection=ssh ansible_user=root ansible_ssh_pass=rootpassword ansible_python_interpreter=/usr/bin/python3
%{ endfor }
EOT
  filename = "${path.module}/inventory.ini"
}
