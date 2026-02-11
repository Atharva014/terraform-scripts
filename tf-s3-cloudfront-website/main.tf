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