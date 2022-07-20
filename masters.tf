resource "hcloud_server" "this" {
  depends_on = [hcloud_firewall.this]
  count      = var.server_size

  name         = "${var.name}-${count.index}"
  server_type  = var.server_type
  image        = var.server_image
  location     = var.server_location
  labels       = var.tags
  ssh_keys     = [hcloud_ssh_key.this.id]
  firewall_ids = [hcloud_firewall.this.id]

  user_data = templatefile("${path.module}/templates/create.sh", {
    name                  = "${var.name}-${count.index}"
    type                  = var.type
    version               = var.version_
    channel               = var.channel
    taints                = var.taints
    labels                = var.labels
    registries            = var.registries
    extra_args            = var.extra_args
    extra_envs            = var.extra_envs
    pre_create_user_data  = var.pre_create_user_data
    post_create_user_data = var.post_create_user_data

    token_id      = random_string.token_id.result
    token_secret  = random_string.token_secret.result
    cluster_host  = "https://${hcloud_load_balancer.this.ipv4}:6443"
    cluster_token = random_string.cluster_token.result
    agent_token   = random_string.agent_token.result
  })
}

resource "hcloud_server_network" "this" {
  count = var.server_size

  server_id  = hcloud_server.this[count.index].id
  network_id = var.network_id
  subnet_id  = var.subnet_id
}