terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
  }
}

resource "azurerm_nat_gateway" "nat" {
  name                = var.nat_gateway.name
  location            = var.nat_gateway.location
  resource_group_name = var.nat_gateway.resource_group_name
  sku_name            = "Standard"
}
