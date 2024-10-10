#!/bin/bash
set -u

function download_fonts() {
    if [ ! -v fonts_dir ] || [ ! -d "$fonts_dir" ]; then
        echo_err "ERROR: Font directory is not defined."
        return 1
    fi
    cd "$fonts_dir"
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
}
