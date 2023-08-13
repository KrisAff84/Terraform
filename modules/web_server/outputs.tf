################################
# Web Server(s)
################################

output "instance_id" {
  description = "The ID of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id}"
  ]
}
output "ami" {
  description = "The AMI used to launch the EC2 instance(s)"
  value       = toset([for instance in aws_instance.web : instance.ami])
}
output "instance_arns" {
  description = "The ARN of the EC2 instance(s)"
  value       = [
    for instance in aws_instance.web : "${instance.id} : ${instance.arn}"
  ]
}
output "azs" {
  description = "The availability zones of the EC2 instance(s)"
  value       = [
    for instance in aws_instance.web : "${instance.id} : ${instance.availability_zone}"
  ]
}
output "instance_state" {
  description = "The state of the EC2 instance(s)"
  value       = [
    for instance in aws_instance.web : "${instance.id} : ${instance.instance_state}"
  ]
}
output "instance_type" {
  description = "The type of the EC2 instance(s)"
  value       = toset([for instance in aws_instance.web : instance.instance_type])
}
output "key_name" {
  description = "The key name of the EC2 instance(s)"
  value       = toset([for instance in aws_instance.web : instance.key_name])
}
output "private_ip" {
  description = "The private IP address of the EC2 instance(s)"
  value       = [
    for instance in aws_instance.web : "${instance.id} : ${instance.private_ip}"
  ]
}
output "public_ip" {
  description = "The public IP address of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.public_ip}"
  ]
}
output "public_dns" {
  description = "The public DNS name of the EC2 instance(s)"
  value       = [
    for instance in aws_instance.web : "${instance.id} : ${instance.public_dns}"
  ]
}

output "security_groups" {
  description = "The security groups associated with the EC2 instance(s)"
  value = toset([for instance in aws_instance.web : instance.vpc_security_group_ids])
}
output "subnet_id" {
  description = "The subnet ID of the EC2 instance(s)"
  value       = [
    for instance in aws_instance.web : "${instance.id} : ${instance.subnet_id}"
  ]
}

################################
# Load Balancer
################################

output "lb_arn" {
  description = "The ARN of the load balancer"
  value       = local.load_balancer > 0 ? aws_lb.web[0].arn : null
}
output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = local.load_balancer > 0 ? aws_lb.web[0].dns_name : null
}

