resource "hcloud_load_balancer" "this" {
  name               = var.name
  location           = var.server_location
  load_balancer_type = "lb11"

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_network" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  network_id       = var.network_id
  subnet_id        = var.subnet_id
}

resource "hcloud_load_balancer_service" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_target" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  type             = "label_selector"
  label_selector   = "???"
  use_private_ip   = true
}
