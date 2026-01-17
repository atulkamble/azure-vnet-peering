resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# VNet-A
resource "azurerm_virtual_network" "vnet_a" {
  name                = "vnet-a"
  address_space       = var.vnet_a_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_a" {
  name                 = "subnet-a"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_a.name
  address_prefixes     = var.subnet_a_prefix
}

# VNet-B
resource "azurerm_virtual_network" "vnet_b" {
  name                = "vnet-b"
  address_space       = var.vnet_b_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_b" {
  name                 = "subnet-b"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_b.name
  address_prefixes     = var.subnet_b_prefix
}

# VNet Peering A -> B
resource "azurerm_virtual_network_peering" "peer_a_to_b" {
  name                         = "peer-a-to-b"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet_a.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_b.id
  allow_virtual_network_access = true
}

# VNet Peering B -> A
resource "azurerm_virtual_network_peering" "peer_b_to_a" {
  name                         = "peer-b-to-a"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet_b.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_a.id
  allow_virtual_network_access = true
}

# Network Security Group for VM1 (Allow SSH)
resource "azurerm_network_security_group" "nsg_vm1" {
  name                = "nsg-vm1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for VM2 (Allow SSH from VNet)
resource "azurerm_network_security_group" "nsg_vm2" {
  name                = "nsg-vm2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

# Public IP for VM1
resource "azurerm_public_ip" "vm1_public_ip" {
  name                = "vm1-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface for VM1 (with Public IP)
resource "azurerm_network_interface" "vm1_nic" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "vm1-ipconfig"
    subnet_id                     = azurerm_subnet.subnet_a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1_public_ip.id
  }
}

# Associate NSG with VM1 NIC
resource "azurerm_network_interface_security_group_association" "vm1_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.vm1_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_vm1.id
}

# Network Interface for VM2 (Private IP only)
resource "azurerm_network_interface" "vm2_nic" {
  name                = "vm2-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "vm2-ipconfig"
    subnet_id                     = azurerm_subnet.subnet_b.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associate NSG with VM2 NIC
resource "azurerm_network_interface_security_group_association" "vm2_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.vm2_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_vm2.id
}

# VM1 in VNet-A with Public IP
resource "azurerm_linux_virtual_machine" "vm1" {
  name                            = "vm1-vneta"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm1_nic.id,
  ]

  os_disk {
    name                 = "vm1-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# VM2 in VNet-B with Private IP only
resource "azurerm_linux_virtual_machine" "vm2" {
  name                            = "vm2-vnetb"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm2_nic.id,
  ]

  os_disk {
    name                 = "vm2-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
