terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "MyWeb" {
  ami             = "ami-051349fa6761577cc"
  instance_type   = "t2.micro"
  count           = "1"
  key_name        = "kriskey"
  security_groups = ["Web"]

  tags = {
    Name = "HelloWorld"
  }
}