resource "azurerm_nat_gateway_public_ip_association" "nat_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = data.azurerm_public_ip.pip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_association" {
  for_each = toset(var.nat_gateway.subnet_names)

  subnet_id      = var.subnet_ids[each.value]
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
