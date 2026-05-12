resource "azurerm_key_vault" "main" {
  name                = "${var.project}-${var.environment}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id

  sku_name = "standard"

}

resource "azurerm_role_assignment" "aks_kv_access" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"

  principal_id = var.aks_kubelet_object_id
}

resource "azurerm_key_vault_secret" "db_url" {
  name = "db-url"

  value = "jdbc:postgresql://${var.postgres_fqdn}:5432/appdb"

  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_username" {
  name         = "db-username"
  value        = var.db_admin_username
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = var.db_admin_password
  key_vault_id = azurerm_key_vault.main.id
}


resource "azurerm_key_vault_secret" "appinsights" {

  name         = "appinsights-connection-string"

  value        = module.monitoring.application_insights_connection_string

  key_vault_id = module.keyvault.key_vault_id
}