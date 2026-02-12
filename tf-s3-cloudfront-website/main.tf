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

resource "aws_cloudfront_origin_access_control" "s3-wensite-oac" {
  name = "s3-wensite-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_domain_name
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
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
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
