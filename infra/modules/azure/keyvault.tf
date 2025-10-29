data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                = "kv${var.project_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}
