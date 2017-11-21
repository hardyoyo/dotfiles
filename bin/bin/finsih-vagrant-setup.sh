#!/bin/bash

# super quick and dirty way to finish up the Vagrant setup, since I can't quite work out all the kinks in the local-bootstrap

cd ~/dotfiles
rm ~/.gitconfig && stow bin
rm ~/.bash_logout ~/.bashrc ~/.inputrc && stow shell
stow tmux
stow vim
vim +PluginInstall +qall -q /dev/null
