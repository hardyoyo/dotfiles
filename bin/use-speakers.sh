#!/bin/bash

#Default Sink: alsa_output.pci-0000_00_1f.3.analog-stereo
#Default Source: alsa_input.pci-0000_00_1f.3.analog-stereo

/usr/bin/pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
/usr/bin/pactl set-default-source alsa_input.pci-0000_00_1f.3.analog-stereo
