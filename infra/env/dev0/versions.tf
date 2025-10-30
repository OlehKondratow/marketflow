terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 0.94.0"
    }
  }
}