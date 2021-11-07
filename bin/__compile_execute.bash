#!/usr/bin/env bash
set -u
# $ <this> <compile_out_file> <exe_file> <arg>...
# compile execute ($ <arg>... )
# compile_messages output stdout to <compile_stdout_file> and stderr to <compile_stderr_file>
# if compile_output do not exist, execute ($ ./<exe_file>)
# $ <this> -a <compile_out_file> <exe_file> <arg1> <arg2>...
# <arg1> is file. compile cmd is automatically decided by <arg1>.

while getopts ac OPT; do
  case $OPT in
    a) declare -r opt_a=1 ;; # auto commands
    c) declare -r opt_c=1 ;; # compile only
  esac
done
shift $((OPTIND-1))

# parameters
declare comp_out_file="$1"
declare exe_file="$2"
shift 2

# echo color
declare -r Esc="$(builtin printf '\033')"
declare -r Reset="${Esc}[m"
declare -r Cmess="${Esc}[32m" # green
declare -r Cerr="${Esc}[31m"  # red

# compiler array
declare -ar compilers=(
gfortran
gcc g++
)
ch_compiler() {
  local argcpl="$1"
  local i
  for i in ${compilers[@]}; do
    [[ ${i} = ${argcpl} ]] && return 0
  done
  return 1
}

# functions
function compile_execute() {
  if ch_compiler "$1"; then
    # compile
    echo ${Cmess}"[compile]"${Reset}
    "$@" -o "$exe_file" &> "$comp_out_file"
    # compile err
    if [[ -s "$comp_out_file" ]];then
      echo ${Cerr}"[compile error]"${Reset}
      cat "$comp_out_file"
      exit 1
    fi
    # execute
    [[ "${opt_c:-0}" -ne 0 ]] && exit 0
    echo ${Cmess}"[execute ${exe_file}]"${Reset}
    ./"$exe_file"
  else
    [[ "${opt_c:-0}" -ne 0 ]] && exit 0
    echo ${Cmess}"[execute]"${Reset}
    "$@"
  fi
}

# opt -a
if [[ "${opt_a:-0}" -ne 0 ]];then
  declare -r efile="$1"
  declare -r ext="${efile##*.}"
  declare -r efile_rmext="${efile%.$ext}"
  declare -r longext="${efile_rmext##*.}.${ext}"
  if [[ "$longext" = 'atc.cpp' ]];then
    compile_execute g++ -D_DEBUG -std=gnu++17 -Wall -Wextra -O2 -DONLINE_JUDGE -I/opt/boost/gcc/include -L/opt/boost/gcc/lib -I/opt/ac-library "$@"
  elif [[ "$ext" = 'cpp' ]];then
    compile_execute g++ "$@"
  fi
  [[ "$ext" = 'c'  ]] && compile_execute gcc "$@"
  [[ "$ext" = 'py' ]] && compile_execute python "$@"
  exit 0
fi

# no opt
compile_execute "$@"

# end
