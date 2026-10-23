terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
  }
}

data "azurerm_public_ip" "appgw" {
  for_each = var.appgws

  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_application_gateway" "appgw" {
  for_each = var.appgws

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.capacity
  }

  gateway_ip_configuration {
    name      = "${each.value.name}-gateway-ip"
    subnet_id = var.subnet_ids[each.value.subnet_name]
  }

  frontend_ip_configuration {
    name                 = "${each.value.name}-frontend-ip"
    public_ip_address_id = data.azurerm_public_ip.appgw[each.key].id
  }

  frontend_port {
    name = each.value.frontend_port_name
    port = each.value.frontend_port
  }

  backend_address_pool {
    name = "${each.value.name}-backend-pool"
    ip_addresses = [each.value.backend_ip]
  }

  backend_http_settings {
    name                  = "${each.value.name}-backend-http-setting"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "${each.value.name}-http-listener"
    frontend_ip_configuration_name = "${each.value.name}-frontend-ip"
    frontend_port_name             = each.value.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${each.value.name}-routing-rule"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "${each.value.name}-http-listener"
    backend_address_pool_name  = "${each.value.name}-backend-pool"
    backend_http_settings_name = "${each.value.name}-backend-http-setting"
  }
}
