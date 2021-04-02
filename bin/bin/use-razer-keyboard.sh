#!/bin/bash

FROM='"HIDKeyboardModifierMappingSrc"'
TO='"HIDKeyboardModifierMappingDst"'

ARGS=""
function Map # FROM TO
{
    CMD="${CMD:+${CMD},}{${FROM}: ${1}, ${TO}: ${2}}"
}

# Plenty of good Usage ID codes can be found here:
# https://developer.apple.com/library/archive/technotes/tn2450/_index.html

# More esoteric Usage ID codes can be found here:
# https://www.usb.org/sites/default/files/hut1_21.pdf

SHIFT_LOCK="0x700000039"
R_COMMAND="0x7000000E7"
L_COMMAND="0x7000000E3"
L_ALT="0x7000000E2"
R_ALT="0x7000000E6"
R_CONTROL="0x7000000E4"
L_CONTROL="0x7000000E0"
NUMLOCK="0x700000053"
SCROLLLOCK="0x700000047"
PAUSE="0x700000048"
PRINTSCREEN="0x700000046"
VOLUP="0x700000080"
VOLDOWN="0x700000081"
VOLMUTE="0x70000007F"

# make the left command key act like left alt
Map ${L_COMMAND} ${L_ALT}
#
# make the right alt key act like right command
Map ${R_ALT} ${R_COMMAND}

# make the left alt key act like left command
Map ${L_ALT} ${L_COMMAND}

hidutil property --set "{\"UserKeyMapping\":[${CMD}]}"
