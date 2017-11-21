#!/bin/bash

# super quick and dirty way to finish up the Vagrant setup, since I can't quite work out all the kinks in the local-bootstrap

cd ~/dotfiles
rm ~/.gitconfig && stow bin
rm ~/.bash_logout ~/.bashrc ~/.inputrc && stow shell
stow tmux
stow vim
vim +PluginInstall +qall -q /dev/null
cd ~/dspace-src && git checkout ucla-vsim-6_x
mkdir ~/workspace
cd ~/workspace
ln -s ~/dspace-src dspace
ln -s ~/dspace-src/dspace/modules/xmlui-mirage2/src/main/webapp/themes/Mirage2 mirage2
ln -s ~/dspace-src/dspace/modules/xmlui/
ln -s ~/dspace-src/dspace/modules/xmlui/src/main/webapp/i18n i18n
