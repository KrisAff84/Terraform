terraform {
  required_version = ">= 1.5.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}
