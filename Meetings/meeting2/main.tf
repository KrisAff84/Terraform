terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws-region
}

resource "aws_instance" "MyWeb" {
  ami             = var.ami
  instance_type   = var.instance
  count           = "1"
  key_name        = "kriskey"
  security_groups = [
    aws_security_group.ssh_access.name,
    aws_security_group.web_access.name
    ]
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access_sg"
  description = "Allow SSH from MyIP"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "web_access" {
  name        = "web_access_sg"
  description = "Allow HTTP from internet"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
} 