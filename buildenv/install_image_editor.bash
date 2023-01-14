#!/usr/bin/env bash
set -u

declare -ar packages=(
  inkscape
  # gimp
  imagemagick
  poppler-utils
  pstoedit
  epstool
)

declare -r script_dir=$(cd $(dirname ${BASH_SOURCE[0]:-$0}); pwd)
. "${script_dir}/modules/utils.bash"

install_packages "${packages[@]}"
