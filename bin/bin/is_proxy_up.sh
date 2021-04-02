#!/usr/bin/env bash
echo "Is the proxy up?"
/usr/sbin/networksetup -getsocksfirewallproxy Wi-fi | grep ^Enabled
