resource "aws_s3_bucket" "jenkins_bucket" {
  bucket        = var.bucket
  force_destroy = true
}