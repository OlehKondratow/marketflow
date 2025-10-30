resource "azurerm_key_vault" "kv" {
  name                       = "${var.project_name}-vault"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  purge_protection_enabled   = false
}
