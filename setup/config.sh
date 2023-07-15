#!/bin/bash
set -u

# paths
dotfiles_dir=${DOTFILES:-${HOME}/dotfiles}
local_dir=${LOCAL:-${HOME}/.local}
trashbox_dir=${TRASHBOX:-${HOME}/.t}
config_dir=${HOME}/.config
npm_dir="${HOME}/.npm-global"
fonts_dir="${HOME}/.fonts"

make_resrc_directories=(
    "$local_dir"
)
make_directories=(
    "${trashbox_dir}"
    "${HOME}/.config/zathura"
    "$npm_dir"
    "$fonts_dir"
)

# packages
install_apt_repository_packages=(
    software-properties-common
    ppa-purge
)
add_apt_repositories=(
    ppa:jonathonf/vim
    ppa:neovim-ppa/stable
)
install_apt_packages=(
    bash zsh shellcheck
    curl wget git unzip
    emacs vim vim-gnome neovim
    tmux
    language-pack-ja manpages-ja manpages-ja-dev
    fcitx fcitx-mozc
    fontconfig fonts-ipafont fonts-ipaexfont fonts-noto
    x11-apps x11-utils x11-xserver-utils dbus-x11 xauth
    feh okular zathura # eog evince
    build-essential cmake make gfortran gcc g++
    liblapack-dev libblas-dev
    python3.9 python3.9-distutils tk-dev python3-tk
    golang rustc nodejs npm
    gnuplot-x11 xsel xclip
    w3m
    fzf # peco fzy
    file nkf bc
    busybox
)
install_apt_image_edit_packages=(
    inkscape
    # gimp
    imagemagick
    poppler-utils
    pstoedit
    epstool
)
install_apt_tex_packages=(
    texlive-latex-base texlive-latex-extra texlive-latex-recommended
    texlive-publishers texlive-extra-utils
    texlive-lang-japanese # texlive-lang-cjk
    xdvik-ja
    texlive-plain-generic
    texlive-fonts-recommended texlive-fonts-extra
    texlive-luatex
    latexmk
)
install_npm_packages=(wsl-open)

# fonts
install_fonts=(
    'https://github.com/yuru7/HackGen/releases/download/v2.5.2/HackGenNerd_v2.5.2.zip'
    'https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
)

# link
link_dotfiles2home_dir=(
    "${dotfiles_dir}/etc"
    "${dotfiles_dir}/etc/shell"
)
link_srcdsts=(
    "${dotfiles_dir}/template" "${HOME}/.template"
    "${dotfiles_dir}/etc/vim" "${HOME}/.vim"
    "${dotfiles_dir}/etc/vim" "${HOME}/.config/nvim"
    "${dotfiles_dir}/etc/emacs" "${HOME}/.emacs.d"
    "${dotfiles_dir}/etc/template" "${HOME}/.template"
    "${dotfiles_dir}/etc/zathurarc" "${HOME}/.config/zathura/zathurarc"
)
