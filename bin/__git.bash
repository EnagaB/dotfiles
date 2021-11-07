#!/usr/bin/env bash
set -u

# parameters
declare -r editor='vim'
declare -r pager='cat'
declare -r dt="$(date +"%Y%m%dT%H%M%S%z")"

# get cmd arg
argcmd="$1"
shift 1

# exe
if [[ "$argcmd" = 'set.def' ]];then
  echo '[git config --global: set default]'
  git config --global core.editor "$editor"
  git config --global core.pager "$pager"
  git config --global color.ui auto
  git config --global credential.helper cache --timeout=86400
  git config --global push.default simple
  git config --global core.autocrlf false
  git config --global core.safecrlf true
  git config --global core.ignorecase false
  git config --global core.quotepath false
elif [[ "$argcmd" = 'set.name' ]];then
  echo "[git config --global: set user.name $1]"
  git config --global user.name "$1"
elif [[ "$argcmd" = 'set.email' ]];then
  echo "[git config --global: set user.email $1]"
  git config --global user.email "$1"
elif [[ "$argcmd" = 'push' ]];then
  echo '[git add -A]'
  git add -A || exit 1
  echo '[git commit -m "date"]'
  git commit -m "$dt" || exit 1
  echo '[git push]'
  git push
elif [[ "$argcmd" = 'pull' ]];then
  echo '[git pull]'
  git pull
fi

# end
