terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_network" "local_bridge" {
  name   = "local_bridge"
  driver = "bridge"
}

resource "docker_image" "ubuntu" {
  name         = "victordevo/ubuntu"
  keep_locally = true
}

resource "docker_container" "master" {
  image = docker_image.ubuntu.name
  name  = "master"

  command = ["/usr/sbin/sshd", "-D"]

  ports {
    internal = 22
    external = 2222
  }

  ports {
    internal = 7077
    external = 7077
  }

  ports {
    internal = 8080
    external = 8080
  }

  mounts {
    source = "/tmp/omega_project/data/ansible_rsa.pub"
    target = "/root/.ssh/authorized_keys"
    type   = "bind"
  }

  mounts {
    source = "/tmp/omega_project/data/"
    target = "/data/"
    type   = "bind"
  }

  networks_advanced {
    name         = docker_network.local_bridge.name
  }
}

resource "docker_container" "driver" {
  image = docker_image.ubuntu.name
  name  = "driver"

  command = ["/usr/sbin/sshd", "-D"]

  ports {
    internal = 22
    external = 2223
  }

  mounts {
    source = "/tmp/omega_project/data/ansible_rsa.pub"
    target = "/root/.ssh/authorized_keys"
    type   = "bind"
  }

  mounts {
    source = "/tmp/omega_project/data/"
    target = "/data/"
    type   = "bind"
  }

  networks_advanced {
    name         = docker_network.local_bridge.name
  }
}

resource "docker_container" "worker1" {
  image = docker_image.ubuntu.name
  name  = "worker1"

  command = ["/usr/sbin/sshd", "-D"]

  ports {
    internal = 22
    external = 2224
  }

  mounts {
    source = "/tmp/omega_project/data/ansible_rsa.pub"
    target = "/root/.ssh/authorized_keys"
    type   = "bind"
  }

  mounts {
    source = "/tmp/omega_project/data/"
    target = "/data/"
    type   = "bind"
  }

  networks_advanced {
    name         = docker_network.local_bridge.name
  }
}

resource "docker_container" "worker2" {
  image = docker_image.ubuntu.name
  name  = "worker2"

  command = ["/usr/sbin/sshd", "-D"]

  ports {
    internal = 22
    external = 2225
  }

  mounts {
    source = "/tmp/omega_project/data/ansible_rsa.pub"
    target = "/root/.ssh/authorized_keys"
    type   = "bind"
  }

  mounts {
    source = "/tmp/omega_project/data/"
    target = "/data/"
    type   = "bind"
  }

  networks_advanced {
    name         = docker_network.local_bridge.name
  }
}
