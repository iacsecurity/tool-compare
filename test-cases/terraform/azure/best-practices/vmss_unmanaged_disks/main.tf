provider "azurerm" {
  features {}
}

locals {
  resource_prefix = "asdf"
  environment = "Tests"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_prefix}-RG"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.resource_prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
  name                 = "${local.resource_prefix}-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.resource_prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_storage_account" "storacc" {
  name                     = "${local.resource_prefix}tstsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.storacc.name
  container_access_type = "private"
}

resource "azurerm_virtual_machine_scale_set" "vmss1" {
  name                = "${local.resource_prefix}-vmss1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_B2s"
    capacity = 1
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = "myosdisk1"
    vhd_containers    = ["${azurerm_storage_account.storacc.primary_blob_endpoint}${azurerm_storage_container.container.name}/myosdisk1.vhd"]
    caching           = "ReadWrite"
    create_option     = "FromImage"    
  }

  os_profile {
    computer_name_prefix = "testvm"
    admin_username = "testadmin"
    admin_password = "Pas1sword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "networkprofile"
    primary = true

    ip_configuration {
      name        = "TestIPConfiguration"
      primary     = true
      subnet_id    = azurerm_subnet.snet.id
    }
  }
}

resource "azurerm_virtual_machine_scale_set" "vmss2" {
  name                = "${local.resource_prefix}-vmss2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_B2s"
    capacity = 1
  }

  storage_profile_os_disk {
    name              = "myosdisk1"
    image             = "https://donotdeletestoracc.blob.core.windows.net/vhds/myosdisk1.vhd"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    os_type           = "linux"    
  }

  os_profile {
    computer_name_prefix = "testvm"
    admin_username = "testadmin"
    admin_password = "Pas1sword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "networkprofile"
    primary = true

    ip_configuration {
      name         = "TestIPConfiguration"
      primary     = true
      subnet_id   = azurerm_subnet.snet.id
    }
  }
}
