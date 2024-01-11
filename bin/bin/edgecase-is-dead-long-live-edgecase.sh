#!/bin/bash

# renames this computer "edgecase" because I like it that way

sudo /usr/sbin/scutil --set ComputerName "edgecase"
sudo /usr/sbin/scutil --set HostName "edgecase"
sudo /usr/sbin/scutil --set LocalHostName "edgecase"

exit 0
