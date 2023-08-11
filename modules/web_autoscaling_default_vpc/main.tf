#########################################
# Data 
#########################################

data "aws_vpc" "default" {
  default = true
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
  user_data = file(var.user_data_file)
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
  target_group_arns = [aws_lb_target_group.asg_lb_tg.arn]
}

##################################################
# Launch Template Security Groups
##################################################


################## ALB Access ####################

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
    description      = var.http_rule_description
    from_port        = var.http_from_port
    to_port          = var.http_to_port
    protocol         = "tcp"
    cidr_blocks      = [var.http_cidr]
    ipv6_cidr_blocks = [var.http_cidr_ipv6]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
