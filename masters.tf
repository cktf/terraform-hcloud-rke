locals {
  bootstrap_file = templatefile("${path.module}/templates/manifests/bootstrap.yml", {
    token_id     = random_string.token_id.result
    token_secret = random_string.token_secret.result
  })
  ccm_file = templatefile("${path.module}/templates/manifests/ccm.yml", {
    pods_cidr      = var.pods_cidr
    hcloud_token   = var.hcloud_token
    hcloud_network = var.network_id
  })
  csi_file = templatefile("${path.module}/templates/manifests/csi.yml", {
    hcloud_token = var.hcloud_token
  })
  ca_file = templatefile("${path.module}/templates/manifests/ca.yml", {
    hcloud_name       = var.name
    hcloud_token      = var.hcloud_token
    hcloud_network    = var.network_id
    hcloud_ssh_key    = hcloud_ssh_key.this.id
    hcloud_node_pools = var.node_pools
    hcloud_cloud_init = base64encode(templatefile("${path.module}/templates/node.sh", {
      type       = var.type
      channel    = var.channel
      version    = var.version_
      registries = var.registries
      join_host  = hcloud_load_balancer_network.this.ip
      join_token = random_string.agent_token.result
    }))
  })
}

resource "hcloud_placement_group" "this" {
  name = var.name
  type = "spread"
}

resource "hcloud_server" "this" {
  for_each   = var.masters
  depends_on = [var.network_id]

  name               = "${var.name}-master-${each.key}"
  server_type        = each.value.type
  image              = "ubuntu-20.04"
  location           = each.value.location
  ssh_keys           = [hcloud_ssh_key.this.id]
  placement_group_id = hcloud_placement_group.this.id
  labels             = merge(try(each.value.tags, {}), { "hcloud/master" = var.name })

  user_data = templatefile("${path.module}/templates/create.sh", {
    type       = var.type
    channel    = var.channel
    version    = var.version_
    registries = var.registries
    pods_cidr  = var.pods_cidr

    taints                = try(each.value.taints, {})
    labels                = try(each.value.labels, {})
    extra_args            = try(each.value.extra_args, [])
    extra_envs            = try(each.value.extra_envs, {})
    pre_create_user_data  = try(each.value.pre_create_user_data, "")
    post_create_user_data = try(each.value.post_create_user_data, "")

    leader        = (each.key == keys(var.masters)[0])
    private_ip    = hcloud_load_balancer_network.this.ip
    public_ip     = hcloud_load_balancer.this.ipv4
    cluster_token = random_string.cluster_token.result
    agent_token   = random_string.agent_token.result

    bootstrap_file = local.bootstrap_file
    ccm_file       = local.ccm_file
    csi_file       = local.csi_file
    ca_file        = local.ca_file
  })
}

resource "hcloud_server_network" "this" {
  for_each = var.masters

  server_id  = hcloud_server.this[each.key].id
  network_id = var.network_id
}
