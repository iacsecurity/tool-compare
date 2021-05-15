# Select test cases

It's possible to run only a few test cases with the rerun make task:

Create a `.rerun` file in the root repository e.g:

```txt
test-cases/terraform/aws/best-practices/cloudfront_not_using_waf
test-cases/terraform/aws/best-practices/ec2_ebs_not_optimized
test-cases/terraform/aws/best-practices/tag_all_items
test-cases/terraform/aws/encryption/at-rest/sagemaker_not_encrypted
test-cases/terraform/aws/encryption/at-rest/secretsmanager_secrets_encrypted_at_rest_with_aws_managed_key_by_default
test-cases/terraform/aws/encryption/at-rest/workgroups_non_encrypted
```

Then execute the make task `rerun-YOURTOOL` e.g:

```bash
# rerun for all tools
make rerun-all
# rerun for cloudrail
make rerun-cloudrail
```