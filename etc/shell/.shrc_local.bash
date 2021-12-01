#!/usr/bin/env bash
# local config for bash/zsh
# source in .bashrc/.zshrc

### Prompt
# true/false. Color of bash prompt.
declare __color_prompt=true
# 'normal'/'simple'/'adam'. Prompt style.
declare __prompt_style='simple'
# true/false. In zsh, vcs_info check_for_change.
declare __vcs_check_for_change=true

### tmux
# true/false. Tmux autostart.
declare -r __tmux_autostart=false

### wsl
declare -r __wsl_vcxsrv_autostart=false
declare -r __wsl_fcitx_autostart=false

### python
# default version
declare -r __python_defver=python3.9

# local config function
function __shrc_local_last() {
  :
}

# EOF
