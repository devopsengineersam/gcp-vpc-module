locals {
  # Permissions for managing IAM roles, to be conditionally applied.
  role_management_permissions = [
    "iam.roles.create",
    "iam.roles.delete",
    "iam.roles.get",
    "iam.roles.undelete",
    "iam.roles.update",
  ]

  # Other permissions that do not require the specific "dig-*" role name condition.
  other_service_permissions = [
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.setIamPolicy",
    "logging.sinks.create",
    "logging.sinks.delete",
    "logging.sinks.get",
    "logging.sinks.update",
    "resourcemanager.organizations.get",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "serviceusage.services.disable",
    "serviceusage.services.enable",
    "serviceusage.services.get",
    "serviceusage.services.list",
    "serviceusage.services.use",
  ]
}

# Module invocation for the five IAM role management permissions with a condition.
module "gcp_org_level_binding_policies_role_management" {
  source                 = "../../modules/sbl_gcp_sa"
  service_name           = "pcpe-lp-uit-eis-sectools-role-mgr"
  description            = "Permissions for DSPM DIG tool - Conditional Role Management (dig-* roles)"
  service_acct_id        = "pcpe-lp-uit-eis-sectools"
  use_prod_gcp_acct      = true
  sa_group_id            = local.sa_group_id 
  gcp_predefined_roles   = []               

  # Custom permissions for IAM role management
  permissions            = local.role_management_permissions

  # IAM Condition: Apply these permissions only if the target role name starts with "dig-"
  # IMPORTANT: This assumes the module '../../modules/sbl_gcp_sa' supports these (or similar)
  #            input parameters for defining an IAM binding condition.
  #            If not, the module itself needs modification or alternative resources must be used.
  condition_title        = "Restrict role management to dig- roles"
  condition_expression   = "resource.name.extract('/roles/{role_id}').startsWith('dig-')"

  providers = {
    aws        = aws        
    aws.nonprod = aws.nonprod
  }
}

# Module invocation for all other permissions without the specific condition.
module "gcp_org_level_binding_policies_other_services" {
  source                 = "../../modules/sbl_gcp_sa"
  service_name           = "pcpe-lp-uit-eis-sectools-other-perms"
  description            = "Permissions for DSPM DIG tool - Other Services"
  service_acct_id        = "pcpe-lp-uit-eis-sectools"
  use_prod_gcp_acct      = true
  sa_group_id            = local.sa_group_id
  gcp_predefined_roles   = []

  # Custom permissions for other services
  permissions            = local.other_service_permissions

  # No specific IAM condition for this set of permissions.

  providers = {
    aws        = aws
    aws.nonprod = aws.nonprod
  }
}