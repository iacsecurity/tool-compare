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

## Contributing to this repo
Anyone can contribute to this repository. The main areas of contribution are:

* Adding an additional tool - simply add the tool to this readme and the `run_all_tools.sh` script. Then,
execute that script and add all of its results as part of your PR. That's it, you're good to go.
  
* Adding test-cases - you can add the test case in the correct spot in the tree under [test-cases](/test-cases)
and run the `run_all_tools.sh` script against it. Make sure to include all of the tools' results as part of your PR.
  
