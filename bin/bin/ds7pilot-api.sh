#!/bin/bash
# ssh_command="ssh -A ec2-user@pub-ds-api-dev.escholarship.org -i ~/.ssh/hpottinger-keypair.pem"

AWS_Login_command="aws ssm start-session --target=i-0eb9e12ca242b398f --profile=sandbox"
# ssh_command="ssh -A ec2-user@i-0eb9e12ca242b398f"

echo "running this command:"
# echo $ssh_command
# eval $ssh_command
echo $AWS_Login_command
eval $AWS_Login_command
