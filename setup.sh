#!/bin/bash
set -u
usage="usage: $ bash $0 [all]

setup development environment.
If 'all' is given, install packages and fonts. The package installation
require administrative privilege."

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"

# parameters
local_dir=${LOCAL:-${HOME}/.local}
trashcan_dir=${TRASHCAN:-${HOME}/.t}
npm_dir="${HOME}/.npm-global"
fonts_dir="${HOME}/.fonts"
make_root_directories=(
    "$local_dir"
)
make_directories=(
    "${trashcan_dir}"
    "${HOME}/.config/zathura"
    "${HOME}/.symlinks"
    "$npm_dir"
    "$fonts_dir"
)
# packages
apt_repository_packages=(
    software-properties-common
    ppa-purge
)
apt_repositories=(
    ppa:jonathonf/vim
    ppa:neovim-ppa/stable
)
apt_packages=(
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
npm_global_packages=(wsl-open)
# fonts
font_urls=(
    'https://github.com/yuru7/HackGen/releases/download/v2.5.2/HackGenNerd_v2.5.2.zip'
    'https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
)
# git config
git_setup_sh="${root_dir}/tools/setup_git_global_configs.sh"
# link
link_dotfiles2home_dir=(
    "${root_dir}/dotfiles"
)
link_srcdsts=(
    "${root_dir}/dotfiles/.vim" "${HOME}/.config/nvim"
    "${root_dir}/dotfiles/zathurarc" "${HOME}/.config/zathura/zathurarc"
)

lib_dir="${root_dir}/lib/sh"
. "${lib_dir}/packages.sh"
. "${lib_dir}/system.sh"

echo "Confirm running without administrative privilege."
if [ "$EUID" -eq 0 ];then
    echo -e "\e[31mERROR: EUID is 0. Run with administrative privilege.\e[m"
    echo "$usage"
    exit 1
fi

echo "Parse arguments"
run_all=false
_n_args="$#"
_args=("$@")
_invalid_args=false
if [ "$_n_args" -lt 2 ]; then
    for _arg in "${_args[@]}"; do
        case "$_arg" in
            "all") run_all=true ;;
            *) _invalid_args=true ;;
        esac
    done
else
    _invalid_args=true
fi
if $_invalid_args; then
    echo -e "\e[31mERROR: Invalid arguments.\e[m"
    echo "$usage"
    exit 1
fi

os_name="$(get_os_name)"
echo "OS: $os_name"

echo "Make directories."
make_root_directory "${make_root_directories[@]}"
mkdir -p "${make_directories[@]}"

echo "Install packages"
if "$run_all" && [ "$os_name" = "ubuntu" ]; then
    echo "Install apt packages"
    install_apt_packages "${apt_repository_packages[@]}"
    add_apt_repositories "${apt_repositories[@]}"
    install_apt_packages "${apt_packages[@]}"
fi
if "$run_all"; then
    echo "Install npm packages"
    npm config set prefix "$npm_dir"
    install_npm_global_packages "${npm_global_packages[@]}"
fi
if "$run_all"; then
    echo "Install fonts and generate caches"
    install_fonts_from_urls "${font_urls[@]}"
fi

echo "Setup git global configs"
bash "$git_setup_sh"

echo "Make links"
for link_df2home_dir in "${link_dotfiles2home_dir[@]}"; do
    link_files=($(find "$link_df2home_dir" -maxdepth 1 -name ".*" -printf "%f\n"))
    for link_file in "${link_files[@]}"; do
        [ "$link_file" = '.' ] && continue
        [ "$link_file" = '..' ] && continue
        [ "$link_file" = '.gitignore' ] && continue
        [ "$link_file" = '.zcompdump' ] && continue
        [ "$link_file" = '.DS_Store' ] && continue
        [[ "$link_file" =~ \.zwc$ ]] && continue
        ln -snfv "${link_df2home_dir}/${link_file}" "${HOME}/${link_file}"
    done
done
i_cnt=-1
for link_srcdst in "${link_srcdsts[@]}"; do
    i_cnt=$(($i_cnt + 1))
    if [[ $(($i_cnt % 2)) -eq 0 ]]; then
        src_pth="$link_srcdst"
        continue
    fi
    dst_pth="$link_srcdst"
    ln -snfv "$src_pth" "$dst_pth" 
done
