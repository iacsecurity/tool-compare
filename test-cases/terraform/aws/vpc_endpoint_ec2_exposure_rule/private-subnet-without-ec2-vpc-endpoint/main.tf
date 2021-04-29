provider "aws" {
  region = "us-east-1"
}

module "private-vpc" {
  source = "../../../../terraform-tests-modules/private-vpc"
  all-subnets-azs = ["a"]
}


