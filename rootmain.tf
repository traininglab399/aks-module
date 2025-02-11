module "resource_group" {
  source = "./modules/resource-group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}
terraform {
  backend "azurerm" {
    resource_group_name  = "stgaccountname-rg"
    storage_account_name = "stgaccountname"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
module "vnet" {
  source = "./modules/vnet"

  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  vnet_address_space      = var.vnet_address_space
  subnet_address_prefixes = var.subnet_address_prefixes
  tags                    = var.tags
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.resource_group_name}-logs"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

module "aks" {
  source = "./modules/aks"

  resource_group_name        = module.resource_group.resource_group_name
  resource_group_location    = module.resource_group.resource_group_location
  cluster_name               = var.cluster_name
  dns_prefix                 = var.dns_prefix
  node_count                 = var.node_count
  vm_size                    = var.vm_size
  subnet_id                  = module.vnet.subnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  enable_private_cluster     = var.enable_private_cluster
  tags                       = var.tags
}
