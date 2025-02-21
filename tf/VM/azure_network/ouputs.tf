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

