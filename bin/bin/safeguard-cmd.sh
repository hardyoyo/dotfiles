#!/usr/bin/env bash

# safeguard-cmd.sh
#
# Usage:
#   safeguard-cmd.sh <command> [args...]
#
# Examples:
#   safeguard-cmd.sh kubectl get pods
#   safeguard-cmd.sh aws s3 ls
#
# Suggested shell functions:
#
#   kubectl() {
#       safeguard-cmd.sh kubectl "$@"
#   }
#
#   aws() {
#       safeguard-cmd.sh aws "$@"
#   }

set -euo pipefail

TIMEOUT_SECONDS=30

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <command> [args ...]"
    exit 1
fi

cmd="$1"
shift

printf -v full_cmd '%q ' "$cmd" "$@"

echo
echo "=================================================="
echo " SAFEGUARDED COMMAND EXECUTION"
echo "=================================================="
echo
echo "The following command is requesting execution:"
echo
echo "  $full_cmd"
echo
echo "Enter 'y' or 'yes' within ${TIMEOUT_SECONDS} seconds to allow."
echo

if ! read -r -t "${TIMEOUT_SECONDS}" -p "Proceed? [y/N] " response; then
    echo
    echo
    echo "Request timed out after ${TIMEOUT_SECONDS} seconds."
    echo "Execution denied."
    exit 1
fi

echo

case "${response}" in
    y|Y|yes|YES|Yes)
        echo "Execution approved."
        exec "$cmd" "$@"
        ;;
    *)
        echo "Execution denied."
        exit 1
        ;;
esac
