#!/bin/bash

sudo yum update -y
sudo yum install httpd

# systemctl controls.
systemctl start httpd
systemctl enable httpd

# Copy the source file to the HTTPD index source.
cp ./index.html /var/www/html/