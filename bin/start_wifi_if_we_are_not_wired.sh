#!/bin/bash

# start the wifi interface if the wired interface is not up (to be used as a startup script)

if (/sbin/ip a | egrep -q 'enp109s0f1:.*state UP'); then
    nmcli r wifi off
else
    nmcli r wifi on
fi
exit 0
