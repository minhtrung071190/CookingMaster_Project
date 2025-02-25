data "terraform_remote_state" "backend-db" {
  backend = "azurerm"
  config = {
    resource_group_name  = "CloudEx-Seneca-RG"
    storage_account_name = "cloudexsenecastorage"
    container_name       = "backend-db"
    key                  = "statefile.tfstate"
  }
}

data "terraform_remote_state" "backend" {
  backend = "azurerm"
  config = {
    resource_group_name  = "CloudEx-Seneca-RG"
    storage_account_name = "cloudexsenecastorage"
    container_name       = "backend"
    key                  = "statefile.tfstate"
  }
}

#Create frontend
resource "azurerm_container_app" "frontend" {
  name                         = "frontend"
  container_app_environment_id = data.terraform_remote_state.backend-db.outputs.container_app_env_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single" # Change if needed

  template {
    container {
      name   = "frontend"
      image  = var.frontend_image
      cpu    = 0.5
      memory = "1Gi"

      # Registry authentication
      env {
        name  = "DOCKER_REGISTRY_SERVER"
        value = "index.docker.io"
      }
      env {
        name  = "DOCKER_REGISTRY_USERNAME"
        value = var.DOCKER_REGISTRY_USERNAME
      }
      env {
        name  = "DOCKER_REGISTRY_PASSWORD"
        value = var.DOCKER_REGISTRY_PASSWORD
      }
      #backend-url
      env {
        name  = "REACT_APP_API_URL"
        value = "http://${data.terraform_remote_state.backend.outputs.backend_url}"
      }
    }
  }
  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 3000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
