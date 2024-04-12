This will be the presentation flow of the video recording:

This is group 17.

Members:
1. Dirghayu Joshi I am the presenter.
2. Rujal Maharjan
3. Malika
4. Parinaya
5. Mahesh

git and github action -> just show public repo.
1. Code walkthrough:
    -> traffic flow diagram explanation.
    -> S3 bucket.
    -> Terraform code structure. Dry run file help. Remote state storing.
    -> Different environment implementation strategy using variable and configuration file.
    -> Fetching images from the s3 bucket.
    -> naming convention in the aws console.
    -> Command line to show that the tf has been just applied.
    -> Load Balancer DNS.

Environment         CIDR         Number of Instances     Instance Type
   Dev          10.100.0.0/16           2                   t3.micro
 Staging        10.200.0.0/16           3                   t3.small
  Prod          10.250.0.0/16           3                   t3.medium
