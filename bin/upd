#!/usr/bin/env bash
set -u

packcmd="$1"

if [[ "$packcmd" =~ apt ]];then
  sudo apt update
  if [[ ! "$packcmd" =~ full ]];then
    sudo apt -y upgrade
  else
    sudo apt -y full-upgrade
    sudo apt -y autoremove
    sudo apt -y autoclean
  fi
  # apt-file
  sudo apt-file update
fi

# end
