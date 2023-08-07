########################################
# S3 Bucket
########################################

resource "aws_s3_bucket" "asg_bucket" {
  bucket        = join("-", [var.name_prefix, "asg-bucket", random_string.bucket_suffix.result])
  force_destroy = var.force_destroy_s3
}

########################################
# Random Bucket Name Suffix Generator
########################################

resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  special = false
}

#############################################
# Instance Profile - Allows Instances 
#             Read/Write Access to S3 Bucket
#############################################

resource "aws_iam_role_policy" "policy" {
  name = "asg_read_write_bucket"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PerformBucketActions",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
        ],
        "Resource" : [
          join("", ["arn:aws:s3:::", var.name_prefix, "-asg-bucket-", random_string.bucket_suffix.result]),
          join("", ["arn:aws:s3:::", var.name_prefix, "-asg-bucket-", random_string.bucket_suffix.result, "/*"])
        ]
      }
    ]
  })
  role = aws_iam_role.asg_bucket_role.name
}

resource "aws_iam_role" "asg_bucket_role" {
  name = "asg_bucket_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "asg_bucket_profile" {
  name = "${var.name_prefix}_asg_bucket_profile"
  role = aws_iam_role.asg_bucket_role.name
}
