#!/usr/bin/env bash
set -u

function curl_autoch() {
  local -r url="$1" lfile="$2"
  [[ -f "$lfile" ]] && return 1
  echo "[curl: ${url}]"
  curl -L "${url}" -o "${lfile}"
}

### latest neovim
if $curl_latest_neovim;then
  url=${gurl}/neovim/neovim/releases/download/stable/nvim.appimage
  lfile=${LOCAL}/bin/nvim.appimage
  curl_autoch "$url" "$lfile"
  chmod u+x "$lfile"
fi

### fonts
fontdir=${HOME}/.fonts
cd $fontdir
for fonturl in ${fonts_url[@]}; do
  filename=$(basename ${fonturl})
  curl_autoch "$fonturl" "${filename}"
  unzip $filename
  rm $filename
done
rm *.md
rm *.txt
fc-cache -fv $fontdir
cd $df

# EOF
