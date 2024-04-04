Project has the following requirements:
1. You have to use git, github and github action. Simulate corporate setup.  <not needed, I will try to implement it alone, grp implementation will come later.>
2. Load balancer should be used. And yeah, terraform should be used to deploy it. <I don't know how to configure a load balancer and for auto scaling.>
3. The written terraform code for the solution should be modular and clean. <Terraform I will write later on. I will try to understand and setup something simpler using load balancer.>
4. There will be three different environment/branches, i.e., dev, staging and prod.
5. The static website should be serving images from an S3 bucket.
6. The application will be deployed in an auto scaling group of ec2 instances with a minimum of 1 and a maximum of 4 instances across 3 availability zones. <This is related to load balancing and auto scaling again.>
7. The application should have a scaling policy to scale out if the load is above 10% of the CPU capacity and scale in if the load is below 5% of the CPU. <Related to scaling again.>
8. table showing different configurations in different terraform environment: <This comes later>

Environment         CIDR         Number of Instances     Instance Type
   Dev          10.100.0.0/16           2                   t3.micro
 Staging        10.200.0.0/16           3                   t3.small
  Prod          10.250.0.0/16           3                   t3.medium

9. Only differences between these three environment (dev, stage & prod) should be:
    1> Different starting range of VPC's private subnet.
    2> The minimum number of instances in auto scaling group.
    3> Instance type.
    4> VPC name and other naming convention should have name altered to reflect the environment's name wherever possible. Example: grp1-dev-vpc and simultaneously grp1-prod-vpc and grp1-stage-vpc.

10. All subnets in the topology should have just 256 IP addresses.
11. Each environment should have their own S3 bucket which should store terraform state and images.
12. The webpage should reflect name of team members.
13. The naming should be done in Camel case.
14. Use trivy or tflint to perform security scans on push and pull requests.
15. Terraform code requirements:
    > Should have different modules for networking, ALB, SG, etc. Modules for Launch Configuration, Target Group, ALB, SG, EC2s and networking
    > Solution should use remote terraform state.
    > Image of web-server should be fetched from the respective s3 bucket.
    > S3 bucket cannot be public.
    > There should be different environments.
    



# Recommended Implementation Flow 
1. Setup your GitHub repo to enable collaboration. 
2. Define branching strategy and git flow 
3. Agree on naming and tagging approach, document it for the report 
4. Manually create ALB with ASG via AWS Console, make sure you understand the way it works.
5. Setup GitHub actions with security scans to start scanning early in the development process.
6. Start writing Terraform code: 
    a. Create relevant S3 buckets for your environments 
    b. Implement networking module 
    c. Implement ALB 
    d. Implement Launch configuration 
    e. Implement Listener  
    f. Implement scaling policies 
7. Deploy multiple environments, verify the website is loading successfully in all of them.