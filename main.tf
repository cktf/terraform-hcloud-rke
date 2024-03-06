terraform {
  required_version = ">= 1.4.0"
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.31.0"
    }
  }
}
