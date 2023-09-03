" Load Once
if exists('g:loaded_comment_cmds') && g:loaded_comment_cmds
    finish
endif
let g:loaded_comment_cmds = 1

command! ToggleCommentout call comment_cmds#toggle_commentout()
command! -range DD <line1>,<line2>call comment_cmds#toggle_commentout()

" vnoremap c :DD<CR>
