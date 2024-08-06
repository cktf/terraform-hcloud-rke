output "host" {
  value       = "https://${module.cluster.load_balancers["server"].public_ipv4}:${module.rke.port}"
  sensitive   = false
  description = "Cluster Host"
}

output "client_key" {
  value       = module.rke.client_key
  sensitive   = true
  description = "Cluster Client Key"
}

output "client_crt" {
  value       = module.rke.client_crt
  sensitive   = true
  description = "Cluster Client Certificate"
}

output "ca_crt" {
  value       = module.rke.ca_crt
  sensitive   = true
  description = "Cluster CA Certificate"
}
