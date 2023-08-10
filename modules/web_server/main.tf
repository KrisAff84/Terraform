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

resource "aws_instance" "web" {
  for_each      = var.public_subnets
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.web_access.id,
    aws_security_group.ssh_access.id
  ]
  subnet_id = each.value
  tags = {
    Name = "web"
  }
}

resource "aws_security_group" "web_access" {
  name        = "web_access"
  description = "Allow web traffic"
  vpc_id      = var.vpc_id
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

variable "region" {
  type = string
}
variable "public_subnets" {
  type = map(string)
}
variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "my_ip" {
  type = string
}
variable "from_port_1" {
  type    = number
  default = 80
}
variable "to_port_1" {
  type    = number
  default = 80
}
variable "protocol_1" {
  type    = string
  default = "tcp"
}
variable "cidr_block_1" {
  type    = string
  default = "0.0.0.0/0"
}
variable "from_port_2" {
  type    = number
  default = 443
}
variable "to_port_2" {
  type    = number
  default = 443
}
variable "protocol_2" {
  type    = string
  default = "tcp"
}
variable "cidr_block_2" {
  type    = string
  default = "0.0.0.0/0"
}
variable "from_ssh_port" {
  type    = number
  default = 22
}
variable "to_ssh_port" {
  type    = number
  default = 22
}
variable "ssh_protocol" {
  type    = string
  default = "tcp"
}
