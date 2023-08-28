" close buffer without closing pane
" https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
function! buffer_cmds#CloseBufferWithoutClosingPane(bang, buffer) abort
    if empty(a:buffer)
        let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    else
        let btarget = bufnr(a:buffer)
    endif
    if btarget < 0 | call Warning_msg('No matching buffer for ' . a:buffer) | return | endif
    if empty(a:bang) && getbufvar(btarget, '&modified')
        call Warning_msg('No write since last change for buffer '.btarget.' (use :Bclose!)')
        return
    endif
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    let wcurrent = winnr()
    for w in wnums
        execute w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
            buffer #
        else
            bprevious
        endif
        if btarget == bufnr('%')
            let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                execute 'buffer '.bjump
            else
                execute 'enew'.a:bang
            endif
        endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
    execute wcurrent.'wincmd w'
endfunction
