command! -bang SetMarkAuto call <SID>set_mark_auto(<q-bang>)
command! DeleteMark call <SID>delete_mark()
command! MoveToMark call <SID>move_to_mark()

let s:marklist = map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')

function! s:set_mark_auto(bang)
    if !exists('b:markpos')
        let b:markpos=-1
    endif
    if empty(a:bang)
        let b:markpos=(b:markpos + 1) % len(s:marklist)
    else
        echon 'next mark: '
        let l:mark=Getchar()
        echon l:mark.', '
        let l:ml=match(s:marklist,l:mark)
        if l:ml == -1 | echon 'err: not match marklist' | return | endif
        let b:markpos=l:ml
    endif
    execute 'mark '.s:marklist[b:markpos]
    echon 'marked '.s:marklist[b:markpos]
endfunction

function! s:delete_mark()
    echon 'delete mark: '
    let l:mark = Getchar()
    echon l:mark
    execute 'delmarks '.l:mark
endfunction

function! s:move_to_mark()
    echon 'move to mark: '
    let l:mark = Getchar()
    echon l:mark
    let l:line = execute("echon line(\"\'".l:mark."\")")
    if l:line != 0
        execute 'normal! `'.l:mark.'zz'
    else
        echon '; err: the mark does not exist.'
    endif
endfunction
