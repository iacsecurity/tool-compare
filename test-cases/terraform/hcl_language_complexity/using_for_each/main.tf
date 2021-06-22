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
