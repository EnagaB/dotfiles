#!/bin/bash
set -u

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"
. "${setup_dir}/config.sh"
. "${setup_dir}/utils.sh"

install_apt_packages "${install_apt_tex_packages[@]}"
