# Cloud Provider and the version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Azure Provider Config
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Resouce Group Config
resource "azurerm_resource_group" "WebAppGrp_Name" {
  name     = var.resourceGroupName
  location = var.location
}
