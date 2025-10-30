resource "azurerm_container_registry" "acr" {
  name                = "${var.project_name}acr${substr(uuid(), 0, 4)}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}
