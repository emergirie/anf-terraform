# https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html
# https://www.terraform.io/docs/providers/azurerm/r/subnet.html
# https://www.terraform.io/docs/providers/azurerm/r/network_interface.html

variable "vnet01_name" {
    type        = string
    description = "Name of the VNet"
    default     = "vnet01"
}

variable "vnet01_address_space" {
    type        = list(string)
    description = "IP Address space for the VNet"
}

variable "vnet01_subnetanf_name" {
    type        = string
    description = "Name of the delegated subnet for ANF"
    default     = "anf"
}

variable "vnet01_subnetanf_address_prefix" {
    type        = string
    description = "Address Prefix for the delegated ANF subnet (/24-/28)"
}

variable "vnet01_subnetvm_name" {
    type        = string
    description = "Name of the subnet for VMs"
    default     = "vm"
}

variable "vnet01_subnetvm_address_prefix" {
    type        = string
    description = "Address Prefix for the VM subnet"
}

variable "vnet01_subnetvm_static_ip_dc01" {
    type        = string
    description = "IP Address for the VM acting as Domain Controller"
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

resource "azurerm_subnet" "vnet01_subnetvm" {
  name                 = var.vnet01_subnetvm_name
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefix       = var.vnet01_subnetvm_address_prefix
}

resource "azurerm_network_interface" "dc01-nic" {
  name                = "dc01-nic"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet01_subnetvm.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vnet01_subnetvm_static_ip_dc01
  }
  depends_on          = [azurerm_subnet.vnet01_subnetvm]
}
