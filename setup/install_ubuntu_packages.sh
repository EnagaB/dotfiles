#!/bin/bash
set -u

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"
libsh_dir="${root_dir}/lib/sh"
setup_dir="${root_dir}/setup"
. "${libsh_dir}/echos.sh"
. "${setup_dir}/apt_utils.sh"
. "${setup_dir}/snap_utils.sh"

basic_packs=(
    bash zsh shellcheck
    curl wget git zip unzip
    fzf file nkf bc busybox
    # peco
    # fzy
)

image_editor_packs=(
    inkscape imagemagick poppler-utils pstoedit epstool
    # gimp
)

text_editor_repos=(
    # ppa:jonathonf/vim
    ppa:neovim-ppa/stable
)
text_editor_packs=(
    neovim
    # emacs
    # vim vim-gnome
)
text_editor_snap_packs=(nvim)

viewer_packs=(
    # feh okular zathura
    gnuplot-x11
    # eog evince
)

jp_packs=(
    language-pack-ja manpages-ja manpages-ja-dev
    fcitx fcitx-mozc
    fontconfig fonts-noto
    # fonts-ipafont
    # fonts-ipaexfont
)

python_packs=(python3.9 python3.9-distutils tk-dev python3-tk)

programming_packs=(
    build-essential cmake make gfortran gcc g++
    # golang rustc nodejs
    liblapack-dev libblas-dev
)

tex_packs=(
    texlive-latex-base texlive-latex-extra texlive-latex-recommended
    texlive-publishers texlive-extra-utils
    texlive-lang-japanese xdvik-ja
    texlive-plain-generic texlive-fonts-recommended texlive-fonts-extra
    texlive-luatex latexmk
    # texlive-lang-cjk
)

x11_packs=(
    x11-apps
    x11-utils
    x11-xserver-utils
    dbus-x11
    xauth
    xsel
    xclip
)

for packtype in "$@"; do
    if [ "$packtype" = 'basic' ]; then
        install_apt_packages "${basic_packs[@]}"
    elif [ "$packtype" = 'image_editor' ]; then
        install_apt_packages "${image_editor_packs[@]}"
    elif [ "$packtype" = 'text_editor' ]; then
        if is_snap_available; then
            install_snap_packages_classic "${text_editor_snap_packs[@]}"
        else
            add_apt_repositories "${text_editor_repos[@]}"
            install_apt_packages "${text_editor_packs[@]}"
        fi
    elif [ "$packtype" = 'viewer' ]; then
        install_apt_packages "${viewer_packs[@]}"
    elif [ "$packtype" = 'jp' ]; then
        install_apt_packages "${jp_packs[@]}"
    elif [ "$packtype" = 'python' ]; then
        install_apt_packages "${python_packs[@]}"
    elif [ "$packtype" = 'programming' ]; then
        install_apt_packages "${programming_packs[@]}"
    elif [ "$packtype" = 'tex' ]; then
        install_apt_packages "${tex_packs[@]}"
    elif [ "$packtype" = 'x11' ]; then
        install_apt_packages "${x11_packs[@]}"
    else
        echo_err "ERROR: Not support apt package type $packtype"
    fi
done
