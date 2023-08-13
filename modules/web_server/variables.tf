################################
# Global
################################

variable "region" {
  type = string
}

################################
# Web Server(s)
################################

### Place note in README about needing to keep key name consistent
variable "public_subnet_ids" {
  description = "List of public subnet IDs to deploy instances to"
  type        = map(string)
  default = {
    "" = ""
  }
}
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
  description = "Path to the user data file"
  type        = string
  default     = ""
}

#######################################
# Security Groups
#######################################

variable "vpc_id" {
  type    = string
  default = ""
}
variable "from_port_1" {
  description = "From port of first ingress rule"
  type        = number
  default     = 80
}
variable "to_port_1" {
  description = "To port of first ingress rule"
  type        = number
  default     = 80
}
variable "protocol_1" {
  description = "Protocol of first ingress rule"
  type        = string
  default     = "tcp"
}
variable "cidr_block_1" {
  description = "CIDR block of first ingress rule"
  type        = string
  default     = "0.0.0.0/0"
}
variable "from_port_2" {
  description = "From port of second ingress rule"
  type        = number
  default     = 443
}
variable "to_port_2" {
  description = "To port of second ingress rule"
  type        = number
  default     = 443
}
variable "protocol_2" {
  description = "Protocol of second ingress rule"
  type        = string
  default     = "tcp"
}
variable "cidr_block_2" {
  description = "CIDR block of second ingress rule"
  default     = "0.0.0.0/0"
}
variable "from_ssh_port" {
  description = "From port of SSH ingress rule"
  type        = number
  default     = 22
}
variable "to_ssh_port" {
  description = "To port of SSH ingress rule"
  type        = number
  default     = 22
}
variable "ssh_protocol" {
  description = "Protocol of SSH ingress rule"
  type        = string
  default     = "tcp"
}
variable "my_ip" {
  description = "IP address to allow SSH access"
  type        = string
}
