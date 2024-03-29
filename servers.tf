data "hcloud_image" "this" {
  name        = "ubuntu-22.04"
  most_recent = true
}

resource "hcloud_ssh_key" "this" {
  name       = var.name
  public_key = var.public_key
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
    { for key, val in var.servers : "server_${key}" => merge(val, { exec = "server", key = key }) },
    { for key, val in var.agents : "agent_${key}" => merge(val, { exec = "agent", key = key }) }
  )

  name               = "${var.name}-${each.value.exec}-${each.value.key}"
  server_type        = each.value.type
  location           = each.value.location
  image              = data.hcloud_image.this.id
  labels             = { "rke/${each.value.exec}" = var.name }
  ssh_keys           = concat(var.ssh_keys, [hcloud_ssh_key.this.id])
  placement_group_id = (each.value.exec == "server") ? hcloud_placement_group.this.id : null

  user_data = templatefile("${path.module}/addons/setup.sh", {
    gateway = var.hcloud_gateway
  })

  public_net {
    ipv4_enabled = (var.hcloud_gateway == "")
    ipv6_enabled = (var.hcloud_gateway == "")
  }
  network {
    network_id = var.hcloud_network
    alias_ips  = []
  }
}

resource "hcloud_server_network" "this" {
  for_each = hcloud_server.this

  server_id  = each.value.id
  network_id = var.hcloud_network

  connection {
    type                = "ssh"
    host                = (var.hcloud_gateway == "") ? each.value.ipv4_address : self.ip
    user                = "root"
    private_key         = var.private_key
    timeout             = "5m"
    bastion_host        = try(var.hcloud_bastion.host, null)
    bastion_port        = try(var.hcloud_bastion.port, null)
    bastion_user        = try(var.hcloud_bastion.user, null)
    bastion_password    = try(var.hcloud_bastion.password, null)
    bastion_private_key = try(var.hcloud_bastion.private_key, null)
  }

  provisioner "remote-exec" {
    inline = ["cloud-init status --wait"]
  }
}
