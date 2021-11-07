#!/usr/bin/env bash
set -u

dfbin=${DOTFILES}/bin
dfsrc=${DOTFILES}/src

echo "build jump.cpp"
g++ -std=c++17 ${dfsrc}/jump.cpp -o ${dfbin}/__jump.out

# EOF
