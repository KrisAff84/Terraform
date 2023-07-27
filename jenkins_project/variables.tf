variable "my_ip" {
  type      = string
  default   = " "
  sensitive = true
}

variable "ami" {
  type    = string
  default = "ami-08541bb85074a743a"
}

variable "bucket_name" {
  type    = string
  default = "jenkins-artifacts-0726"
}