variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us.west.1"
}
resource "random_string" "random" {
  length = 6
  upper  = false
}
variable "bucket" {
  description = "Name of S3 bucket"
  type        = string
  default     = "ASG_project_bucket${random_string.random}"
}
variable "ami" {
  description = "AMI for EC2 launch template"
  type        = string
  default     = "ami-0c38b9e37c107d921"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

