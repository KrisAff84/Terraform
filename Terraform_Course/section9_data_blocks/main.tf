# Data blocks query or fetch data

data "aws_s3_bucket" "data_bucket" {
  bucket = "data-bucket-080923"
}

# To reference the data block, use the following syntax:

resource "aws_iam_policy" "data_bucket" {
  name        = "data_bucket_policy"
  description = "Allow access to data bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${data.aws_s3_bucket.data_bucket.arn}"
      }
    ]
  })
}