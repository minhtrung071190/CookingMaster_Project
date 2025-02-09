# main.tf

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Log Analytics workspace (required for Container Apps)
resource "azurerm_log_analytics_workspace" "frontend_logs" {
  name                = "frontend-app-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on          = [azurerm_resource_group.rg]
}

# Create a Container Apps environment
resource "azurerm_container_app_environment" "frontend_env" {
  name                       = "frontend-app-env"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.frontend_logs.id
}

# Create a Container App
resource "azurerm_container_app" "app" {
  name                         = "frontend-container"
  container_app_environment_id = azurerm_container_app_environment.frontend_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single" # or "Multiple" for multiple revisions

  template {
    container {
      name   = "frontend-container"
      image  = "henry071190/frontend:7" # Replace with your container image
      cpu    = 0.5
      memory = "1Gi"

      # Add environment variables for registry authentication
      env {
        name  = "DOCKER_REGISTRY_SERVER"
        value = "index.docker.io"
      }
      env {
        name  = "DOCKER_REGISTRY_USERNAME"
        value = var.docker_user
      }
      env {
        name  = "DOCKER_REGISTRY_PASSWORD"
        value = var.docker_password
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
