#!/usr/bin/env bash
set -euo pipefail

DEBUG=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --debug) DEBUG=true; shift ;;
        *) shift ;;
    esac
done

# Check if any utun interface has an IP address
while read -r line; do
    if [[ "$line" =~ ^(utun[0-9]+): ]]; then
        interface="${BASH_REMATCH[1]}"

        if ip=$(ifconfig "$interface" | grep "inet " | awk '{print $2}'); then
            [[ $DEBUG == true ]] && echo "VPN found: $interface has IP $ip" >&2
            echo "1"
            exit 0
        fi
    fi
done < <(ifconfig | grep "^utun")

[[ $DEBUG == true ]] && echo "No VPN found: no utun interfaces with IP" >&2
echo "0"
exit 0
