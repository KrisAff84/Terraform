#!/bin/bash
apt update
apt install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>This EC2 instance was deployed with Terraform!</h1>" >> /var/www/html/index.html
