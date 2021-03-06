resource "random_string" "token_id" {
  length  = 6
  upper   = false
  special = false
}

resource "random_string" "token_secret" {
  length  = 16
  upper   = false
  special = false
}

resource "random_string" "cluster_token" {
  length  = 48
  special = false
}

resource "random_string" "agent_token" {
  length  = 48
  special = false
}

data "k8sbootstrap_auth" "this" {
  depends_on = [hcloud_server.this]

  server = "https://${hcloud_load_balancer.this.ipv4}:6443"
  token  = "${random_string.token_id.result}.${random_string.token_secret.result}"
}
