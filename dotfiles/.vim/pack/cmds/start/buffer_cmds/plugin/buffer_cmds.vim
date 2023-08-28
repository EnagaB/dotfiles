" Load Once
if exists('g:loaded_buffer_cmds') && g:loaded_buffer_cmds
    finish
endif
let g:loaded_buffer_cmds = 1

command! -bang -complete=buffer -nargs=* Bclose
            \ call buffer_cmds#CloseBufferWithoutClosingPane(<q-bang>, <q-args>)
