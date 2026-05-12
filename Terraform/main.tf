module "resource_group" {
  source = "./modules/resource-group"

  project     = var.project
  environment = var.environment
  location    = var.location
}

module "network" {
  source = "./modules/network"

  project              = var.project
  environment          = var.environment
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  vnet_address_space   = var.vnet_address_space
  aks_subnet_cidr      = var.aks_subnet_cidr
  postgres_subnet_cidr = var.postgres_subnet_cidr
}

module "monitoring" {
  source = "./modules/monitoring"

  project             = var.project
  environment         = var.environment
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  log_retention_days  = var.log_retention_days
  workspace_name     = "aks-log-workspace"
  appinsights_name   = "springboot-appinsights"
}

module "acr" {
  source = "./modules/acr"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
}

module "aks" {
  source = "./modules/aks"

  project               = var.project
  environment           = var.environment
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  kubernetes_version    = var.kubernetes_version
  subnet_id             = module.network.aks_subnet_id
  workspace_id          = module.monitoring.workspace_id
  acr_id                = module.acr.acr_id
  system_node_count     = var.system_node_count
  system_node_vm_size   = var.system_node_vm_size
  system_node_min_count = var.system_node_min_count
  system_node_max_count = var.system_node_max_count
}

module "keyvault" {
  source = "./modules/keyvault"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  aks_kubelet_object_id = module.aks.kubelet_object_id
  #key_vault_id = module.keyvault.key_vault_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  #postgres_fqdn    = module.postgres.postgres_fqdn
  db_admin_username = var.db_admin_username
  db_admin_password = var.db_admin_password
} 

resource "azurerm_key_vault_secret" "db_url" {
  name         = "db-url"
  value        = "jdbc:postgresql://${module.postgres.postgres_fqdn}:5432/appdb"
  key_vault_id = module.keyvault.key_vault_id
}

resource "azurerm_key_vault_secret" "appinsights" {
  name         = "appinsights-connection-string"
  value        = module.monitoring.application_insights_connection_string
  key_vault_id = module.keyvault.key_vault_id
}

module "postgres" {
  source = "./modules/postgres"

  project                 = var.project
  environment             = var.environment
  postgres_database_name  = var.postgres_database_name
  postgres_storage_mb     = var.postgres_storage_mb
  postgres_sku            = var.postgres_sku
  location                = module.resource_group.resource_group_location
  resource_group_name     = module.resource_group.resource_group_name
  postgres_subnet_id      = module.network.postgres_subnet_id
  private_dns_zone_id     = module.network.private_dns_zone_id
  postgres_admin_username = var.postgres_admin_username
  key_vault_id = module.keyvault.key_vault_id

}

data "azurerm_client_config" "current" {}

