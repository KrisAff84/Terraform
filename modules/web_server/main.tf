#####################################
# Terraform Version and Providers
#####################################

terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      version = "~> 5.10.0"
    }
  }
}
provider "aws" {
  region = var.region
}

#####################################
# Data Sources
#####################################

data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
locals {
  public_subnets = var.public_subnets != {"" = ""} ? var.public_subnets : {public_subnet_1 = data.aws_subnets.public.ids[0]}
  vpc_id         = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id
}


#####################################
# Web Server(s)
#####################################


resource "aws_instance" "web" {
  for_each      = local.public_subnets
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.web_access.id,
    aws_security_group.ssh_access.id
  ]
  user_data = file(var.user_data_file)
  subnet_id = each.value
  tags = {
    Name = "web_server_${each.key}"
  }
  associate_public_ip_address = true
}

#####################################
# Security Groups
#####################################

resource "aws_security_group" "web_access" {
  name        = "web_access"
  description = "Allow web traffic"
  vpc_id      = local.vpc_id
  ingress {
    from_port   = var.from_port_1
    to_port     = var.to_port_1
    protocol    = var.protocol_1
    cidr_blocks = [var.cidr_block_1]
  }
  ingress {
    from_port   = var.from_port_2
    to_port     = var.to_port_2
    protocol    = var.protocol_2
    cidr_blocks = [var.cidr_block_2]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "Allow SSH traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = var.from_ssh_port
    to_port     = var.to_ssh_port
    protocol    = var.ssh_protocol
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

