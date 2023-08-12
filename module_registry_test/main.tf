module "web-autoscaling-default-vpc" {
  source  = "app.terraform.io/Dev_Practice/web-autoscaling-default-vpc/aws"
  version = "1.0.0"

  region           = "us-east-1"
  ami              = "ami-00970f57473724c10"
  instance_type    = "t2.micro"
  key_name         = "kriskey"
  max_size         = 5
  min_size         = 2
  desired_capacity = 2
  my_ip            = "24.162.52.74/32"
}

# NEED TO UPDATE:

# EITHER REQUIRE USER-DATA FILE OR PUT USER DATA IN MAIN.TF
# MAKE DEFAULT NAME PREFIX HAVE HYPHENS INSTEAD OF UNDERSCORES
 