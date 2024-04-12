Project Setup Instructions
This guide will walk you through how we set up the project, configuring different environments, and installing Terraform.

Setting up Prerequisites
We will need an S3 bucket to store the Terraform state files securely. If  it hasnot been created we can use the AWS CLI or GUI.

We will use AWS CLI: aws s3 mb s3://acs-final-grp-17

Using AWS Management Console (GUI):
-- First Navigate to the S3 service in the AWS Management Console.
-- Then click on "Create bucket".
-- Now enter "acs-final-grp-17" as the bucket name and follow the on-screen instructions to create the bucket.


Installing Terraform
Downloading Terraform:
-- Download the appropriate Terraform package for your operating system from the official Terraform website.

Extract the Terraform binary:
-- Extract the downloaded zip file to a directory of your choice.

Adding Terraform to PATH:
-- Add the directory containing the Terraform binary to your system's PATH environment variable.
-- For Linux/Mac: Edit your shell configuration file (e.g., ~/.bashrc, ~/.bash_profile, ~/.zshrc) and add the following line: export PATH=$PATH:/path/to/terraform/directory

Verifying Installation:

-- Open a new terminal or command prompt and run: terraform --version ( We can see the Terraform version information if the installation was successful.)

Configuring Environments
--  We can configure different environments using Terraform by creating separate directories for each environment and providing environment-specific configurations.

Environment-specific Configurations:
-- In each environment directory, create main.tf and variables.tf files with environment-specific configurations.
-- main.tf: It defines the Terraform resources and configurations for the environment.
-- variables.tf: It defines environment-specific variables and their values.

Initializing Terraform:
-- Navigate to the environment directory (e.g., dev) in your terminal.
-- Run the following command to initialize Terraform and download provider plugins: terraform init

Code For installing Terraform: 
-- sudo yum install -y yum-utils shadow-utils
-- sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
-- sudo yum -y install terraform

Apply Terraform Configuration:
-- After initializing Terraform, you can apply the configuration to create or update resources: terraform apply

Clean Up Resources:
-- When you no longer need the resources, you can destroy them using: terraform destroy

Terraform Components:
It consits of 3 components
-- config.tf
-- main.tf
-- output.tf
-- variables.tf


This README provides a detailed guide for setting up the project, configuring environments, and installing Terraform. Following these steps ensures a smooth setup process.













