terraform {
  required_version = ">= 0.14.0"
  required_providers {}
}

module "cluster" {
  source = "./modules/cluster"

  name                  = var.name
  type                  = var.type
  version_              = var.version_
  channel               = var.channel
  taints                = var.taints
  labels                = var.labels
  tags                  = var.tags
  registries            = var.registries
  server_size           = var.server_size
  server_type           = var.server_type
  server_image          = var.server_image
  server_location       = var.server_location
  network_id            = var.network_id
  subnet_id             = var.subnet_id
  extra_args            = var.extra_args
  extra_envs            = var.extra_envs
  pre_create_user_data  = var.pre_create_user_data
  post_create_user_data = var.post_create_user_data
}

module "node_pool" {
  source   = "./modules/node_pool"
  for_each = var.node_pools

  name                  = try(each.value.name, var.name)
  type                  = try(each.value.type, var.type)
  version_              = try(each.value.version_, var.version_)
  channel               = try(each.value.channel, var.channel)
  taints                = try(each.value.taints, {})
  labels                = try(each.value.labels, {})
  tags                  = try(each.value.tags, {})
  registries            = try(each.value.registries, var.registries)
  server_size           = try(each.value.server_size, var.server_size)
  server_type           = try(each.value.server_type, var.server_type)
  server_image          = try(each.value.server_image, var.server_image)
  server_location       = try(each.value.server_location, var.server_location)
  network_id            = try(each.value.network_id, var.network_id)
  subnet_id             = try(each.value.subnet_id, var.subnet_id)
  extra_args            = try(each.value.extra_args, var.extra_args)
  extra_envs            = try(each.value.extra_envs, var.extra_envs)
  pre_create_user_data  = try(each.value.pre_create_user_data, var.pre_create_user_data)
  post_create_user_data = try(each.value.post_create_user_data, var.post_create_user_data)

  join_host  = module.cluster.join_host
  join_token = module.cluster.join_token
}
