variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "vnet_a_address_space" {
  description = "Address space for VNet-A"
  type        = list(string)
}

variable "vnet_b_address_space" {
  description = "Address space for VNet-B"
  type        = list(string)
}

variable "subnet_a_prefix" {
  description = "Address prefix for Subnet-A"
  type        = list(string)
}

variable "subnet_b_prefix" {
  description = "Address prefix for Subnet-B"
  type        = list(string)
}

variable "vm_size" {
  description = "Size of the Virtual Machines"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VMs"
  type        = string
  sensitive   = true
}
