command! -bang SetMarkAuto call mark_cmds#set_mark_auto(<q-bang>)
command! DeleteMark call mark_cmds#delete_mark()
command! MoveToMark call mark_cmds#move_to_mark()
