locals {
  server_configs = {
    "disable-cloud-controller" = "true"
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

data "hcloud_image" "this" {
  name        = "ubuntu-22.04"
  most_recent = true
}

resource "hcloud_placement_group" "this" {
  name = var.name
  type = "spread"
}

resource "hcloud_server" "this" {
  lifecycle {
    ignore_changes = [image]
  }

  for_each = merge(
    { for key, val in var.servers : "server_${key}" => merge(val, { exec = "server" }) },
    { for key, val in var.agents : "agent_${key}" => merge(val, { exec = "agent" }) }
  )

  name               = "${var.name}-${each.value.exec}-${each.key}"
  server_type        = each.value.type
  location           = each.value.location
  image              = data.hcloud_image.this.id
  ssh_keys           = [hcloud_ssh_key.this.id]
  placement_group_id = hcloud_placement_group.this.id
  labels             = { "rke/${each.value.exec}" = var.name }

  connection {
    type        = "ssh"
    host        = self.ipv4_address
    user        = "root"
    private_key = tls_private_key.this.private_key_openssh
    timeout     = "4m"
  }

  provisioner "remote-exec" {
    inline = ["cloud-init status --wait"]
  }
}

resource "hcloud_server_network" "this" {
  for_each = hcloud_server.this

  server_id  = each.value.id
  network_id = var.hcloud_network
}

module "cluster" {
  source  = "cktf/rke/module"
  version = "1.20.0"

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
    # scaler = templatefile("${path.module}/addons/scaler.yml", {
    #   name         = var.name
    #   type         = var.type
    #   channel      = var.channel
    #   version      = var.version_
    #   registries   = var.registries
    #   configs      = merge(var.configs, local.agent_configs)
    #   pools        = var.pools
    #   default_pool = var.pools[keys(var.pools)[0]]

    #   hcloud_image   = data.hcloud_image.this.id
    #   hcloud_token   = var.hcloud_token
    #   hcloud_network = var.hcloud_network
    #   hcloud_ssh_key = hcloud_ssh_key.this.id
    # })
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
