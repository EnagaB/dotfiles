#!/usr/bin/env bash
set -u

echo "build jump.cpp"
g++ -std=c++17 "${dfsrc}/jump/jump.cpp" -o "${dfbin}/__jump.out"

# EOF
