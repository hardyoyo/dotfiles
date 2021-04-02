#!/usr/bin/env bash
set -x
sudo /usr/sbin/networksetup -setsocksfirewallproxystate "Wi-Fi" off
sudo /usr/sbin/networksetup -setsocksfirewallproxystate "Thunderbolt Ethernet Slot  1" off
sudo /usr/sbin/networksetup -setsocksfirewallproxy "Wi-Fi" off
sudo /usr/sbin/networksetup -setsocksfirewallproxy "Thunderbolt Ethernet Slot  1" off
exit 0
