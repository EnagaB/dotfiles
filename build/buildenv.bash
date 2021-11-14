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
# bash (assump 4)
if ! ps --pid $$ -o command | tail -1 | grep  '^bash' &> /dev/null ;then
  echo "err: not bash"
  exit 1
fi


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
type apt &> /dev/null && . $sh_apt_install
type curl &> /dev/null && . $sh_curl_install
type git &> /dev/null && . $sh_git_install

### build
type g++ &> /dev/null && . $sh_cpp_build

### link
. $sh_link

# EOF
