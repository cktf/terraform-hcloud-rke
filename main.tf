terraform {
  required_version = ">= 0.14.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.36.0"
    }
    k8sbootstrap = {
      source  = "nimbolus/k8sbootstrap"
      version = "~> 0.1.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7.1"
    }
  }
}
