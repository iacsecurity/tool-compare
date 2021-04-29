provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "sse-s3-encrypted" {
  bucket = "cloudrail-encrypted-czx7zxchs"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "sse-s3-encrypted" {
  bucket                  = aws_s3_bucket.sse-s3-encrypted.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "kms-s3-encrypted" {
  bucket = "cloudrail-encrypted-ckkx6zxchs"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "kms-s3-encrypted" {
  bucket                  = aws_s3_bucket.kms-s3-encrypted.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
