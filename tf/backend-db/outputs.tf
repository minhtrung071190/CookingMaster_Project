output "backend_db_url" {
  value = azurerm_container_app.backend_db.ingress[0].fqdn
}

output "container_app_env_id" {
  value = azurerm_container_app_environment.cookingmaster_env.id
}

output "logs" {
  value = azurerm_log_analytics_workspace.logs.name
}