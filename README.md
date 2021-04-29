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

### Best Practices
| Test Case                                                                                                                         | Checkov               | Indeni Cloudrail      | Kics                  | Snyk                  | Terrascan             | Tfsec                 |
|-----------                                                                                                                        |---------              |------------------     |------                 |------                 |-----------            |-------                |
|[deploy_ec2_to_default_vpc](/best-practices/deploy_ec2_to_default_vpc)                                                             | :white_check_mark:    | :white_check_mark:    | :white_check_mark:    | :x:                   | :white_check_mark:    | :white_check_mark:    |
|[deploy_redshift_in_ec2_classic_mode](/best-practices/deploy_redshift_in_ec2_classic_mode)                                         | :x:                   | :white_check_mark:    | :x:                   | :x:                   | :x:                   | :x:                   |
|[security_group_no_description_for_rules](/best-practices/security_group_no_description_for_rules)                                 | :x:                   | :white_check_mark:    | :x:                   | :x:                   | :x:                   | :x:                   |
|[security_group_no_description_for_security_group](/best-practices/security_group_no_description_for_security_group)               | :x:                   | :white_check_mark:    | :x:                   | :white_check_mark:    | :x:                   | :white_check_mark:    |
|[tag_all_items](/best-practices/tag_all_items)                                                                                     | :x:                   | :white_check_mark:    | :x:                   | :x:                   | :x:                   | :x:                   |
|[using_public_amis](/best-practices/using_public_amis)                                                                             | :x:                   | :white_check_mark:    | :x:                   | :x:                   | :x:                   | :x:                   |

## Contributing
Anyone can contribute to this repository. The main areas of contribution are:

* Adding an additional tool - simply add the tool to this readme and the `run_all_tools.sh` script. Then,
execute that script and add all of its results as part of your PR. That's it, you're good to go.
  
* Adding test-cases - you can add the test case in the correct spot in the tree under [test-cases](/test-cases)
and run the `run_all_tools.sh` script against it. Make sure to include all of the tools' results as part of your PR.
  
