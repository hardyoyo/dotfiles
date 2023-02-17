#!/bin/bash

# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

health=$(aws --profile pub elasticbeanstalk describe-instances-health --environment-name eb-pub-jschol2-prd --attribute-names HealthStatus | jq '.InstanceHealthList[].HealthStatus')

# echo "$health"

if [ "$health" == "\"Ok\"" ]; then
    echo "Yes, it's OK to deploy to prd now."
else
    echo "Hmm, it might not be OK to deploy to prd now. Check this out:"
    aws --profile pub elasticbeanstalk describe-instances-health --environment-name eb-pub-jschol2-prd --attribute-names All
fi
exit 0
