#!/usr/bin/env bash
set -u

echo "build jump.cpp"
pushd "${dfsrc}/jump"
[[ -f "${dfbin}/__jump.out" ]] && rm "${dfbin}/__jump.out"
[[ -d "${dfsrc}/jump/build" ]] && rm -r "${dfsrc}/jump/build"
mkdir build \
  && cd build \
  && cmake .. \
  && make \
  && mv __jump.out "$dfbin"
popd

# EOF
