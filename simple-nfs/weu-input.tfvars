# Region
region = "West Europe"

# Resource Group
rg01_name = "rg-anf-tfdemo-weu"

# VNet
vnet01_name                     = "vnet-anf-tfdemo-weu"
vnet01_address_space            = ["172.20.0.0/16"]
vnet01_subnetanf_name           = "subnet-anf-tfdemo-weu"
vnet01_subnetanf_address_prefix = "172.20.1.0/24"

# ANF
anf01_account_name                      = "anf-tfdemo-weu"
anf01_pool01_name                       = "anf-tfdemo-pool"
anf01_pool01_service_level              = "Standard"
anf01_pool01_size_in_tb                 = 4
anf01_pool01_vol01_name                 = "anf-tfdemo-volnfs01"
anf01_pool01_vol01_volume_path          = "tfdemo-volnfs01"
anf01_pool01_vol01_storage_quota_in_gb  = 1024
