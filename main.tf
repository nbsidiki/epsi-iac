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
