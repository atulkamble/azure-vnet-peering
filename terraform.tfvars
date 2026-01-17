resource_group_name = "vnet-peering-demo-rg"
location            = "East US"

vnet_a_address_space = ["10.0.0.0/16"]
vnet_b_address_space = ["10.1.0.0/16"]

subnet_a_prefix = ["10.0.1.0/24"]
subnet_b_prefix = ["10.1.1.0/24"]

# VM Configuration
vm_size        = "Standard_B1s"
admin_username = "azureuser"
admin_password = "P@ssw0rd1234!" # Change this to a secure password
