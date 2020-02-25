# https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html
# https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html

variable "ad01_name" {
    type        = string
    description = "Name of the AD Domain"
    default     = "anf.test"
}

variable "ad01_name_netbios" {
    type        = string
    description = "NetBIOS Name of the AD Domain"
    default     = "ANF"
}

variable "ad01_ou_anf" {
    type        = string
    description = "OU for the Computer Accounts created by ANF"
    default     = "CN=Computers"
}

variable "dc01_name" {
    type        = string
    description = "Name of the VM acting as Domain Controller"
    default     = "dc01"
}

variable "dc01_admin_user" {
    type        = string
    description = "Name of the admin user for the VM acting as Domain Controller"
}

variable "dc01_admin_password" {
    type        = string
    description = "Password of the admin user for the VM acting as Domain Controller"
}

// v2.0.0
#resource "azurerm_windows_virtual_machine" "dc01" {
resource "azurerm_virtual_machine" "dc01" {
  name                = var.dc01_name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  #size                = "Standard_F2"
  vm_size             = "Standard_F2"
  #admin_username      = var.dc01_admin_user
  #admin_password      = var.dc01_admin_password
  network_interface_ids = [
    azurerm_network_interface.dc01-nic.id,
  ]
  #os_disk {
  storage_os_disk {
    name                  = "odsisk"
    caching               = "ReadWrite"
    create_option         = "FromImage"
    #storage_account_type  = "Standard_LRS"
    managed_disk_type     = "Standard_LRS"
  }
  #source_image_reference {
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  os_profile {
    computer_name       = var.dc01_name
    admin_username      = var.dc01_admin_user
    admin_password      = var.dc01_admin_password
  }
  os_profile_windows_config {
    provision_vm_agent  = true
  }
}

locals {
  import_command        = "Import-Module ADDSDeployment"
  #password_command      = "$password = ConvertTo-SecureString '${azurerm_windows_virtual_machine.dc01.admin_password}' -AsPlainText -Force"
  password_command      = "$password = ConvertTo-SecureString '${var.dc01_admin_password}' -AsPlainText -Force"
  install_ad_command    = "Add-WindowsFeature -name AD-Domain-Services -IncludeManagementTools"
  configure_ad_command  = "Install-ADDSForest -CreateDnsDelegation:$false -DomainName ${var.ad01_name} -DomainNetbiosName ${var.ad01_name_netbios} -InstallDns:$true -SafeModeAdministratorPassword $password -NoRebootOnCompletion -Force:$true"
  shutdown_command      = "shutdown -r -t 10"
  exit_code_command     = "exit 0"
  powershell_command    = "${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_command}"
}

resource "azurerm_virtual_machine_extension" "dc01-ad-create"{
  name                  = "ad-create"
  virtual_machine_id    = azurerm_virtual_machine.dc01.id
  publisher             = "Microsoft.Compute"
  type                  = "CustomScriptExtension"
  type_handler_version  = "1.9"
  settings              = <<SETTINGS
  {
    "CommandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
  }
  SETTINGS
}
