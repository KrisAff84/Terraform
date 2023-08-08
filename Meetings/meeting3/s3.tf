resource "aws_s3_bucket" "example_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
} 