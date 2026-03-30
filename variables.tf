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

variable "server_names" {
  description = "Liste des noms pour les serveurs client"
  type        = list(string)
  default     = ["alpha", "beta", "gamma"]
}

variable "machines" {
  description = "Liste des machines virtuelles à déployer"
  type = list(object({
    name      = string
    vcpu      = number
    disk_size = number
    region    = string
  }))

  default = [
    {
      name      = "vm-app-1"
      vcpu      = 2
      disk_size = 20
      region    = "eu-west-1"
    }
  ]

  validation {
    condition = alltrue([
      for machine in var.machines : machine.vcpu >= 2 && machine.vcpu <= 64
    ])
    error_message = "Chaque machine doit avoir un vcpu entre 2 et 64."
  }

  validation {
    condition = alltrue([
      for machine in var.machines : machine.disk_size >= 20
    ])
    error_message = "Chaque machine doit avoir un disk_size supérieur ou égal à 20 Go."
  }

  validation {
    condition = alltrue([
      for machine in var.machines : contains([
        "eu-west-1",
        "us-east-1",
        "ap-southeast-1"
      ], machine.region)
    ])
    error_message = "Chaque machine doit avoir une region parmi: eu-west-1, us-east-1, ap-southeast-1."
  }
}
