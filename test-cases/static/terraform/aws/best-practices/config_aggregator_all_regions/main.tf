resource "aws_config_configuration_aggregator" "organization" {

  name = "example"

  account_aggregation_source {
    account_ids = ["123456789012"]
    regions     = ["us-east-2", "us-east-1", "us-west-1", "us-west-2"]
  }
}
