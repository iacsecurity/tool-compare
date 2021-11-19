resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-access-logs"
  acl    = "private"
  force_destroy = true
}