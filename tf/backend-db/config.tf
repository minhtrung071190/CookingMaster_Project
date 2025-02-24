terraform {
  backend "azurerm" {
    resource_group_name  = "CloudEx-Seneca-RG"
    storage_account_name = "cloudexsenecastorage"
    container_name       = "backend-db"
    key                  = "statefile.tfstate"
  }
}