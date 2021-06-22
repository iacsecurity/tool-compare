# In this case, we're simply using an external, commonly used module
# to create a user who has a password.
module "jack" {
  source = "cloudposse/iam-user/aws"
  version    = "v0.8.0"
  name       = "jack"
  user_name  = "jack@companyname.com"
  pgp_key    = "keybase:jack"
  groups     = ["admins"]
}