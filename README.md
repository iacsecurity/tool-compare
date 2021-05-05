![MIT License](https://img.shields.io/github/license/iacsecurity/tool-compare)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

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
The tables below list test cases included in this repository. For each case, it shows which tools
are able to catch it specifically, and which don't.

### Summary
|     | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|Tested Version|2.0.87|1.2.130|1.2.4|1.563.0|1.4.0|0.38.3|
|Total Catch Rate|59%|69%|29%|43%|16%|26%|

### test-cases/terraform/aws/best-practices
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[alb_drop_http_headers](test-cases/terraform/aws/best-practices/alb_drop_http_headers)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[cloudfront_not_using_waf](test-cases/terraform/aws/best-practices/cloudfront_not_using_waf)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[cloudtrail_enabled_on_multi_region](test-cases/terraform/aws/best-practices/cloudtrail_enabled_on_multi_region)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:x:|:x:|
|[config_aggregator_all_regions](test-cases/terraform/aws/best-practices/config_aggregator_all_regions)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[deploy_ec2_to_default_vpc](test-cases/terraform/aws/best-practices/deploy_ec2_to_default_vpc)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|
|[deploy_redshift_in_ec2_classic_mode](test-cases/terraform/aws/best-practices/deploy_redshift_in_ec2_classic_mode)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[dynamodb_without_recovery_enabled](test-cases/terraform/aws/best-practices/dynamodb_without_recovery_enabled)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[ec2_ebs_not_optimized](test-cases/terraform/aws/best-practices/ec2_ebs_not_optimized)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[ecr_make_tags_immutable](test-cases/terraform/aws/best-practices/ecr_make_tags_immutable)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:x:|:x:|
|[ecr_use_image_scanning](test-cases/terraform/aws/best-practices/ecr_use_image_scanning)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[ecs_cluster_container_insights](test-cases/terraform/aws/best-practices/ecs_cluster_container_insights)|:white_check_mark:|:x:|:x:|:white_check_mark:|:x:|:x:|
|[elasticache_automatic_backup](test-cases/terraform/aws/best-practices/elasticache_automatic_backup)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[kms_uses_rotation](test-cases/terraform/aws/best-practices/kms_uses_rotation)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[rds_retention_period_set](test-cases/terraform/aws/best-practices/rds_retention_period_set)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[security_group_no_description_for_rules](test-cases/terraform/aws/best-practices/security_group_no_description_for_rules)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[security_group_no_description_for_securi..](test-cases/terraform/aws/best-practices/security_group_no_description_for_security_group)|:x:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[tag_all_items](test-cases/terraform/aws/best-practices/tag_all_items)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[using_public_amis](test-cases/terraform/aws/best-practices/using_public_amis)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|Category Catch Rate|72%|44%|28%|44%|11%|28%|

### test-cases/terraform/aws/encryption/at-rest
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[athena_not_encrypted](test-cases/terraform/aws/encryption/at-rest/athena_not_encrypted)|:white_check_mark:|:x:|:x:|:white_check_mark:|:x:|:x:|
|[cloudtrail_not_encrypted](test-cases/terraform/aws/encryption/at-rest/cloudtrail_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[cloudwatch_groups_not_encrypted](test-cases/terraform/aws/encryption/at-rest/cloudwatch_groups_not_encrypted)|:x:|:white_check_mark:|:x:|:x:|:white_check_mark:|:x:|
|[codbuild_using_aws_key](test-cases/terraform/aws/encryption/at-rest/codbuild_using_aws_key)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[dax_cluster_not_encrypted](test-cases/terraform/aws/encryption/at-rest/dax_cluster_not_encrypted)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[docdb_cluster_encrypted_at_rest_using_cm..](test-cases/terraform/aws/encryption/at-rest/docdb_cluster_encrypted_at_rest_using_cmk_not_customer_managed)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[docdb_cluster_encrypted_without_kms_key](test-cases/terraform/aws/encryption/at-rest/docdb_cluster_encrypted_without_kms_key)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[docdb_clusters_non_encrypted](test-cases/terraform/aws/encryption/at-rest/docdb_clusters_non_encrypted)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[dynamodb_not_encrypted](test-cases/terraform/aws/encryption/at-rest/dynamodb_not_encrypted)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[ecr_repo_not_encrypted](test-cases/terraform/aws/encryption/at-rest/ecr_repo_not_encrypted)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[elasticache_replication_group_not_encryp..](test-cases/terraform/aws/encryption/at-rest/elasticache_replication_group_not_encrypted_at_rest)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[elasticsearch_not_encrypted](test-cases/terraform/aws/encryption/at-rest/elasticsearch_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[kinesis_stream_not_encrypted](test-cases/terraform/aws/encryption/at-rest/kinesis_stream_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[neptune_cluster_no_encryption](test-cases/terraform/aws/encryption/at-rest/neptune_cluster_no_encryption)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:x:|
|[rds_cluster_encrypt_at_rest_disabled](test-cases/terraform/aws/encryption/at-rest/rds_cluster_encrypt_at_rest_disabled)|:white_check_mark:|:white_check_mark:|:x:|:x:|:x:|:white_check_mark:|
|[redshift_not_encrypted](test-cases/terraform/aws/encryption/at-rest/redshift_not_encrypted)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|
|[rest_api_cache_non_encrypted](test-cases/terraform/aws/encryption/at-rest/rest_api_cache_non_encrypted)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[s3_bucket_non_encrypted](test-cases/terraform/aws/encryption/at-rest/s3_bucket_non_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[s3_bucket_object_non_encrypted](test-cases/terraform/aws/encryption/at-rest/s3_bucket_object_non_encrypted)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[sagemaker_not_encrypted](test-cases/terraform/aws/encryption/at-rest/sagemaker_not_encrypted)|:white_check_mark:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[secretsmanager_secrets_encrypted_at_rest..](test-cases/terraform/aws/encryption/at-rest/secretsmanager_secrets_encrypted_at_rest_with_aws_managed_key_by_default)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[secretsmanager_secrets_encrypted_at_rest..](test-cases/terraform/aws/encryption/at-rest/secretsmanager_secrets_encrypted_at_rest_with_aws_managed_key_by_key_arn)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[sns_topic_encrypted_at_rest_with_aws_man..](test-cases/terraform/aws/encryption/at-rest/sns_topic_encrypted_at_rest_with_aws_managed_key_by_key_arn)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[sqs_queue_not_encrypted](test-cases/terraform/aws/encryption/at-rest/sqs_queue_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[workgroups_non_encrypted](test-cases/terraform/aws/encryption/at-rest/workgroups_non_encrypted)|:x:|:white_check_mark:|:x:|:x:|:x:|:white_check_mark:|
|[workspace_root_volume_not_encrypted_at_r..](test-cases/terraform/aws/encryption/at-rest/workspace_root_volume_not_encrypted_at_rest)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[workspace_user_volume_not_encrypted_at_r..](test-cases/terraform/aws/encryption/at-rest/workspace_user_volume_not_encrypted_at_rest)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|Category Catch Rate|56%|85%|26%|41%|7%|30%|

### test-cases/terraform/aws/encryption/in-transit
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[alb_use_http](test-cases/terraform/aws/encryption/in-transit/alb_use_http)|:white_check_mark:|:white_check_mark:|:x:|:x:|:x:|:white_check_mark:|
|[cloudfront_distribution_not_encrypted](test-cases/terraform/aws/encryption/in-transit/cloudfront_distribution_not_encrypted)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[cloudfront_protocol_version_is_low](test-cases/terraform/aws/encryption/in-transit/cloudfront_protocol_version_is_low)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[ecs_task_definition_not_encrypted_in_tra..](test-cases/terraform/aws/encryption/in-transit/ecs_task_definition_not_encrypted_in_transit)|:white_check_mark:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[elasticache_replication_group_not_encryp..](test-cases/terraform/aws/encryption/in-transit/elasticache_replication_group_not_encrypted_in_transit)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[elasticsearch_encrypt_node_to_node_disab..](test-cases/terraform/aws/encryption/in-transit/elasticsearch_encrypt_node_to_node_disabled)|:x:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[load_balancer_listener_http](test-cases/terraform/aws/encryption/in-transit/load_balancer_listener_http)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[vpc_has_only_dynamodb_vpce_gw_connection](test-cases/terraform/aws/encryption/in-transit/vpc_has_only_dynamodb_vpce_gw_connection)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|Category Catch Rate|75%|100%|38%|62%|25%|75%|

### test-cases/terraform/aws/iam/iam-entities
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[human_users_defined](test-cases/terraform/aws/iam/iam-entities/human_users_defined)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[iam_user_inline_policy_attach](test-cases/terraform/aws/iam/iam-entities/iam_user_inline_policy_attach)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[iam_user_managed_policy_direct_attachmen..](test-cases/terraform/aws/iam/iam-entities/iam_user_managed_policy_direct_attachment)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[passrole_and_lambda_permissions_cause_pr..](test-cases/terraform/aws/iam/iam-entities/passrole_and_lambda_permissions_cause_priv_escalation)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[password_policy_not_locked_down](test-cases/terraform/aws/iam/iam-entities/password_policy_not_locked_down)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:white_check_mark:|
|[policy-too-broad](test-cases/terraform/aws/iam/iam-entities/policy-too-broad)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[policy_missing_principal](test-cases/terraform/aws/iam/iam-entities/policy_missing_principal)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[public_and_private_ec2_same_role](test-cases/terraform/aws/iam/iam-entities/public_and_private_ec2_same_role)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|Category Catch Rate|38%|100%|0%|38%|0%|12%|

### test-cases/terraform/aws/iam/resource-authentication
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[rds_without_authentication](test-cases/terraform/aws/iam/resource-authentication/rds_without_authentication)|:x:|:x:|:white_check_mark:|:x:|:white_check_mark:|:x:|
|[rest_api_without_authorization](test-cases/terraform/aws/iam/resource-authentication/rest_api_without_authorization)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:x:|:x:|
|Category Catch Rate|50%|0%|100%|50%|50%|0%|

### test-cases/terraform/aws/iam/resource-policies
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[cloudwatch_log_destination_insecure_poli..](test-cases/terraform/aws/iam/resource-policies/cloudwatch_log_destination_insecure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[ecr_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/ecr_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[efs_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/efs_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[elasticsearch_domain_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/elasticsearch_domain_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[glue_data_catalog_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/glue_data_catalog_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[kms_key_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/kms_key_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[lambda_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/lambda_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[rest_api_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/rest_api_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[s3_bucket_acl_public_all_authenticated_u..](test-cases/terraform/aws/iam/resource-policies/s3_bucket_acl_public_all_authenticated_users_canned)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[s3_bucket_acl_public_all_users_canned](test-cases/terraform/aws/iam/resource-policies/s3_bucket_acl_public_all_users_canned)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[s3_bucket_acl_public_all_users_canned_wi..](test-cases/terraform/aws/iam/resource-policies/s3_bucket_acl_public_all_users_canned_with_overriding_access_block)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[s3_bucket_policy_public_to_all_authentic..](test-cases/terraform/aws/iam/resource-policies/s3_bucket_policy_public_to_all_authenticated_users)|:x:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|
|[secrets_manager_not_secure_policy](test-cases/terraform/aws/iam/resource-policies/secrets_manager_not_secure_policy)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|Category Catch Rate|15%|100%|23%|15%|23%|15%|

### test-cases/terraform/aws/logging
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[api_gateway_no_xray](test-cases/terraform/aws/logging/api_gateway_no_xray)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|
|[cloudfront_distribution_without_logging](test-cases/terraform/aws/logging/cloudfront_distribution_without_logging)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|
|[cloudtrail_file_log_validation_disabled](test-cases/terraform/aws/logging/cloudtrail_file_log_validation_disabled)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|[cloudwatch_log_groups_no_retention](test-cases/terraform/aws/logging/cloudwatch_log_groups_no_retention)|:white_check_mark:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|:x:|
|[docdb_audit_logs_missing](test-cases/terraform/aws/logging/docdb_audit_logs_missing)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[ec2_without_monitoring](test-cases/terraform/aws/logging/ec2_without_monitoring)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[eks_logging_disabled](test-cases/terraform/aws/logging/eks_logging_disabled)|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|:x:|:x:|
|[elasticsearch_domain_logging_disabled](test-cases/terraform/aws/logging/elasticsearch_domain_logging_disabled)|:white_check_mark:|:x:|:x:|:white_check_mark:|:white_check_mark:|:white_check_mark:|
|[elb_without_access_logs](test-cases/terraform/aws/logging/elb_without_access_logs)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[globalaccelerator_accelerator_no_flow_lo..](test-cases/terraform/aws/logging/globalaccelerator_accelerator_no_flow_logs)|:white_check_mark:|:x:|:x:|:white_check_mark:|:x:|:x:|
|[lambda_without_explicit_log_group](test-cases/terraform/aws/logging/lambda_without_explicit_log_group)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[lambda_without_xray](test-cases/terraform/aws/logging/lambda_without_xray)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|
|[neptune_cluster_no_logging](test-cases/terraform/aws/logging/neptune_cluster_no_logging)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[rds_without_logging](test-cases/terraform/aws/logging/rds_without_logging)|:white_check_mark:|:x:|:x:|:x:|:x:|:x:|
|[redshift_without_logging](test-cases/terraform/aws/logging/redshift_without_logging)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:x:|:x:|
|[rest_api_no_access_logging](test-cases/terraform/aws/logging/rest_api_no_access_logging)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:white_check_mark:|:x:|
|[s3_access_logging_disabled](test-cases/terraform/aws/logging/s3_access_logging_disabled)|:white_check_mark:|:x:|:white_check_mark:|:white_check_mark:|:x:|:white_check_mark:|
|Category Catch Rate|94%|24%|47%|65%|29%|18%|

### test-cases/terraform/aws/networking/vpc-endpoints
| Test Case | Checkov | Indeni Cloudrail | Kics | Snyk | Terrascan | Tfsec |
|----|----|----|----|----|----|----|
|[dynamodb-vpce-exist-without-routeassocia..](test-cases/terraform/aws/networking/vpc-endpoints/dynamodb-vpce-exist-without-routeassociation)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|[sqs-vpc-endpoint-without-dns-resolution](test-cases/terraform/aws/networking/vpc-endpoints/sqs-vpc-endpoint-without-dns-resolution)|:x:|:white_check_mark:|:x:|:x:|:x:|:x:|
|Category Catch Rate|0%|100%|0%|0%|0%|0%|

## Contributing
Anyone can contribute to this repository. The main areas of contribution are:

* Adding an additional tool - simply add the tool to this readme and the `run_all_tools.sh` script. Then,
execute that script and add all of its results as part of your PR. That's it, you're good to go.
  
* Adding test-cases - you can add the test case in the correct spot in the tree under [test-cases](/test-cases)
and run the `run_all_tools.sh` script against it. Make sure to include all of the tools' results as part of your PR.
  
