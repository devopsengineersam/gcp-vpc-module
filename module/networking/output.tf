output "vpc_self_link" {
  value = google_compute_network.orchestrator_vpc.self_link
}

output "subnet_self_links" {
  value = { for k, v in google_compute_subnetwork.regional_subnets : k => v.self_link }
}

output "private_service_connection" {
  value = var.enable_private_service_access ? google_service_networking_connection.private_service_connection[0] : null
}