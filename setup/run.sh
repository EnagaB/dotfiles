#!/bin/bash
set -u
usage="usage: $ bash run.sh [all]

setup development environment.
If 'all' is given, install packages and fonts. The package installation
require administrative privilege."

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"
. "${setup_dir}/config.sh"
. "${setup_dir}/utils.sh"

echo "Confirm running without administrative privilege."
if [ "$EUID" -eq 0 ];then
    echo_error "ERROR: EUID is 0. Run with administrative privilege."
    echo "$usage"
    exit 1
fi

echo "Parse arguments."
n_args="$#"
args=("$@")
run_all=false
invalid_args=false
if [ "$n_args" -lt 2 ]; then
    for arg in "${args[@]}"; do
        case "$arg" in
            "all") run_all=true ;;
            *) invalid_args=true ;;
        esac
    done
else
    invalid_args=true
fi
if $invalid_args ; then
    echo_error "ERROR: Invalid arguments."
    echo "$usage"
    exit 1
fi

os_name="$(get_os_name)"
echo "OS: $os_name"

bash "${setup_dir}/make_directories.sh"
"$run_all" && [ "$os_name" = "ubuntu" ] && bash "${setup_dir}/install_apt_packages.sh"
"$run_all" && bash "${setup_dir}/install_npm_packages.sh"
"$run_all" && bash "${setup_dir}/install_fonts.sh"
bash "${setup_dir}/setup_git_configs.sh"
bash "${setup_dir}/make_links.sh"
