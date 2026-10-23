output "subnet_ids" {
  description = "Map of subnet IDs keyed by Azure subnet names."
  value       = { for k, v in azurerm_subnet.jio-sub : v.name => v.id }
}
