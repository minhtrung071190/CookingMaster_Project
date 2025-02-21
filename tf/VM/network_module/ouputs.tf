output "vnet1_id" {
  value = azurerm_virtual_network.vnets["vnet1"].id
}

output "vnet2_id" {
  value = azurerm_virtual_network.vnets["vnet2"].id
}

output "vnet1_subnet_id" {
  value = azurerm_subnet.subnets["vnet1"].id
}

output "vnet2_subnet_id" {
  value = azurerm_subnet.subnets["vnet2"].id
}

output "bastion_subnet" {
  value = azurerm_subnet.azure-bastion-subnet
}

output "resource_group_name" {
  value = azurerm_resource_group.MST300-project2-rg.name
}

output "location" {
  value = azurerm_resource_group.MST300-project2-rg.location
}
