# Data Security Posture Management

[**Prisma Cloud DSPM**](https://docs.prismacloud.io/en/enterprise-edition/content-collections/data-security-posture-management/data-security-posture-management) is an agentless, multi-cloud data security platform that discovers, classifies, protects, and governs sensitive data. As organizations increasingly shift their data assets to the cloud, implementing robust data monitoring capabilities becomes essential. Prisma Cloud DSPM's mission is to provide organizations with these capabilities, ensuring complete visibility and real-time control over potential security risks to their data.

---

## DSPM Onboarding Runbook for GCP

This runbook assists Account Engineers (AEs) in onboarding through the CLI, console, or Terraform when the regular SBL pipeline is unavailable.

---

## Onboarding the Orchestrator Account

The **Prisma Cloud DSPM Orchestrator** is the component responsible for analyzing data from your environment. It enables Prisma Cloud DSPM’s compute resources (e.g., EC2 for AWS, VM for Azure and GCP) to scan and analyze accounts across your cloud platform. The Orchestrator is installed in a single dedicated account (a security tooling account) while monitoring other scanned accounts.

### ✅ Prerequisites

#### 1. Create or Designate a GCP project/(Account)
   - Create a new GCP Project or use an existing one dedicated to running the DSPM Orchestrator.
   - **Note:** ⚠️ You will notice an increase in costs due to provisioned resources (e.g., Virtual machines and VPCs).

#### 2. Install Terraform on GCP Cloud Shell
   Follow these steps to install Terraform:

   ```bash
   # Ensure that your system is up to date and that you have installed the `gnupg` and `software-properties-common` packages. You will use these packages to verify HashiCorp's GPG signature and install HashiCorp's Debian package repository.
   sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

   # Install HashiCorp's GPG key.
   wget -O- https://apt.releases.hashicorp.com/gpg | \
   gpg --dearmor | \
   sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

   # Verify the GPG key's fingerprint.
   gpg --no-default-keyring \
   --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
   --fingerprint
   
   # The gpg command reports the key fingerprint:
   #/usr/share/keyrings/hashicorp-archive-keyring.gpg
   # -------------------------------------------------
   # pub   rsa4096 XXXX-XX-XX [SC]
   # AAAA AAAA AAAA AAAA
   # uid         [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
   #sub   rsa4096 XXXX-XX-XX [E]


   # Add the official HashiCorp repository to your system.
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

   # Update apt to download the package information from the HashiCorp repository.
   sudo apt update

   # Install Terraform
   sudo apt-get install terraform

   # Verify installation
   terraform version
   ```

#### 3. Create a Cloud Storage Bucket For Terraform State file
   Create a uniquely named Cloud Storage bucket to store the Terraform state file:

   ```bash
   gcloud storage buckets create <your-unique-bucket-name> --location=us-central1
   ```

---

### Onboarding Steps

#### Step 1: Copy and paste the following code into a the GCP Cloud Shell 

_This will create the main.tf file and paste the code in the file_
   
```
cat > main.tf <<'EOF'
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.2.0"
    }
  }
  # defines the terraform backend to store the state file
  backend "gcs" {
    bucket = "<your-unique-bucket-name>"               # replace the your-unique-bucket-name from the previous step
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "<gcp_project_name>"                       # replace with your gcp project name
}

module "dig_security_orchestrator" {
  source      = "https://onboarding.usel.dig.security/gcp/terraform/latest/orchestrator-terraform.zip//modules/orchestrator_project"
  tenant_id   = "806775379468908544"
  external_id = "@46ef5e"
}
EOF
```

   **Note:** Replace `your-unique-bucket-name` and the region values as needed.

#### Step 2: Initialize Terraform
   ```bash
   terraform init
   ```

#### Step 3: Review the Execution Plan
   ```bash
   terraform plan
   ```

#### Step 4: Apply the Configuration
   ```bash
   terraform apply
   ```
   Type `yes` when prompted to proceed.

#### Step 5: Verify Resources
   Confirm the resources are created in the GCP Project Console.

#### Step 6: Share the GCP Project ID
   Provide the GCP Project ID where the Orchestrator is installed for verification on the DSPM console.

---

## Onboarding Monitored Accounts

Monitored accounts are the GCP projects that DSPM will scan.

For each of the GCP Project you wish to scan, perform the below steps:

### Onboarding Steps

#### Step 1: Copy and paste the following code into a the GCP Cloud Shell 

_This will create the main.tf file and paste the code in the file_

```
cat > main.tf <<'EOF'
cat > main.tf <<'EOF'
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.2.0"
    }
  }
  # defines the terraform backend to store the state file
  backend "gcs" {
    bucket = "<your-unique-bucket-name>"               # replace the your-unique-bucket-name from the previous step
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "<gcp_project_name>"                       # replace with your gcp project name
}

module "dig_security_monitored_account" {
  source                     = "https://onboarding.usel.dig.security/gcp/terraform/latest/monitored-terraform.zip//modules/monitored"
  tenant_id                  = "806775379468908544"
  external_id                = "046ef5e"
  orchestrator_project_ref   = "<gcp-project-id>"
  orchestrator_sa            = "dig-usel-orchestrator-046ef5e@<gcp-project-id>.iam.gserviceaccount.com"
}
EOF
```

   **Note:** Replace `bucket`, `project`, `orchestrator_project_ref` and `orchestrator_sa `.

#### Step 2: Initialize Terraform
   ```bash
   terraform init
   ```

#### Step 3: Review the Execution Plan
   ```bash
   terraform plan
   ```

#### Step 4: Apply the Configuration
   ```bash
   terraform apply
   ```
   Type `yes` when prompted to proceed.

#### Step 5: Verify Resources
   Confirm the resources are created in the GCP Project.

#### Step 6: Share GCP Project IDs
   Provide all onboarded GCP Project IDs for verification on the DSPM console.

---

### Key Notes:
- Ensure all steps are performed in the respective GCP Projects using GCP Cloud Shell.
- Replace placeholder values (e.g., bucket names, regions, project IDs) with actual values.
- Verify Terraform configurations before applying to avoid unintended resource changes.