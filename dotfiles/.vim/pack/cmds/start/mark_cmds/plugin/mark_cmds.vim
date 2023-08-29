" Load Once
if exists('g:loaded_mark_cmds') && g:loaded_mark_cmds
    finish
endif
let g:loaded_mark_cmds = 1

command! -bang SetMarkAuto call mark_cmds#set_mark_auto(<q-bang>)
command! DeleteMark call mark_cmds#delete_mark()
command! MoveToMark call mark_cmds#move_to_mark()
