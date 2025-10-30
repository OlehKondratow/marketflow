resource "azurerm_eventhub_namespace" "kafka" {
  name                = "eh-${var.project_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
  kafka_enabled       = true
}
