# locals.tf or within the same file if preferred
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
    "resourcemanager.organizations.get",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.setIamPolicy",
    "logging.sinks.create",
    "logging.sinks.delete",
    "logging.sinks.get",
    "logging.sinks.update",
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
  service_name           = "pcpe-lp-uit-eis-sectools-role-mgr-permissions"
  description            = "Permissions for DSPM DIG tool - Conditional Role Management (dig-* roles)"
  service_acct_id        = local.service_account_id_for_tool
  use_prod_gcp_acct      = true
  sa_group_id            = local.sa_group_id
  gcp_predefined_roles   = []

  permissions            = local.role_management_permissions

  # IAM Condition: Apply these permissions only if the target role name starts with "dig-"
  # and the resource is an IAM Role.
  binding_condition = {
    title       = "Restrict IAM Role Management to 'dig-' prefixed roles on IAM service"
    description = "Grants permissions to manage IAM custom roles (create, delete, get, undelete, update) only if the resource is an IAM Role, its service is iam.googleapis.com, and the role's ID starts with 'dig-'."
    expression  = "resource.type == \"iam.googleapis.com/Role\" && resource.service == \"iam.googleapis.com\" && resource.name.extract('/roles/{role_id}').startsWith('dig-')"
  }

  providers = {
    aws         = aws
    aws.nonprod = aws.nonprod
  }
}

# Module invocation for all other permissions without the specific condition.
module "gcp_org_level_binding_policies_other_services" {
  source                 = "../../modules/sbl_gcp_sa"
  service_name           = "pcpe-lp-uit-eis-sectools-other-permisions"
  description            = "Permissions for DSPM DIG tool - Other Services"
  service_acct_id        = local.service_account_id_for_tool
  use_prod_gcp_acct      = true
  sa_group_id            = local.sa_group_id
  gcp_predefined_roles   = []

  permissions            = local.other_service_permissions

  providers = {
    aws         = aws
    aws.nonprod = aws.nonprod
  }
}