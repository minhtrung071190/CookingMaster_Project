terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {} # This block is required for the Azure provider to work
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "eastus"

  tags = {
    name = "app-rg"
  }
}

#Create virtual networks
resource "azurerm_virtual_network" "vnets" {
  for_each            = var.vpc_name
  name                = each.value
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [lookup(var.vpc_cidr, each.key)]

}

#Create subnets
resource "azurerm_subnet" "subnets" {
  for_each             = var.subnet_name
  name                 = each.value
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnets[each.key].name
  address_prefixes     = [lookup(var.subnet_cidr, each.value)]

}