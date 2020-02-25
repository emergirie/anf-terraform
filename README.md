# anf-terraform
Collection of examples how to utilize Terraform to quickly managed deployments of Azure NetApp Files

All examples are based on the Azure Provider for Terraform: https://www.terraform.io/docs/providers/azurerm/index.html

## simple-nfs

Creation of a simple NFS setup with one Azure NetApp Files volume.

* Resource Group
* Vnet + Subnet for ANF
* ANF Account + Pool + NFS Volume

## smb-dc-win

Creation of a simple SMB setup with one Azure NetApp Files volume and one Windows-based DC for the AD.

* Resource Group
* Vnet + Subnet for ANF + DC
* ANF Account + Pool + SMB Volume

Remark: Setup will run fine, but the volume will be created as a NFS volume. See https://github.com/terraform-providers/terraform-provider-azurerm/issues/5871
