variable "resource_tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)
  default = {
    aide-id       = "AIDE_0086284"
    Owner         = "EIS"
    Project       = "prisma-dspm"
    ManagedBy     = "Terraform"
    service-tier  = "p1"
  }
}