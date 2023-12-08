#!/bin/bash
set -euo pipefail

# find the default NAT gateway IP address
gateway_ip=$(ip route | awk '/default/ { print $3 }')

# Check if connected to the internet
if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo "Already connected to the internet. No action needed."
else
  # Try to open the captive portal login page
  xdg-open "http://$gateway_ip"

fi

exit 0
