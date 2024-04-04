Pointers to revisit about terraform:

# What is Infrastructure as Code with Terraform? | Terraform | HashiCorp Developer
- Terraform interact with cloud platforms and other services via their application programming interfaces (APIs).
- Terraform's configuration language is declarative, meaning that it describes the desired end-state for your infrastructure, in contrast to procedural programming languages that require step-by-step instructions to perform tasks. Terraform providers automatically calculate dependencies between resources to create or destroy them in the correct order.
- To deploy infrastructure with Terraform: Scope - Identify the infrastructure for your project. Author - Write the configuration for your infrastructure. Initialize - Install the plugins Terraform needs to manage the infrastructure. Plan - Preview the changes Terraform will make to match your configuration. Apply - Make the planned changes.
- Terraform keeps track of your real infrastructure in a state file, which acts as a source of truth for your environment. Terraform uses the state file to determine the changes to make to your infrastructure so that it will match your configuration.

# Mac installation of terraform:
- brew tap hashicorp/tap
- brew install hashicorp/tap/terraform
- brew update
- brew upgrade hashicorp/tap/terraform
- alias tf=terraform

# Amazon linux installation of terraform:
- sudo yum install -y yum-utils
- sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
- sudo yum -y install terraform

# Verify installation:
- terraform -help

# Building infrastructure in terraform: (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build)

I will be running this tutorial and creating a dummy infrastructure in aws to understand it more deeply. I will be putting all my steps here.

# Part 1: Setting up aws cli after installation:
1. aws configure
2. aws configure set aws_session_token <yourTokenValue>
3. aws ec2 describe-vpcs # This is to verify your connections with your aws account.

# Part 2: Copying the main.tf file and understanding it. Specific notes will be as follows:
- The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision your infrastructure. In this example configuration, the aws provider's source is defined as hashicorp/aws, which is shorthand for registry.terraform.io/hashicorp/aws.
- You can also set a version constraint for each provider defined in the required_providers block. The version attribute is optional, but we recommend using it to constrain the provider version so that Terraform does not install a version of the provider that does not work with your configuration. If you do not specify a provider version, Terraform will automatically download the most recent version during initialization.
- Use resource blocks to define components of your infrastructure. 
- Resource blocks have two strings before the block: the resource type and the resource name. In this example, the resource type is aws_instance and the name is app_server. The ID for your EC2 instance is aws_instance.app_server.

# Part 3: Running the terraform setup.
- terraform init  
    - Initializing a configuration directory downloads and installs the providers defined in the configuration. In this case it is aws.
    - Terraform downloads the aws provider and installs it in a hidden subdirectory of your current working directory, named .terraform
    - Terraform also creates a lock file named .terraform.lock.hcl which specifies the exact provider versions used

- terraform fmt
    - formats the files in your configuration.
    - Similar to beautify. Returns all the files that were formatted.

- terraform validate
    - Validate your configuration.

# Part 4: Creating infrastructure with terraform.
- terraform apply
    - Terraform prints out the execution plan which describes the actions Terraform will take in order to change your infrastructure to match the configuration.
    - You have to confirm the plan with yes, before terraform starts with it.
    - I faced error here because of the AMI ID value difference. I used this command to list all the existing ec2 instances with their AMI ids: aws ec2 describe-instances --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value|[0],ImageId,InstanceId]' --output table
    - When you applied your configuration, Terraform wrote data into a file called terraform.tfstate. Terraform stores the IDs and properties of the resources it manages in this file, so that it can update or destroy those resources going forward.

- terraform state list
    - Terraform has a built-in command called terraform state for advanced state management. Use the list subcommand to list of the resources in your project's state.

# Security Considerations:
- Before typing in "yes" after terraform apply, check the execution plan. Maybe there is some issue which can cause big error.
- The Terraform state file is the only way Terraform can track which resources it manages, and often contains sensitive information, so you must store your state file securely and restrict access to only trusted team members who need to manage your infrastructure. In production, we recommend storing your state remotely.