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
  vpc = module.network.vpc_id
  private_subnet_1 = module.network.private_subnet1_id
  private_subnet_2 = module.network.private_subnet2_id
  public_subnet_1  = module.network.public_subnet1_id
  public_subnet_2  = module.network.public_subnet2_id
}

module "network" {
  source = "../modules/2_tier_network"
  region  = "us-west-2"
  vpc_cidr = "10.0.0.0/16"
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
output "lb_dns_name" {
  value = module.auto_scaling_group.lb_dns_name
}
output "network_vpc" {
  value = module.network.vpc_id
}
