resource "aws_s3_bucket" "jenkins_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}