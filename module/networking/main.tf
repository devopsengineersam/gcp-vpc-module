terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.34.0"
    }
  }
}

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

# 2. Firewall Rules for Egress
resource "google_compute_firewall" "egress_common" {
  name      = "dspm-egress-common"
  network   = google_compute_network.orchestrator_vpc.name
  direction = "EGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["53", "80", "443"]
  }

  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "egress_cloudsql" {
  name      = "dspm-egress-cloudsql"
  network   = google_compute_network.orchestrator_vpc.name
  direction = "EGRESS"
  priority  = 1001

  allow {
    protocol = "tcp"
    ports    = ["3307"]
  }

  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "egress_fileshare" {
  name      = "dspm-egress-fileshare"
  network   = google_compute_network.orchestrator_vpc.name
  direction = "EGRESS"
  priority  = 1002

  allow {
    protocol = "tcp"
    ports    = ["445"]
  }

  destination_ranges = ["0.0.0.0/0"] # Replace with on-prem Fileshare IPs if known
}

resource "google_compute_global_address" "private_service_access" {
  count = var.enable_private_service_access ? 1 : 0
  
  name          = var.private_service_access_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.private_service_access_prefix_length
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_service_connection" {
  count = var.enable_private_service_access ? 1 : 0

  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_access[0].name]
}

resource "google_compute_subnetwork" "regional_subnets" {
  for_each      = var.subnet_configurations
  name          = "subnet-${each.key}"
  ip_cidr_range = each.value.cidr_block
  region        = each.key
  network       = google_compute_network.vpc.id
}

resource "google_compute_router" "regional_routers" {
  for_each = var.subnet_configurations
  name     = "router-${each.key}"
  region   = each.key
  network  = google_compute_network.vpc.id
  
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "regional_nats" {
  for_each = var.subnet_configurations
  name                               = "nat-${each.key}"
  router                             = google_compute_router.regional_routers[each.key].name
  region                             = each.key
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = var.nat_logging_enabled
    filter = var.nat_log_filter
  }
}