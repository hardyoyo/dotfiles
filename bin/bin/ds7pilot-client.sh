#!/bin/bash
# ssh_command="ssh -A ec2-user@pub-ds-client-dev.escholarship.org -i ~/.ssh/hpottinger-keypair.pem"

AWS_Login_command="aws ssm start-session --target=i-026d11d9d030de57f --profile=sandbox"

# ssh_command="AWS_PROFILE=sandbox ssh -A i-026d11d9d030de57f"

echo "running this command:"
# echo $ssh_command
# eval $ssh_command

echo $AWS_Login_command
eval $AWS_Login_command
