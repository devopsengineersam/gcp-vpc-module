# Data Security Posture Management

**Prisma Cloud DSPM**  is an agentless, multi-cloud, data security platform that discovers, classifies, protects, and governs sensitive data. As more and more organizations shift to manage their data assets in the cloud, this process requires implementation of better data monitoring capabilities. Prisma Cloud DSPM's mission is to provide organizations with such capabilities, in order to ensure complete visibility and real-time control over potential security risks to their data.

## DSPM onboarding runbook for AWS

This runbook is intended to help onboard AE's through the CLI, console and terraform if preffered, that cannot be onboarded using the regular SBL pipeline.

### Onboarding the Orchestrator account

**Prisma Cloud DSPM Orchestrator** is the component responsible for analyzing data from your environment. This component enables Prisma Cloud DSPM’s compute resources - e.g., EC2 for AWS, VM for Azure - to scan and analyze your different accounts across the selected cloud platform. You will install Orchestrator in a single dedicated account (a security tooling account) while monitoring other scanned accounts.

#### Prerequisites

All the bellow steps should be ran on the AWS Cloudshell since it already has the AWS CLI installed on it.

#### 1. Install Terraform
   In order to run the terraform runbook, terraform must be installed on the AWS Cloudshell

   Since AWS Cloudshell by default runs on Amazon Linux2023 operating system, this is how to install Terraform on Amazon Linux 2023, follow these steps: 

• Install DNF plugin for config-manager: Amazon Linux 2023 uses dnf as its package manager. 
```
sudo dnf install -y 'dnf-command(config-manager)'
```

Add the HashiCorp repository. 
```
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```
install terraform. 
```
sudo dnf install -y terraform
```
Verify the installation. 
```
terraform version
```
This command should display the installed Terraform version, confirming a successful installation. 

#### 1. Create an S3 bucket that will be used to hold the terraform state file **(Give the bucket-name a unique name)**

```
aws s3 mb s3://bucket-name
```

### Onboarding..

### Step 1: Copy and paste the following code into the main.tf file

_copying and pasting the below code will automatically create the main.tf file and paste the code in the file_

```
cat > main.tf <<'EOF'
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "your-terraform-state-bucket"
    key     = "path/to/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "dig_security_orchestrator" {
  source      = "https://onboarding.use1.dig.security/aws/terraform/latest/dig-security-roles.zip//dig_security_orchestrator_account"
  tenant_id   = "806775379468908544"
  external_id = "046ef5e7089808486948fdeb943f963319933f0a6236363ffa780e1a180ae01"
}
EOF
```

**N/B: Replace the bucket-name with the bucket name that you created in the prerequisites.**

### Step 3: Initialize Terraform

```
terraform init
```
This command initializes the Terraform configuration, downloads the necessary provider plugin, download the terraform module and sets up the backend.

### Step 4: Review the execution plan

```
terraform plan
```
This command creates an execution plan, showing what actions Terraform will take to achieve the desired state defined in the configuration.
Go through the plan to get a preview of the resources that will be installed on your AWS account (Orchestrator account)

### Step 5: Apply the configuration

```
terraform apply
```
This command applies the changes required to reach the desired state of the configuration. You will be prompted to confirm before proceeding. Type "yes" to proceed.

### Step 6: Verify the resources
After the apply is complete, you can verify that the resources have been created in the AWS Management Console.