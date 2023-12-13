resource "hcloud_firewall" "this" {
  name = var.name

  rule {
    port        = "22"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "SSH Inbound Traffic"
  }
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

  apply_to {
    label_selector = "rke/server=${var.name}"
  }

  apply_to {
    label_selector = "rke/agent=${var.name}"
  }
}
