I will be replicating a bit of this infrastructure using the Amazon GUI, I will see what all changes I will make to defaults to configure it:


<ed>

# Step 1: VPC Creation:
Name: try-acs-final <ed>
CIDR: 10.2.0.0/16 <ed>

# Step 2: Create the following Subnets:
    # Subnet 1: 
        VPC: vpc-0849df4dc5f5c84d0
        Name: acs-final-1   <ed>
        AZ: us-east-1b
        CIDR Block: 10.2.1.0/24 <ed> 24 needed CIDR.
    
    # Subnet 2:
        VPC: vpc-0849df4dc5f5c84d0
        Name: acs-final-2 <ed>
        AZ: us-east-1c
        CIDR Block: 10.2.2.0/24 <ed>
    
    # Subnet 3:
        VPC: vpc-0849df4dc5f5c84d0
        Name: acs-final-3
        AZ: us-east-1d
        CIDR Block: 10.2.3.0/24 <ed>

    # Subnet 4:
        VPC: vpc-0849df4dc5f5c84d0
        Name: priv-acs-final-1 <ed>
        AZ: us-east-1b
        CIDR Block: 10.2.4.0/24   <ed>      

    # Subnet 5:
        VPC: vpc-0849df4dc5f5c84d0
        Name: priv-acs-final-2 <ed>
        AZ: us-east-1c
        CIDR Block: 10.2.5.0/24  <ed>

    # Subnet 6:
        VPC: vpc-0849df4dc5f5c84d0
        Name: priv-acs-final-3 <ed>
        AZ: us-east-1d
        CIDR Block: 10.2.6.0/24  <ed>

# Step 3: Internet Gateway creation:
    Name: acs-final-igw 
    VPC associated with: vpc-0849df4dc5f5c84d0 # Then attach it to VPC.

# Step 3.5: NAT Gateway setup.
    Name: acs-final-nat 
    Subnet: acs-final-1
    Type of Nat Gateway Connectivity: Public

# For a public Nat Gateway, you have to create an elastic IP. This might become another step. GUI did it automatically while allocating.


# Step 4: Route table creation:
    # Public route table:
        Name: acs-final-rtb-public <ed>
        Associated subnets with this route table: acs-final-1, acs-final-2, acs-final-3.
        Add internet gateway as one of the route.

    # Private route table creation:
        Name: acs-final-rtb-private <ed>
        Associate subnets with this route table: priv-acs-final-1, priv-acs-final-2, priv-acs-final-3
        Add Nat gateway as one of the route.


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
    Inbound 1: SSH from 10.2.0.0/16 -> Project VPC's CIDR block.
    Inbound 2: HTTP from 0.0.0.0 -> Project VPC's CIDR block.

# Step 8: Original ec2 setup for ASG and load balancing:
    Name: acs-final-default
    AMI: Amazon Linux (ami-051f8a213df8bc089)
    Instance type: t2.micro  <ed>
    Key Pair login: Vockey
    VPC: vpc-0849df4dc5f5c84d0 (created one: try-acs-final)
    Subnet: priv-acs-final-1
    Security Group: acs-final-ec2-sg

# Step 9: Login to this ec2 instance and initialize web-server using Bastion host.

# Step 9.5: Delete NAT gateway and elastic IP that were initialized.

# Step 10: Capturing AMI image of the intialized webserver:
    Name: default-webserver-ami
    Description: Image for autoscaling group.


# Step : Create a target group:
    Target type: instances
    Name: ec2-webserver-grp
    VPC: vpc-0849df4dc5f5c84d0 (created one: try-acs-final)
Didn't choose any target instances. The default instance is not considered a target instance.


# Step 11: Create a load balancer:
    Name: acs-final-lb
    VPC: vpc-0849df4dc5f5c84d0 (created one: try-acs-final)
    Mapping: us-east-1b, us-east-1c and us-east-1d (Subnets: acs-final-1, acs-final-2 and acs-final-3)
    Security Group: acs-final-ec2-sg (Created above for all the web ec2 instances.)
    Listener (where to forward the traffic): Protocol HTTP, Port 80, Target: ec2-webserver-grp

# Step 12: Create a launch template:
    Name: acs-final-ec2-config-temp
    AMI: default-webserver-ami (created above)
    Instance type: t2.micro (Changes based on env)
    Key pair name: vockey
    Security Group: acs-final-ec2-sg (Created above)
    Enabled Detailed Cloudwatch monitoring


# Step 13: Create Auto Scaling Group:
    Name: acs-final-asg
    VPC: vpc-0849df4dc5f5c84d0 (created one: try-acs-final)
    Availability Zones and Subnets: us-east-1b, us-east-1c and us-east-1d (Subnets: priv-acs-final-1, priv-acs-final-2 and priv-acs-final-3)
    I attached it straightaway to the existing load balancer.
    I enabled group metric collection using cloud9.

    # Auto Scaling Group Policy (Depends on the env variable value):
    Desired Capacity: 1 <ed>
    Min: 1  <ed>
    Max: 6  <ed>
    
    # Automatic Scaling:
    Type: Target Tracking Scaling Policy
    Name: ACS Final Scaling Policy
    Metric: CPU Utilization
    Target Value: 60 <ed>

    Tag for the new instant:
    Name - ec2-asg-created
    Rest were default.
