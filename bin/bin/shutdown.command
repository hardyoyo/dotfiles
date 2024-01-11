#!/bin/bash

# shutdown in a nice and orderly fashion

# first poweroff Lando

numContainers=$(docker ps | wc -l)
numContainers=$((numContainers - 1))


# if _=$(( numContainers > 0 ));
# then
#     # /usr/local/bin/lando poweroff
#     # let's try just stopping any docker container
#     docker stop $(docker ps -q)
#     # sometimes containers revive, we headshot those
#     # TODO: check for any running containers, this command complains if there aren't any to kill
#     #docker kill $(docker ps -q)
# fi

# shutdown any running mysql server
# brew services stop mysql 2>&1 /dev/null
# this is noisy and weird if mysql hasn't been started, mysql natively is dumb anyway

# finally, shutdown immediately

# just shutdown all applications right meow
sudo /sbin/shutdown -h now
# this normal shutdown remembers what applications were running, and restores them on boot, I'd prefer not to do that
# osascript -e 'tell application "System Events" to shut down'

