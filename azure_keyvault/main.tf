data "azurerm_client_config" "current" {}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
  }
}

resource "azurerm_key_vault" "kv" {
  for_each = var.keyvaults

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = each.value.sku_name
  rbac_authorization_enabled    = true
  purge_protection_enabled      = each.value.purge_protection_enabled
  soft_delete_retention_days    = each.value.soft_delete_retention_days
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  for_each = var.keyvaults

  scope                = azurerm_key_vault.kv[each.key].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "vm_password" {
  for_each = var.secrets

  name         = each.value.name
  value        = each.value.value
  key_vault_id = azurerm_key_vault.kv[each.value.key_vault].id

  depends_on = [azurerm_role_assignment.kv_secrets_officer]
}