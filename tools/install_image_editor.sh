#!/bin/bash
set -u

packages=(
    inkscape
    # gimp
    imagemagick
    poppler-utils
    pstoedit
    epstool
)

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"
. "${root_dir}/lib/sh/packages.sh"
install_apt_packages "${packages[@]}"
