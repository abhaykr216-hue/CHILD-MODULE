variable "keyvaults" {
  description = "Map of Azure Key Vault definitions."
  type        = map(any)
}

variable "secrets" {
  description = "Map of secrets to create inside the vaults."
  type        = map(any)
}
