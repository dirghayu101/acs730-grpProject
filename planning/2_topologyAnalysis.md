The following are the components of the topology provided (note worthy):
1. NAT gateway.
2. ASG
3. Application Load Balancer.
4. Bastion Host (I have no clue why it is even there)
5. S3 bucket 
6. 3 Availability zones.

Other mentions in the project specification document (note worthy):
1. ASG with a minimum of 1 and a maximum of 4.
2. Scaling policy: scale out if load is greater than 10% and scale in if load is less than 5%. Last project I wasn't able to implement scale in properly.
3. This is going to be very interesting challenge. Since, you are going to write terraform code for this you have to setup multiple environment. Production, staging and development. You have to write your terraform code as such that it deploys new topology for different environment using terraform.
Changes that you have to make according to the environment:
Development:        10.100.0.0/16           2 instance (min in ASG)          t3.micro 
Staging:            10.200.0.0/16           3 instance (min in ASG)          t3.small
Production:         10.250.0.0/16           3 instance (min in ASG)          t3.medium
5. All subnets regardless of environment should have CIDR block with 256 IP addresses.
6. The name of different environment should have mention of the environment. For example something like: grp-1-prod-vpc, grp-1-dev-vpc or grp-1-stag-vpc. Same goes for other resources.
7. Github action should verify every commit you are going to make.
8. One of the requirement is modularity of code, DRY and consistent naming and tagging strategy.
9. Git commits will be used to evaluate the contribution of group members.
10. Each environment should have its own S3 bucket.
11. Make modules for networking, ALB, Launch Templates, SG and ASG.
12. The S3 bucket cannot be public.
13. For github action, recommended tools are trivy and tflint.
14. The deployed web server should load an image from the S3 bucket.
15. The solution should use remote terraform state.