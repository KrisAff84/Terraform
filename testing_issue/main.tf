terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      version = "~> 5.10.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
locals {
  subnet_ids = var.subnet_ids[0] != "" ? var.subnet_ids : [data.aws_subnets.default.ids[0]]
}

variable "subnet_ids" {
  type = list(string)
  default = [
    ""
  ]
}

output "data_subnet_ids" {
  value = data.aws_subnets.default.ids
}
output "local_subnet_ids" {
  value = local.subnet_ids
}
output "subnet_info" {
  value = data.aws_subnets.default
}
