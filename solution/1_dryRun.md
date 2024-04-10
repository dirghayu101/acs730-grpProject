I will be replicating a bit of this infrastructure using the Amazon GUI, I will see what all changes I will make to defaults to configure it:

# Step 1: VPC Creation:
Name: try-acs-final
CIDR: 10.2.0.0/16

# Step 2: Create the following Subnets:
    # Subnet 1: 
        VPC: vpc-0849df4dc5f5c84d0
        Name: acs-final-1
        AZ: us-east-1b
        CIDR Block: 10.2.1.0/24
    
    # Subnet 2:
        VPC: vpc-0849df4dc5f5c84d0
        Name: acs-final-2
        AZ: us-east-1c
        CIDR Block: 10.2.2.0/24
    
    # Subnet 3:
        VPC: vpc-0849df4dc5f5c84d0
        Name: acs-final-3
        AZ: us-east-1d
        CIDR Block: 10.2.3.0/24

    # Subnet 4:
        VPC: vpc-0849df4dc5f5c84d0
        Name: priv-acs-final-1
        AZ: us-east-1b
        CIDR Block: 10.2.4.0/24        

    # Subnet 5:
        VPC: vpc-0849df4dc5f5c84d0
        Name: priv-acs-final-2
        AZ: us-east-1c
        CIDR Block: 10.2.5.0/24  

    # Subnet 6:
        VPC: vpc-0849df4dc5f5c84d0
        Name: priv-acs-final-3
        AZ: us-east-1d
        CIDR Block: 10.2.6.0/24  

# Step 3: Internet Gateway creation:
    Name: acs-final-igw
    VPC associated with: vpc-0849df4dc5f5c84d0 # Then attach it to VPC.

# Step 4: Route table creation:
    # Public route table:
        Name: acs-final-rtb-public
        Associated subnets with this route table: acs-final-1, acs-final-2, acs-final-3.
        Add internet gateway as one of the route.

    # Private route table creation:
        Name: acs-final-rtb-private
        Associate subnets with this route table: priv-acs-final-1, priv-acs-final-2, priv-acs-final-3


# Step 5: Setup S3 bucket in the aws console.
    Upload images and use this command on each image object to give them public access.
        aws s3 presign s3://acs-final-ec2-bucket/demo.png --expires-in 3000

# Step 6: Bastion Setup (I will use an ec2 instance in public subnet, will replace this with some bastion initialization code):
    Name: acs-final-access-node
    AMI: Amazon Linux (ami-051f8a213df8bc089)
    Instance type: t2.micro
    Key Pair Login: Vockey
    VPC: vpc-0849df4dc5f5c84d0
    Subnet: acs-final-1 
    Public IP assign: Enable
    Security Group: 1 rule: SSH allowed from anywhere.
    ...Rest is default.

# Step 7: Security Group setup for ec2 instances in the ASG and Load Balancer.
    Name: acs-final-ec2-sg
    Description: Allows HTTP and SSH.
    VPC: vpc-0849df4dc5f5c84d0 (created one: try-acs-final)
    Inbound 1: SSH from 10.2.1.0/24 -> Project VPC's CIDR block.
    Inbound 2: HTTP from 10.2.1.0/24 -> Project VPC's CIDR block.

# Step 8: Original ec2 setup for ASG and load balancing:
    Name: acs-final-default
    AMI: Amazon Linux (ami-051f8a213df8bc089)
    Instance type: t2.micro # Will change according to the environment
    Key Pair login: Vockey
    VPC: vpc-0849df4dc5f5c84d0 (created one: try-acs-final)
    Subnet: priv-acs-final-1
    Security Group: acs-final-ec2-sg

# Step 9: 
