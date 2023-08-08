variable "aws-region" {
  type    = string
  default = "us-west-2"
}
variable "ami" {
  type    = string
  default = "ami-051349fa6761577cc"
}
variable "instance" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}
variable "vpc_id" {
  type    = string
  default = "vpc-0b5e4f154b9d81d02"
}
variable "my_ip" {
  type    = string
  default = "24.162.52.74/32"
}
variable "bucket_name" {
  type    = string
  default = "my-example-bucket-0727"
}