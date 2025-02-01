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

# Configure le réseau local pour le master
resource "docker_network" "local_spark_network" {
  count  = var.is_master ? 1 : 0
  name   = "spark-network-local"
  driver = "bridge"

  ipam_config {
    subnet = "172.16.0.0/16" # Sous-réseau pour le master
  }
}

# Configure le réseau distant pour les workers
resource "docker_network" "distant_spark_network" {
  count  = var.is_master ? 0 : 1
  name   = "spark-network-distant"
  driver = "bridge"

  ipam_config {
    subnet = "172.15.0.0/16" # Sous-réseau pour les workers
  }

}

# Pull the Spark image
resource "docker_image" "spark_image" {
  name         = "victordevo/sparkma:latest"
  keep_locally = false
}

# Resources for the master node
resource "docker_container" "spark_master" {
  count = var.is_master ? 1 : 0

  name  = "spark-master"
  image = docker_image.spark_image.name

  ports {
    internal = 7077
    external = 7077
  }

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = docker_network.local_spark_network[0].name
  }

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  env = [
    "SPARK_MODE=master",
    "SPARK_MASTER_HOST=spark-master",
    "SPARK_MASTER_PORT=7077"
  ]

  command = [
    "/opt/spark/bin/spark-class",
    "org.apache.spark.deploy.master.Master",
    "--host", "spark-master"
  ]
}

# Resources for the master node
resource "docker_container" "driver" {
  count = var.is_master ? 1 : 0

  name  = "driver"
  image = docker_image.spark_image.name

  networks_advanced {
    name = docker_network.local_spark_network[0].name
  }

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  command = [
    "/opt/spark/bin/spark-submit",
    "--master", "spark://spark-master:7077",
    "/app/wordcount.py",
    "/app/input.txt"
  ]
}

# Resources for the worker nodes
resource "docker_container" "spark_worker_1" {
  count = var.is_master ? 0 : 1

  name  = "spark-worker-1"
  image = docker_image.spark_image.name

  ports {
    internal = 8081
    external = 8081
  }

  networks_advanced {
    name = docker_network.distant_spark_network[0].name
  }

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  env = [
    "SPARK_MODE=worker",
    "SPARK_MASTER=spark://172.20.10.8:7077",
    "SPARK_WORKER_CORES=1",
    "SPARK_WORKER_MEMORY=1024m"
  ]

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

  ports {
    internal = 8082
    external = 8082
  }

  networks_advanced {
    name = docker_network.distant_spark_network[0].name
  }

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  env = [
    "SPARK_MODE=worker",
    "SPARK_MASTER=spark://172.20.10.8:7077",
    "SPARK_WORKER_CORES=1",
    "SPARK_WORKER_MEMORY=1024m"
  ]

  command = [
    "/opt/spark/bin/spark-class",
    "org.apache.spark.deploy.worker.Worker",
    "spark://172.20.10.8:7077"
  ]
}
