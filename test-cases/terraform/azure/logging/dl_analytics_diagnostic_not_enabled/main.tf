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

resource "azurerm_data_lake_store" "dls" {
  name                = "${local.resource_prefix}datalakestore"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

}

resource "azurerm_data_lake_analytics_account" "dla" {
  name                = "${local.resource_prefix}datalakeanalytics"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  default_store_account_name = azurerm_data_lake_store.dls.name
}
