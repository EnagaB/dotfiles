#!/bin/bash
set -u
usage="usage: $ bash $0 [all]

setup development environment.
If 'all' is given, install packages and fonts. The package installation
require administrative privilege."

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit; pwd)"

echo "Load config"
. "${root_dir}/config_setup.sh"

echo "Confirm running without administrative privilege."
if [ "$EUID" -eq 0 ];then
    echo_error "ERROR: EUID is 0. Run with administrative privilege."
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
    echo_error "ERROR: Invalid arguments."
    echo "$usage"
    exit 1
fi

os_name="$(get_os_name)"
echo "OS: $os_name"

echo "Make directories."
for _resrc_dir in "${make_resrc_directories[@]}"; do
    for _sub_dir in "${resrc_sub_directories[@]}"; do
        _make_dir="${_resrc_dir}/${_sub_dir}"
        _mkdir "$_make_dir"
    done
done
for _make_dir in "${make_directories[@]}"; do
    _mkdir "$_make_dir"
done

echo "Install packages"
if "$run_all" && [ "$os_name" = "ubuntu" ]; then
    echo "Install apt packages"
    install_apt_packages "${install_apt_repository_packages[@]}"
    for repo in "${add_apt_repositories[@]}"; do
        sudo add-apt-repository -y "$repo"
    done
    install_apt_packages "${install_apt_packages[@]}"
fi
if "$run_all"; then
    echo "Install npm packages"
    npm config set prefix "$npm_dir"
    npm install -g npm
    npm install -g "${install_npm_packages[@]}"
fi
if "$run_all"; then
    echo "Install fonts and generate caches"
    _ord_dir="$(pwd)"
    cd "$fonts_dir"
    for install_font in "${install_fonts[@]}"; do
        echo "install $install_font"
        font_filename="$(basename "${install_font}")"
        curl -L "$install_font" -o "$font_filename"
        unzip -o "$font_filename"
        rm "$font_filename"
    done
    fc-cache -fv "$fonts_dir"
    cd "$_ord_dir"
fi

echo "Setup git global configs"
setup_git_global_configs

echo "Make links"
for link_df2home_dir in "${link_dotfiles2home_dir[@]}"; do
    link_files=($(find "$link_df2home_dir" -maxdepth 1 -name ".*" -printf "%f\n"))
    for link_file in "${link_files[@]}"; do
        [ "$link_file" = '.' ] && continue
        [ "$link_file" = '..' ] && continue
        [ "$link_file" = '.gitignore' ] && continue
        [ "$link_file" = '.zcompdump' ] && continue
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
