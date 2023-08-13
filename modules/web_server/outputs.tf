################################
# Web Server(s)
################################

# output "instance_id" {
#   description = "The ID of the EC2 instance(s)"
#   value = aws_instance.web.id
# }
# output "ami" {
#   description = "The AMI used to launch the EC2 instance(s)"
#   value       = aws_instance.web[0].ami
# }
# output "instance_arns" {
#   description = "The ARN of the EC2 instance(s)"
#   value       = [
#     for instance in aws_instance.web : "${instance.id} : ${instance.arn}"
#   ]
# }
# output "azs" {
#   description = "The availability zones of the EC2 instance(s)"
#   value       = [
#     for instance in aws_instance.web : "${instance.id} : ${instance.availability_zone}"
#   ]
# }
# output "instance_state" {
#   description = "The state of the EC2 instance(s)"
#   value       = [
#     for instance in aws_instance.web : "${instance.id} : ${instance.state}"
#   ]
# }
# output "instance_type" {
#   description = "The type of the EC2 instance(s)"
#   value       = aws_instance.web[0].instance_type
# }
# output "key_name" {
#   description = "The key name of the EC2 instance(s)"
#   value       = aws_instance.web[0].key_name
# }
# output "private_ip" {
#   description = "The private IP address of the EC2 instance(s)"
#   value       = [
#     for instance in aws_instance.web : "${instance.id} : ${instance.private_ip}"
#   ]
# }
output "public_ip" {
  description = "The public IP address of the EC2 instance(s)"
  value = [
    for instance in aws_instance.web : "${instance.id} : ${instance.public_ip}"
  ]
}
# output "public_dns" {
#   description = "The public DNS name of the EC2 instance(s)"
#   value       = [
#     for instance in aws_instance.web : "${instance.id} : ${instance.public_dns}"
#   ]
# }
# # DO I NEED TO INCLUDE AN OPTION FOR USING security_groups INSTEAD OF vpc_security_group_ids?
# output "security_groups" {
#   description = "The security groups associated with the EC2 instance(s)"
#   value = aws_instance.web.vpc_security_groups
# }
# output "subnet_id" {
#   description = "The subnet ID of the EC2 instance(s)"
#   value       = aws_instance.web[each.key].subnet_id
# }



