#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${1:-$PWD}"

echo "Scanning for HTTPS remotes on git.ucsf.edu in: $WORKSPACE"
echo

fixed=0

for dir in "$WORKSPACE"/*/; do
    [ -d "$dir/.git" ] || continue

    while IFS= read -r remote; do
        url=$(git -C "$dir" remote get-url "$remote" 2>/dev/null) || continue

        if [[ "$url" == https://git.ucsf.edu/* ]]; then
            ssh_url=$(echo "$url" | sed 's|https://git.ucsf.edu/|git@git.ucsf.edu:|')
            repo=$(basename "$dir")
            echo "  fixing: $repo ($remote)"
            echo "    from: $url"
            echo "      to: $ssh_url"
            git -C "$dir" remote set-url "$remote" "$ssh_url"
            fixed=$((fixed + 1))
        fi
    done < <(git -C "$dir" remote)
done

echo
echo "Done. Fixed $fixed remote(s)."

exit 0
