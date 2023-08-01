resource "aws_s3_bucket" "asg_bucket" {
  bucket        = format("%s%s", var.bucket_prefix, random_string.bucket_suffix.result)
  force_destroy = true
}
