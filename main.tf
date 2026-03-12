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
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = "nginx-terraform"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = 8080
  }
}
