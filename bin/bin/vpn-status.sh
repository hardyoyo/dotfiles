#!/bin/bash
set -euo pipefail

# set -x # uncomment for super debugging

DEBUG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --debug)
            DEBUG=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Function to check if IP is in a CIDR range
is_ip_in_cidr() {
    local ip=$1
    local cidr=$2
    if [[ $DEBUG == true ]]; then
        echo "Checking IP: $ip against CIDR: $cidr"
    fi

    # Split IP and CIDR
    IFS='/' read -r network mask <<< "$cidr"

    # Convert IP and network to decimal
    IFS='.' read -r -a ip_octets <<< "$ip"
    IFS='.' read -r -a network_octets <<< "$network"

    ip_dec=$((ip_octets[0] * 256 ** 3 + ip_octets[1] * 256 ** 2 + ip_octets[2] * 256 + ip_octets[3]))
    network_dec=$((network_octets[0] * 256 ** 3 + network_octets[1] * 256 ** 2 + network_octets[2] * 256 + network_octets[3]))

    # Calculate mask
    mask_dec=$((0xffffffff << (32 - mask) & 0xffffffff))

    # Apply mask
    ip_masked=$((ip_dec & mask_dec))
    network_masked=$((network_dec & mask_dec))

    if [[ $DEBUG == true ]]; then
        printf "IP (masked): %08x\n" $ip_masked
        printf "Network (masked): %08x\n" $network_masked
    fi

    # Compare
    if [[ $ip_masked -eq $network_masked ]]; then
        return 0
    else
        return 1
    fi
}


# List of CIDR ranges
CIDR_LIST=(
    "128.218.0.0/16"
)

# Get current IP
CURRENT_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [[ $DEBUG == true ]]; then
    echo "Current IP: $CURRENT_IP"
fi

# Check if IP is in any of the CIDR ranges
for cidr in "${CIDR_LIST[@]}"; do
    if is_ip_in_cidr "$CURRENT_IP" "$cidr"; then
        if [[ $DEBUG == true ]]; then
          echo "IP is in CIDR range: $cidr"
        fi

        echo -ne "\033[36m1\033[0m"
        exit 0

    else
        if [[ $DEBUG == true ]]; then
          echo "IP is NOT in CIDR range: $cidr"
        fi
        exit 1
    fi

done

# we shouldn't reach this ever
exit 2
