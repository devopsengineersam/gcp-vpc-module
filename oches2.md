# Data Security Posture Management

**Prisma Cloud DSPM** is an agentless, multi-cloud data security platform that discovers, classifies, protects, and governs sensitive data. As organizations increasingly shift their data assets to the cloud, implementing robust data monitoring capabilities becomes essential. Prisma Cloud DSPM's mission is to provide organizations with these capabilities, ensuring complete visibility and real-time control over potential security risks to their data.

---

## DSPM Onboarding Runbook for AWS

This runbook assists Account Engineers (AEs) in onboarding through the CLI, console, or Terraform when the regular SBL pipeline is unavailable.

---

## Onboarding the Orchestrator Account

The **Prisma Cloud DSPM Orchestrator** is the component responsible for analyzing data from your environment. It enables Prisma Cloud DSPM’s compute resources (e.g., EC2 for AWS, VM for Azure) to scan and analyze accounts across your cloud platform. The Orchestrator is installed in a single dedicated account (a security tooling account) while monitoring other scanned accounts.

### ✅ Prerequisites

#### 1. Create or Designate an AWS Account
   - Create a new AWS account or use an existing one dedicated to running the DSPM Orchestrator.
   - **Note:** You will notice an increase in costs due to provisioned resources (e.g., EC2 instances, VPCs).

#### 2. Install Terraform on AWS CloudShell
   AWS CloudShell runs on Amazon Linux 2023. Follow these steps to install Terraform:

   ```bash
   # Install DNF plugin for config-manager
   sudo dnf install -y 'dnf-command(config-manager)'

   # Add the HashiCorp repository
   sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

   # Install Terraform
   sudo dnf install -y terraform

   # Verify installation
   terraform version
   ```

#### 3. Create an S3 Bucket for Terraform State
   Create a uniquely named S3 bucket to store the Terraform state file:

   ```bash
   aws s3 mb s3://your-unique-bucket-name
   ```

---

### Onboarding Steps

#### Step 1: Copy and paste the following code into a the AWS Cloudshell 

_This will create the main.tf file and paste the code in the file_
   
```
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
    bucket = "your-unique-bucket-name"          # change to your bucket-name
    key    = "terraform.tfstate"                # e.g. “envs/prod/dspm/terraform.tfstate”
    region = "us-east-1"                        # change to your AWS region where you created the S3 bucket in the prerequisites
    encrypt = true
}
}

provider "aws" {
region = "us-east-1"                          # change to your AWS region accordingly
}

module "dig_security_orchestrator" {
source      = "https://onboarding.use1.dig.security/aws/terraform/latest/dig-security-roles.zip//dig_security_orchestrator_account"
tenant_id   = "806775379468908544"
external_id = "046ef5e7089808486948fdeb943f963319933f0a6236363ffa780e1a180ae01"
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
   Confirm the resources are created in the AWS Management Console.

#### Step 6: Share the AWS Account ID
   Provide the AWS Account ID where the Orchestrator is installed for verification on the DSPM console.

---

## Onboarding Monitored Accounts

Monitored accounts are the AWS accounts that DSPM will scan.

For each of the AWS accounts you wish to scan, perform the below steps:

### Onboarding Steps

#### Step 1: Copy and paste the following code into a the AWS Cloudshell 

_This will create the main.tf file and paste the code in the file_

```
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
    bucket = "your-unique-bucket-name"          # change to your bucket-name
    key    = "terraform.tfstate"                # e.g. “envs/prod/dspm/terraform.tfstate”
    region = "us-east-1"                        # change to your AWS region where you created the S3 bucket in the prerequisites
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"                          # change to your AWS region accordingly
}

module "dig_security_monitored_account" {
  source                  = "https://onboarding.use1.dig.security/aws/terraform/latest/dig-security-roles.zip//dig_security_monitored_account"
  tenant_id               = "806775379468908544"
  external_id             = "046ef5e7089808486948fdeb943f963319933f0a6236363ffa780e1a180ae01"
  orchestrator_account_id = <orchestrator_aws_account_id>  #
}
EOF
```

   **Note:** Replace `your-unique-bucket-name`, region values, and `your-orchestrator-account-id`.

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
   Confirm the resources are created in the AWS Management Console.

#### Step 6: Share AWS Account IDs
   Provide all onboarded AWS Account IDs for verification on the DSPM console.

---

### Key Notes:
- Ensure all steps are performed in the respective AWS accounts using AWS CloudShell.
- Replace placeholder values (e.g., bucket names, regions, account IDs) with actual values.
- Verify Terraform configurations before applying to avoid unintended resource changes.