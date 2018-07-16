#!/bin/bash

# a simple script to kill conky and start a new conky, useful to call from crontab on a regular basis

# we have to do it this way, in an if, because killall likes to kill the conky we are respawning if we don't, which is lame

if command killall -q conky; then
    LC_ALL=en_US.UTF-8 /usr/bin/conky -qd
else
    LC_ALL=en_US.UTF-8 /usr/bin/conky -qd
fi
