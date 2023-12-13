resource "hcloud_load_balancer" "this" {
  name               = var.name
  network_zone       = var.hcloud_zone
  load_balancer_type = "lb11"

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_network" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  network_id       = var.hcloud_network
}

resource "hcloud_load_balancer_service" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = "tcp"
  listen_port      = module.cluster.port
  destination_port = module.cluster.port
}

resource "hcloud_load_balancer_target" "this" {
  depends_on = [hcloud_load_balancer_network.this]

  load_balancer_id = hcloud_load_balancer.this.id
  type             = "label_selector"
  label_selector   = "rke/server=${var.name}"
  use_private_ip   = true
}
