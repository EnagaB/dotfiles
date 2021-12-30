#!/usr/bin/env bash
set -u

# parameters
declare -r im_density=600
declare -r im_fuzz='5%'
declare -r tmpfn='IMG_CONV_TMP'

# functions
function GetExtension() {
  local tmp1="$(basename $1)"
  local tmp2="${tmp1##*.}"
  if [ "$tmp1" != "$tmp2" ];then
    # extension exists
    echo "$tmp2"
  fi
}
function ChangeExtension() {
  local OriExt="$(GetExtension $2)"
  echo "${2%.$OriExt}.$1"
}

# args
declare -r ext2="$1"
shift 1

# convert
for ff in "$@"; do
  echo -n "convert ext to ${ext2}: ${ff}: "
  if [[ ! -f "$ff" ]];then
    echo 'not exist'
    continue
  fi
  ext1=$(GetExtension "$ff")
  outff=$(ChangeExtension "$ext2" "$ff")
  # convert
  ncv=0
  # create cp_tmp_file
  tf1="${tmpfn}1"
  tf2="${tmpfn}2"
  cp "$ff" "$tf1"
  # svg
  if [[ "$ext1" = 'svg' ]];then
    [[ "$ext2" = 'pdf' ]] && inkscape -f "$tf1" -A "$outff" -D && ncv=1
    [[ "$ext2" = 'eps' ]] && inkscape -f "$tf1" -E "$outff" -D && ncv=1
    [[ "$ext2" = 'png' ]] && inkscape -f "$tf1" -e "$outff" -D && ncv=1
  elif [[ "$ext1" = 'pdf' ]];then
    if [[ "$ext2" = 'png' ]];then
      pdfcrop "$tf1" "$tf2"
      convert -density "${im_density}" "${tf2}" "${outff}"
      ncv=1
    fi
  elif [[ "$ext1" = 'eps' ]];then
    [[ "$ext2" = 'pdf' ]] && inkscape -f "$tf1" -A "$outff" -D && ncv=1
    if [[ "$ext2" = 'png' ]];then
      inkscape -f "$tf1" -b "#ffffff00" -y 0.0 -d "$im_density" -e "$outff" -D
      ncv=1
    fi
  elif [[ "$ext1" = 'png' ]];then
    if [[ "$ext2" = 'pdf' ]];then
      convert "$tf1" -fuzz "$im_fuzz" -trim +repage "$tf2"
      convert -density "$im_density" "$tf2" "$outff"
      ncv=1
    fi
  fi
  # remove cp_tmp_file
  [[ -f "$tf1" ]] && rm "$tf1"
  [[ -f "$tf2" ]] && rm "$tf2"
  if [[ "$ncv" -eq 0 ]];then
    echo 'failed'
  else
    echo 'succeed'
  fi
done

# end
