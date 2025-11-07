resource "aws_s3_bucket" "s3_bucket_label" {
  bucket = var.bucket_name
  tags = {
    Env = var.bucket_env_tag
  }
}

resource "aws_s3_bucket_website_configuration" "s3_web_host_label" {
  depends_on = [ aws_s3_bucket.s3_bucket_label ]
  bucket = aws_s3_bucket.s3_bucket_label.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_ublic_access_block_label" {
  depends_on = [ aws_s3_bucket.s3_bucket_label ]
  bucket = aws_s3_bucket.s3_bucket_label.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_label" {
  bucket = aws_s3_bucket.s3_bucket_label.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl_label" {

  depends_on = [ aws_s3_bucket_ownership_controls.s3_bucket_ownership_label ]

  bucket = aws_s3_bucket.s3_bucket_label.id
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "s3_policy_get_objects" {
  bucket = aws_s3_bucket.s3_bucket_label.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "Statement1",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
            "s3:GetObject"
        ],
        "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
  } 
  EOF
}