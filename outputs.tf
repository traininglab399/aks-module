output "resource_group_name" {
  description = "The name of the resource group."
  value       = local.main_resource_group_name
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = local.vnet_name
}

output "subnet_id" {
  description = "The ID of the subnet used for AKS."
  value       = data.azurerm_subnet.aks_subnet.id
}

output "cluster_name" {
  description = "The name of the AKS cluster."
  value       = module.aks.cluster_name
}

output "kube_config" {
  description = "The kubeconfig file content for accessing the AKS cluster."
  value       = module.aks.kube_config
  sensitive   = true
}

output "cluster_fqdn" {
  description = "The FQDN of the AKS cluster."
  value       = module.aks.cluster_fqdn
}
