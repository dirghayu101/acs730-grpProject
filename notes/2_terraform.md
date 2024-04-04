This is the part 2 (continuation from 1_terraform.md)

Okay, we created a dummy terraform infrastructure in part 1. 

Now, we will be modifying it using terraform.

The project is located in the directory ./aws_terraform_trial


# Part 1: How terraform handle updates?
For this one, you have to change the AMI ID in the main.tf file. Just change it to something else then run:
- terraform apply
    - The AWS provider knows that it cannot change the AMI of an instance after it has been created, so Terraform will destroy the old instance and create a new one.
    - Before prompting you to enter yes, terraform will present its execution plan. There will be this line in your terraform execution plan: -/+ resource "aws_instance" "app_server"
    - The prefix -/+ means that Terraform will destroy and recreate the resource, rather than updating it in-place. 
    - Terraform can update some attributes in-place (indicated with the ~ prefix)
    - The execution plan also shows the reason behind +/- (change of AMI ID.)

# Part 2: Destroying infrastructure in terraform.
- terraform destroy
    - The terraform destroy command terminates resources managed by your Terraform project. This command is the inverse of terraform apply in that it terminates all the resources specified in your Terraform state.
    - It does not destroy resources running elsewhere that are not managed by the current Terraform project.
    - The - prefix indicates that the instance will be destroyed. As with apply, Terraform shows its execution plan and waits for approval before making any changes.

# Part 3: Defining Variable (Basics). I will cover it in more detail in the next part.
1. In the directory where you have initialized terraform (terraform init), create a new file called variables.tf with a block defining a new instance_name variable. (refer ./aws_terraform_trial/variables.tf)

2. After finishing 1. In the main.tf (refer ./aws_terraform_trial/main.tf), update the aws_instance resource block to use the new variable. 

3. Using CLI: terraform apply -var "instance_name=YetAnotherName"
You can run this to update the name of the deployed instance (if you haven't destroyed)

# Part 4: Giving output in the cli.
1. Checkout the file "./aws_terraform_trial/outputs.tf".
2. Terraform prints output values to the screen when you apply your configuration (tf apply). 
3. Query the outputs with the terraform output command.
    - terraform output 