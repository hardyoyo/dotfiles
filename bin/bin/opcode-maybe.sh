#!/usr/bin/env bash

# bail quietly if AWS isn’t ready
if ! aws sts get-caller-identity >/dev/null 2>&1; then
  echo "⚠️  AWS SSO not ready (run: aws sso login)"
  return 1 2>/dev/null || exit 1
fi

# load creds
eval "$(aws configure export-credentials --profile bedrock --format env)"

# set all the required ENVs so Claude will work
export AWS_REGION="us-west-2"
export AWS_PROFILE="bedrock"
export CLAUDE_CODE_USE_BEDROCK=1
export CLAUDE_CODE_STRIP_BETA_HEADERS=1
export CLAUDE_CODE_DISABLE_EAGER_STREAMING=1

export ANTHROPIC_BEDROCK_BASE_URL="https://unified-api.ucsf.edu/general/awsai"
export DISABLE_PROMPT_CACHING=0

# model stuff
export ANTHROPIC_MODEL="sonnet"
export ANTHROPIC_DEFAULT_SONNET_MODEL="us.anthropic.claude-sonnet-4-6"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"
export ANTHROPIC_DEFAULT_OPUS_MODEL="us.anthropic.claude-opus-4-6-v1"

# use HAIKU for the subagent
export ANTHROPIC_SMALL_FAST_MODEL="haiku"
export CLAUDE_CODE_SUBAGENT_MODEL="us.anthropic.claude-haiku-4-5-20251001-v1:0"

# start in planning mode


exec command /Applications/opcode.app/Contents/MacOS/opcode "$@"

exit 0
