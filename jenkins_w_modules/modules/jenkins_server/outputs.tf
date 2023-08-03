#####################################
# EC2 Instance - Jenkins Server
#####################################

output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
output "private_ip" {
  value = aws_instance.jenkins_server.private_ip
}
output "tags" {
  value = aws_instance.jenkins_server.tags
}
output "ami" {
  value = aws_instance.jenkins_server.ami
}
output "arn" {
  value = aws_instance.jenkins_server.arn
}
output "az" {
  value = aws_instance.jenkins_server.availability_zone
}
output "instance_profile" {
  value = aws_instance.jenkins_server.iam_instance_profile
}
output "state" {
  value = aws_instance.jenkins_server.instance_state
}
output "instance_type" {
  value = aws_instance.jenkins_server.instance_type
}
output "key_name" {
  value = aws_instance.jenkins_server.key_name
}
output "sgs" {
  value = aws_instance.jenkins_server.security_groups
}
output "subnet_id" {
  value = aws_instance.jenkins_server.subnet_id
}


