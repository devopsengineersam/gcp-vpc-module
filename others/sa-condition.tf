# 1. Create the Service Account
resource "google_service_account" "eis_sectools_service_account" {
  account_id   = "eis-sectools-sa"
  display_name = "EIS Sectools Service Account"
  description  = "Service account for EIS Sectools to perform DSPM enablement"
}

# 2. Define the Custom Role (from your image)
resource "google_organization_iam_custom_role" "eis_sectools_scoped_role" {
  role_id     = "eis_sectools_scoped_role"
  org_id      = "531591688136" # optum.com - Replace with your actual org_id or var.org_id
  title       = "EIS Sectools Scoped Role"
  description = "Custom role for EIS Sectools to perform DSPM enablement on GCP resources."
  permissions = [
    "iam.roles.create",
    "iam.roles.delete",
    "iam.roles.get",
    "iam.roles.undelete",
    "iam.roles.update",
  ]
}

# 3. Bind the Service Account to the Custom Role with Conditions (from your image)
resource "google_organization_iam_member" "eis_sectools_scoped_role_member" {
  org_id = "531591688136" # optum.com - Replace with your actual org_id or var.org_id
  role   = google_organization_iam_custom_role.eis_sectools_scoped_role.name
  member = "serviceAccount:${google_service_account.eis_sectools_service_account.email}"

  condition {
    title       = "Restrict IAM Role Management to 'dig-' prefixed roles on IAM service"
    description = "Grants permissions to manage IAM custom roles (create, delete, get, undelete, update) only if the resource is an IAM Role, its service is iam.googleapis.com, and the role's ID starts with 'dig-'"
    expression  = "resource.type == 'cloudresourcemanager.googleapis.com/Project' && api.getAttribute('iam.googleapis.com/role_id', '').startsWith('dig_'),title=Restrict IAM Role Creation to 'dig_' prefixed roles"
  }
}

# api.getAttribute('iam.googleapis.com/role_id', '').startsWith('dig-'),title=Restrict IAM Role Creation to 'dig-' prefixed roles"

"resource.type == 'cloudresourcemanager.googleapis.com/Project' && api.getAttribute('iam.googleapis.com/role_id', '').startsWith('dig_')"