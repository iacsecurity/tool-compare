terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.57"
    }
  }
}

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

resource "azurerm_storage_account" "storacc" {
  name                     = "${local.resource_prefix}funcapptstsa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "svcplanconsumption" {
  name                = "${local.resource_prefix}-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  #kind                = "Linux"
  #reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "functionapp" {
  name = "${local.resource_prefix}-functionapp"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.svcplanconsumption.id
  storage_account_name       = azurerm_storage_account.storacc.name
  storage_account_access_key = azurerm_storage_account.storacc.primary_access_key
  #os_type                    = "linux"
  version                    = "~3"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "java"
  }

  site_config {
    java_version = "1.8"
    #linux_fx_version = "JAVA|11"
  }
}


# linux vs win
#func "kind": "functionapp,linux",   vs    "kind": "functionapp",
#fun  "reserved": true,             vs     "reserved": false,
#GET /subscriptions/{subscription}b/providers/Microsoft.Web/availableStacks?osTypeSelected=linux&api-version=2018-02-01

