data "azurerm_public_ip" "pip" {
  name                = var.nat_gateway.public_ip_name
  resource_group_name = var.nat_gateway.resource_group_name
}
