output "key_vault_ids" {
  description = "Map of key vault IDs keyed by the vault resource name"
  value       = { for k, v in azurerm_key_vault.kv : k => v.id }
}
