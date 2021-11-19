# In this case we are using a local variable to pass information to the login_profile resource.
# While a case that looks exactly like this is less common, the use of locals, variables, etc. to
# pass information to resource is very common.

resource "aws_iam_user" "example" {
  name          = "example"
  path          = "/"
}

locals {
  user_name = aws_iam_user.example.name
  versioning_enabled = false
}

resource "aws_iam_user_login_profile" "example" {
  user    = local.user_name
  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_s3_bucket" "access-logs-bucket" {
  bucket = "cloudtrail-access-logs"
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = local.versioning_enabled
  }
}