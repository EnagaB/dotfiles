#!/bin/bash
set -u

_fonts_dir="${HOME}/.fonts"

_url_HackGen='https://github.com/yuru7/HackGen/releases/download/v2.5.2/HackGenNerd_v2.5.2.zip'
_url_Myrica='https://github.com/tomokuni/Myrica/raw/master/product/Myrica.zip'
_url_PlemolJP='https://github.com/yuru7/PlemolJP/releases/download/v1.7.1/PlemolJP_v1.7.1.zip'

function install_fonts_from_urls() {
    if [ ! -d "$_fonts_dir" ]; then
        mkdir -p "$_fonts_dir"
    fi
    cd "$_fonts_dir"
    local font_url font_filename
    for font_url in "$@"; do
        echo "install font: ${font_url}"
        font_filename="$(basename "${font_url}")"
        curl -L "$font_url" -o "$font_filename"
        if [ "${font_filename##*.}" = "zip" ]; then
            unzip -o "$font_filename"
        fi
        rm "$font_filename"
    done
    fc-cache -fv "$_fonts_dir"
}

for font in "$@"; do
    if [ "$font" = "HackGen" ]; then
        install_fonts_from_urls "$_url_HackGen"
    elif [ "$font" = "Myrica" ]; then
        install_fonts_from_urls "$_url_Myrica"
    elif [ "$font" = "PlemolJP" ]; then
        install_fonts_from_urls "$_url_PlemolJP"
    else
        install_fonts_from_urls "$font"
    fi
done
