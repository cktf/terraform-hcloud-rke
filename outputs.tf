output "host" {
  value       = "https://${hcloud_load_balancer.this.ipv4}:${module.cluster.port}"
  sensitive   = false
  description = "Cluster Host"
}

output "client_key" {
  value       = module.cluster.client_key
  sensitive   = true
  description = "Cluster Client Key"
}

output "client_crt" {
  value       = module.cluster.client_crt
  sensitive   = true
  description = "Cluster Client Certificate"
}

output "ca_crt" {
  value       = module.cluster.ca_crt
  sensitive   = true
  description = "Cluster CA Certificate"
}
