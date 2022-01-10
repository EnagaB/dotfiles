#!/usr/bin/env bash
# build develop environment in ubuntu + apt
# > bash buildenv.bash
# assump 1: path of config file is ./config.bash
#        2: path of src dir is ./src
#        3: bash
set -u

### check
# non su
if [ "$EUID" -eq 0 ];then
  echo "Please run as non-root"
  exit 1
fi

# get option
for opt in "$@"; do
  case "$opt" in
    --no-admin) declare -r use_admin=false ;;
    --no-install) declare -r install_packages=false ;;
    *)
      echo "Error: Option ${opt} is not implemented."
      exit 1
      ;;
  esac
done
[[ ! -v use_admin ]] && declare -r use_admin=true
[[ ! -v install_packages ]] && declare -r install_packages=true

# os
[[ $(uname -s) =~ ^CYGWIN ]] && declare -r os='cygwin'
[[ ! -v os ]] && declare -r os='ubuntu'

### path
# dir
declare -r spt=$(cd $(dirname ${BASH_SOURCE[0]:-$0}); pwd)
declare -r src=${spt}/src
# config
declare -r config=${spt}/config.bash
# path
declare -r df=${DOTFILES:-${HOME}/df}
declare -r loc=${LOCAL:-${HOME}/.local}
declare -r tbox=${TRASHBOX:-${HOME}/.t}
declare -r dfbin=${df}/bin
declare -r dfsrc=${df}/src
declare -r dfetc=${df}/etc
declare -r dfsh=${dfetc}/shell
declare -r appconfig=${HOME}/.config
# src
declare -r sh_mkdir_init=${src}/mkdir_init.bash
declare -r sh_link=${src}/link.bash
declare -r sh_apt_install=${src}/apt_install.bash
declare -r sh_curl_install=${src}/curl_install.bash
declare -r sh_git_install=${src}/git_install.bash
declare -r sh_cpp_build=${src}/cpp_build.bash

### WD
cd $df

### source parameters/config
. "$config"

### make dirs
. $sh_mkdir_init

### install packages
# apt
[[ "$os" = 'ubuntu' ]] && \
  $install_package && \
  $use_admin && \
  type apt &> /dev/null && \
  . $sh_apt_install
# curl
$install_package && \
  type curl &> /dev/null && \
  . $sh_curl_install
# git
$install_package && \
  type git &> /dev/null && \
  . $sh_git_install

### build
type g++ &> /dev/null && . $sh_cpp_build

### link
. $sh_link

# EOF
