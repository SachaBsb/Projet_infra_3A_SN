terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_image" "pyspark" {
  name = "custom-spark"
  keep_locally = true
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
    "SPARK_MODE=master"
  ]

  ports {
    internal = 7077
    external = 7077
  }

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = "spark-network"
  }
}

# Worker containers for Spark
resource "docker_container" "spark_worker" {
  count = 3

  image = docker_image.pyspark.name
  name  = "spark-worker-${count.index}"

  env = [
    "SPARK_MODE=worker",
    "SPARK_MASTER_URL=spark://spark-master:7077"
  ]

  ports {
    internal = 8081 + count.index
    external = 8081 + count.index
  }

  networks_advanced {
    name = "spark-network"
  }
}
