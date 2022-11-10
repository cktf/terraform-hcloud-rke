resource "helm_release" "this" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.21.0"

  values = [
    yamlencode({
      cloudProvider = "hetzner"
      tolerations = [{
        effect = "NoSchedule"
        key    = "node-role.kubernetes.io/master"
      }]
      affinity = {
        nodeAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution = {
            nodeSelectorTerms = [{
              matchExpressions = [{
                key      = "node-role.kubernetes.io/master"
                operator = "Exists"
              }]
            }]
          }
        }
      }
      extraEnv = {
        HCLOUD_IMAGE   = "ubuntu-20.04"
        HCLOUD_TOKEN   = var.hcloud_token
        HCLOUD_NETWORK = var.network_id
        HCLOUD_SSH_KEY = hcloud_ssh_key.this.id
        HCLOUD_CLOUD_INIT = base64encode(templatefile("${path.module}/templates/node.sh", {
          type       = var.type
          channel    = var.channel
          version    = var.version_
          registries = var.registries
          join_host  = hcloud_load_balancer_network.this.ip
          join_token = random_string.agent_token.result
        }))
      }
      autoscalingGroups = [for key, val in var.node_pools : {
        minSize = val.min_size
        maxSize = val.max_size
        name    = "${val.type}:${val.location}:${var.name}-${key}"
      }]
    })
  ]
}
