terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
  }
}

resource "azurerm_bastion_host" "bast" {
  for_each = var.bastion

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "bas_config"
    subnet_id            = var.subnet_ids[each.value.subnets_name]
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}