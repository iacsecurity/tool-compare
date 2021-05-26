resource "aws_globalaccelerator_accelerator" "example" {
  name            = "Example"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    #flow_logs_enabled   = true
    #flow_logs_s3_bucket = "example-bucket"
    #flow_logs_s3_prefix = "flow-logs/"
  }
}
