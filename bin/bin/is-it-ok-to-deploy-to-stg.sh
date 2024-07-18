#!/bin/bash

# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

health=$(aws --profile pub elasticbeanstalk describe-instances-health --environment-name eb-pub-jschol2-stg --attribute-names HealthStatus | jq '.InstanceHealthList[].HealthStatus')

# echo "$health"

if [ "$health" == "\"Ok\"" ]; then
    echo "Yes, it's OK to deploy to jschol-stg now."
else
    echo "No, it's not OK to deploy to jschol-stg now. Here's why:"
    aws --profile pub elasticbeanstalk describe-instances-health --environment-name eb-pub-jschol2-stg --attribute-names All
fi
exit 0
