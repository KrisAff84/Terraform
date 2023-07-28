# Deploys a 
provider "aws" {
  region = var.aws_region
}
data "aws_availability_zones" "azs" {}
data "aws_vpc" "default" {
  default = true
}

# EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_server_sg.id]
  key_name               = var.key_pair
  tags = {
    Name = "Jenkins_Server"
  }
  user_data            = <<EOF
#!/bin/bash
yum update -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
dnf install java-11-amazon-corretto -y
yum install jenkins -y
systemctl enable jenkins
systemctl start jenkins
EOF
  iam_instance_profile = aws_iam_instance_profile.ec2_bucket_profile.name
}

resource "aws_security_group" "jenkins_server_sg" {
  name        = "web_server_inbound"
  description = "Allow SSH from MyIP and access to port 8080"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "Allow 8080 from the Internet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_s3_bucket" "jenkins_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}
resource "aws_s3_bucket_ownership_controls" "jenkins_bucket_acl" {
  bucket = aws_s3_bucket.jenkins_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_iam_role_policy" "policy" {
  name = "ec2_jenkins_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PerformBucketActions",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
        ],
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"

        ]
      }
    ]
  })
  role = aws_iam_role.ec2_bucket_role.name
}

resource "aws_iam_role" "ec2_bucket_role" {
  name = "ec2_bucket_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_bucket_profile" {
  name = "ec2_bucket_profile"
  role = aws_iam_role.ec2_bucket_role.name
}
