#########################################
# Data 
#########################################

data "aws_vpc" "default" {
  default = true
}
data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

###########################################
# Launch Template
###########################################

resource "aws_launch_template" "apache_lt" {
  name          = "${var.name_prefix}_lt"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.asg_lb_access.id,
    aws_security_group.asg_ssh_access_sg.id
  ]
  iam_instance_profile {
    name = aws_iam_instance_profile.asg_bucket_profile.name
  }
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

resource "aws_autoscaling_group" "apache_asg" {
  name = "${var.name_prefix}_asg"
  launch_template {
    id      = aws_launch_template.apache_lt.id
    version = "$Latest"
  }
  max_size          = var.max_size
  min_size          = var.min_size
  health_check_type = "ELB"
  desired_capacity  = var.desired_capacity
  vpc_zone_identifier = [
    data.aws_subnets.default.ids[0],
    data.aws_subnets.default.ids[1]
  ]
  # target_group_arns = [aws_lb_target_group.asg_lb_tg.arn]
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.apache_asg.name
  lb_target_group_arn   = aws_lb_target_group.asg_lb_tg.arn
}


##################################################
# Launch Template Security Groups
##################################################


################## Web Access ####################

resource "aws_security_group" "asg_lb_access" {
  name        = "${var.name_prefix}_asg_web_access"
  description = "Allow web access through load balancer"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description     = var.http_rule_description
    from_port       = var.http_from_port
    to_port         = var.http_to_port
    protocol        = "tcp"
    security_groups = [aws_security_group.asg_lb_sg.id]
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
  name        = "${var.name_prefix}_asg_ssh_access"
  description = var.ssh_sg_description
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = var.ssh_sg_description
    from_port   = var.ssh_from_port
    to_port     = var.ssh_to_port
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
#             Read/Write Access to S3 Bucket
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
          join("", ["arn:aws:s3:::", var.name_prefix, "-asg-bucket-", random_string.bucket_suffix.result]),
          join("", ["arn:aws:s3:::", var.name_prefix, "-asg-bucket-", random_string.bucket_suffix.result, "/*"])
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
  name = "${var.name_prefix}_asg_bucket_profile"
  role = aws_iam_role.asg_bucket_role.name
}

#############################################
# Application Load Balancer
#############################################

resource "aws_lb" "asg_lb" {
  name               = "${var.name_prefix}-asg-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.asg_lb_sg.id]
  subnets = [
    data.aws_subnets.default.ids[0],
    data.aws_subnets.default.ids[1]
  ]
}

############### Listener #####################

resource "aws_lb_listener" "asg_lb_listener" {
  load_balancer_arn = aws_lb.asg_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_lb_tg.arn
  }
}

############### Target Group #####################

resource "aws_lb_target_group" "asg_lb_tg" {
  name     = "${var.name_prefix}-asg-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

#############################################
# Load Balancer Security Group
#############################################

resource "aws_security_group" "asg_lb_sg" {
  name        = "${var.name_prefix}_asg_lb_sg"
  description = var.lb_sg_description
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = var.http_rule_description
    from_port   = var.http_from_port
    to_port     = var.http_to_port
    protocol    = "tcp"
    cidr_blocks = [var.http_cidr]
    ipv6_cidr_blocks = [var.http_cidr_ipv6]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


########################################
# S3 Bucket
########################################

resource "aws_s3_bucket" "asg_bucket" {
  bucket        = join("-", [var.name_prefix, "asg-bucket", random_string.bucket_suffix.result])
  force_destroy = var.force_destroy_s3
}

########################################
# Random Bucket Name Suffix Generator
########################################

resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  special = false
}
