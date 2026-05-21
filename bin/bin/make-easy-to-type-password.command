#!/bin/bash

LHkeys='12345!@#$%qwertasdfgzxcv'
RHkeys='67890-=_+[]{};:,.<>yuiophjklbnm'

# left hand
lH () {
    LC_CTYPE=C </dev/urandom tr -dc "${LHkeys}" | head -c1
}
# right hand
rH () {
    LC_CTYPE=C </dev/urandom tr -dc "${RHkeys}" | head -c1
}

ezPassword () {
lH
rH
lH
rH
lH
rH
lH
rH
echo
}


echo
echo "Generating 12 random 8-character passwords, pick one..."
echo
for i in {1..12}
do
  ezPassword
done
echo
echo "REMEMBER! upcase at least one of those characters, you pick which one."
echo
read -n 1 -s -r -p "Press any key to continue..."
echo
