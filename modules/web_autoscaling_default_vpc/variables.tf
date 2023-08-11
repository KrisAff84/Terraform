################################
# Global
################################

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "asg_module"
}
variable "region" {
  type = string
}

################################
# Launch Template
################################

variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "user_data_file" {
  type = string
  default = "apache_rpm.sh"
}

################################
# Autoscaling Group
################################

variable "max_size" {
  type = number
}
variable "min_size" {
  type = number
}
variable "desired_capacity" {
  type = number
}

################################
# Load Balancer Security Groups
################################

########## HTTP Access #########

variable "lb_sg_description" {
  type    = string
  default = "Allow HTTP access"
}
variable "http_rule_description" {
  type    = string
  default = "Allow HTTP from the Internet"
}
variable "http_from_port" {
  type    = number
  default = 80
}
variable "http_to_port" {
  type    = number
  default = 80
}
variable "http_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "http_cidr_ipv6" {
  type    = string
  default = "::/0"
}

################################
# Autoscaling Security Groups
################################

########## SSH Access ##########

variable "ssh_sg_description" {
  type    = string
  default = "Allow SSH access from MyIP"
}
variable "ssh_from_port" {
  type    = number
  default = 22
}
variable "ssh_to_port" {
  type    = number
  default = 22
}
variable "my_ip" {
  description = "IP CIDR to SSH from"
  type        = string
}
