#!/usr/bin/env bash
set -u

echo "build jump.cpp"
outfile="${dfbin}/__jump.out"
[[ -f "$outfile" ]] && rm "$outfile"
g++ -std=c++17 -Wall "${dfsrc}/jump/jump.cpp" -o "$outfile"
[[ ! -f "$outfile" ]] && g++ -std=c++1z -Wall "${dfsrc}/jump/jump.cpp" -o "$outfile"

# EOF
