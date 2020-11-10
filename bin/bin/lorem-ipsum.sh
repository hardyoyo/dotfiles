#!/bin/bash

# uses the very handy https://github.com/per9000/lorem

echo
echo

#lorem -l 3 --spook --randomize # probably too exciting
#lorem -l 3 --randomize # too boring
lorem -l 3 --randomize | pbcopy && pbpaste

echo
echo "^^^ this text copied to your clipboard already..."
echo
read -n 1 -s -r -p "Press any key to continue..."

