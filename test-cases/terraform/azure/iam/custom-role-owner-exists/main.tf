provider "azurerm" {
  features {}
}

locals {
  resource_prefix = "asdf"
  tests_scope = "Tests"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "primary" {}

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_prefix}-RG"
  location = "West Europe"
}

resource "azurerm_role_definition" "example" {
  name        = "${local.resource_prefix}-custom-role"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["*"]
    not_actions = []
  }

}
