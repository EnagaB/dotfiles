#!/bin/bash
set -u
echo "Add git alias"

git config --global alias.s "status -sb"
git config --global alias.d "diff"
git config --global alias.tree 'log --graph --all --format="%x09%C(cyan bold)%an%Creset%x09%C(yellow)%h%Creset %C(magenta reverse)%d%Creset %s"'
