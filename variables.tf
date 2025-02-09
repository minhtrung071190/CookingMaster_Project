variable "resource_group_name" {
  default = "CloudEx-Seneca-RG"
}

variable "location" {
  default = "East US"
}

variable "container_group_name" {
  default = "cookingmaster"
}

variable "frontend_image" {
  default     = "henry071190/frontend:7"
  description = "Docker image for frontend"
}

# variable "backend_image" {
#   default = "henry071190/backend:latest"
#   description = "Docker image for backend"
# }

variable "dns_name_label" {
  default = "cookingmaster-app"
}

variable "docker_registry_username" {
  description = "The Docker registry username"
  type        = string
}

variable "docker_registry_password" {
  description = "The Docker registry password"
  type        = string
}
# variable "docker_registry_username" {}
# variable "docker_registry_password" {}
