#!/usr/bin/env bash
# confirm that ~/.bash_profile and ~/.bash_login do not exist
[[ -f "${HOME}/.bashrc" ]] && . "${HOME}/.bashrc"

# EOF
