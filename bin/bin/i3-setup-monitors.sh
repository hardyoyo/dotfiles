#!/bin/bash

notify-send 'Restoring monitor preferences...'

# how many monitors are connected?
M=$(xrandr --listactivemonitors | head -n1)

NM=""${M: -1}""

# always set the resolution of the embedded notebook display to something readable
xrandr --output eDP-1 --mode 2560x1440 --dpi 96

# conditional setup depending on how many monitors are present
# scenario 1: 3 or more monitors, we must be home

if [ "$NM" -gt 2 ]
then
    # WE ARE HOME, DO THE RIGHT THING
    notify-send 'More than two monitors present, assuming we are home...'

    # set the resolutions of all the monitors to what is comfortable on my desk
    xrandr --output HDMI-2 --mode 1280x1024 --dpi 96
    xrandr --output eDP-1 --mode 1600x900 --dpi 96
    # xrandr --output DP-1 --mode 3840x2400 --dpi 96 --scale 2x2
    xrandr --output DP-1 --mode 1920x1200 --dpi 96 

    # set up the relative positioning of my monitors on my desk
    xrandr --output HDMI-2 --left-of DP-1 --output DP-1 --left-of eDP-1

    # set up the rotation of my left-most monitor
    xrandr --output HDMI-2 --rotate left

    # set DP-1 as the primary monitor
    xrandr --output DP-1 --primary

    # set up Terminator to use the tiny profile, DOESN'T WORK
    #export TERMINAL="/usr/bin/terminator -p tiny"
else
    # WE ARE NOT HOME, set the embedded monitor as our primary
    notify-send 'Two or fewer monitors present, assuming we are NOT home...'
    xrandr --output eDP-1 --primary

fi

# set the DPI of all the monitors, just to be sure
xrandr --dpi 96


# TODO: get fancy for the 2-monitor situation, if necessary

exit 0
