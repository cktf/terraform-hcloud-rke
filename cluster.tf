locals {
  server_configs = {
    "disable-cloud-controller" = "true"
    "cluster-cidr"             = "10.244.0.0/16"
    "disable"                  = ["local-storage", "servicelb", "traefik"]
    "tls-san"                  = [hcloud_load_balancer_network.this.ip, hcloud_load_balancer.this.ipv4]

    "kubelet-arg"   = ["cloud-provider=external"]
    "flannel-iface" = "$(ip a | grep $(hostname -I | awk '{print $2}') | awk '{print $NF}')"
    "node-ip"       = "$(hostname -I | awk '{print $2}')"
    "node-name"     = "$(hostname -f)"
  }
  agent_configs = {
    "kubelet-arg"   = ["cloud-provider=external"]
    "flannel-iface" = "$(ip a | grep $(hostname -I | awk '{print $2}') | awk '{print $NF}')"
    "node-ip"       = "$(hostname -I | awk '{print $2}')"
    "node-name"     = "$(hostname -f)"
  }
}

module "cluster" {
  source  = "cktf/rke/module"
  version = "1.20.1"

  type       = var.type
  channel    = var.channel
  version_   = var.version_
  registries = var.registries
  configs    = var.configs
  addons = merge(var.addons, {
    driver = templatefile("${path.module}/addons/driver.yml", {
      hcloud_token   = var.hcloud_token
      hcloud_network = var.hcloud_network
    })
    scaler = templatefile("${path.module}/addons/scaler.yml", {
      name            = var.name
      pools           = var.pools
      hcloud_image    = data.hcloud_image.this.id
      hcloud_token    = var.hcloud_token
      hcloud_network  = var.hcloud_network
      hcloud_ssh_key  = hcloud_ssh_key.this.id
      hcloud_firewall = hcloud_firewall.this.id
      hcloud_cloud_init = base64encode(templatefile("${path.module}/addons/agent.sh", {
        type       = var.type
        channel    = var.channel
        version    = var.version_
        registries = var.registries
        configs    = merge(var.configs, local.agent_configs)
        pool = try(var.pools[keys(var.pools)[0]], {
          channel    = null
          version    = null
          registries = {}
          configs    = {}
        })
      }))
    })
  })

  server_ip = hcloud_load_balancer_network.this.ip

  servers = {
    for key, val in var.servers : key => {
      channel    = val.channel
      version    = val.version
      registries = val.registries
      configs    = merge(val.configs, local.server_configs)
      pre_exec   = "sleep 30"
      connection = {
        type        = "ssh"
        host        = hcloud_server.this["server_${key}"].ipv4_address
        user        = "root"
        private_key = tls_private_key.this.private_key_openssh
        timeout     = "4m"
      }
    }
  }

  agents = {
    for key, val in var.agents : key => {
      channel    = val.channel
      version    = val.version
      registries = val.registries
      configs    = merge(val.configs, local.agent_configs)
      connection = {
        type        = "ssh"
        host        = hcloud_server.this["agent_${key}"].ipv4_address
        user        = "root"
        private_key = tls_private_key.this.private_key_openssh
        timeout     = "4m"
      }
    }
  }
}
