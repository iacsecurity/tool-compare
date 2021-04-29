provider "aws" {
  region = "eu-west-1"
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

resource "aws_s3_bucket_object" "object" {
  bucket                 = aws_s3_bucket.cloudrail.id
  key                    = "example_file_encrypted_awskms"
  content                = "Cloudrail example"
  server_side_encryption = "aws:kms"
}
