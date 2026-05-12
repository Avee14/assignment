data "azurerm_key_vault_secret" "postgres_password" {
  name         = "db-password"
  key_vault_id = var.key_vault_id
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "${var.project}-${var.environment}-psql-${random_string.suffix.result}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "15"
  delegated_subnet_id = var.postgres_subnet_id
  private_dns_zone_id = var.private_dns_zone_id
  administrator_login    = var.postgres_admin_username
  administrator_password = data.azurerm_key_vault_secret.postgres_password.value
  zone                   = "1"
  storage_mb             = var.postgres_storage_mb
  sku_name               = var.postgres_sku

  high_availability {
    mode                      = var.environment == "prod" ? "ZoneRedundant" : "Disabled"
    standby_availability_zone = var.environment == "prod" ? "2" : null
  }

}

resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = var.postgres_database_name
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

# PostgreSQL server configuration tuning
resource "azurerm_postgresql_flexible_server_configuration" "connection_throttling" {
  name      = "connection_throttle.enable"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "on"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_connections" {
  name      = "log_connections"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "on"
}
