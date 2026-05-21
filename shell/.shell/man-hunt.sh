#!/bin/env bash
function man-option {
  man "$1" | less -p "^ *$2"
}
