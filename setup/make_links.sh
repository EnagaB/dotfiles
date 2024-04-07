#!/bin/bash
set -u

echo "Make links"

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit; pwd)"

dotfiles2home_dir=(
    "${root_dir}/dotfiles"
)

srcdsts=(
    "${root_dir}/dotfiles/.vim" "${HOME}/.config/nvim"
    "${root_dir}/dotfiles/zathurarc" "${HOME}/.config/zathura/zathurarc"
)
n_srcdsts=$(("${#srcdsts[@]}" / 2))

for df2home_dir in "${dotfiles2home_dir[@]}"; do
    link_files=($(find "$df2home_dir" -maxdepth 1 -name ".*" -printf "%f\n"))
    for link_file in "${link_files[@]}"; do
        [ "$link_file" = '.' ] && continue
        [ "$link_file" = '..' ] && continue
        [ "$link_file" = '.gitignore' ] && continue
        [ "$link_file" = '.zcompdump' ] && continue
        [ "$link_file" = '.DS_Store' ] && continue
        [[ "$link_file" =~ \.zwc$ ]] && continue
        ln -snfv "${df2home_dir}/${link_file}" "${HOME}/${link_file}"
    done
done

for i_sd in $(seq 0 $(($n_srcdsts - 1))); do
    i_src=$(($i_sd * 2))
    i_dst=$(($i_sd * 2 + 1))
    src_pth="${srcdsts[$i_src]}"
    dst_pth="${srcdsts[$i_dst]}"
    dst_parent_pth="$(dirname "$dst_pth")"
    if [ ! -d "$dst_parent_pth" ]; then
        mkdir -p "$dst_parent_pth"
    fi
    ln -snfv "$src_pth" "$dst_pth" 
done
