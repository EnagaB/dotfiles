#!/usr/bin/env bash
set -u

declare -ar packages=(
  texlive-latex-base texlive-latex-extra texlive-latex-recommended
  texlive-publishers texlive-extra-utils
  texlive-lang-japanese # texlive-lang-cjk
  xdvik-ja
  texlive-plain-generic
  texlive-fonts-recommended texlive-fonts-extra
  texlive-luatex
  latexmk
)

declare -r script_dir=$(cd $(dirname ${BASH_SOURCE[0]:-$0}); pwd)
. "${script_dir}/modules/utils.bash"

install_packages "${packages[@]}"
