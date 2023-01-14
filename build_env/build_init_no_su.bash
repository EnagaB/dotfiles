#!/usr/bin/env bash
set -u
declare -r script_dir=$(cd $(dirname ${BASH_SOURCE[0]:-$0}); pwd)
bash "${script_dir}/build_init.bash" --no-admin --no-install
