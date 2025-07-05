resource_group_name  = "vnet-peering-demo-rg"
location             = "East US"

vnet_a_address_space = ["10.0.0.0/16"]
vnet_b_address_space = ["10.1.0.0/16"]

subnet_a_prefix      = ["10.0.1.0/24"]
subnet_b_prefix      = ["10.1.1.0/24"]
