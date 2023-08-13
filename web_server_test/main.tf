module "web_server" {
  source = "../modules/web_server"

  region = "us-west-2"
  # public_subnet_ids = {
  #   "public_subnet_1" = module.network.public_subnet1_id,
  #   "public_subnet_2" = module.network.public_subnet2_id
  # }
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.micro"
  key_name      = "kriskey"
  # user_data_file = "nginx_debian.sh"
  # vpc_id         = module.network.vpc_id
  my_ip = "24.162.52.74/32"
}

# module "network" {
#   source = "../modules/2_tier_network"
# }
# output "instance_type" {
#   value = module.web_server.instance_type
# }
# output "availability_zone" {
#   value = module.web_server.azs
# }
# output "security_groups" {
#   value = module.web_server.security_groups
# }
output "public_ip" {
  value = module.web_server.public_ip
}
# output "instance_id" {
#   value = module.web_server.instance_id
# }