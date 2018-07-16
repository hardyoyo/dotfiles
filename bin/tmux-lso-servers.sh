#!/bin/sh
tmux new-session -d -s lso
 
tmux new-window -t lso:1 -n 'dev' 'ssh -A dev'
tmux new-window -t lso:2 -n 'live' 'ssh -A live'
tmux new-window -t lso:3 -n 'db' 'ssh -A db'
 
tmux select-window -t lso:1
tmux -2 attach-session -t lso
