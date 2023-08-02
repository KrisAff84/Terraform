variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-west-1"
}
variable "bucket_prefix" {
  description = "Prefix for bucket name"
  type        = string
  default     = "asg-bucket-"
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
variable "key_name" {
  description = "Name for generated key pair"
  type        = string
  default     = "kris_asg_key"
}
variable "my_ip" {
  type    = string
  default = "24.162.52.74/32"
}
