terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
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

resource "azurerm_security_center_contact" "example" {
  email = "contact@example.com"
  #phone = "+1-555-555-5555"

  alert_notifications = false
  alerts_to_admins    = true
}
