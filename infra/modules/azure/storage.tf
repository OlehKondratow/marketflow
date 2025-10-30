resource "azurerm_storage_account" "sa" {
  name                     = "${var.project_name}stor${substr(uuid(), 0, 4)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
}
