# Map type variables

variable "ip_addresses" {
  type = map(string)
  default = {
    "dev"  = "10.0.100.1/24"
    "prod" = "10.0.200.1/24"
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

resource "aws_vpc" "main" {
  cidr_block = var.ip_addresses[var.environment]
}

# To iterate over a map, use the for_each meta-argument.
# The for_each meta-argument expects a map, so you can't use it with a list or set type variable.

resource "aws_vpc" "main" {
  for_each = var.ip_addresses

  cidr_block = each.value
}

# Can also create map of maps 

variable "env" {
  type = map(string)
  default = {
    "dev" = {
      ip = "10.0.250.0/24"
      az = "us-east-1a"
    }
    "prod" = {
      ip = "10.0.150.0/24"
      az = "us-east-1b"
    }
  }
}

# To refer to map of maps, use the following syntax:

resource "aws_subnet" "list_subnet" {
  for_each          = var.env
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.ip
  availability_zone = each.value.az
}

# Or to refer to a specific map of maps, use the following syntax:

resource "aws_subnet" "list_subnet" {
  for_each          = var.env["dev"]
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.ip
  availability_zone = each.value.az
}