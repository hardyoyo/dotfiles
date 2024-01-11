#!/bin/bash

# shutdown in a nice and orderly fashion

# first poweroff Lando

numContainers=$(docker ps | wc -l)
numContainers=$((numContainers - 1))


if _=$(( numContainers > 0 ));
then
    # /usr/local/bin/lando poweroff
    # let's try just stopping any docker container
    docker stop $(docker ps -q)
    # sometimes containers revive, we headshot those
    docker kill $(docker ps -q)
fi

# shutdown any running mysql server
brew services stop mysql

# finally, reboot immediately
sudo /sbin/reboot
