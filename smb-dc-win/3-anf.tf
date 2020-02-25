# https://www.terraform.io/docs/providers/azurerm/r/netapp_account.html
# https://www.terraform.io/docs/providers/azurerm/r/netapp_pool.html
# https://www.terraform.io/docs/providers/azurerm/r/netapp_volume.html
# https://www.terraform.io/docs/providers/azurerm/r/netapp_snapshot.html

variable "anf01_account_name" {
    type        = string
    description = "Name of the Azure NetApp Files Account"
    default     = "anf01"
}

variable "anf01_account_ad_computerprefix" {
    type        = string
    description = "Prefix used for computer accounts created in AD for the Azure NetApp Files Account"
    default     = "anfsmb"
}

variable "anf01_pool01_name" {
    type        = string
    description = "Name of the Azure NetApp Files Pool"
    default     = "pool01"
}

variable "anf01_pool01_service_level" {
    type        = string
    description = "Service Level of the Azure NetApp Files Pool (Standard/Premium/Ultra)"
    default     = "Standard"
}

variable "anf01_pool01_size_in_tb" {
    type        = number
    description = "Size (TiB) of the Azure NetApp Files Pool"
    default     = 4
}

variable "anf01_pool01_vol01_name" {
    type        = string
    description = "Name of the Azure NetApp Files Volume"
    default     = "vol01"
}

variable "anf01_pool01_vol01_volume_path" {
    type        = string
    description = "Path for the Azure NetApp Files Volume"
    default     = "vol01"
}

variable "anf01_pool01_vol01_storage_quota_in_gb" {
    type        = number
    description = "Size (GiB) of the Azure NetApp Files Volume"
    default     = 1024
}

resource "azurerm_netapp_account" "anf01_account" {
  name                = var.anf01_account_name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  active_directory {
    username            = var.dc01_admin_user
    password            = var.dc01_admin_password
    smb_server_name     = var.anf01_account_ad_computerprefix
    dns_servers         = [var.vnet01_subnetvm_static_ip_dc01]
    domain              = var.ad01_name
    organizational_unit = var.ad01_ou_anf
  }
  depends_on          = [azurerm_virtual_machine_extension.dc01-ad-create]
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
  # future (maybe 2.1.0)
  #protocols           = ["smb"]
  export_policy_rule {
      rule_index        = 1
      allowed_clients   = ["0.0.0.0/0"]
      cifs_enabled      = true
      nfsv3_enabled     = false
      nfsv4_enabled     = false
      #unix_read_only    = false
      #unix_read_write   = true
  }
}
