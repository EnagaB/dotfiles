#!/bin/bash
set -u

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"
. "${root_dir}/config_setup.sh"
install_apt_packages "${install_apt_tex_packages[@]}"
