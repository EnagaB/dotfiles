# bash

function get_os() {
  [[ $(uname -s) =~ ^CYGWIN ]] && local -r os='cygwin'
  [[ ! -v os ]] && local -r os='ubuntu'
  echo "$os"
}

function install_packages() {
  sudo apt -o Acquire::Retries=10 update \
    && sudo apt -o Acquire::Retries=10 upgrade -y \
    && sudo apt -o Acquire::Retries=10 install -y \
    "$@"
}

function build_cmake() {
  local -r src_dir="$1"
  local -r dst_out="$2"
  local -r build_dir="${src_dir}/build"
  local -r dst_filename=$(basename "$dst_out")
  [[ -f "$dst_out" ]] && rm "$dst_out"
  [[ -d "$build_dir" ]] && rm -r "$build_dir"
  pushd "$src_dir"
  mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && ln -snfv "${build_dir}/${dst_filename}" "$dst_out"
  popd
}
