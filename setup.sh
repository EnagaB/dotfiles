#!/bin/bash
set -u
usage="usage: $ bash $0 [all]

setup development environment.
If 'all' is given, install packages and fonts. The package installation
require administrative privilege."

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"
setup_dir="${root_dir}/setup"
libsh_dir="${root_dir}/lib/sh"
. "${libsh_dir}/echos.sh"
. "${libsh_dir}/os.sh"
. "${setup_dir}/utils.sh"

local_dir=${LOCAL:-${HOME}/.local}
ins_ubuntu_packs_sh="${setup_dir}/install_ubuntu_packages.sh"
ins_npm_packs_sh="${setup_dir}/install_npm_packages.sh"
ins_fonts_sh="${setup_dir}/install_fonts.sh"
setup_git_sh="${setup_dir}/setup_git.sh"
make_links_sh="${setup_dir}/make_links.sh"

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
    echo_err "ERROR: Invalid arguments."
    echo "$usage"
    exit 1
fi

echo "Make directories."
make_root_directory "$local_dir"

if "$run_all"; then
    echo "Install packages"
    if is_ubuntu; then
        bash "$ins_ubuntu_packs_sh" basic
        bash "$ins_ubuntu_packs_sh" text_editor
        bash "$ins_ubuntu_packs_sh" jp
        bash "$ins_ubuntu_packs_sh" python
        bash "$ins_ubuntu_packs_sh" programming
        bash "$ins_ubuntu_packs_sh" x11
    fi
    if is_wsl; then
        bash "$ins_npm_packs_sh" wsl
    fi
    echo "Install fonts"
    bash "$ins_fonts_sh" "PlemolJP"
fi

bash "$setup_git_sh"
bash "$make_links_sh"
