provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "aws_sns_topic" {
  name = "glacier-sns-topic"
}

resource "aws_glacier_vault" "not_secure_archive" {
  name = "not_secure_archive"

  notification {
    sns_topic = aws_sns_topic.aws_sns_topic.arn
    events    = ["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"]
  }

  access_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Sid": "add-read-only-perm",
          "Principal": "*",
          "Effect": "Allow",
          "Action": [
             "glacier:*"
          ],
          "Resource": "arn:aws:glacier:us-east-1:115553109071:vaults/not_secure_archive"
       }
    ]
}
EOF
}