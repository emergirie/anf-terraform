variable "region" {
    type        = string
    description = "Azure Region for the deployment"
}

variable "rg01_name" {
    type        = string
    description = "Name for the Resource Group"
}

variable "vnet01_name" {
    type        = string
    description = "Name of the VNet"
}

variable "vnet01_address_space" {
    type        = list(string)
    description = "IP Address space for the VNet"
}

variable "vnet01_subnetanf_name" {
    type        = string
    description = "Name of the delegated subnet for ANF"
}

variable "vnet01_subnetanf_address_prefix" {
    type        = string
    description = "Address Prefix for the delegated subnet for ANF (/24-/28)"
}

variable "anf01_account_name" {
    type        = string
    description = "Name of the Azure NetApp Files Account"
}

variable "anf01_pool01_name" {
    type        = string
    description = "Name of the Azure NetApp Files Pool"
}

variable "anf01_pool01_service_level" {
    type        = string
    description = "Service Level of the Azure NetApp Files Pool (Standard/Premium/Ultra)"
}

variable "anf01_pool01_size_in_tb" {
    type        = number
    description = "Size (TiB) of the Azure NetApp Files Pool"
}

variable "anf01_pool01_vol01_name" {
    type        = string
    description = "Name of the Azure NetApp Files Volume"
}

variable "anf01_pool01_vol01_volume_path" {
    type        = string
    description = "Path for the Azure NetApp Files Volume"
}

variable "anf01_pool01_vol01_storage_quota_in_gb" {
    type        = number
    description = "Size (GiB) of the Azure NetApp Files Volume"
}