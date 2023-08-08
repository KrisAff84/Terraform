terraform {
  backend "s3" {
    bucket = "terraform-state-080723"
    key    = "apache-autoscaling-infra/terraform.tfstate"
    region = "us-west-2"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}