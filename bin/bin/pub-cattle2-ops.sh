#!/bin/bash

AWS_Login_command="aws --profile pub ssm start-session --target=i-06c0e7740ff1f95f8"

echo "running this command:"
echo $AWS_Login_command
eval $AWS_Login_command
