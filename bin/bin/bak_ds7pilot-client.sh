#!/bin/bash
ssh_command="ssh -A ec2-user@pub-ds-dev.escholarship.org -i ~/.ssh/hpottinger-keypair.pem"
echo "running this command:"
echo $ssh_command
eval $ssh_command
