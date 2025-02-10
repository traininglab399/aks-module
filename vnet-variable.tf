variable "resource_group_name" {
  description = "The name of the resource group where the VNet will be created."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must not be empty."
  }
}

variable "location" {
  description = "The Azure region where the VNet will be created."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", lower(var.location)))
    error_message = "The location must be a valid Azure region (e.g., eastus)."
  }
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network (CIDR block)."
  type        = list(string)
  default     = ["10.0.0.0/16"]

  validation {
    condition     = alltrue([for cidr in var.vnet_address_space : can(cidrsubnet(cidr, 0, 0))])
    error_message = "The vnet_address_space must contain valid CIDR blocks."
  }
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the Subnet (CIDR block)."
  type        = list(string)
  default     = ["10.0.1.0/24"]

  validation {
    condition     = alltrue([for cidr in var.subnet_address_prefixes : can(cidrsubnet(cidr, 0, 0))])
    error_message = "The subnet_address_prefixes must contain valid CIDR blocks."
  }
}

variable "subnet_name" {
  description = "The name of the Subnet."
  type        = string
  default     = "default-subnet"

  validation {
    condition     = length(var.subnet_name) > 0
    error_message = "The subnet name must not be empty."
  }
}

variable "tags" {
  description = "A map of tags to apply to the VNet and Subnet."
  type        = map(string)
  default     = {}
}
