#!/usr/bin/env bash
# build develop environment in ubuntu + apt
# > bash buildenv.bash
# assump 1: path of this script is /path/to/dotfiles/<scrdir>/<this_script>
#        2: path of config file is /path/to/dotfiles/<scrdir>/config.bash
#        3: path of src dir is /path/to/dotfiles/src/<scrdir>
#        4: bash
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

### get path (assump 1-3)
# dir
declare -r scrdir=$(cd $(dirname ${BASH_SOURCE[0]:-$0}); pwd)
declare -r df=$(dirname $scrdir)
declare -r src=${df}/src/$(basename $scrdir)
# file
declare -r config=${scrdir}/config.bash

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

### link
. $sh_link

# EOF
