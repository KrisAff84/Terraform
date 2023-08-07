##########################################
# S3 Bucket
##########################################

output "bucket_name" {
  value = aws_s3_bucket.asg_bucket.id
}
output "bucket_arn" {
  value = aws_s3_bucket.asg_bucket.arn
}
