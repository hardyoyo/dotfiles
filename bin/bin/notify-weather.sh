#!/bin/bash

notify-send -t 30000 "        *** Weather ***" "$(ansiweather -f 5 -l 4381982 -u imperial -a off | sed -e 's/ - /\n/g')"
