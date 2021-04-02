#!/usr/bin/env bash
set -x
sudo /usr/sbin/networksetup -setsocksfirewallproxystate "Thunderbolt Ethernet Slot  1" localhost 1080
sudo /usr/sbin/networksetup -setsocksfirewallproxystate "Wi-Fi" localhost 1080
ssh -N -D 1080 -p 18822 -v hpottinger@cdl-aws-bastion.cdlib.org
/usr/sbin/networksetup -setsocksfirewallproxystate "Wi-Fi" off
/usr/sbin/networksetup -setsocksfirewallproxystate "Thunderbolt Ethernet Slot  1" off
/usr/sbin/networksetup -setsocksfirewallproxy "Wi-Fi" off
/usr/sbin/networksetup -setsocksfirewallproxy "Thunderbolt Ethernet Slot  1" off
exit 0
