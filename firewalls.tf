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
}

resource "hcloud_firewall_attachment" "this" {
  firewall_id = hcloud_firewall.this.id
  server_ids = [
    for key, val in var.masters : hcloud_server.this[key].id
  ]
  label_selectors = [
    for key, val in var.node_pools : "hcloud/node-group=${key}"
  ]
}
