#!/bin/bash
set -u

echo "Setup git"

git config --global core.ignorecase false
git config --global core.quotepath false
git config --global core.safecrlf true
git config --global core.autocrlf false

git config --global color.ui auto

git config --global credential.helper 'cache --timeout 3600'

git config --global merge.ff false
git config --global pull.ff only

git config --global push.default simple

git config --global alias.s "status -sb"
git config --global alias.d "diff"
git config --global alias.tree \
    'log --graph --pretty=format:"%x09%C(cyan)%an%Creset%x09%C(yellow)%h%Creset %s%C(auto)%d%Creset"'
