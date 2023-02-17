#!/bin/bash

# send a notification to confirm which bluetooth connections are active
CURRENT_BT=$(blueutil --connected --format json | jq '.[] .name' | tr -d '"' | tr "\n" "\t \t \t \t \t \t")
terminal-notifier -title "Current Bluetooth Connections" -message "${CURRENT_BT}"
