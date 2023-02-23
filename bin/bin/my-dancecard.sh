#!/bin/bash

set -euo pipefail

echo ------------------- MY RADAR ------------------- && echo && /usr/local/bin/icalBuddy -eep 'notes,location' -df '%a %b-%d-%Y (%RD)' -sd -t -nc -n -nrd -sed eventsToday+7
echo
echo -----------TRELLO - dev current work------------ && echo && trellotool card list todo | grep hardy_cdl | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'
echo
echo ---------------TRELLO - up next----------------- && echo && trellotool card list "Up Next" | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'|sed -r 's/\/$//g'|tail -n6
echo
echo ---------------TRELLO - new -------------------- && echo && trellotool card list "New Since Last Check-in" | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'|sed -r 's/\/$//g'
echo
echo ---------------TRELLO - backlog----------------- && echo && trellotool card list 60523683a26f1a2b2456d42f | grep hardy_cdl | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'
echo
echo -------------- Janeway Latest Tag -------------- && printf "$(/usr/local/bin/gh api repos/BirkbeckCTP/janeway/tags | /usr/local/bin/jq '.[0].name' | /usr/bin/tr -d \")\n"
echo
rich --markdown  ~/.step-goals
echo
echo ----------------- Can\'t Wait\! ------------------ && days_until.py /Users/hpotting/.event_list.txt
echo
exit 0
