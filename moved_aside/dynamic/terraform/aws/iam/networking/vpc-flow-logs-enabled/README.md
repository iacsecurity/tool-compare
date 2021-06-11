# VPC Flow Logs Enabled

This dynamic test case checks to see that a VPC which is used by a resource described in IaC is included in a tool's
inspection for VPC flow logging.

The Terraform in this case will create a resource within a VPC that already exists in the cloud account and doens't
have flow logs enabled. 
