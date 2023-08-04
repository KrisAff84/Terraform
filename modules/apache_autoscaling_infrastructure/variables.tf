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
# Autoscaling Security Groups
################################

########## HTTP Access #########

variable "sg_description" {
  type    = string
  default = "Allow HTTP(S) access"
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

######### HTTPS Access #########

variable "https_rule_description" {
  type    = string
  default = "Allow HTTPS from the Internet"
}
variable "https_from_port" {
  type    = number
  default = 443
}
variable "https_to_port" {
  type    = number
  default = 443
}
variable "https_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "https_cidr_ipv6" {
  type    = string
  default = "::/0"
}

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
  description = "IP address to SSH from"
  type        = string
}
