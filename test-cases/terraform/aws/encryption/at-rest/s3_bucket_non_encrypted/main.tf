provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cloudrail" {
  bucket = "cloudrail-non-encrypted-czx7zxchs"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "cloudrail" {
  bucket                  = aws_s3_bucket.cloudrail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
