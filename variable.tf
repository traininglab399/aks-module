variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "The size of the virtual machines in the node pool."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network (CIDR block)."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the Subnet (CIDR block)."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "log_retention_days" {
  description = "The number of days to retain logs in the Log Analytics Workspace."
  type        = number
  default     = 30
}

variable "enable_private_cluster" {
  description = "Enable private cluster configuration."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to apply to the resources."
  type        = map(string)
  default     = {}
}
