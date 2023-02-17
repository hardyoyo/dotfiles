#!/bin/bash

# reboot in a nice and orderly fashion

# first poweroff Lando
/usr/local/bin/lando poweroff

# finally, reboot immediately
sudo /sbin/reboot

# a formality, if the command above completes, the exit is irrelevant
exit 0
