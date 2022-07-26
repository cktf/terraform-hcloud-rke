resource "hcloud_placement_group" "this" {
  name = var.name
  type = "spread"
}

resource "hcloud_server" "this" {
  for_each = var.masters

  name               = "master-${each.key}"
  server_type        = each.value.type
  image              = "ubuntu-20.04"
  location           = each.value.location
  ssh_keys           = [hcloud_ssh_key.this.id]
  firewall_ids       = [hcloud_firewall.this.id]
  placement_group_id = hcloud_placement_group.this.id
  labels             = merge(try(each.value.tags, {}), { cluster = var.name, role = "master" })

  network {
    network_id = var.network_id
  }

  user_data = templatefile("${path.module}/templates/create.sh", {
    name       = "master-${each.key}"
    type       = var.type
    channel    = var.channel
    version    = var.version_
    registries = var.registries

    taints                = try(each.value.taints, {})
    labels                = try(each.value.labels, {})
    extra_args            = try(each.value.extra_args, [])
    extra_envs            = try(each.value.extra_envs, {})
    pre_create_user_data  = try(each.value.pre_create_user_data, "")
    post_create_user_data = try(each.value.post_create_user_data, "")

    leader        = (each.key == keys(var.masters)[0])
    token_id      = random_string.token_id.result
    token_secret  = random_string.token_secret.result
    cluster_host  = "https://${hcloud_load_balancer.this.ipv4}:6443"
    cluster_token = random_string.cluster_token.result
    agent_token   = random_string.agent_token.result
  })
}

resource "hcloud_server_network" "this" {
  for_each = var.masters

  server_id = hcloud_server.this[each.key].id
  subnet_id = var.subnet_id
}
