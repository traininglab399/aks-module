# Resource Group Module
module "tags" {
  source = "../../Developer_Experience/terraform-modules/az-tags"
  tags   = local.tags
}

module "main_rg" {
  source            = "../../Developer_Experience/terraform-modules/az-resource-groups"
  location          = local.location
  resourcegroupname = local.main_resource_group_name
  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
  tags              = module.tags.tags
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "logs" {
  name                = local.log_analytics_workspace_name
  location            = local.location
  resource_group_name = local.vnet_rg
  retention_in_days   = var.log_retention_days
  tags                = module.tags.tags
}

# Managed Identity for AKS
module "avm-res-managedidentity-userassignedidentity" {
  source              = "../../Developer_Experience/terraform-modules/az-managed-identity"
  name                = "${local.application_name}-mi-${var.environment}"
  location            = local.location
  resource_group_name = local.main_resource_group_name
  tags                = module.tags.tags
}

# Role Assignments
resource "azurerm_role_assignment" "role-assignment-dnszone" {
  scope                = data.azurerm_private_dns_zone.dnszone-aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = module.avm-res-managedidentity-userassignedidentity.principal_id
}

# AKS Module
module "aks" {
  source                     = "./modules/aks"
  resource_group_name        = local.main_resource_group_name
  resource_group_location    = local.location
  cluster_name               = var.cluster_name
  dns_prefix                 = var.dns_prefix
  node_count                 = var.node_count
  vm_size                    = var.vm_size
  subnet_id                  = data.azurerm_subnet.aks_subnet.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  enable_private_cluster     = var.enable_private_cluster
  private_dns_zone_id        = data.azurerm_private_dns_zone.dnszone-aks.id
  managed_identity_id        = module.avm-res-managedidentity-userassignedidentity.identity_id
  tags                       = module.tags.tags
}
