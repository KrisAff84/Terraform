module "auto_scaling_group" {
  source           = "../modules/apache_autoscaling_infrastructure"
  name_prefix      = "test"
  region           = "us-west-2"
  ami              = "ami-00970f57473724c10"
  instance_type    = "t2.micro"
  key_name         = "kriskey"
  max_size         = 5
  min_size         = 2
  desired_capacity = 2
  my_ip            = "24.162.52.74/32"
}

output "launch_template_id" {
  value = module.auto_scaling_group.launch_temp_id
}
output "vpc" {
  value = module.auto_scaling_group.vpc_id
}
output "autoscaling_group_arn" {
  value = module.auto_scaling_group.asg_arn
}