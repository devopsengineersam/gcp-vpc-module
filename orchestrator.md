# Data Security Posture Management

**Prisma Cloud DSPM**  is an agentless, multi-cloud, data security platform that discovers, classifies, protects, and governs sensitive data. As more and more organizations shift to manage their data assets in the cloud, this process requires implementation of better data monitoring capabilities. Prisma Cloud DSPM's mission is to provide organizations with such capabilities, in order to ensure complete visibility and real-time control over potential security risks to their data.

## DSPM onboarding runbook for AWS

This runbook is intended to help onboard AE's through the CLI, console and terraform if preffered, that cannot be onboarded using the regular SBL pipeline.

### Onboarding the Orchestrator account

**Prisma Cloud DSPM Orchestrator** is the component responsible for analyzing data from your environment. This component enables Prisma Cloud DSPM’s compute resources - e.g., EC2 for AWS, VM for Azure - to scan and analyze your different accounts across the selected cloud platform. You will install Orchestrator in a single dedicated account (a security tooling account) while monitoring other scanned accounts.

#### Prerequisites

All the bellow steps should be ran on the AWS Cloudshell since it already has the AWS CLI installed on it.

#### 1.Install Terraform
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



