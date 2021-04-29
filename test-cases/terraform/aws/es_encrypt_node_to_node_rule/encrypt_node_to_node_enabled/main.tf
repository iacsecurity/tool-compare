provider "aws" {
  region = "us-east-1"
}

resource "aws_elasticsearch_domain" "example" {
  domain_name           = "cloudrail-encrypted-in-tran"
  elasticsearch_version = "6.0"

  cluster_config {
    instance_type = "i3.large.elasticsearch"
  }

  node_to_node_encryption {
    enabled = true
  }
}