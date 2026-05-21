#!/usr/bin/env bash
set -euo pipefail

bold_underline=$'\033[1;4m'
reset=$'\033[0m'

today_date="$(date '+%A, %B %-d, %Y')"

echo "${bold_underline}TODAY — ${today_date}${reset}"

icalBuddy -nc -npn -nrd -df '%I:%M %p' -tf '%I:%M %p' eventsToday \
| awk '
  /^•/ { title=$0; sub(/^•[ \t]*/, "", title); next }
  /^[ \t]*[0-9][0-9]?:[0-9][0-9] [AP]M - [0-9][0-9]?:[0-9][0-9] [AP]M/ {
    line=$0; gsub(/^[ \t]+/,"",line)
    split(line, parts, " - ")
    start = parts[1]; end = parts[2]

    split(start, a, " "); t1=a[1]; m1=a[2]
    split(t1, b, ":"); sh=b[1]; sm=b[2]

    split(end, c, " ");   t2=c[1]; m2=c[2]
    split(t2, d, ":");    eh=d[1]; em=d[2]

    sub(/^0/,"",sh); sub(/^0/,"",eh)

    sdisp = (sm == "00" ? sh : sh ":" sm)
    edisp = (em == "00" ? eh : eh ":" em)

    sshort = (m1 == "AM" ? "am" : "pm")
    eshort = (m2 == "AM" ? "am" : "pm")

    if (sshort == eshort) {
      printf "%s–%s%s | %s\n", sdisp, edisp, sshort, title
    } else {
      printf "%s%s–%s%s | %s\n", sdisp, sshort, edisp, eshort, title
    }
  }
'

