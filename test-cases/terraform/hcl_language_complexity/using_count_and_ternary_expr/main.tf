# In this case we're using count and a teranry expression to set a password for one user,
# but not the other. For a tool to pass this test case it should alert a violation about
# only one of the two users. A tool that doesn't alert at all is considered a failure of the test.

locals {
    allow_password_jack = false
    allow_password_jill = true
}

resource "aws_iam_user" "jack" {
  name          = "jack"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "jack" {
  count = local.allow_password_jack ? 1 : 0
  user    = aws_iam_user.jack.name
  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_user" "jill" {
  name          = "jill"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "jill" {
  count = local.allow_password_jill ? 1 : 0
  user    = aws_iam_user.jill.name
  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_security_group_rule" "trust-rules-dev" {
	count = 4
	description = var.trust-sg-rules[count.index]["description"]
	type = "ingress"
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/2"]
	to_port = var.trust-sg-rules[count.index]["to_port"]
	from_port = 10
	security_group_id = aws_security_group.trust-rules-dev.id
}
	
resource "aws_security_group" "trust-rules-dev" {
	description = "description"
}
	
variable "trust-sg-rules" {
	description = "A list of maps that creates a number of sg"
	type = list(map(string))
	
	default = [
		{
			description = "Allow egress of http traffic"
			from_port = "80"
			to_port = "80"
			type = "egress"
		},
		{
			description = "Allow egress of http traffic"
			from_port = "80"
			to_port = "80"
			type = "egress"
		}
	]
}