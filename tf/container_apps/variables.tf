variable "resource_group_name" {
  default = "CloudEx-Seneca-RG"
}

variable "location" {
  default = "East US"
}

variable "port" {
  type        = number
  description = "Port to open on the container and the public IP address."
  default     = 80
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 1
}

variable "memory_in_gb" {
  type        = number
  description = "The amount of memory to allocate to the container in gigabytes."
  default     = 2
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Always"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}

variable "image" {
  type        = string
  description = "Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials."
  default     = "henry071190/frontend:7"
}
# variable "container_group_name" {
#   default = "cookingmaster"
# }

variable "frontend_image" {
  default     = "henry071190/frontend:5"
  description = "Docker image for frontend"
}

variable "backend_image" {
  default     = "henry071190/backend"
  description = "Docker image for backend"
}

variable "db_image" {
  default     = "henry071190/backend_db"
  description = "Docker image for backend db"
}


# # variable "backend_image" {
# #   default = "henry071190/backend:latest"
# #   description = "Docker image for backend"
# # }

# variable "dns_name_label" {
#   default = "cookingmaster-app"
# }

variable "docker_registry_username" {
  description = "The Docker registry username"
  type        = string
}

variable "docker_registry_password" {
  description = "The Docker registry password"
  type        = string
}

variable "container_apps" {
  type = map(object({
    image       = string
    target_port = number
  }))
  default = {
    frontend = {
      image       = "henry071190/frontend:5"
      target_port = 3000
    }
    backend = {
      image       = "henry071190/backend"
      target_port = 8888
    }
  }
}

variable "mysql_root_password" {
  type        = string
  description = "The password for the MySQL root user"
  sensitive   = true
}