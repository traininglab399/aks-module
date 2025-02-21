# Data Sources for Existing Resources
data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  resource_group_name = local.vnet_rg
}

data "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_private_dns_zone" "dnszone-aks" {
  name                = "privatelink.${local.location}.azmk8s.io"
  resource_group_name = local.vnet_rg
}

data "azurerm_private_dns_zone" "dnszone-contoso" {
  name                = "private.xyz.com"
  resource_group_name = local.vnet_rg
}
