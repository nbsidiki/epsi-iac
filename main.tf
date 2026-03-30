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

resource "docker_network" "app_network" {
  name = "nginx-network"
}

resource "docker_image" "nginx" {
  name         = var.docker_image_name
  keep_locally = true
}

resource "docker_image" "curl" {
  name         = "appropriate/curl:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id
  ports {
    internal = var.internal_port
    external = var.external_port
  }
  networks_advanced {
    name    = docker_network.app_network.name
    aliases = ["nginx"]
  }
}

resource "docker_container" "client" {
  count      = var.client_count
  name       = "client-${count.index}"
  image      = docker_image.curl.image_id
  command = [
    "sh",
    "-c",
    "curl http://nginx && sleep 30"
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
  depends_on = [docker_container.nginx]
}

resource "null_resource" "nginx_test" {
  depends_on = [docker_container.nginx]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Attente du démarrage de Nginx..."
      sleep 3
      echo "Test de l'URL http://localhost:${var.external_port}"
      if curl -s http://localhost:${var.external_port} | grep -q "Welcome"; then
        echo "✅ Test réussi : Nginx répond correctement avec la page Welcome"
      else
        echo "❌ Test échoué : Nginx ne répond pas correctement"
        exit 1
      fi
    EOT
  }

  triggers = {
    container_id = docker_container.nginx.id
  }
}
