resource "hcloud_firewall" "this" {
  name = "${var.name} master"

  rule {
    port        = "22"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "SSH Server"
  }
  rule {
    port        = "2379"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "HA with embedded etcd"
  }
  rule {
    port        = "2380"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "HA with embedded etcd"
  }
  rule {
    port        = "6443"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Kubernetes API Server"
  }
  rule {
    port        = "8472"
    protocol    = "udp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Flannel VXLAN"
  }
  rule {
    port        = "10250"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Kubelet metrics"
  }
}

resource "hcloud_firewall" "node" {
  name = "${var.name} node"

  rule {
    port        = "22"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "SSH Server"
  }
  rule {
    port        = "80"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Ingress Controller"
  }
  rule {
    port        = "443"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Ingress Controller"
  }
  rule {
    port        = "6443"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Kubernetes API Server"
  }
  rule {
    port        = "8472"
    protocol    = "udp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Flannel VXLAN"
  }
  rule {
    port        = "10250"
    protocol    = "tcp"
    direction   = "in"
    source_ips  = ["0.0.0.0/0", "::/0"]
    description = "Kubelet metrics"
  }
}
