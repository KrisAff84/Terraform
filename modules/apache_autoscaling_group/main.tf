#########################################
# Data 
#########################################

data "aws_vpc" "default" {
  default = true
}
data "aws_availability_zones" "available" {
  state = "available"
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
    aws_security_group.asg_web_access_sg.id,
    aws_security_group.asg_ssh_access_sg.id
  ]
  iam_instance_profile {
    name = var.instance_profile
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
  name        = "${var.name_prefix}_apache_asg_web_access"
  description = var.sg_description
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description      = var.http_rule_description
    from_port        = var.http_from_port
    to_port          = var.http_to_port
    protocol         = "tcp"
    cidr_blocks      = [var.http_cidr]
    ipv6_cidr_blocks = [var.http_cidr_ipv6]
  }
  ingress {
    description      = var.https_rule_description
    from_port        = var.https_from_port
    to_port          = var.https_to_port
    protocol         = "tcp"
    cidr_blocks      = [var.https_cidr]
    ipv6_cidr_blocks = [var.https_cidr_ipv6]
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
  name        = "${var.name_prefix}_apache_asg_ssh_access"
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