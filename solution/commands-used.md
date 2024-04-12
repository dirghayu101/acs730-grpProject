# SSH Connection: ssh -i key.pem ec2-user@<ip>

# AWS command to make objects accessible publicly for set interval: aws s3 presign s3://acs-final-ec2-bucket/demo.png --expires-in 3000

# Command to move files using SSH: 
scp -i <sshKey> <localFilePath> username@dns:<destinationFilePath>

# For Directory :
scp -i <sshKey> -r <localDirectoryPath> username@dns<destinationPath>

# Example:  sudo scp -i "vockey.pem" -r ./received-file ec2-user@10.100.5.35:/home/ec2-user/received_file/


# Check status of a service like httpd or apache: systemctl status httpd



# To check data source value without initializing the entire infrastructure:
alias tf=terraform
tf init
tf refresh
tf show

# Tf to add var value for env variable.
tf apply -var "env=<env>"
tf apply -auto-approve