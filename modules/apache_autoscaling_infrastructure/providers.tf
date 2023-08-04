terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      version = "~> 5.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
}
provider "aws" {
  region = var.region
}