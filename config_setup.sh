#!/bin/bash
set -u

# paths
local_dir=${LOCAL:-${HOME}/.local}
trashbox_dir=${TRASHCAN:-${HOME}/.t}
npm_dir="${HOME}/.npm-global"
fonts_dir="${HOME}/.fonts"

make_resrc_directories=(
    "$local_dir"
)
resrc_sub_directories=(bin etc include lib share src tmp)
make_directories=(
    "${trashbox_dir}"
    "${HOME}/.config/zathura"
    "${HOME}/.symlinks"
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
function install_apt_packages() {
    sudo apt -o Acquire::Retries=10 update \
        && sudo apt -o Acquire::Retries=10 upgrade -y \
        && DEBIAN_FRONTEND=noninteractive sudo apt -o Acquire::Retries=10 install -y \
        "$@"
}


# fonts
install_fonts=(
    'https://github.com/yuru7/HackGen/releases/download/v2.5.2/HackGenNerd_v2.5.2.zip'
    'https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
)

# git config
function setup_git_global_configs() {
    git config --global core.ignorecase false
    git config --global core.quotepath false
    git config --global core.safecrlf true
    git config --global core.autocrlf false
    git config --global color.ui auto
    git config --global credential.helper 'cache --timeout 3600'
    git config --global merge.ff false
    git config --global pull.ff only
    git config --global push.default simple
    git config --global alias.s "status -sb"
    git config --global alias.d "diff"
    git config --global alias.tree \
        'log --graph --pretty=format:"%x09%C(cyan)%an%Creset%x09%C(yellow)%h%Creset %s%C(auto)%d%Creset"'
}

# link
link_dotfiles2home_dir=(
    "${root_dir}/dotfiles"
)
link_srcdsts=(
    "${root_dir}/dotfiles/.vim" "${HOME}/.config/nvim"
    "${root_dir}/dotfiles/zathurarc" "${HOME}/.config/zathura/zathurarc"
)

function echo_error() {
    echo -en "\e[31m"
    echo -n "$@"
    echo -e "\e[m"
}

function get_os_name() {
    if [[ $(uname -s) =~ ^CYGWIN ]]; then
        echo "cygwin"
        return 0
    fi
    local os_release=/etc/os-release
    if [ -f "$os_release" ]; then
        if grep "Ubuntu" "$os_release" &> /dev/null; then
            echo "ubuntu"
        else
            return 1
        fi
        return 0
    fi
    return 1
}

function _mkdir() {
    make_dir="$1"
    if [ -d "$make_dir" ]; then
        echo "${make_dir}: already exists."
        return 0
    fi
    mkdir -pv "$make_dir"
}

function build_cmake() {
    local -r src_dir="$1"
    local -r dst_out="$2"
    local -r build_dir="${src_dir}/build"
    local -r dst_filename=$(basename "$dst_out")
    [[ -f "$dst_out" ]] && rm "$dst_out"
    [[ -d "$build_dir" ]] && rm -r "$build_dir"
    pushd "$src_dir"
    mkdir build \
        && cd build \
        && cmake .. \
        && make \
        && ln -snfv "${build_dir}/${dst_filename}" "$dst_out"
    popd
}
