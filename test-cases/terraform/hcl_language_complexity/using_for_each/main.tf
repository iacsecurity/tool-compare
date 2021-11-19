# In this case we're using a for-each and expect the tool to only for all users who have a password
# and only those that have a password.

resource "aws_iam_user" "example" {
  for_each = {
      jack = "jack"
      jill = "jill"
      jane = "jane"
  }
  name          = each.value
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "example" {
  for_each = {
    jack = "jack"
    jill = "jill"
    # jane = "jane" - excluding one on purpose
  }
  user    = each.value
  pgp_key = "keybase:some_person_that_exists"
}


locals{
  prefix = "blah"
}

# tfsec:ignore:AWS002 tfsec:ignore:AWS017 tfsec:ignore:AWS077
resource "aws_s3_bucket" "for_web" {
  for_each = var.targets

  bucket = "${local.prefix}-${lookup(each.value, "name")}-web"
  acl    = "private"

  versioning {
    enabled    = false
    mfa_delete = false
  }

  tags = {
    Name = "${local.prefix}-${lookup(each.value, "name")}-web"
  }
}

variable "targets" {
  default={
    "a" = {
      name = "test"
    },
    "b" = {
      name = "test"
    },
    "c" = {
      name = "test"
    }
  }
}
