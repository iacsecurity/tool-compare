provider "azurerm" {
  subscription_id = "230613d8-3b34-4790-b650-36f31045f19a"
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

resource "azurerm_logic_app_workflow" "workflow" {
  name                = "${local.resource_prefix}-workflow"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}