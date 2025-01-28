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

resource "docker_network" "spark_network" {
  name = "spark-network"
}

# Spark Master
resource "docker_container" "spark_master" {
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

  networks_advanced {
    name = docker_network.spark_network.name
  }
  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  # Configuration spécifique au master
  env = [
    "SPARK_MODE=master",
    "SPARK_MASTER_HOST=spark-master",
    "SPARK_MASTER_PORT=7077"
  ]
  
}

# Spark Worker 1
resource "docker_container" "spark_worker_1" {
  image = docker_image.pyspark.name
  name  = "spark-worker-1"

  networks_advanced {
    name = docker_network.spark_network.name
  }
  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  # Configuration spécifique au worker
  env = [
    "SPARK_MODE=worker",
    "SPARK_MASTER=spark://spark-master:7077"
  ]
}

# Spark Worker 2
resource "docker_container" "spark_worker_2" {
  image = docker_image.pyspark.name
  name  = "spark-worker-2"

  networks_advanced {
    name = docker_network.spark_network.name
  }
  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }

  # Configuration spécifique au worker
  env = [
    "SPARK_MODE=worker",
    "SPARK_MASTER=spark://spark-master:7077"
  ]
}

# Conteneur pour exécuter le script WordCount
resource "docker_container" "wordcount" {
  image = docker_image.pyspark.name
  name  = "wordcount-container"

  mounts {
    source = "${abspath("${path.module}/app")}"
    target = "/app"
    type   = "bind"
  }
  networks_advanced {
    name = docker_network.spark_network.name
  }

  # Commande pour exécuter le script avec le master et les workers
  command = [
    "spark-submit",
    "--master", "spark://spark-master:7077",
    "--executor-memory", "512m",
    "--executor-cores", "1",
    "--driver-memory", "512m",
    "--driver-cores", "1",
    "--conf", "spark.dynamicAllocation.enabled=true",
    "--conf", "spark.dynamicAllocation.minExecutors=1",
    "--conf", "spark.dynamicAllocation.maxExecutors=2",
    "--conf", "spark.memory.fraction=0.6",
    "--conf", "spark.memory.storageFraction=0.5",
    "/app/wordcount.py",
    "/app/data.txt"
  ]

}
