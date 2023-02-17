#!/bin/bash

# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

aws ec2 stop-instances --profile sandbox --instance-ids 'i-026d11d9d030de57f' 'i-0ba3bad342f6378fb'

exit 0
