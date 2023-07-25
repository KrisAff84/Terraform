provider "aws" {
  region = "us-west-2"
}

data "aws_availability_zones" "azs" {}

# EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_server_sg.id]
  key_name = "kriskey"
  tags = {
    "Name"     = "Jenkins_Server"
  }
  user_data = <<EOF
#!/bin/bash
yum update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf install java-11-amazon-corretto -y
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins
EOF
}

resource "aws_security_group" "jenkins_server_sg" {
  name        = "web_server_inbound"
  description = "Allow SSH from MyIP and access to port 8080"
  vpc_id      = "vpc-0b5e4f154b9d81d02"
  ingress {
    description = "Allow 8080 from the Internet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  tags = {
    Name    = "web_server_inbound"
    Purpose = "Intro to Resource Blocks Lab"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
