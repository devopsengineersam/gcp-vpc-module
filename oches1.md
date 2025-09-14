Here’s a cleaned up, polished, and GitHub-ready README.md with corrected grammar, structured formatting, and beautified with markdown color-coding (using code blocks, highlights, and notes).

⸻


# 🔐 Data Security Posture Management (DSPM)

## Prisma Cloud DSPM

**Prisma Cloud DSPM** is an **agentless**, **multi-cloud data security platform** that discovers, classifies, protects, and governs sensitive data.  
As organizations continue to shift their data assets to the cloud, the need for stronger **data visibility, monitoring, and control** has become critical.  

👉 Prisma Cloud DSPM’s mission is to **provide real-time visibility and control** over sensitive data to mitigate risks and ensure compliance.

---

# 🚀 DSPM Onboarding Runbook for AWS

This runbook helps onboard AWS accounts to **Prisma Cloud DSPM** through:

- **AWS CLI**
- **AWS Console**
- **Terraform (preferred)**  

This guide is designed for onboarding **orchestrator** and **monitored accounts** that **cannot be onboarded via the standard SBL pipeline**.

---

## 🛠️ Onboarding the Orchestrator Account

The **Prisma Cloud DSPM Orchestrator** is the **central component** that analyzes data across your cloud accounts.  
It uses compute resources (e.g., **EC2 in AWS**) to scan and analyze monitored accounts.  

📌 The Orchestrator should be installed in a **dedicated AWS security tooling account**.

---

### ✅ Prerequisites

#### 1. Create a dedicated AWS account
Use a **new or existing AWS account** for the Orchestrator.  
⚠️ _Expect an increase in AWS costs in this account, as resources such as EC2 and VPC networking will be provisioned._

All steps below should be executed in the **AWS CloudShell** of this account (AWS CLI is pre-installed there).

---

#### 2. Install Terraform in CloudShell

CloudShell runs **Amazon Linux 2023** by default. To install Terraform:

```bash
# Install DNF config-manager plugin
sudo dnf install -y 'dnf-command(config-manager)'

# Add HashiCorp repository
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform
sudo dnf install -y terraform

# Verify installation
terraform version


⸻

3. Create an S3 Bucket for Terraform State

aws s3 mb s3://<your-unique-bucket-name>

⚠️ Replace <your-unique-bucket-name> with a globally unique name.

⸻

🚦 Onboarding Steps

Step 1: Create main.tf

Run this one-liner to generate a Terraform config file:

cat > main.tf <<'EOF'
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13.0"
    }
  }

  backend "s3" {
    bucket = "cdktf-backend-dev"      # 🔄 Replace with your bucket-name
    key    = "terraform.tfstate"      # e.g. "envs/prod/dspm/terraform.tfstate"
    region = "us-east-1"              # 🔄 Replace with your AWS region
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"                # 🔄 Replace with your AWS region
}

module "dig_security_orchestrator" {
  source      = "https://onboarding.use1.dig.security/aws/terraform/latest/dig-security-roles.zip//dig_security_orchestrator_account"
  tenant_id   = "806775379468908544"
  external_id = "046ef5e7089808486948fdeb943f963319933f0a6236363ffa780e1a180ae01"
}
EOF


⸻

Step 2: Initialize Terraform

terraform init

This downloads providers, modules, and configures the S3 backend.

⸻

Step 3: Review Execution Plan

terraform plan

Check the resources Terraform will provision in your AWS Orchestrator account.

⸻

Step 4: Apply Configuration

terraform apply

Confirm by typing yes.

⸻

Step 5: Verify Resources

Log in to the AWS Management Console and confirm resources were created successfully.

⸻

Step 6: Share Account ID

Provide the AWS Account ID of your Orchestrator account to the Prisma Cloud DSPM team for verification.

⸻

📡 Onboarding Monitored Accounts

Monitored accounts are AWS accounts that Prisma Cloud DSPM will scan for sensitive data.
Repeat the following steps in each monitored account using CloudShell.

⸻

🚦 Steps

Step 1: Create main.tf

cat > main.tf <<'EOF'
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13.0"
    }
  }

  backend "s3" {
    bucket = "cdktf-backend-dev"         # 🔄 Replace with your bucket-name
    key    = "terraform.tfstate"         # e.g. "envs/prod/dspm/terraform.tfstate"
    region = "us-east-1"                 # 🔄 Replace with your AWS region
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"                   # 🔄 Replace with your AWS region
}

module "dig_security_monitored_account" {
  source                  = "https://onboarding.use1.dig.security/aws/terraform/latest/dig-security-roles.zip//dig_security_monitored_account"
  tenant_id               = "806775379468908544"
  external_id             = "046ef5e7089808486948fdeb943f963319933f0a6236363ffa780e1a180ae01"
  orchestrator_account_id = <orchestrator_aws_account_id>   # 🔄 Replace with your Orchestrator AWS Account ID
}
EOF


⸻

Step 2: Initialize Terraform

terraform init


⸻

Step 3: Review Execution Plan

terraform plan


⸻

Step 4: Apply Configuration

terraform apply

Confirm by typing yes.

⸻

Step 5: Verify Resources

Check the AWS Management Console to confirm provisioning.

⸻

Step 6: Share Account ID

Provide the AWS Account IDs of all monitored accounts to the DSPM team for validation.

⸻

✅ Summary
	•	Orchestrator account provisions scanning resources.
	•	Monitored accounts are linked to the orchestrator.
	•	Terraform automates resource setup.
	•	Ensure S3 backend, region settings, and account IDs are correctly updated.

⸻

⚠️ Note: Always review Terraform plans before applying.
🛡️ This ensures you maintain visibility into infrastructure changes.

---

Would you like me to also add **badges, a table of contents, and collapsible sections** (like `<details>`) to make it look more GitHub-professional?