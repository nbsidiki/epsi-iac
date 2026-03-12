terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" {
  host = "unix://${pathexpand("~/.docker/run/docker.sock")}"
}

resource "docker_image" "nginx" {
  name         = var.docker_image_name
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id
  ports {
    internal = var.internal_port
    external = var.external_port
  }
}
