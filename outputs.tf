output "nginx_container_id" {
  description = "L'identifiant du conteneur nginx"
  value       = docker_container.nginx.id
}
