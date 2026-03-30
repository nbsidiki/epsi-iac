variable "docker_image_name" {
  description = "Le nom de l'image Docker à utiliser"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Le nom du conteneur Docker"
  type        = string
  default     = "nginx-terraform"
}

variable "external_port" {
  description = "Le port externe exposé sur l'hôte"
  type        = number
  default     = 8080
}

variable "internal_port" {
  description = "Le port interne du conteneur"
  type        = number
  default     = 80
}

variable "client_count" {
  description = "Nombre de conteneurs client à déployer"
  type        = number
  default     = 3
}
