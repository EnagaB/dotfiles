#!/bin/bash
set -eu

trash_can="${TRASHCAN:-""}"
if [ -z "$trash_can" ]; then
    echo "ERROR: trash box (TRASHCAN) is not defined"
    echo "$usage"
fi

max_cnt_down=10

echo "trash box: $trash_can"

# show files/dirs
echo "files and directories in trash box:"
delete_filedirs=( $(find ${trash_can} -maxdepth 1) )
for fd in "${delete_filedirs[@]}"; do
    base_fd=$(basename "$fd")
    [[ "$base_fd" = '.'  ]] && continue
    [[ "$base_fd" = '..' ]] && continue
    echo -n "$base_fd "
done
echo ''

# countdown
for cdt in $(seq ${max_cnt_down} -1 1) ; do
    [[   "$cdt" -eq "${max_cnt_down}" ]] && echo -n "countdown ${cdt} "
    [[ ! "$cdt" -eq "${max_cnt_down}" ]] && echo -n "${cdt} "
    sleep 1
done
echo ''

echo "delete trash box"
rm -rf $trash_can

echo "make new trash box"
mkdir -p $trash_can
