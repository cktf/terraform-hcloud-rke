resource "hcloud_load_balancer" "this" {
  name               = var.name
  network_zone       = var.zone
  load_balancer_type = "lb11"

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_network" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  subnet_id        = var.subnet_id
}

resource "hcloud_load_balancer_service" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_target" "this" {
  depends_on = [hcloud_load_balancer_network.this]

  load_balancer_id = hcloud_load_balancer.this.id
  type             = "label_selector"
  label_selector   = "cluster=${var.name},role=master"
  use_private_ip   = true
}
