############################
# Basic numberical functions
############################

variable "num_1" {
  type = number
  default = 10
}

variable "num_2" {
  type = number
  default = 27
}

variable "num_3" {
  type = number
  default = 16
}

locals {
  maximum = max(var.num_1, var.num_2, var.num_3)
  minimum = min(var.num_1, var.num_2, var.num_3, 89, 12)
}

output "max_value" {
  value = local.maximum
}

output "min_value" {
  value = local.minimum
}

#######################################################
# Example of using string functions to standardize tags
#######################################################

locals {
  common_tags = {
    Name = lower(local.server_name)
    Owner = lower(local.team)
    App = lower(local.app)
    CreatedBy = lower(local.created_by)
  }
}

########################
# cidrsubnet function
########################

# cidrsubnet(prefix, newbits, netnum)
# prefix = cidr block
# newbits = number of bits to allocate to subnet (the number after the slash in the cidr block)
# netnum = subnet number to allocate (the third decimal place in the cidr block)

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

locals {
  public_subnet_cidrs = cidrsubnet(var.vpc_cidr, 8, [1, 2, 3, 4])
  private_subnet_cidrs = cidrsubnet(var.vpc_cidr, 8, [101, 102, 103, 104])
}