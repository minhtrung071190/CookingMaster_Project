# main.tf

provider "azurerm" {
  features {}
  subscription_id = "922ef694-a56b-40f9-b615-36e3aedb343f"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Log Analytics workspace (required for Container Apps)
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on          = [azurerm_resource_group.rg]
}

# Create a Container Apps environment
resource "azurerm_container_app_environment" "cookingmaster_env" {
  name                       = "frontend-backend-db-env"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
}

# Create a Container App
resource "azurerm_container_app" "apps" {
  for_each                     = var.container_apps
  name                         = each.key
  container_app_environment_id = azurerm_container_app_environment.cookingmaster_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single" # Change if needed

  template {
    container {
      name   = "${each.key}-container"
      image  = each.value.image
      cpu    = 0.5
      memory = "1Gi"

      # Registry authentication
      env {
        name  = "DOCKER_REGISTRY_SERVER"
        value = "index.docker.io"
      }
      env {
        name  = "DOCKER_REGISTRY_USERNAME"
        value = var.docker_registry_username
      }
      env {
        name  = "DOCKER_REGISTRY_PASSWORD"
        value = var.docker_registry_password
      }
    }
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = each.value.target_port
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "backend_db" {
  name                         = "backend-db"
  container_app_environment_id = azurerm_container_app_environment.cookingmaster_env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single" # Change if needed

  template {
    container {
      name   = "backend-db"
      image  = var.db_image
      cpu    = 0.5
      memory = "1Gi"

      # Registry authentication
      env {
        name  = "DOCKER_REGISTRY_SERVER"
        value = "index.docker.io"
      }
      env {
        name  = "DOCKER_REGISTRY_USERNAME"
        value = var.docker_registry_username
      }
      env {
        name  = "DOCKER_REGISTRY_PASSWORD"
        value = var.docker_registry_password
      }
      # Database credentials
      env {
        name  = "MYSQL_ROOT_PASSWORD"
        value = var.mysql_root_password
      }
    }
  }
  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 3306
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
