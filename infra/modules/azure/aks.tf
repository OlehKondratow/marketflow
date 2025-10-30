resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  dns_prefix          = "${var.project_name}-dns"
  sku_tier            = "Free"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "system"
    vm_size    = "Standard_B2s"
    node_count = 1
  }

  network_profile {
    network_plugin = "azure"
  }
}
