#!/usr/bin/env bash
# build develop environment in ubuntu + apt
set -u

### functions
function apt_upgrade_packages() {
  echo '[upgrade packages]'
  sudo apt update && sudo apt -y upgrade
}
# function apt_install_package() {
#   local -r pack="$1"
#   if ! dpkg -L "$pack" &> /dev/null ;then
#     # not installed
#     echo "[${pack}: install]"
#     sudo apt -y install "$pack"
#     return 0
#   else
#     # already installed
#     echo "[${pack}: already installed]"
#     return 1
#   fi
# }
function apt_install_package() {
  local -r pack="$1"
  echo "[${pack}: install]"
  sudo apt -y install "$pack"
}
function apt_add_repository() {
  local repo="${1##*\:}"
  if ! cat /etc/apt/sources.list.d/*.list | grep "${repo}" &>/dev/null ;then
    echo "[${1}: add]"
    sudo add-apt-repository -y "$1"
  else
    echo "[${1}: already added]"
  fi
}

# install packages for repositories
apt_upgrade_packages
for pk in ${apt_repo_packs[@]}; do
  apt_install_package "$pk"
done

# add repositories
for rp in ${apt_ppa_repos[@]}; do
  apt_add_repository "$rp"
done
apt_upgrade_packages

# Install packages
for pk in ${apt_packs[@]}; do
  apt_install_package "$pk"
done

# EOF
