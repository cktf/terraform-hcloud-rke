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
    error_message = "Valid values for `type` are (k3s, rke2)."
  }
}

variable "version_" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Version"
}

variable "channel" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Channel"
}

variable "taints" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster Taints"
}

variable "labels" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster Labels"
}

variable "tags" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster Tags"
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

variable "server_size" {
  type        = number
  default     = 0
  sensitive   = false
  description = "Cluster Server Size"
}

variable "server_type" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Server Type"
}

variable "server_image" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Server Image"
}

variable "server_location" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Server Location"
}

variable "network_id" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Network ID"
}

variable "subnet_id" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Subnet ID"
}

variable "extra_args" {
  type        = list(string)
  default     = []
  sensitive   = false
  description = "Cluster Extra Arguments"
}

variable "extra_envs" {
  type        = map(string)
  default     = {}
  sensitive   = false
  description = "Cluster Extra Environments"
}

variable "pre_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Pre-Create user-data"
}

variable "post_create_user_data" {
  type        = string
  default     = ""
  sensitive   = false
  description = "Cluster Post-Create user-data"
}

variable "node_pools" {
  type        = map(any)
  default     = {}
  sensitive   = false
  description = "Cluster Node Pools"
}
