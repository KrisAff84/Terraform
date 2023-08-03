##########################################
# Launch Template
##########################################

output "launch_temp_name" {
  value = aws_launch_template.apache_lt.name
}
output "launch_temp_id" {
  value = aws_launch_template.apache_lt.id
}
output "launch_temp_description" {
  value = aws_launch_template.apache_lt.description
}
output "launch_temp_instance_prof" {
  value = aws_launch_template.apache_lt.iam_instance_profile
}
output "launch_temp_ami" {
  value = aws_launch_template.apache_lt.image_id
}
output "launch_temp_instance_type" {
  value = aws_launch_template.apache_lt.instance_type
}
output "launch_temp_key_name" {
  value = aws_launch_template.apache_lt.key_name
}
output "launch_temp_sgs" {
  value = aws_launch_template.apache_lt.security_group_names
}
output "launch_temp_tags" {
  value = aws_launch_template.apache_lt.tags
}
output "launch_temp_user_data" {
  value = aws_launch_template.apache_lt.user_data
}

##########################################
# Autoscaling Group
##########################################

output "asg_arn" {
  value = aws_launch_template.apache_asg.arn
}
output "asg_azs" {
  value = aws_launch_template.apache_asg.availability_zones
}
output "desired_capacity" {
  value = aws_launch_template.apache_asg.desired_capacity
}
output "asg_health_check_grace_period" {
  value = aws_launch_template.apache_asg.health_check_grace_period
}
output "asg_health_check_type" {
  value = aws_launch_template.apache_asg.health_check_type
}
output "asg_name" {
  value = aws_launch_template.apache_asg.id
}
output "asg_launch_temp_name" {
  value = aws_launch_template.apache_asg.launch_template.name
}
output "asg_launch_temp_id" {
  value = aws_launch_template.apache_asg.launch_template.id
}
output "load_balancers" {
  value = aws_launch_template.apache_asg.launch_template.load_balancers
}
output "max_size" {
  value = aws_launch_template.apache_asg.max_size
}
output "min_size" {
  value = aws_launch_template.apache_asg.min_size
}
output "min_size" {
  value = aws_launch_template.apache_asg.min_size
}
output "predicted_capacity" {
  value = aws_launch_template.apache_asg.predicted_capacity
}
output "asg_tag" {
  value = ["${aws_launch_template.apache_asg.tag.key} = ${aws_launch_template.apache_asg.tag.value}"]
}
output "asg_tg_arns" {
  value = aws_launch_template.apache_asg.tag.target_group_arns
}
output "asg_vpc" {
  value = aws_launch_template.apache_asg.tag.vpc_zone_identifier
}