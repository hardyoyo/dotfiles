#!/bin/bash

current_ip=`dig +short myip.opendns.com @resolver1.opendns.com`
if [ ! -f $PWD/.requiresvpn ]; then exit 0
elif [[ $current_ip =~ ^128\.48\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "current ip is $current_ip and is INSIDE the UCOP VPN."
    exit 0
else
    echo "current ip is $current_ip and is NOT in the UCOP VPN."
    exit 1
fi
