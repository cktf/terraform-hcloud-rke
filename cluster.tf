data "hcloud_image" "this" {
  name        = "ubuntu-22.04"
  most_recent = true
}

resource "hcloud_placement_group" "this" {
  name = var.name
  type = "spread"
}

resource "hcloud_server" "this" {
  for_each = var.servers

  name               = "${var.name}-server-${each.key}"
  server_type        = each.value.type
  location           = each.value.location
  image              = data.hcloud_image.this.id
  ssh_keys           = [hcloud_ssh_key.this.id]
  placement_group_id = hcloud_placement_group.this.id
  labels             = { "rke/server" = var.name }
  delete_protection  = true
  rebuild_protection = true

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
  version = "1.19.1"

  type       = var.type
  channel    = var.channel
  version_   = var.version_
  registries = var.registries
  configs    = var.configs
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
      channel    = each.value.channel
      version    = each.value.version
      registries = each.value.registries
      configs    = each.value.configs
      connection = {
        type        = "ssh"
        host        = hcloud_server.this[each.key].ipv4_address
        user        = "root"
        private_key = tls_private_key.this.private_key_openssh
        timeout     = "4m"
      }
    }
  }
}
