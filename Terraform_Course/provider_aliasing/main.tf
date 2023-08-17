provider "aws" {
  region = "us-east-1"
  alias  = "east"
}
provider "aws" {
  region = "us-west-2"
  alias  = "west"
}

# To reference the provider alias, use the following syntax:

resource "aws_vp" {
  provider   = aws.east
  cidr_block = "10.100.10.0/16"
}
resource "aws_vpc" {
  provider   = aws.west
  cidr_block = "10.200.10.0/16"
}