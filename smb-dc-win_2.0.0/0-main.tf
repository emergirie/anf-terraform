# https://www.terraform.io/docs/providers/azurerm/index.html
# https://www.terraform.io/docs/providers/azurerm/r/resource_group.html

provider "azurerm" {
  version = "=2.0.0"
  features {}
}

# https://azure.microsoft.com/en-us/global-infrastructure/services/?products=netapp
# southeastasia, centralus, eastus, eastus2, westus2, southcentralus, northeurope, westeurope, japaneast, australiaeast, uksouth, ukwest, canadacentral

variable "region" {
    type        = string
    description = "Azure Region for the deployment (southeastasia, centralus, eastus, eastus2, westus2, southcentralus, northeurope, westeurope, japaneast, australiaeast, uksouth, ukwest, canadacentral)"
}

variable "rg01_name" {
    type        = string
    description = "Name for the Resource Group"
    default     = "rg01"
}

resource "azurerm_resource_group" "rg01" {
  name      = var.rg01_name
  location  = var.region
}
