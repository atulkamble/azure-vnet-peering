output "vnet_a_id" {
  value = azurerm_virtual_network.vnet_a.id
}

output "vnet_b_id" {
  value = azurerm_virtual_network.vnet_b.id
}

output "peering_a_to_b_id" {
  value = azurerm_virtual_network_peering.peer_a_to_b.id
}

output "peering_b_to_a_id" {
  value = azurerm_virtual_network_peering.peer_b_to_a.id
}

output "vm1_public_ip" {
  description = "Public IP address of VM1"
  value       = azurerm_public_ip.vm1_public_ip.ip_address
}

output "vm1_private_ip" {
  description = "Private IP address of VM1"
  value       = azurerm_network_interface.vm1_nic.private_ip_address
}

output "vm2_private_ip" {
  description = "Private IP address of VM2"
  value       = azurerm_network_interface.vm2_nic.private_ip_address
}

output "vm1_ssh_command" {
  description = "SSH command to connect to VM1"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.vm1_public_ip.ip_address}"
}

output "vm2_ssh_command" {
  description = "SSH command to connect to VM2 (from VM1)"
  value       = "ssh ${var.admin_username}@${azurerm_network_interface.vm2_nic.private_ip_address}"
}
