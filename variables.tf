variable "name" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Name"
}

variable "zone" {
  type        = string
  default     = "eu-central"
  sensitive   = false
  description = "Cluster Zone"
}

variable "type" {
  type        = string
  default     = "k3s"
  sensitive   = false
  description = "Cluster Type"

  validation {
    condition     = contains(["k3s", "rke2"], var.type)
    error_message = "Valid values for `type` are (k3s, rke2)."
  }
}

variable "channel" {
  type        = string
  default     = "latest"
  sensitive   = false
  description = "Cluster Channel"
}

variable "version_" {
  type        = string
  default     = "v1.24.3+k3s1"
  sensitive   = false
  description = "Cluster Version"
}

variable "registries" {
  type = map(object({
    endpoint = string
    username = string
    password = string
  }))
  default     = {}
  sensitive   = false
  description = "Cluster Registries"
}

variable "network_id" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Network ID"
}

variable "hcloud_token" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster HCloud Token"
}

variable "masters" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Masters"
}

variable "node_pools" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Node Pools"
}
