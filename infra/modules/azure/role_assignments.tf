data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "network_contrib" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

# Optional: KeyVault secrets access for current user
resource "azurerm_role_assignment" "kv_secret_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.user_object_id
}
