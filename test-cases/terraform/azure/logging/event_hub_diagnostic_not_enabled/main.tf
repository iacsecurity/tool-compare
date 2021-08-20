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

resource "azurerm_eventhub_namespace" "example" {
  name                = "${local.resource_prefix}eventhubnamespace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  capacity            = 1

}
