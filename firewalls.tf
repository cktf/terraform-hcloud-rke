resource "hcloud_firewall" "this" {
  name = "${var.name} master"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "2379"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "2380"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "6443"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "9345"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "10250"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "179"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "4789"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "5473"
  }
}

resource "hcloud_firewall" "node" {
  name = "${var.name} node"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "2379"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "2380"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "6443"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "9345"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "10250"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "179"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "4789"
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "5473"
  }
}
