terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}
provider "azurerm" {
  features {}
}
locals {
  test_description = "set up sql server that doesn't have a public access"
  test_name        = "PublicAccessSqlDatabaseRule-test"
  resource_prefix = "test"
}
resource "azurerm_resource_group" "tests-resource-group" {
  name     = "${local.resource_prefix}resourcegroup"
  location = "West Europe"
}

resource "azurerm_mssql_server" "my-sql-server" {
  name                          = "${local.resource_prefix}sqlserver"
  resource_group_name           = azurerm_resource_group.tests-resource-group.name
  location                      = azurerm_resource_group.tests-resource-group.location
  version                       = "12.0"
  administrator_login           = "4dm1n157r470r"
  administrator_login_password  = "4-v3ry-53cr37-p455w0rd"
  public_network_access_enabled = true

  tags = {
    ResScope = local.test_description
  }
}

resource "azurerm_storage_account" "my-storage-account" {
  name                     = "${local.resource_prefix}storageaccount"
  resource_group_name      = azurerm_resource_group.tests-resource-group.name
  location                 = azurerm_resource_group.tests-resource-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "my-sql-database" {
  name                = "${local.resource_prefix}sqldatabase"
  resource_group_name = azurerm_resource_group.tests-resource-group.name
  location            = azurerm_resource_group.tests-resource-group.location
  server_name         = azurerm_mssql_server.my-sql-server.name

  //  extended_auditing_policy {
  //    storage_endpoint                        = azurerm_storage_account.my-storage-account.primary_blob_endpoint
  //    storage_account_access_key              = azurerm_storage_account.my-storage-account.primary_access_key
  //    storage_account_access_key_is_secondary = true
  //    retention_in_days                       = 6
  //  }

  tags = {
    ResScope = local.test_description
  }
}

resource "azurerm_sql_firewall_rule" "example" {
  name                = "allow inbound internet"
  resource_group_name = azurerm_resource_group.tests-resource-group.name
  server_name         = azurerm_mssql_server.my-sql-server.name
  start_ip_address    = "79.181.213.138"
  end_ip_address      = "79.181.213.138"
}