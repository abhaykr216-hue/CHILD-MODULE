variable "bastion" {
  description = "Map of Bastion definitions."
  type        = map(any)
}

variable "subnet_ids" {
  description = "Map of subnet IDs created by the subnet module."
  type        = map(string)
}