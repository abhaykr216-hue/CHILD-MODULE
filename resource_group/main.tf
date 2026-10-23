terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  for_each = var.rgs

  name     = each.value.name
  location = each.value.location
}
