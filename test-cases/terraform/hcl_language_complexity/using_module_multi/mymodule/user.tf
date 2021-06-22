variable "allow_password" {
  type = bool
}

variable "user_name" {
  type = string
}

variable "pgp_key" {
  type = string
}

resource "aws_iam_user" "user" {
  name          = var.user_name
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "jack" {
  count = var.allow_password ? 1 : 0
  user    = aws_iam_user.user.name
  pgp_key = var.pgp_key
}
