resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.project}-${var.environment}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project}-${var.environment}"
  kubernetes_version  = var.kubernetes_version

  role_based_access_control_enabled = true

  # Use a dedicated node resource group name (cleaner)
  node_resource_group = "${var.project}-${var.environment}-aks-nodes-rg"

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = var.system_node_vm_size
    vnet_subnet_id = var.subnet_id
    os_disk_size_gb     = 50
    type                = "VirtualMachineScaleSets"
    zones               = ["1", "2", "3"] # Spread across availability zones
    min_count           = var.system_node_min_count
    max_count           = var.system_node_max_count

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.environment
    }
  }

  # System-assigned identity for AKS control plane
  identity {
    type = "SystemAssigned"
  }

  # Managed identity for kubelet (used for ACR pull, Key Vault access)
  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet.id
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    service_cidr      = "10.100.0.0/16"
    dns_service_ip    = "10.100.0.10"
  }

  # Enable Azure Monitor integration
  oms_agent {
    log_analytics_workspace_id = var.workspace_id
  }

  # Enable Key Vault secrets provider (CSI driver)
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  # Enable workload identity (for pods to access Azure resources)
  workload_identity_enabled = true
  oidc_issuer_enabled       = true

}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

resource "azurerm_user_assigned_identity" "aks_kubelet" {
  name                = "${var.project}-${var.environment}-aks-kubelet-identity"
  location            = var.location
  resource_group_name = var.resource_group_name

}

