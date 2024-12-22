#!/bin/bash
set -u
usage="usage: $ bash $0 [all]

setup development environment.
If 'all' is given, install packages and fonts. The package installation
require administrative privilege."

echo "Confirm running without administrative privilege."
if [ "$EUID" -eq 0 ];then
    echo_err "ERROR: EUID is 0. Run with administrative privilege."
    echo "$usage"
    exit 1
fi

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"
setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"
libsh_dir="${root_dir}/lib/sh"
local_dir="${LOCAL:-"${HOME}/.local"}"
fonts_dir="${HOME}/.fonts"

echo "Import functions"
. "${libsh_dir}/echos.sh"
. "${libsh_dir}/os.sh"
. "${libsh_dir}/wsl.sh"
for setup_src in $(ls "${setup_dir}/src"/*.sh); do
    . "$setup_src"
done

echo "Parse arguments"
. "${setup_dir}/parse_args.sh"
echo "run all: $run_all"

# make directory
echo "Make directories"
make_root_directory "$local_dir"
[ ! -d "$fonts_dir" ] && mkdir -p "$fonts_dir"

if "$run_all"; then
    echo "Install packages"
    install_apt_packages \
        bash zsh shellcheck \
        curl wget git zip unzip zstd \
        fzf file nkf bc busybox \
        software-properties-common ppa-purge gpg
    install_apt_packages \
        language-pack-ja manpages-ja manpages-ja-dev \
        fcitx fcitx-mozc \
        fontconfig fonts-noto
    install_apt_packages \
        build-essential cmake make gfortran gcc g++ \
        liblapack-dev libblas-dev
    install_apt_packages python3-full tk-dev
    install_apt_packages \
        x11-apps x11-utils x11-xserver-utils dbus-x11 \
        xauth xsel xclip
    install_apt_packages gnuplot-x11
    if is_snap_available; then
        install_snap_packages_classic nvim
    else
        add_apt_repositories 'ppa:neovim-ppa/stable'
        install_apt_packages neovim vim
    fi
    install_eza
    echo "Download fonts"
    download_fonts \
        'https://github.com/yuru7/PlemolJP/releases/download/v1.7.1/PlemolJP_v1.7.1.zip'
    fc-cache -fv "$fonts_dir"
fi

bash "${setup_dir}/setup_git.sh"
bash "${setup_dir}/make_links.sh"
