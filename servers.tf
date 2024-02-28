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
    { for key, val in var.servers : "server_${key}" => merge(val, { exec = "server", key = key }) },
    { for key, val in var.agents : "agent_${key}" => merge(val, { exec = "agent", key = key }) }
  )

  name               = "${var.name}-${each.value.exec}-${each.value.key}"
  server_type        = each.value.type
  location           = each.value.location
  image              = data.hcloud_image.this.id
  ssh_keys           = [hcloud_ssh_key.this.id]
  placement_group_id = hcloud_placement_group.this.id
  labels             = { "rke/${each.value.exec}" = var.name }
  user_data          = "" # TODO: default route setup

  public_net {
    ipv4_enabled = (var.hcloud_gateway == "")
    ipv6_enabled = (var.hcloud_gateway == "")
  }

  connection {
    type                = "ssh"
    host                = self.ipv4_address
    user                = "root"
    private_key         = tls_private_key.this.private_key_openssh
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

resource "hcloud_server_network" "this" {
  for_each = hcloud_server.this

  server_id  = each.value.id
  network_id = var.hcloud_network
}
