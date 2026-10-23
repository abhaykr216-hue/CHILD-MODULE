data "azurerm_public_ip" "pip" {
  for_each = var.bastion

  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
}
