resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# VNet-A
resource "azurerm_virtual_network" "vnet_a" {
  name                = "vnet-a"
  address_space       = var.vnet_a_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_a" {
  name                 = "subnet-a"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_a.name
  address_prefixes     = var.subnet_a_prefix
}

# VNet-B
resource "azurerm_virtual_network" "vnet_b" {
  name                = "vnet-b"
  address_space       = var.vnet_b_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_b" {
  name                 = "subnet-b"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_b.name
  address_prefixes     = var.subnet_b_prefix
}

# VNet Peering A -> B
resource "azurerm_virtual_network_peering" "peer_a_to_b" {
  name                      = "peer-a-to-b"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_a.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_b.id
  allow_virtual_network_access = true
}

# VNet Peering B -> A
resource "azurerm_virtual_network_peering" "peer_b_to_a" {
  name                      = "peer-b-to-a"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_b.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_a.id
  allow_virtual_network_access = true
}
