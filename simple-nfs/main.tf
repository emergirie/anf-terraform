# https://www.terraform.io/docs/providers/azurerm/r/netapp_account.html

provider "azurerm" {
  version = "=1.41"
}

resource "azurerm_resource_group" "rg01" {
  name      = var.rg01_name
  location  = var.region
}

resource "azurerm_virtual_network" "vnet01" {
  name                = var.vnet01_name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  address_space       = var.vnet01_address_space
}

resource "azurerm_subnet" "vnet01_subnetanf" {
  name                 = var.vnet01_subnetanf_name
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefix       = var.vnet01_subnetanf_address_prefix
  delegation {
    name = "netapp"
    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_netapp_account" "anf01_account" {
  name                = var.anf01_account_name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  #active_directory {
  #  username            = "aduser"
  #  password            = "aduserpwd"
  #  smb_server_name     = "SMBSERVER"
  #  dns                 = ["1.2.3.4"]
  #  domain              = "westcentralus.com"
  #  organizational_unit = "OU=FirstLevel"
  #}
}

resource "azurerm_netapp_pool" "anf01_pool01" {
  name                = var.anf01_pool01_name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  account_name        = azurerm_netapp_account.anf01_account.name
  service_level       = var.anf01_pool01_service_level
  size_in_tb          = var.anf01_pool01_size_in_tb
}

resource "azurerm_netapp_volume" "anf01_vol01" {
  name                = var.anf01_pool01_vol01_name
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  account_name        = azurerm_netapp_account.anf01_account.name
  pool_name           = azurerm_netapp_pool.anf01_pool01.name
  volume_path         = var.anf01_pool01_vol01_volume_path
  service_level       = azurerm_netapp_pool.anf01_pool01.service_level
  subnet_id           = azurerm_subnet.vnet01_subnetanf.id
  storage_quota_in_gb = var.anf01_pool01_vol01_storage_quota_in_gb
}
