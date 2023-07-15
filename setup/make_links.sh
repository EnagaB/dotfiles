#!/bin/bash
set -u

echo "Make links"

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")"; pwd)"
. "${setup_dir}/config.sh"

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
