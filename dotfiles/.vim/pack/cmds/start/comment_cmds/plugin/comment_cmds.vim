" Load Once
if exists('g:loaded_comment_cmds') && g:loaded_comment_cmds
    finish
endif
let g:loaded_comment_cmds = 1

command! ToggleCommentout call comment_cmds#toggle_commentout()
command! DebugToggleCommentout source $MYVIMRC | call comment_cmds#toggle_commentout()
