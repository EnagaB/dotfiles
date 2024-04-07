#!/bin/bash
set -u

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"
libsh_dir="${root_dir}/lib/sh"
setup_dir="${root_dir}/setup"
. "${libsh_dir}/echos.sh"
. "${setup_dir}/npm_utils.sh"

wsl_packs=(wsl-open)

for packtype in "$@"; do
    if [ "$packtype" = 'wsl' ]; then
        install_npm_global_packages "${wsl_packs[@]}"
    else
        echo_err "ERROR: Not support npm package type $packtype"
    fi
done
