variable "is_master" {
  description = "Set to true if this is the master node, false if this is a worker node"
  type        = bool
  default     = true
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Réseau pour le master
resource "docker_network" "local_spark_network" {
  count  = var.is_master ? 1 : 0
  name   = "spark-network-local"
  driver = "bridge"

  ipam_config {
    subnet = "172.16.0.0/16" # Sous-réseau pour le master
  }
}

# Réseau pour les workers
resource "docker_network" "distant_spark_network" {
  count  = var.is_master ? 0 : 1
  name   = "spark-network-distant"
  driver = "bridge"

  ipam_config {
    subnet = "172.15.0.0/16" # Sous-réseau pour les workers
  }
}

# Image Spark
resource "docker_image" "spark_image" {
  name         = "victordevo/sparkma:latest"
  keep_locally = true
}

resource "docker_container" "spark_master" {
  count = var.is_master ? 1 : 0
  name  = "spark-master"
  image = docker_image.spark_image.name

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 7077
    external = 7077
  }
  
  networks_advanced {
    name          = docker_network.local_spark_network[0].name
    ipv4_address  = "172.16.0.10"
  }
  
  mounts {
    source = "/tmp/spoon_project/app/"
    target = "/app"
    type   = "bind"
  }

  mounts {
    source = "/tmp/spoon_project/app/logs/log4j.properties"
    target = "/opt/spark/conf/log4j.properties"
    type   = "bind"
  }
  
  command = [
    "/opt/spark/bin/spark-class",
    "org.apache.spark.deploy.master.Master",
  ]

}


resource "docker_container" "driver" {
  count = var.is_master ? 1 : 0

  name  = "driver"
  image = docker_image.spark_image.name

  networks_advanced {
    name = docker_network.local_spark_network[0].name
    ipv4_address  = "172.16.0.4"
  }

  mounts {
    source = "/tmp/spoon_project/app/"
    target = "/app"
    type   = "bind"
  }
  mounts {
      source = "/tmp/spoon_project/app/logs/log4j.properties"
      target = "/opt/spark/conf/log4j.properties"
      type   = "bind"
    }
 
 env = [
    "SPARK_DRIVER_HOST=172.16.0.4",  # Définir l'adresse IP du Driver
    "SPARK_DRIVER_PORT=7078"         # Définir un port fixe pour le Driver
  ]

  command = [
    "/opt/spark/bin/spark-submit",
    "--master", "spark://172.20.10.8:7077",
    "--conf", "spark.driver.host=172.16.0.4",
    "--conf", "spark.driver.port=7078",
    "/app/wordcount.py",
    "/app/input.txt"
  ]
}

resource "docker_container" "spark_worker_1" {
  count = var.is_master ? 0 : 1

  name  = "spark-worker-1"
  image = docker_image.spark_image.name


  networks_advanced {
    name          = docker_network.distant_spark_network[0].name
    ipv4_address  = "172.15.0.11" # Adresse IP locale
  }

  mounts {
    source = "/tmp/spoon_project/app/"
    target = "/app"
    type   = "bind"
  }

  mounts {
    source = "/tmp/spoon_project/app/logs/log4j.properties"
    target = "/opt/spark/conf/log4j.properties"
    type   = "bind"
  }

command = [
  "/opt/spark/bin/spark-class",
  "org.apache.spark.deploy.worker.Worker",
  "spark://172.20.10.8:7077"
]

}


resource "docker_container" "spark_worker_2" {
  count = var.is_master ? 0 : 1

  name  = "spark-worker-2"
  image = docker_image.spark_image.name

  networks_advanced {
    name          = docker_network.distant_spark_network[0].name
    ipv4_address  = "172.15.0.10" # Adresse IP locale
  }

  mounts {
    source = "/tmp/spoon_project/app/"
    target = "/app"
    type   = "bind"
  }
  mounts {
    source = "/tmp/spoon_project/app/logs/log4j.properties"
    target = "/opt/spark/conf/log4j.properties"
    type   = "bind"
  }

  command = [
    "/opt/spark/bin/spark-class",
    "org.apache.spark.deploy.worker.Worker",
    "spark://172.20.10.8:7077"
  ]

}
