##########################################
# Global
##########################################

output "region" {
  value = var.region
}
output "name_prefix" {
  value = var.name_prefix
}
output "vpc_id" {
  value = data.aws_vpc.default.id
}
output "vpc_cidr" {
  value = data.aws_vpc.default.cidr_block
}
output "vpc_cidr_ipv6" {
  value = data.aws_vpc.default.ipv6_cidr_block
}

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
  value = aws_autoscaling_group.apache_asg.arn
}
output "asg_azs" {
  value = aws_autoscaling_group.apache_asg.availability_zones
}
output "desired_capacity" {
  value = aws_autoscaling_group.apache_asg.desired_capacity
}
output "asg_health_check_grace_period" {
  value = aws_autoscaling_group.apache_asg.health_check_grace_period
}
output "asg_health_check_type" {
  value = aws_autoscaling_group.apache_asg.health_check_type
}
output "asg_name" {
  value = aws_autoscaling_group.apache_asg.id
}
output "asg_launch_temp_name" {
  value = aws_autoscaling_group.apache_asg.launch_template[0].name
}
output "asg_launch_temp_id" {
  value = aws_autoscaling_group.apache_asg.launch_template[0].id
}
output "asg_load_balancers" {
  value = aws_autoscaling_group.apache_asg.load_balancers
}
output "max_size" {
  value = aws_autoscaling_group.apache_asg.max_size
}
output "min_size" {
  value = aws_autoscaling_group.apache_asg.min_size
}
output "predicted_capacity" {
  value = aws_autoscaling_group.apache_asg.predicted_capacity
}
output "asg_tag" {
  value = aws_autoscaling_group.apache_asg.tag
}
output "asg_tg_arns" {
  value = aws_autoscaling_group.apache_asg.target_group_arns
}

##########################################
# Load Balancer
##########################################

output "lb_arn" {
  value = aws_lb.asg_lb.arn
}
output "lb_name" {
  value = aws_lb.asg_lb.name
}
output "lb_dns_name" {
  value = aws_lb.asg_lb.dns_name
}
output "lb_zone_id" {
  value = aws_lb.asg_lb.zone_id
}
output "lb_sg_id" {
  value = aws_lb.asg_lb.security_groups
}
output "lb_subnets" {
  value = aws_lb.asg_lb.subnets
}
output "lb_tg_arns" {
  value = aws_lb_target_group.asg_lb_tg.arn
}
output "lb_tg_name" {
  value = aws_lb_target_group.asg_lb_tg.name
}
output "lb_tg_port" {
  value = aws_lb_target_group.asg_lb_tg.port
}
output "lb_tg_protocol" {
  value = aws_lb_target_group.asg_lb_tg.protocol
}
output "lb_listener_arn" {
  value = aws_lb_listener.asg_lb_listener.arn
}
