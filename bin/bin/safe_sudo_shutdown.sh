#!/usr/bin/env bash
set -x

# powerdown Lando
/usr/local/bin/lando poweroff

# Turn off the proxy/fake VPN
sudo /usr/sbin/networksetup -setsocksfirewallproxystate "Wi-Fi" off
sudo /usr/sbin/networksetup -setsocksfirewallproxystate "Thunderbolt Ethernet Slot  1" off

# shutdown
sudo /sbin/halt

exit 0
