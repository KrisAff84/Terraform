module "jenkins_server" {
  source = "./modules/jenkins_server"

  aws_region    = "us-west-2"
  ami           = "ami-08541bb85074a743a"
  key_name      = "kriskey"
  name_prefix   = "module_test"
  ssh_my_ip     = "24.162.52.74/32"
  web_access_ip = "24.162.52.74/32"
}

output "server_public_ip" {
  value = module.jenkins_server.public_ip
}
output "subnet_id" {
  value = module.jenkins_server.subnet_id
}
output "availability_zone" {
  value = module.jenkins_server.az
}