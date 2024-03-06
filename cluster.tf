locals {
  server_configs = {
    "disable-cloud-controller" = "true"
    "cluster-cidr"             = "10.244.0.0/16"
    "service-cidr"             = "10.245.0.0/16"
    "cluster-dns"              = "10.245.0.10"
    "tls-san"                  = [hcloud_load_balancer_network.this.ip, hcloud_load_balancer.this.ipv4]
    "disable"                  = ["local-storage", "metrics-server", "traefik", "servicelb", "rke2-metrics-server", "rke2-ingress-nginx"]

    "kubelet-arg" = ["cloud-provider=external"]
    "node-ip"     = (var.hcloud_gateway == "") ? "$(hostname -I | awk '{print $2}')" : "$(hostname -I | awk '{print $1}')"
  }
  agent_configs = {
    "kubelet-arg" = ["cloud-provider=external"]
    "node-ip"     = (var.hcloud_gateway == "") ? "$(hostname -I | awk '{print $2}')" : "$(hostname -I | awk '{print $1}')"
  }
  pool_configs = {
    "server" = "https://${hcloud_load_balancer_network.this.ip}:${module.cluster.port}"
    "token"  = var.agent_token
  }
}

module "cluster" {
  source  = "cktf/rke/module"
  version = "1.23.1"

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
      name           = var.name
      pools          = var.pools
      hcloud_image   = data.hcloud_image.this.id
      hcloud_token   = var.hcloud_token
      hcloud_network = var.hcloud_network
      hcloud_gateway = var.hcloud_gateway
      hcloud_ssh_key = hcloud_ssh_key.this.id
      hcloud_cloud_init = base64encode(templatefile("${path.module}/addons/agent.sh", {
        path       = "${path.module}/addons"
        type       = var.type
        channel    = var.channel
        version_   = var.version_
        gateway    = var.hcloud_gateway
        registries = var.registries
        configs    = merge(var.configs, local.agent_configs, local.pool_configs)
        pool = try(var.pools[keys(var.pools)[0]], {
          channel    = null
          version    = null
          registries = {}
          configs    = {}
          pre_exec   = ""
          post_exec  = ""
        })
      }))
    })
  })

  server_ip    = hcloud_load_balancer_network.this.ip
  agent_token  = var.agent_token
  server_token = var.server_token

  servers = {
    for key, val in var.servers : key => {
      channel    = val.channel
      version    = val.version
      registries = val.registries
      configs    = merge(val.configs, local.server_configs)
      pre_exec   = val.pre_exec
      post_exec  = val.post_exec
      connection = {
        type                = "ssh"
        host                = (var.hcloud_gateway == "") ? hcloud_server.this["server_${key}"].ipv4_address : hcloud_server_network.this["server_${key}"].ip
        user                = "root"
        private_key         = var.private_key
        timeout             = "5m"
        bastion_host        = try(var.hcloud_bastion.host, null)
        bastion_port        = try(var.hcloud_bastion.port, null)
        bastion_user        = try(var.hcloud_bastion.user, null)
        bastion_password    = try(var.hcloud_bastion.password, null)
        bastion_private_key = try(var.hcloud_bastion.private_key, null)
      }
    }
  }

  agents = {
    for key, val in var.agents : key => {
      channel    = val.channel
      version    = val.version
      registries = val.registries
      configs    = merge(val.configs, local.agent_configs)
      pre_exec   = val.pre_exec
      post_exec  = val.post_exec
      connection = {
        type                = "ssh"
        host                = (var.hcloud_gateway == "") ? hcloud_server.this["agent_${key}"].ipv4_address : hcloud_server_network.this["agent_${key}"].ip
        user                = "root"
        private_key         = var.private_key
        timeout             = "5m"
        bastion_host        = try(var.hcloud_bastion.host, null)
        bastion_port        = try(var.hcloud_bastion.port, null)
        bastion_user        = try(var.hcloud_bastion.user, null)
        bastion_password    = try(var.hcloud_bastion.password, null)
        bastion_private_key = try(var.hcloud_bastion.private_key, null)
      }
    }
  }
}
