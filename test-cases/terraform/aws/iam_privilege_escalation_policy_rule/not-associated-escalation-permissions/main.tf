provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group" "group-1" {
  name = "group-1"
  path = "/"
}

resource "aws_iam_policy" "allow-policy" {
  name = "allow-policy"
  description = "un-attached policy"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "iam:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF

}
