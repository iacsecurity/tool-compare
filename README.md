# tool-compare
In the world of infrastructure-as-code security there are several tools for users to choose from.
The goal of this repository is to help compare the different options so that users can
choose the tool that best fits their own needs.

## What tools are there?
* [Checkov](https://github.com/bridgecrewio/checkov)
* [Indeni Cloudrail](https://www.indeni.com/cloudrail)
* [Kics](https://github.com/Checkmarx/kics)
* [Snyk](https://snyk.io/) 
* [Terrascan](https://github.com/accurics/terrascan) 
* [Tfsec](https://github.com/tfsec/tfsec)
  
(there are others, anyone can add to this list, sorted A-Z)

## How does this repo work?
This repository has a set of test-cases and a main script, called [run_all_tools.sh](/run_all_tools.sh) 
which runs the above-listed tools against each of the test-cases. This allows any potential user
to see what the tool can do, and how it compares, before even installing it.

## Test case catch rate
The table below compares the different tools' catch rates for the test cases included in this repository.

### terraform
#### aws
##### best-practices
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[deploy_ec2_to_default_vpc](test-cases/terraform/aws/best-practices/deploy_ec2_to_default_vpc)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|
|[deploy_redshift_in_ec2_classic_mode](test-cases/terraform/aws/best-practices/deploy_redshift_in_ec2_classic_mode)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[security_group_no_description_for_rules](test-cases/terraform/aws/best-practices/security_group_no_description_for_rules)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[security_group_no_description_for_security_group](test-cases/terraform/aws/best-practices/security_group_no_description_for_security_group)|:x:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[tag_all_items](test-cases/terraform/aws/best-practices/tag_all_items)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[using_public_amis](test-cases/terraform/aws/best-practices/using_public_amis)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
##### encryption
###### at-rest
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[cloudtrail_not_encrypted](test-cases/terraform/aws/encryption/at-rest/cloudtrail_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[cloudwatch_groups_not_encrypted](test-cases/terraform/aws/encryption/at-rest/cloudwatch_groups_not_encrypted)|:x:|:white_check_mark:|:x:|:x:|:white_check_mark:|:x:|
|[codbuild_using_aws_key](test-cases/terraform/aws/encryption/at-rest/codbuild_using_aws_key)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[dax_cluster_not_encrypted](test-cases/terraform/aws/encryption/at-rest/dax_cluster_not_encrypted)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[docdb_cluster_encrypted_at_rest_using_cmk_not_customer_managed](test-cases/terraform/aws/encryption/at-rest/docdb_cluster_encrypted_at_rest_using_cmk_not_customer_managed)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[docdb_cluster_encrypted_without_kms_key](test-cases/terraform/aws/encryption/at-rest/docdb_cluster_encrypted_without_kms_key)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[docdb_clusters_non_encrypted](test-cases/terraform/aws/encryption/at-rest/docdb_clusters_non_encrypted)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[rds_cluster_encrypt_at_rest_disabled](test-cases/terraform/aws/encryption/at-rest/rds_cluster_encrypt_at_rest_disabled)|:white_check_mark:|:white_check_mark:|:x:|:x:|:x:|:white_check_mark:|
|[rest_api_cache_non_encrypted](test-cases/terraform/aws/encryption/at-rest/rest_api_cache_non_encrypted)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[s3_bucket_non_encrypted](test-cases/terraform/aws/encryption/at-rest/s3_bucket_non_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[s3_bucket_object_non_encrypted](test-cases/terraform/aws/encryption/at-rest/s3_bucket_object_non_encrypted)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[secretsmanager_secrets_encrypted_at_rest_with_aws_managed_key_by_default](test-cases/terraform/aws/encryption/at-rest/secretsmanager_secrets_encrypted_at_rest_with_aws_managed_key_by_default)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[secretsmanager_secrets_encrypted_at_rest_with_aws_managed_key_by_key_arn](test-cases/terraform/aws/encryption/at-rest/secretsmanager_secrets_encrypted_at_rest_with_aws_managed_key_by_key_arn)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[sns_topic_encrypted_at_rest_with_aws_managed_key_by_key_arn](test-cases/terraform/aws/encryption/at-rest/sns_topic_encrypted_at_rest_with_aws_managed_key_by_key_arn)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[sqs_queue_not_encrypted](test-cases/terraform/aws/encryption/at-rest/sqs_queue_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[workgroups_non_encrypted](test-cases/terraform/aws/encryption/at-rest/workgroups_non_encrypted)|:x:|:white_check_mark:|:x:|:x:|:x:|:white_check_mark:|
|[workspace_root_volume_not_encrypted_at_rest](test-cases/terraform/aws/encryption/at-rest/workspace_root_volume_not_encrypted_at_rest)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[workspace_user_volume_not_encrypted_at_rest](test-cases/terraform/aws/encryption/at-rest/workspace_user_volume_not_encrypted_at_rest)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
###### in-transit
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[alb_use_http](test-cases/terraform/aws/encryption/in-transit/alb_use_http)|:white_check_mark:|:white_check_mark:|:x:|:x:|:x:|:white_check_mark:|
|[cloudfront_distribution_not_encrypted](test-cases/terraform/aws/encryption/in-transit/cloudfront_distribution_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[cloudfront_protocol_version_is_low](test-cases/terraform/aws/encryption/in-transit/cloudfront_protocol_version_is_low)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[ecs_task_definition_not_encrypted_in_transit](test-cases/terraform/aws/encryption/in-transit/ecs_task_definition_not_encrypted_in_transit)|:white_check_mark:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[elasticsearch_encrypt_node_to_node_disabled](test-cases/terraform/aws/encryption/in-transit/elasticsearch_encrypt_node_to_node_disabled)|:x:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[load_balancer_listener_http](test-cases/terraform/aws/encryption/in-transit/load_balancer_listener_http)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[vpc_has_only_dynamodb_vpce_gw_connection](test-cases/terraform/aws/encryption/in-transit/vpc_has_only_dynamodb_vpce_gw_connection)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
##### iam
###### iam-entities
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[human_users_defined](test-cases/terraform/aws/iam/iam-entities/human_users_defined)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[iam_user_inline_policy_attach](test-cases/terraform/aws/iam/iam-entities/iam_user_inline_policy_attach)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[iam_user_managed_policy_direct_attachment](test-cases/terraform/aws/iam/iam-entities/iam_user_managed_policy_direct_attachment)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[passrole_and_lambda_permissions_cause_priv_escalation](test-cases/terraform/aws/iam/iam-entities/passrole_and_lambda_permissions_cause_priv_escalation)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[policy-too-broad](test-cases/terraform/aws/iam/iam-entities/policy-too-broad)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[policy_missing_principal](test-cases/terraform/aws/iam/iam-entities/policy_missing_principal)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[public_and_private_ec2_same_role](test-cases/terraform/aws/iam/iam-entities/public_and_private_ec2_same_role)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
###### resource-policies
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[cloudwatch_log_destination_insecure_policy](test-cases/terraform/aws/iam/resource-policies/cloudwatch_log_destination_insecure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[efs_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/efs_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[elasticsearch_domain_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/elasticsearch_domain_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[glue_data_catalog_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/glue_data_catalog_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[kms_key_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/kms_key_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[lambda_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/lambda_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[rest_api_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/rest_api_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[s3_bucket_acl_public_all_authenticated_users_canned](test-cases/terraform/aws/iam/resource-policies/s3_bucket_acl_public_all_authenticated_users_canned)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[s3_bucket_acl_public_all_users_canned](test-cases/terraform/aws/iam/resource-policies/s3_bucket_acl_public_all_users_canned)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[s3_bucket_acl_public_all_users_canned_with_overriding_access_block](test-cases/terraform/aws/iam/resource-policies/s3_bucket_acl_public_all_users_canned_with_overriding_access_block)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[s3_bucket_policy_public_to_all_authenticated_users](test-cases/terraform/aws/iam/resource-policies/s3_bucket_policy_public_to_all_authenticated_users)|:x:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|
|[secrets_manager_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/secrets_manager_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
##### logging
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[cloudtrail_file_log_validation_disabled](test-cases/terraform/aws/logging/cloudtrail_file_log_validation_disabled)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[cloudwatch_log_groups_no_retention](test-cases/terraform/aws/logging/cloudwatch_log_groups_no_retention)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:x:|
|[eks_logging_disabled](test-cases/terraform/aws/logging/eks_logging_disabled)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[lambda_without_explicit_log_group](test-cases/terraform/aws/logging/lambda_without_explicit_log_group)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
##### networking
###### vpc-endpoints
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[dynamodb-vpce-exist-without-routeassociation](test-cases/terraform/aws/networking/vpc-endpoints/dynamodb-vpce-exist-without-routeassociation)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[sqs-vpc-endpoint-without-dns-resolution](test-cases/terraform/aws/networking/vpc-endpoints/sqs-vpc-endpoint-without-dns-resolution)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|

## Contributing
Anyone can contribute to this repository. The main areas of contribution are:

* Adding an additional tool - simply add the tool to this readme and the `run_all_tools.sh` script. Then,
execute that script and add all of its results as part of your PR. That's it, you're good to go.
  
* Adding test-cases - you can add the test case in the correct spot in the tree under [test-cases](/test-cases)
and run the `run_all_tools.sh` script against it. Make sure to include all of the tools' results as part of your PR.
  
