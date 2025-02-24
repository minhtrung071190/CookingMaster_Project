terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.20.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "922ef694-a56b-40f9-b615-36e3aedb343f"
}