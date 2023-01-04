#!/usr/bin/env zsh

export DOTSH=${HOME}/dotfiles/etc/shell
. ${DOTSH}/shenv.bash
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
typeset -U PATH

# EOF
