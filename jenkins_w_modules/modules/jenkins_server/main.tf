#####################################
# Data - Get Default VPC
#####################################

data "aws_vpc" "default" {
  default = true
}

#####################################
# EC2 Instance - Jenkins Server
#####################################

resource "aws_instance" "jenkins_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_server_sg.id]
  key_name               = var.key_name
  tags = {
    Name = "${var.name_prefix}_server"
  }
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf install java-11-amazon-corretto -y
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins
EOF
  )
  iam_instance_profile = var.instance_profile
  # aws_iam_instance_profile.ec2_bucket_profile.name
}

#####################################
# Instance Security Group
#####################################

resource "aws_security_group" "jenkins_server_sg" {
  name        = "${var.name_prefix}_server_sg"
  description = "Allow SSH and access to port 8080"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "Allow 8080 from web_access_ip"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.web_access_ip]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [var.ssh_my_ip]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}