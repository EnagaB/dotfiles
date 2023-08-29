" grep and quickfix
function! search_cmds#grep_quickfix(bang)
    if ! exists('b:search_cmds_pattern')
        let b:search_cmds_pattern = ''
    endif
    let l:current_window_num = winnr()
    let l:normal_q_maparg = maparg("q", "n", 0, 1)
    if len(l:normal_q_maparg) == 0 || l:normal_q_maparg["buffer"] == 0
        if empty(a:bang) || strlen(b:search_cmds_pattern) == 0
            let b:search_cmds_pattern = input('Enter grep pattern: ')
        endif
        if empty(b:search_cmds_pattern)
            return
        endif
        execute 'vimgrep /' . b:search_cmds_pattern . '/j %:p'
        if len(getqflist()) == 0
            return
        endif
        nnoremap <buffer><nowait> j :<C-u>cnext<CR>zz
        nnoremap <buffer><nowait> k :<C-u>cprevious<CR>zz
        nnoremap <buffer><nowait> q :<C-u>GrepQuickfix<CR>
    else
        nmapclear <buffer>
        call setqflist([], 'r')
    endif
    execute 'cwindow ' . min([max([len(getqflist()), 1]), 5])
    execute l:current_window_num . 'wincmd w'
endfunction
