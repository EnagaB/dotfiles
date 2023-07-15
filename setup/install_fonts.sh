#!/bin/bash
set -u

echo "Install fonts"

setup_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")"; pwd)"
. "${setup_dir}/config.sh"

cd "$fonts_dir"

for install_font in "${install_fonts[@]}"; do
    echo "install $install_font"
    font_filename="$(basename "${install_font}")"
    curl -L "$install_font" -o "$font_filename"
    unzip -o "$font_filename"
    rm "$font_filename"
done

echo "Generate font caches"
fc-cache -fv "$fonts_dir"
