let s:marklist = map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')

function! mark_cmds#set_mark_auto(bang)
    if !exists('b:markpos')
        let b:markpos=-1
    endif
    if empty(a:bang)
        let b:markpos=(b:markpos + 1) % len(s:marklist)
    else
        echon 'next mark: '
        let l:mark=s:get_char()
        echon l:mark.', '
        let l:ml=match(s:marklist,l:mark)
        if l:ml == -1 | echon 'err: not match marklist' | return | endif
        let b:markpos=l:ml
    endif
    execute 'mark '.s:marklist[b:markpos]
    echon 'marked '.s:marklist[b:markpos]
endfunction

function! mark_cmds#delete_mark()
    echon 'delete mark: '
    let l:mark = s:get_char()
    echon l:mark
    execute 'delmarks '.l:mark
endfunction

function! mark_cmds#move_to_mark()
    echon 'move to mark: '
    let l:mark = s:get_char()
    echon l:mark
    let l:line = execute("echon line(\"\'".l:mark."\")")
    if l:line != 0
        execute 'normal! `'.l:mark.'zz'
    else
        echon '; err: the mark does not exist.'
    endif
endfunction

" Get a char
function! s:get_char()
    let l:c=getchar()
    if l:c =~ '^\d\+$'
        let l:c=nr2char(l:c)
    endif
    return l:c
endfunction
