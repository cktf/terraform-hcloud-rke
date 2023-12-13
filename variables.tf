variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Name"
}

variable "type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "Cluster Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for 'type' are (k3s, rke2)."
  }
}

variable "channel" {
  type        = string
  default     = "stable"
  sensitive   = false
  description = "Cluster Channel"

  validation {
    condition     = contains(["stable", "latest", "testing"], var.channel)
    error_message = "Valid values for 'channel' are (stable, latest, testing)."
  }
}

variable "version_" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Version"
}

variable "registries" {
  type        = any
  default     = {}
  sensitive   = false
  description = "Cluster Registries"
}

variable "configs" {
  type        = any
  default     = {}
  sensitive   = false
  description = "Cluster Configs"
}

variable "addons" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster AddOns"
}

variable "hcloud_zone" {
  type        = string
  default     = "eu-central"
  sensitive   = false
  description = "HCloud Zone"
}

variable "hcloud_token" {
  type        = string
  default     = ""
  sensitive   = false
  description = "HCloud Token"
}

variable "hcloud_network" {
  type        = string
  default     = ""
  sensitive   = false
  description = "HCloud Network"
}

variable "servers" {
  type = map(object({
    type       = string
    location   = string
    channel    = optional(string)
    version    = optional(string)
    registries = optional(any, {})
    configs    = optional(any, {})
  }))
  default     = {}
  sensitive   = false
  description = "Cluster Servers"
}

variable "agent_pools" {
  type = map(object({
    type       = string
    location   = string
    min_size   = number
    max_size   = number
    channel    = optional(string)
    version    = optional(string)
    registries = optional(any, {})
    configs    = optional(any, {})
  }))
  default     = {}
  sensitive   = false
  description = "Cluster Agent Pools"
}
