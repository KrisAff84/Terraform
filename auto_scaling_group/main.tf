
#########################################
# Data 
#########################################

data "aws_vpc" "default" {
  default = true
}
data "aws_availability_zones" "available" {
  state = "available"
}

##########################################
# Key Pair
##########################################

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.key.private_key_pem
  filename = "${var.key_name}.pem"
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

###########################################
# Launch Template
###########################################

resource "aws_launch_template" "asg_web_lt" {
  name          = "asg_web_lt"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.asg_web_access_sg.id,
    aws_security_group.asg_ssh_access_sg.id
  ]
  # iam_instance_profile {
  #   name = "test"
  # }
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
EOF
  )
}

###########################################
# Autoscaling Group
###########################################

resource "aws_autoscaling_group" "web_asg" {
  name = "web_asg"
  launch_template {
    id      = aws_launch_template.asg_web_lt.id
    version = "$Latest"
  }
  max_size          = 5
  min_size          = 2
  health_check_type = "ELB"
  desired_capacity  = 2
  availability_zones = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]
}


##################################################
# Launch Template Security Groups
##################################################


################## Web Access ####################

resource "aws_security_group" "asg_web_access_sg" {
  name        = "web_server_inbound"
  description = "Allow HTTP(S) access"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description      = "Allow HTTP from the Internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Allow HTTPS from the Internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

################## SSH Access ####################

resource "aws_security_group" "asg_ssh_access_sg" {
  name        = "SSH"
  description = "Allow SSH access from MyIP"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "Allow SSH from  MyIP"
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

#############################################
# Instance Profile - Allows Instances 
# Read/Write Access to S3 Bucket
#############################################

resource "aws_iam_role_policy" "policy" {
  name = "asg_read_write_bucket"
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
          format("%s%s%s", "arn:aws:s3:::", var.bucket_prefix, random_string.bucket_suffix.result),
          format("%s%s%s%s", "arn:aws:s3:::", var.bucket_prefix, random_string.bucket_suffix.result, "/*")
        ]
      }
    ]
  })
  role = aws_iam_role.asg_bucket_role.name
}

resource "aws_iam_role" "asg_bucket_role" {
  name = "asg_bucket_role"
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

resource "aws_iam_instance_profile" "asg_bucket_profile" {
  name = "asg_bucket_profile"
  role = aws_iam_role.asg_bucket_role.name
}

########################################
# S3 Bucket
########################################

resource "aws_s3_bucket" "asg_bucket" {
  bucket        = format("%s%s", var.bucket_prefix, random_string.bucket_suffix.result)
  force_destroy = true
}

########################################
# Random Bucket Name Suffix Generator
########################################

resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  special = false
}
