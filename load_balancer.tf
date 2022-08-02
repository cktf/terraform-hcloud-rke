resource "hcloud_load_balancer" "this" {
  name               = var.name
  network_zone       = var.zone
  load_balancer_type = "lb11"

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer" "alb" {
  name               = "${var.name}-http"
  network_zone       = var.zone
  load_balancer_type = "lb11"

  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_network" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  network_id       = var.network_id
}

resource "hcloud_load_balancer_network" "alb" {
  load_balancer_id = hcloud_load_balancer.alb.id
  network_id       = var.network_id
}

resource "hcloud_load_balancer_service" "this" {
  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443
}

resource "hcloud_load_balancer_service" "https" {
  load_balancer_id = hcloud_load_balancer.alb.id
  protocol         = "http"
  listen_port      = 443
  destination_port = 443
}

resource "hcloud_load_balancer_service" "http" {
  load_balancer_id = hcloud_load_balancer.alb.id
  protocol         = "http"
  listen_port      = 80
  destination_port = 80
}

resource "hcloud_load_balancer_target" "this" {
  depends_on = [hcloud_load_balancer_network.this]

  load_balancer_id = hcloud_load_balancer.this.id
  type             = "label_selector"
  label_selector   = "hcloud/master=${var.name}"
  use_private_ip   = true
}

resource "hcloud_load_balancer_target" "alb" {
  for_each   = var.node_pools
  depends_on = [hcloud_load_balancer_network.alb]

  load_balancer_id = hcloud_load_balancer.alb.id
  type             = "label_selector"
  label_selector   = "hcloud/node-group=${var.name}-${each.key}"
  use_private_ip   = true
}
