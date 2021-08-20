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
  name                     = "${local.resource_prefix}tststacc"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "examplecontainer"
  storage_account_name  = azurerm_storage_account.storacc.name
  container_access_type = "private"
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "${local.resource_prefix}eventhubnamespace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  capacity            = 1
}

resource "azurerm_eventhub" "eventhub" {
  name                = "${local.resource_prefix}-eventhub"
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_eventhub_namespace.example.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "example" {
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_eventhub_namespace.example.name
  eventhub_name       = azurerm_eventhub.eventhub.name
  name                = "authrule1"
  send                = true
  //listen              = true
  //manage              = true
}


resource "azurerm_iothub" "iothub" {
  name                = "${local.resource_prefix}-IoTHub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = azurerm_storage_account.storacc.primary_blob_connection_string
    name                       = "export"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = azurerm_storage_container.example.name
    encoding                   = "Avro"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  endpoint {
    type              = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.example.primary_connection_string
    name              = "export2"
  }

  route {
    name           = "export"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
  }

  route {
    name           = "export2"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export2"]
    enabled        = true
  }

  enrichment {
    key            = "tenant"
    value          = "$twin.tags.Tenant"
    endpoint_names = ["export", "export2"]
  }

}
