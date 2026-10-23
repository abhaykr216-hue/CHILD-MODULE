variable "nat_gateway" {
  description = "Single NAT gateway shared by the frontend and backend subnets."
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    public_ip_name      = string
    subnet_names        = list(string)
  })
}

variable "subnet_ids" {
  description = "Map of subnet IDs created by the subnet module."
  type        = map(string)
}
