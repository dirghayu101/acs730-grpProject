# Random Notes (Ref: https://developer.hashicorp.com/terraform/language)
- Checkout the example in the mentioned reference, it's quiet interesting.
- The Terraform language is declarative, describing an intended goal rather than the steps to reach that goal. 
- The ordering of blocks and the files they are organized into are generally not significant; Terraform only considers implicit and explicit relationships between resources when determining an order of operations.

# Once you are checking out the example, here is an explanation:
Context: While declaring the instance, I was trying to pass the value of VPC-ID along with subnet ID and security group ID. When I tried to validate this configuration, it gave me an error and I was clueless.

# The example will give me an idea about the reason behind that error.


# I used gemini to explain me this line: "Terraform only considers implicit and explicit relationships between resources when determining an order of operations"

Here's a breakdown of the statement about Terraform's order of operations:

# Terraform doesn't care about file or block order:
* You might organize your Terraform configuration into multiple files and blocks for readability.
* The order you define these blocks or files in doesn't affect how Terraform executes the configuration.

# Terraform prioritizes dependencies:
* Terraform analyzes your configuration to identify relationships between resources.
* These relationships are called **dependencies**. A resource depends on another if it needs the other one to be created or configured first.
* Terraform builds a dependency graph based on these relationships.

# Execution based on dependencies:
* Terraform uses the dependency graph to determine the order of operations.
* It prioritizes creating or configuring resources that other resources depend on.
* This ensures everything is set up correctly before Terraform uses it.

# Analogy:
Imagine building a house. You can't put on the roof before the walls are built. Terraform works similarly, ensuring dependent resources are created first, like building the walls before the roof.
