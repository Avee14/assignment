resource "azurerm_container_registry" "main" {
  name                = "${replace(var.project, "-", "")}${var.environment}${random_string.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false # Use managed identity instead

  # Geo-replication for HA (only supported on Premium SKU)
  dynamic "georeplications" {
    for_each = var.acr_sku == "Premium" ? var.acr_georeplications : []
    content {
      location                = georeplications.value
      zone_redundancy_enabled = true
    }
  }
}
