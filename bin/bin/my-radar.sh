#!/bin/bash
echo ------------------- MY RADAR ------------------- && echo && /usr/local/bin/icalBuddy -eep 'notes,location' -df '%a %b-%d-%Y (%RD)' -sd -t -nc -n -nrd -sed eventsToday+7

exit 0
