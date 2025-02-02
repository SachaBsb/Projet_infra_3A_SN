terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Variable pour identifier le rôle de l'hôte
variable "is_master" {
  type    = bool
  default = true  # Par défaut, l'hôte est considéré comme le master
}

# Créer le Docker Network uniquement si is_master est true
resource "docker_network" "spark_network" {
  count = var.is_master ? 1 : 0
  name  = "spark-network"
}

# Image Docker Spark
resource "docker_image" "pyspark" {
  name         = "spark:3.5.4-scala2.12-java17-python3-ubuntu"
  keep_locally = false
}

# Spark Master
resource "docker_container" "spark_master" {
  count = var.is_master ? 1 : 0  # Créer uniquement si l'hôte est le master
  image = docker_image.pyspark.name
  name  = "spark-master"

  # Ports pour Spark
  ports {
    internal = 7077
    external = 7077
  }

  ports {
    internal = 8080
    external = 8080
  }

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  networks_advanced {
    name = var.is_master ? docker_network.spark_network[0].name : "bridge"
  }

  # Configuration spécifique au master
  env = [
  "SPARK_MODE=master",
  "SPARK_MASTER_HOST=0.0.0.0", # Permet de se lier à toutes les interfaces réseau
  "SPARK_MASTER_PORT=7077",
  "SPARK_LOCAL_IP=0.0.0.0"
  ]
}

# Spark Worker 1
resource "docker_container" "spark_worker_1" {
  count = var.is_master ? 0 : 1

  image = docker_image.pyspark.name
  name  = "spark-worker-1"

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  ports {
  internal = 7077
  external = 7077
}

  # Configuration spécifique au worker
  env = [
    "SPARK_MODE=worker",
    "SPARK_MASTER=spark://localhost:7077" # Utilisation du tunnel SSH
  ]
}

# Conteneur pour exécuter le script WordCount
resource "docker_container" "wordcount" {
  count = var.is_master ? 1 : 0
  image = docker_image.pyspark.name
  name  = "wordcount-container"

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  # Connecter au réseau Docker si is_master est true
  networks_advanced {
    name = var.is_master ? docker_network.spark_network[0].name : "bridge"
  }

  # Commande pour exécuter le script avec le master et les workers
  command = [
    "spark-submit",
    "--master", "spark://spark-master:7077",
    "/app/wordcount.py",
    "/app/input.txt"
  ]
}
