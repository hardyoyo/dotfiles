#!/bin/bash

echo
echo "PTO EVENTS FOR THE LAST MONTH"
echo
icalBuddy -eep 'start,summary' -po 'date,title' eventsFrom:"$(date -v -1m -v 1d '+%Y-%m-%d')" to:"$(date '+%Y-%m-%d')" | grep -A 1 PTO:
echo
exit 0
