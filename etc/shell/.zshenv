#!/usr/bin/env zsh

export DOTSH=${HOME}/dotfiles/etc/shell
. ${DOTSH}/shenv.sh
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

typeset -U PATH
