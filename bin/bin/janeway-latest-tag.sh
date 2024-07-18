#!/bin/bash
set -euo pipefail

latest_release=$(gh api repos/BirkbeckCTP/janeway/tags | /opt/homebrew/bin/jq '.[0].name' | sed 's/"//g')
echo "https://github.com/BirkbeckCTP/janeway/releases/tag/$latest_release"
exit 0
