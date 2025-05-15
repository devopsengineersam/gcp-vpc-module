module "dspm_vpc_permissions" {
  source = ".../modules/sbl_gcp_sa"  # Use your internal module path
  service_name    = "dspm-vpc-deployer"
  description     = "Permissions for DSPM VPC Networking Components"
  service_act_id  = "dspm-vpc-deployer"
  use_prod_gcp_act = true

  # Use predefined roles instead of granular permissions
  gcp_predefined_roles = [
    "roles/compute.networkAdmin",
    "roles/servicenetworking.serviceAgent",
    "roles/iam.serviceAccountUser"
  ]

  # Custom permissions (keep empty if using predefined roles)
  permissions = []
  
  providers = {
  aws = aws
  aws.nonprod = aws.nonprod
}
}