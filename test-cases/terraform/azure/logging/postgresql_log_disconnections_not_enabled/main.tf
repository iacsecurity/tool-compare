provider "azurerm" {
  features {}
}

locals {
  resource_prefix = "asdf"
  tests_scope = "Tests"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_prefix}-RG"
  location = "West Europe"
}

resource "azurerm_postgresql_server" "example" {
  name                = "${local.resource_prefix}-postgresql-server"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "B_Gen5_2"

  administrator_login          = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "11"
  ssl_enforcement_enabled      = true
  public_network_access_enabled    = true
}

resource "azurerm_postgresql_configuration" "example" {
  name                = "log_disconnections"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.example.name
  value               = "off"
}

