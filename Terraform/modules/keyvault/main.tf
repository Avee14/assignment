resource "azurerm_key_vault" "main" {
  name                = "${var.project}-${var.environment}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name = "standard"

  purge_protection_enabled = false
}