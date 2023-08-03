variable "aws_region" {
  type = string
}
variable "ami" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key_name" {
  type = string
}
variable "name_prefix" {
  description = "Prefix in which to name resources"
  type        = string
}
variable "ssh_my_ip" {
  description = "IP CIDR from which you wish to access Jenkins server via SSH"
  type        = string
}
variable "web_access_ip" {
  description = "IP CIDR from which you wish to access Jenkins server via browser"
  type        = string
}
variable "instance_profile" {
  description = "If using the S3 module with this module you must call the S3 module"
  type        = string
  default     = null
}