terraform {

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azurerm" {
    subscription_id = "b568099c-fb2f-4e51-946f-d9e40f80e73b"
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "uksouth"
  name     = "rg-uks-flextest"
}

