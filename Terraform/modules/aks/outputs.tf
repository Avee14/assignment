output "aks_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.main.id
}
output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}