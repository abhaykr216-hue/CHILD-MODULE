terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.80.0"
    }
  }
}

resource "azurerm_network_interface" "nic" {
  for_each = var.nics
  name = each.value.name
  location = each.value.location
  resource_group_name = each.value.resource_group_name
  ip_configuration {
    name = each.value.ipconfig_name
    private_ip_address_allocation = "Dynamic"
    subnet_id = data.azurerm_subnet.jio-sub[each.key].id
    # public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}

data "azurerm_network_security_group" "jio-nsg" {
  for_each = var.nics
  name                = each.value.nsg_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each = var.nics
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = data.azurerm_network_security_group.jio-nsg[each.key].id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.nics
  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm-size
  admin_username      = each.value.admin-username
  admin_password = data.azurerm_key_vault_secret.jio-secrets[each.key].value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = each.value.image_version
  }
}
