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
