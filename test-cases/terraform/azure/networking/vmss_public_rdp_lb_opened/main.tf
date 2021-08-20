# no any nsg - opened

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
  address_space       = ["10.6.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
  name                 = "${local.resource_prefix}-snet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.6.25.0/24"]
}

resource "azurerm_public_ip" "lbpip" {
  name                = "${local.resource_prefix}-lbpip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_lb" "elb" {
  name                = "${local.resource_prefix}-elb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "FrontPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bck" {
  loadbalancer_id = azurerm_lb.elb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "probe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.elb.id
  name                = "rdp-running-probe"
  port                = 3389
}

resource "azurerm_lb_rule" "example" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.elb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "FrontPublicIPAddress"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bck.id
  probe_id = azurerm_lb_probe.probe.id
}

resource "azurerm_windows_virtual_machine_scale_set" "example" {
  name                = "${local.resource_prefix}-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_B2s"
  instances           = 3
  admin_password      = "P@55w0rd1234!"
  admin_username      = "adminuser"
  computer_name_prefix = "pc"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.snet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bck.id]
    }
  }
}

//load_balancer_inbound_nat_rules_ids
//depends_on = [azurerm_lb_backend_address_pool.bck]
