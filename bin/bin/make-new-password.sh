#!/bin/bash

punctuation="!*%#.@()[],"

echo
echo "Generating 12 random ten-character passwords, pick one..."

echo
for i in {1..12}
do
# strings < /dev/urandom | grep -o '[[:alnum:]]' | head -n 9 | tr -d '\n'; echo "${punctuation:$(( RANDOM % ${#punctuation} )):1}"
LC_CTYPE=C < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c9; echo "${punctuation:$(( RANDOM % ${#punctuation} )):1}"
done
echo
echo
read -n 1 -s -r -p "Press any key to continue..."

