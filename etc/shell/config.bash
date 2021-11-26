#!/usr/bin/env bash
# source in shrc.bash/.bashrc/.zshrc

### prompt
# style
declare __prompt_style='simple'     # normal/simple/adam (zsh)
# zsh vcs_info check_for_change
declare __vcs_check_for_change=true # true(heavy)/false

### tmux
# autostart
declare -r __tmux_autostart=0

### wsl
declare -r __wsl_vcxsrv_autostart=0
declare -r __wsl_fcitx_autostart=0

### python
# default version
declare -r __python_defver=python3.9

# local config
declare -r __path_shrc_local=~/.shrc_local

# EOF
