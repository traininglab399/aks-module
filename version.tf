terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Ensure this is at least 3.x
    }
  }
}

provider "azurerm" {
  features {}
}
