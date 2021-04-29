provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cloudrail_anthena_bucket" {
  bucket = "cloudrail-wg-encrypted-sse-s3"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "cloudrail_anthena_bucket" {
  bucket                  = aws_s3_bucket.cloudrail_anthena_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_athena_workgroup" "cloudrail_wg" {
  name = "cloudrail-wg-encrypted-sse-s3"

  configuration {
    enforce_workgroup_configuration    = false
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://{aws_s3_bucket.cloudrail_anthena_bucket.bucket}/output/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}

resource "aws_s3_bucket" "cloudrail_anthena_bucket_2" {
  bucket = "cloudrail-wg-encrypted-sse-s3-2"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "cloudrail_anthena_bucket_2" {
  bucket                  = aws_s3_bucket.cloudrail_anthena_bucket_2.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_athena_workgroup" "cloudrail_wg_2" {
  name = "cloudrail-wg-encrypted-sse-s3-2"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://{aws_s3_bucket.cloudrail_anthena_bucket_2.bucket}/output/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}