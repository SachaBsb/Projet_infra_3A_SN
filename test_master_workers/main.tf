terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Docker image for Spark
resource "docker_image" "pyspark" {
  name         = "bitnami/spark:3.3.0"
  keep_locally = false
}

# Master container for Spark
resource "docker_container" "spark_master" {
  image = docker_image.pyspark.name
  name  = "spark-master"

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  env = [
    "SPARK_MODE=master" # Sets the container as the Spark master
  ]

  ports {
    internal = 7077
    external = 7077
  }

  ports {
    internal = 8080
    external = 8080
  }
}

# Worker containers for Spark
resource "docker_container" "spark_worker" {
  count = 3 # Create 3 workers

  image = docker_image.pyspark.name
  name  = "spark-worker-${count.index}"

  env = [
    "SPARK_MODE=worker",               # Sets the container as a Spark worker
    "SPARK_MASTER_URL=spark://spark-master:7077" # Connect to the master
  ]

  ports {
    internal = 8081 + count.index
    external = 8081 + count.index
  }
}
