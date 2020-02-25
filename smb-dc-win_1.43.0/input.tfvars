# Region
region = "West Europe"

# Resource Group
rg01_name = "rg-tfdemo-weu"

# VNet
vnet01_name                     = "vnet-tfdemo-weu"
vnet01_address_space            = ["172.20.0.0/16"]
vnet01_subnetanf_name           = "subnet-tfdemo-weu-anf"
vnet01_subnetanf_address_prefix = "172.20.1.0/24"
vnet01_subnetvm_name            = "subnet-tfdemo-weu-vms"
vnet01_subnetvm_address_prefix  = "172.20.0.0/24"
vnet01_subnetvm_static_ip_dc01  = "172.20.0.100"

# ANF
anf01_account_name                      = "anf-tfdemo-weu"
anf01_pool01_name                       = "anf-tfdemo-pool"
anf01_pool01_service_level              = "Standard"
anf01_pool01_size_in_tb                 = 4
anf01_pool01_vol01_name                 = "smb-01"
anf01_pool01_vol01_volume_path          = "smb-01"
anf01_pool01_vol01_storage_quota_in_gb  = 1024

# DC01
dc01_admin_user     = "netapp"
