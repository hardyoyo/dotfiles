#!/bin/bash

set -euo pipefail

echo ------------------- MY RADAR ------------------- && echo && /opt/homebrew/bin/icalBuddy -eep 'notes,location' -df '%a %b-%d-%Y (%RD)' -sd -t -nc -n -nrd -sed eventsToday+7
echo
echo -----------TRELLO - dev current work------------ && echo && trellotool card list todo | grep hardy_cdl | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'
echo

sprints=($(trellotool list list | grep Week | grep HP | grep -oE '[0-9a-f]{24}'))
# current_sprint=$(trellotool list list | grep Week | grep HP | grep -oE '[0-9a-f]{24}' | head -n 1)
current_sprint="${sprints[0]}"
next_sprint="${sprints[1]}"

if [ -n "$current_sprint" ]; then
    echo -----------TRELLO - current sprint ------------- && echo && trellotool card list "$current_sprint" | grep hardy_cdl | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"), RLENGTH)}'|sed -r 's/ #/\//g'
else
    echo ---- GRATS\! YOU ARE A FLOATER THIS SPRINT\!--------
fi

if [ -n "$next_sprint" ]; then
    echo -------------TRELLO - next sprint ---------------- && echo && trellotool card list "$next_sprint" | grep hardy_cdl | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"), RLENGTH)}'|sed -r 's/ #/\//g'
else
    echo ---- GRATS\! YOU ARE A FLOATER NEXT SPRINT\!--------
fi


echo ---------------TRELLO - up next----------------- && echo && trellotool card list "Up Next" | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'|sed -r 's/\/$//g'|tail -n6
echo
echo ---------------TRELLO - new -------------------- && echo && trellotool card list "New Since Last Check-in" | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'|sed -r 's/\/$//g'|grep -vi "new since last check"
echo
echo ---------------TRELLO - backlog----------------- && echo && trellotool card list 60523683a26f1a2b2456d42f | grep hardy_cdl | awk -F '\|' '{print $3, $7"#"substr($3,match($3,"PUBD-[0-9]+"),RLENGTH)}'|sed -r 's/ #/\//g'
echo
echo -------------- Janeway Latest Tag -------------- && printf "$(/opt/homebrew/bin/gh api repos/BirkbeckCTP/janeway/tags | /opt/homebrew/bin/jq '.[0].name' | /usr/bin/tr -d \")\n"
echo
# echo -------------- ✨ STEP Goals  ✨ --------------- && rich --markdown  ~/.step-goals
rich --markdown --width 45 ~/.step-goals
echo
echo ----------------- Can\'t Wait\! ------------------ && days_until.py /Users/hpotting/.event_list.txt
echo
exit 0
