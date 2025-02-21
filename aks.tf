resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                              = var.cluster_name
  location                          = var.resource_group_location
  resource_group_name               = var.resource_group_name
  dns_prefix_private_cluster        = var.dns_prefix
  private_cluster_enabled           = var.enable_private_cluster
  private_dns_zone_id               = var.private_dns_zone_id
  azure_policy_enabled              = true
  kubernetes_version                = "1.30"
  local_account_disabled            = true
  oidc_issuer_enabled               = true
  sku_tier                          = "Standard"
  workload_identity_enabled         = true
  automatic_channel_upgrade         = "patch"
  role_based_access_control_enabled = true
  http_application_routing_enabled  = true

  web_app_routing {
    dns_zone_ids = [var.private_dns_zone_id]
  }

  default_node_pool {
    name                         = "default"
    vm_size                      = var.vm_size
    os_disk_size_gb              = 30
    os_sku                       = "Ubuntu"
    min_count                    = 1
    max_count                    = 3
    enable_auto_scaling          = true
    max_pods                     = 110
    only_critical_addons_enabled = true
    vnet_subnet_id               = var.subnet_id
    zones                        = ["1", "2", "3"]
  }

  auto_scaler_profile {
    balance_similar_node_groups = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    load_balancer_sku   = "standard"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  depends_on = [
    azurerm_role_assignment.role-assignment-dnszone,
  ]

  lifecycle {
    ignore_changes = [default_node_pool.0.upgrade_settings]
  }
}
