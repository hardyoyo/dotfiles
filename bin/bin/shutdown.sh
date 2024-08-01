#!/bin/bash

# shutdown in a nice and orderly fashion

# first poweroff Lando
# /usr/local/bin/lando poweroff

# finally, shutdown immediately
sudo /sbin/shutdown -h now

# a formality, if the command above completes, the exit is irrelevant
exit 0
