#!/bin/bash

# start conky with the correct Y gap, depending on whether we're docked (wired internet present) or roaming

# take a short nap first
sleep 20

if (/sbin/ip a | egrep -q 'enp109s0f1:.*state UP'); then
  conky -y 200 &
 else
  conky -y 80 &
fi
exit 0
