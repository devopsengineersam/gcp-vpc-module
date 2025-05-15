# variable "project_id" {
#   description = "GCP Project ID"
#   type        = string
# }

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "orchestrator-vpc"
}

variable "routing_mode" {
  description = "Network routing mode (REGIONAL or GLOBAL)"
  type        = string
  default     = "REGIONAL"
}

variable "subnet_configurations" {
  description = "Map of regions to subnet configurations (keys = regions, values = CIDR blocks)"
  type        = map(object({
    cidr_block = string
  }))
  default     = {
    "us-central1" = { cidr_block =  "10.129.1.0/24", }
  }
}

variable "enable_private_service_access" {
  description = "Enable VPC Private Services Access"
  type        = bool
  default     = false
}

variable "private_service_access_name" {
  description = "Name for the private service access IP range"
  type        = string
  default     = "private-service-access-ip"
}

variable "private_service_access_prefix_length" {
  description = "Prefix length for private service access IP range"
  type        = number
  default     = 24
}

variable "nat_logging_enabled" {
  description = "Enable NAT gateway logging"
  type        = bool
  default     = true
}

variable "nat_log_filter" {
  description = "NAT log filter type"
  type        = string
  default     = "ERRORS_ONLY"
}

variable "environment" {
   description = "environment where DIG will be onboarded"
   type        = string
   default     = "nonprod"
  
}

# variable "tags" {
#   description = "Mandatory labels for all resources (lowercase keys only)"
#   type        = map(string)
#   validation {
#     condition     = alltrue([
#       for k in ["aide-id", "service-tier", "owner", "project", "managedby"] : contains(keys(var.tags), k)
#     ])
#     error_message = "Missing required labels: 'aide-id', 'service-tier', 'owner', 'project', 'managedby'"
#   }
# }

# variable "environment" {
#   description = "Deployment environment (e.g., prod, dev)"
#   type        = string
#   default     = "dev"
# }
