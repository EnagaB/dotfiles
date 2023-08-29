" Load Once
if exists('g:loaded_search_cmds') && g:loaded_search_cmds
    finish
endif
let g:loaded_search_cmds = 1

command! -bang GrepQuickfix call search_cmds#grep_quickfix(<q-bang>)
