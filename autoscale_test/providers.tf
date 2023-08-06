terraform {
  required_version = "~> 1.5.3"
  backend "s3" {
    bucket = "terraform-state-0805232"
    key    = "apache_autoscaling_infrastructure/terraform.tfstate"
    region = "us-west-2"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}