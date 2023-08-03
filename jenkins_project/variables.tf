variable "ami" {
  type    = string
  default = "ami-08541bb85074a743a"
}
variable "bucket_name" {
  type    = string
  default = "jenkins-artifacts-0726"
}
variable "aws_region" {
  type    = string
  default = "us-west-2"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key_pair" {
  type    = string
  default = "jenkins_key"
}
variable "my_ip" {
  type      = string
  default   = " "
  sensitive = true
}