#!/bin/bash

blueutil --connect "Bluetooth Keyboard"
blueutil --connect "Anker A7726"
blueutil --connect "ERGO M575"
blueutil --connect "MPOW HC5"

notify-bluetooth-connections.sh
