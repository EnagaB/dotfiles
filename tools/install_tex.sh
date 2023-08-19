#!/bin/bash
set -u

packages=(
    texlive-latex-base texlive-latex-extra texlive-latex-recommended
    texlive-publishers texlive-extra-utils
    texlive-lang-japanese # texlive-lang-cjk
    xdvik-ja
    texlive-plain-generic
    texlive-fonts-recommended texlive-fonts-extra
    texlive-luatex
    latexmk
)

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"
. "${root_dir}/lib/sh/packages.sh"
install_apt_packages "${packages[@]}"
