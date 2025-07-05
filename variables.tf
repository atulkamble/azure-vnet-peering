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
