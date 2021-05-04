#!/bin/bash

if [ -z "$AWS_ACCESS_KEY_ID" ]
then
  echo "To run this script, you'll need AWS credentials (for use with terraform plan)."
  exit 1
fi

if [ -z "$CLOUDRAIL_API_KEY" ]
then
  echo "To run this script, you'll need to provide the CLOUDRAIL_API_KEY environment variable."
  exit 1
fi

if [ -z "$SNYK_TOKEN" ]
then
  echo "To run this script, you'll need to provide the SNYK_TOKEN environment variable."
  exit 1
fi

export AWS_REGION=us-west-1

# Generate all plan files
echo Generating plan files, where they do not exist yet
find . -name "main.tf" -exec dirname {} \; | grep -v "\.terraform" | while read -r test_case; do echo $test_case ; ORG_PATH=$PWD ; cd $test_case ; if [ ! -f plan.out ]; then terraform init ; terraform plan -out=plan.out ; fi ; cd $ORG_PATH; done

# Checkov
echo Now running Checkov on all cases
docker pull bridgecrew/checkov:latest
docker run -t -v $PWD:/tf bridgecrew/checkov --version > version_checkov.txt
find . -name "main.tf" -exec dirname {} \; | grep -v "\.terraform" | while read -r test_case; do echo $test_case ; ORG_PATH=$PWD ; cd $test_case ; if [ ! -f checkov_results.txt ]; then docker run -t -v $PWD:/tf bridgecrew/checkov --quiet -d /tf | sed 's/\[[0-9;]*m//g' | sed "s~$ORG_PATH~tool-compare~" > checkov_results.txt ; fi ; cd $ORG_PATH; done

# tfsec
echo Now running tfsec on all cases
docker pull liamg/tfsec:latest
docker run -t -v $PWD:/tf liamg/tfsec --version > version_tfsec.txt
find . -name "main.tf" -exec dirname {} \; | grep -v "\.terraform" | while read -r test_case; do echo $test_case ; ORG_PATH=$PWD ; cd $test_case ; if [ ! -f tfsec_results.txt ]; then docker run --rm -v "$(pwd):/src" liamg/tfsec /src --no-color | sed "s~$ORG_PATH~tool-compare~" > tfsec_results.txt ; fi; cd $ORG_PATH; done

# KICS
echo Now running KICS on all cases
docker pull checkmarx/kics:latest
docker run -t -v $PWD:/tf checkmarx/kics version | awk '{print $NF}' > version_kics.txt
find . -name "main.tf" -exec dirname {} \; | grep -v "\.terraform" | while read -r test_case; do echo $test_case ; ORG_PATH=$PWD ; cd $test_case ; if [ ! -f kics_results.txt ]; then docker run --rm -v "$(pwd):/src" checkmarx/kics:latest -p /src | sed "s~$ORG_PATH~tool-compare~" | grep -v "Executing queries" > kics_results.txt ; fi ; cd $ORG_PATH; done

# Terrascan
echo Now running Terrascan on all cases
brew install terrascan
terrascan version | awk '{print $NF}' > version_terrascan.txt
find . -name "main.tf" -exec dirname {} \; | grep -v "\.terraform" | while read -r test_case; do echo $test_case ; ORG_PATH=$PWD ; cd $test_case ; if [ ! -f terrascan_results.txt ]; then terrascan scan | sed "s~$ORG_PATH~tool-compare~" > terrascan_results.txt ; fi ; cd $ORG_PATH; done

# Snyk
echo Now running Snyk on all cases
docker pull snyk/snyk-cli:docker
docker run -t -v empty:/project -e SNYK_TOKEN snyk/snyk-cli:docker --version | tail -n 1 > version_snyk.txt
find . -name "main.tf" -exec dirname {} \; | grep -v "\.terraform" | while read -r test_case; do echo $test_case ; ORG_PATH=$PWD ; cd $test_case ; if [ ! -f snyk_results.txt ]; then docker run --rm -v "$(pwd):/project" -e SNYK_TOKEN snyk/snyk-cli:docker iac test --experimental /project | sed "s~$ORG_PATH~tool-compare~" > snyk_results.txt ; fi ; cd $ORG_PATH; done

# Cloudrail
echo Now running Cloudrail on all cases
docker pull indeni/cloudrail-cli:latest
docker run -t -v $PWD:/tf indeni/cloudrail-cli --version | awk '{print $NF}' > version_cloudrail.txt
find . -name "main.tf" -exec dirname {} \; | grep -v "\.terraform" | while read -r test_case; do echo $test_case ; ORG_PATH=$PWD ; cd $test_case ; if [ ! -f cloudrail_results.txt ]; then docker run --rm -v $PWD:/data -e CLOUDRAIL_API_KEY indeni/cloudrail-cli run --tf-plan plan.out --output-file cloudrail_results.txt --no-cloud-account --auto-approve -v; fi ; cd $ORG_PATH; done
