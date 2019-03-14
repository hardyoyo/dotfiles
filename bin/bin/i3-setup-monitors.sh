#!/bin/bash

notify-send 'Restoring monitor preferences...'

# how many monitors are connected?
M=$(xrandr --listactivemonitors | head -n1)

NM=""${M: -1}""

# always set the resolution of the embedded notebook display to something readable
xrandr --output eDP-1 --mode 1920x1080

# conditional setup depending on how many monitors are present
# scenario 1: 3 or more monitors, we must be home

if [ "$NM" -gt 2 ]
then
    # WE ARE HOME, DO THE RIGHT THING
    notify-send 'More than two monitors present, assuming we are home...'

    # set up the relative positioning of my monitors on my desk
    xrandr --output HDMI-2 --left-of DP-1 --output DP-1 --left-of eDP-1

    # set up the rotation of my left-most monitor
    xrandr --output HDMI-2 --rotate left

    # set DP-1 as the primary monitor
    xrandr --output DP-1 --primary
else
    # WE ARE NOT HOME, set the embedded monitor as our primary
    notify-send 'Two or fewer monitors present, assuming we are NOT home...'
    xrandr --output eDP-1 --primary

fi


# TODO: get fancy for the 2-monitor situation, if necessary

exit 0
