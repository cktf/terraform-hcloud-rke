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
  ssh_keys           = [hcloud_ssh_key.this.id] # TODO: external ssh key
  placement_group_id = hcloud_placement_group.this.id
  labels             = { "rke/${each.value.exec}" = var.name }

  connection {
    type        = "ssh"
    host        = self.ipv4_address
    user        = "root"
    private_key = tls_private_key.this.private_key_openssh
    timeout     = "4m"
    # TODO: (private IP only through bastion)
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
