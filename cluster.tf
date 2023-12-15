locals {
  server_configs = {
    "disable-cloud-controller" = "true"
    "disable"                  = ["local-storage", "servicelb", "traefik"]
    "tls-san"                  = [hcloud_load_balancer_network.this.ip, hcloud_load_balancer.this.ipv4]
    # "cluster-cidr" = "${pods_cidr}"

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

  for_each = var.servers

  name               = "${var.name}-server-${each.key}"
  server_type        = each.value.type
  location           = each.value.location
  image              = data.hcloud_image.this.id
  ssh_keys           = [hcloud_ssh_key.this.id]
  placement_group_id = hcloud_placement_group.this.id
  labels             = { "rke/server" = var.name }

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
  configs = merge(var.configs, {

  })
  addons = merge(var.addons, {
    # autoscaler = templatefile("${path.module}/addons/autoscaler.yml", {
    #   hcloud_image      = "ubuntu-22.04"
    #   hcloud_token      = var.hcloud_token
    #   hcloud_network    = var.hcloud_network
    #   hcloud_ssh_key    = hcloud_ssh_key.this.id
    #   hcloud_cloud_init = ""
    #   node_pools = [for key, val in var.node_pools : {
    #     minSize = val.min_size
    #     maxSize = val.max_size
    #     name    = "${val.type}:${val.location}:${var.name}-${key}"
    #   }]
    # })
    # manager = templatefile("${path.module}/addons/manager.yml", {
    #   cluster_cidr   = ""
    #   hcloud_token   = var.hcloud_token
    #   hcloud_network = var.hcloud_network
    # })
    # storage = templatefile("${path.module}/addons/storage.yml", {
    #   hcloud_token = var.hcloud_token
    # })
  })

  server_ip   = hcloud_load_balancer_network.this.ip
  external_db = ""

  servers = {
    for key, val in var.servers : key => {
      channel    = val.channel
      version    = val.version
      registries = val.registries
      configs    = merge(val.configs, local.server_configs)
      pre_exec   = "sleep 30"
      connection = {
        type        = "ssh"
        host        = hcloud_server.this[key].ipv4_address
        user        = "root"
        private_key = tls_private_key.this.private_key_openssh
        timeout     = "4m"
      }
    }
  }
}
