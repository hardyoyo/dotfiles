#!/bin/bash

set -euo pipefail

echo "#### Building list of installed crates ..."
# Get list of installed crates
installed_crates=$(cargo install --list)

# Parse out just crate names 
crates=$(echo "$installed_crates" | awk -F' v' '{print $1}')


echo "#### Updating all installed crates..."
# Iteratively install each crate forced to latest version
for crate in $crates; do
  cargo install --force "$crate"
done

exit 0
