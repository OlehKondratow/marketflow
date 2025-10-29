terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.94.0"
    }
  }

  backend "local" {}
  # Рекомендуется использовать удаленный бэкенд для совместной работы
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "tfstatestorageacc"
  #   container_name       = "tfstate"
  #   key                  = "marketflow.dev.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
  use_azuread_auth = true
}

# Рекомендуется использовать аутентификацию по ключу и роль с меньшими привилегиями
provider "snowflake" {
  account  = "jnvtvbs-wz81424"
  region   = "westeurope.azure"
  username = var.snowflake_user
  password = var.snowflake_password
  role     = "ACCOUNTADMIN"
  role     = "TERRAFORM_ROLE" # Пример роли с ограниченными правами
  private_key_path = var.snowflake_private_key_path
}
