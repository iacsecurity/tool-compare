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

module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = "demodb"
  username = "user"
  password = aws_ssm_parameter.pw.value
  port     = "3306"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
}
