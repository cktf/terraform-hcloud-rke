resource "hcloud_firewall" "this" {
  name = var.name

  rule {
    protocol        = "icmp"
    direction       = "out"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description     = "ICMP Internet Traffic"
  }
  rule {
    port            = "any"
    protocol        = "tcp"
    direction       = "out"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description     = "TCP Internet Traffic"
  }
  rule {
    port            = "any"
    protocol        = "udp"
    direction       = "out"
    destination_ips = ["0.0.0.0/0", "::/0"]
    description     = "UDP Internet Traffic"
  }

  dynamic "apply_to" {
    for_each = var.masters
    content {
      server = hcloud_server.this[apply_to.key].id
    }
  }

  dynamic "apply_to" {
    for_each = var.node_pools
    content {
      label_selector = "hcloud/node-group=${apply_to.key}"
    }
  }
}
