# main.tf

provider "azurerm" {
  features {}
  subscription_id = "922ef694-a56b-40f9-b615-36e3aedb343f"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "myRGStorage"
    storage_account_name = "cloudexsenecastorage"
    container_name       = "network"
    key                  = "network/statefile.tfstate"
  }
}

#Create network interface
resource "azurerm_network_interface" "webserver_nic" {
  for_each            = var.webserver_name
  name                = "${each.value}-ip"
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.terraform_remote_state.network.outputs.vnet1_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create webserver
resource "azurerm_virtual_machine" "webserver" {
  for_each                         = var.webserver_name
  name                             = each.value
  resource_group_name              = data.terraform_remote_state.network.outputs.resource_group_name
  location                         = data.terraform_remote_state.network.outputs.location
  vm_size                          = "Standard_D2s_v3"
  network_interface_ids            = [azurerm_network_interface.webserver_nic[each.key].id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"
}

storage_os_disk {
  name              = "${each.value}-osdisk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"
}

os_profile {
  computer_name  = each.value
  admin_username = "ubuntu"
  admin_password = var.server_password
}

os_profile_linux_config {
  disable_password_authentication = false
}

#Install Docker
resource "azurerm_virtual_machine_extension" "install_docker" {
  for_each                   = var.webserver_name
  name                       = "install_docker"
  virtual_machine_id         = azurerm_virtual_machine.webserver[each.key].id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true

  protected_settings = <<PROTECTED_SETTINGS
  {
    "script": "curl -fsSL https://get.docker.com | sh && sudo usermod -aG docker ubuntu"
  }
  PROTECTED_SETTINGS
}

#Create client network interface
resource "azurerm_network_interface" "client_nic" {
  name                = "client-nic"
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.terraform_remote_state.network.outputs.vnet2_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}