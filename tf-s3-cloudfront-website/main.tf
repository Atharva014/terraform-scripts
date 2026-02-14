# create bucket
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags = merge( var.common_tags, { "Name" = "ath-website-bucket" } )
}

# enable versionong on bucket
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# add html files inside bucket
resource "aws_s3_object" "index_file" {
  bucket = aws_s3_bucket.this.id
  key = "index.html"
  source = "./website-files/index.html"
  content_type = "text/html"
  etag   = filemd5("./website-files/index.html")
}

resource "aws_s3_object" "error_file" {
  bucket = aws_s3_bucket.this.id
  key = "error.html"
  source = "./website-files/error.html"
  content_type = "text/html"
  etag   = filemd5("./website-files/error.html")
}

# Origin Access Control
resource "aws_cloudfront_origin_access_control" "s3-wensite-oac" {
  name = "s3-wensite-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

# S3 Bucket Policy for OAC
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.this.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
          }
        }
      }
    ]
  })
}

# Cloudfront caching policy
resource "aws_cloudfront_cache_policy" "this" {
  name = "s3-website-policy"
  default_ttl = 86400
  min_ttl = 1
  max_ttl = 31536000
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

# CloudFront Distribution with OAC
resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3-wensite-oac.id
    origin_id = aws_s3_bucket.this.id
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.id
    viewer_protocol_policy = "allow-all"
    cache_policy_id = aws_cloudfront_cache_policy.this.id
  }
  custom_error_response {
    error_code = 404
    response_code = 404
    response_page_path = "/error.html"
    error_caching_min_ttl = 10
  }
  custom_error_response {
    error_code = 403
    response_code = 404
    response_page_path = "/error.html"
    error_caching_min_ttl = 10
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
