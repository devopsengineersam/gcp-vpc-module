module "dspm_vpc_permissions" {
  source = ".../modules/sbl_gcp_sa"
  service_name    = "dspm-vpc-deployer"
  description     = "Permissions for DSPM VPC Networking Components"
  service_act_id  = "dspm-vpc-deployer"
  use_prod_gcp_act = true

  gcp_predefined_roles = []

  permissions = [
    # Compute Engine Permissions
    "compute.addresses.create",
    "compute.addresses.delete",
    "compute.addresses.get",
    "compute.addresses.list",
    "compute.firewalls.create",
    "compute.firewalls.delete",
    "compute.firewalls.get",
    "compute.firewalls.list",
    "compute.networks.create",
    "compute.networks.delete",
    "compute.networks.get",
    "compute.networks.list",
    "compute.networks.update",
    "compute.routers.create",
    "compute.routers.delete",
    "compute.routers.get",
    "compute.routers.list",
    "compute.routers.update",
    "compute.subnetworks.create",
    "compute.subnetworks.delete",
    "compute.subnetworks.get",
    "compute.subnetworks.list",
    "compute.subnetworks.update",

    # Service Networking
    "servicenetworking.services.addPeering",
    "servicenetworking.services.get",
    "servicenetworking.services.update",

    # Service Account Basic Usage
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list"
  ]
}

providers = {
  aws = aws
  aws.nonprod = aws.nonprod
}