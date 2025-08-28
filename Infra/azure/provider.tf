terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "2cc37953-d4a5-4866-870a-dc708c212344"
}
