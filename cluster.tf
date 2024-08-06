module "cluster" {
  source  = "cktf/cluster/hcloud"
  version = "1.3.0"

  name    = var.name
  bastion = merge(var.hcloud_bastion, { gateway = var.hcloud_gateway })

  servers = {
    server = {
      for key, val in var.servers : key => {
        type     = val.type
        network  = var.hcloud_network
        location = val.location
        ssh_keys = var.ssh_keys
      }
    }
    agent = {
      for key, val in var.agents : key => {
        type     = val.type
        network  = var.hcloud_network
        location = val.location
        ssh_keys = var.ssh_keys
      }
    }
  }

  firewalls = {
    server = {
      inbounds = {}
      outbounds = {
        "icmp" = {
          description     = "ICMP Outbound Traffic"
          destination_ips = ["0.0.0.0/0", "::/0"]
        }
        "any:tcp" = {
          description     = "TCP Outbound Traffic"
          destination_ips = ["0.0.0.0/0", "::/0"]
        }
        "any:udp" = {
          description     = "UDP Outbound Traffic"
          destination_ips = ["0.0.0.0/0", "::/0"]
        }
      }
    }
    agent = {
      inbounds = {}
      outbounds = {
        "icmp" = {
          description     = "ICMP Outbound Traffic"
          destination_ips = ["0.0.0.0/0", "::/0"]
        }
        "any:tcp" = {
          description     = "TCP Outbound Traffic"
          destination_ips = ["0.0.0.0/0", "::/0"]
        }
        "any:udp" = {
          description     = "UDP Outbound Traffic"
          destination_ips = ["0.0.0.0/0", "::/0"]
        }
      }
    }
  }

  load_balancers = {
    server = {
      network = tonumber(var.hcloud_network)
      mapping = {
        tonumber(module.rke.port) = tonumber(module.rke.port)
      }
    }
  }
}
