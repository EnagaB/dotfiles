" edit
command! RegisterWord
            \ execute 'let @' . g:CONFIG['hilight_word_register'] . '=expand("<cword>")'
command! HighlightRegisterWord
            \ set nohlsearch |
            \ let @/='\<' . eval('@' . g:CONFIG['hilight_word_register']) . '\>' | set hlsearch
command! HighlightRegister
            \ set nohlsearch |
            \ let @/=eval('@' . g:CONFIG['hilight_word_register']) | set hlsearch
" noremap <Plug>e(func)toggle_comment_out :<C-u>call <SID>toggle_comment_out()<CR>
" search
command! -bang OneCharSearchCL call <SID>one_char_search_current_line(<q-bang>)
command! -bang GrepQuickfix call <SID>grep_quickfix(<q-bang>)
" command! ToggleCommentout call <SID>toggle_comment_out()
" command! ToggleOnelineCommentout call <SID>toggle_oneline_comment_out()
" command! ToggleCommentout call <SID>toggle_oneline_comment_out()
" command! ToggleCommentout call <SID>toggle_commentout()
command! ToggleCommentout source $MYVIMRC | call <SID>toggle_commentout()
" pane
" toggle pane size maximized or balanced
command! ToggleResizePanes call <SID>toggle_resize_panes()
" others
command! OpenFiler call <SID>OpenFiler()
command! ShowFilepath echo expand("%:p")
command! Pwf ShowFilepath
command! ReloadVimrc source $MYVIMRC

""" echo highlight
" error
function! Error_msg(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction
" warning
function! Warning_msg(msg)
    echohl WarningMsg
    echomsg a:msg
    echohl None
endfunction

" modified append(): append string based on the cursor position
" a:line  = 0 => insert string at the cursor
"        >= 1 => append line at cursor-line + a:line and insert string
" if you insert lines, :let l:ii=0 | let l:ii=FUNC(l:ii,string) | ...
function! Append(line, string)
    let l:curpos = getpos('.')
    if a:line == 0
        let l:curline = getline(l:curpos[1])
        call setline(l:curpos[1],
                    \      strpart(l:curline,0,l:curpos[2]).a:string.strpart(l:curline,l:curpos[2]))
    elseif a:line >= 1
        call append(l:curpos[1]+a:line-1, a:string)
    endif
    return a:line+1
endfunction

" Save and restore mappings
" https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping
" saved_maps = SaveMappings(['a', 'b'], 'n', v:false)
" call RestoreMappings(saved_maps)
function! SaveMappings(keys, mode, global) abort
    let mappings = {}
    if a:global
        for l:key in a:keys
            let buf_local_map = maparg(l:key, a:mode, 0, 1)
            sil! exe a:mode.'unmap <buffer> '.l:key
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                        \     ? map_info
                        \     : {
                        \ 'unmapped' : 1,
                        \ 'buffer'   : 0,
                        \ 'lhs'      : l:key,
                        \ 'mode'     : a:mode,
                        \ }
            call Restore_mappings({l:key : buf_local_map})
        endfor
    else
        for l:key in a:keys
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                        \     ? map_info
                        \     : {
                        \ 'unmapped' : 1,
                        \ 'buffer'   : 1,
                        \ 'lhs'      : l:key,
                        \ 'mode'     : a:mode,
                        \ }
        endfor
    endif
    return mappings
endfunction
function! RestoreMappings(mappings) abort
    for mapping in values(a:mappings)
        if !has_key(mapping, 'unmapped') && !empty(mapping)
            exe     mapping.mode
                        \ . (mapping.noremap ? 'noremap   ' : 'map ')
                        \ . (mapping.buffer  ? ' <buffer> ' : '')
                        \ . (mapping.expr    ? ' <expr>   ' : '')
                        \ . (mapping.nowait  ? ' <nowait> ' : '')
                        \ . (mapping.silent  ? ' <silent> ' : '')
                        \ .  mapping.lhs
                        \ . ' '
                        \ . substitute(mapping.rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')
        elseif has_key(mapping, 'unmapped')
            sil! exe mapping.mode.'unmap '
                        \ .(mapping.buffer ? ' <buffer> ' : '')
                        \ . mapping.lhs
        endif
    endfor
endfunction

""" toggle comment out
" not visual mode: mod in visual mode, getpos("'<") ~ getpos("'>")
function! s:_old_toggle_comment_out()
    """ parameters
    let l:comtypes=[ ',:' , ',b:' ]
    " get comment str
    let l:com=',' . &comments
    for l:ct in l:comtypes
        let l:comPos=matchend(l:com,l:ct)
        if l:comPos != -1
            break
        endif
    endfor
    if l:comPos == -1
        call Error_msg('err: comments')
        return 1
    endif
    let l:com=strpart(l:com,l:comPos,1)
    " echo l:com
    " get line
    let l:cpos=getpos('.')
    let l:cline=getline(l:cpos[1])
    if len(l:cline) == 0
        return 1
    endif
    let l:start=matchend(l:cline,'^\s*')
    if match(l:cline,'^\s*\'.l:com) == -1
        " non comment line => insert comment string
        call setline(l:cpos[1],strpart(l:cline,0,l:start).l:com.' '.strpart(l:cline,l:start))
    else
        " comment line => remove comment string
        let l:start2=matchend(l:cline,'^\s*\'.l:com.'\s*')
        call setline(l:cpos[1],strpart(l:cline,0,l:start).strpart(l:cline,l:start2))
    endif
endfunction

function! s:get_oneline_comments()
    let l:oneline_comments = ''
    let l:comments = split(&comments, ',')
    let l:oneline_comments_flags = [':', 'b:']
    for l:oneline_comments_flag in l:oneline_comments_flags
        for l:comment in l:comments
            if stridx(l:comment, l:oneline_comments_flag) == 0
                let l:oneline_comments = l:comment[strlen(l:oneline_comments_flag):]
                break
            endif
        endfor
        if strlen(l:oneline_comments) != 0
            break
        endif
    endfor
    if strlen(l:oneline_comments) == 0
        echo 'Getting one-line comments failed.'
        return v:null
    endif
    return l:oneline_comments
endfunction

function! s:delete_prefix_suffix_spaces(line, del_suffix)
    " return list index 0: deleted line
    "                   1: length of prefix spaces
    let l:line = a:line
    " delete prefix spaces
    let l:prefix_spaces = matchlist(l:line, '^\s\+')
    let l:prefix_spaces_num = len(l:prefix_spaces) != 0 ? strlen(l:prefix_spaces[0]) : 0
    " delete suffix spaces
    let l:suffix_spaces_num = 0
    if a:del_suffix
        let l:suffix_spaces = matchlist(l:line, '\s\+$')
        let l:suffix_spaces_num = len(l:suffix_spaces) != 0 ? strlen(l:suffix_spaces[0]) : 0
    endif
    let l:line = l:line[l:prefix_spaces_num:strlen(l:line)-l:suffix_spaces_num-1]
    return [l:line, l:prefix_spaces_num]
endfunction

function! s:str_reverse(string)
    let l:strlen = strlen(a:string)
    if l:strlen == 0
        return ''
    endif
    let l:retstr = ''
    for l:i in range(1, l:strlen)
        let l:retstr = l:retstr . a:string[l:strlen - l:i]
    endfor
    return l:retstr
endfunction

" function! s:toggle_oneline_commentout(linenum)
function! s:toggle_commentout()
    " Change a:linenum-th line to comment.
    " b:toggle_comment is the list of comment sign.
    " if len(b:toggle_comment) == 0 (oneline commentout sign):
    "   get oneline comment prefix.
    " if len(b:toggle_comment) == 1 (oneline commentout sign):
    "   b:toggle_comment[0] is the oneline comment prefix.
    " if len(b:toggle_comment) == 2 (multiline commentout sign):
    "   b:toggle_comment[0] and [1] are the multiline comment prefix and suffix.
    " otherwise: Error.

    let b:toggle_comments = ['/*', '*/']

    if ! exists('b:toggle_comments')
        let b:toggle_comments = []
    endif
    " get comment
    if len(b:toggle_comments) == 0
        call add(b:toggle_comments, s:get_oneline_comments())
        if b:toggle_comments[0] == v:null
            let b:toggle_comments = []
            return 1
        endif
    endif
    if len(b:toggle_comments) > 2 || len(b:toggle_comments) < 1
        echo 'Num of b:toggle_comments items must be 1 or 2.'
        return 1
    endif
    " get current line
    let l:current_cursor_pos = getpos('.')
    let l:current_line = getline(l:current_cursor_pos[1])
    if strlen(l:current_line) == 0
        return 1
    endif
    " delete prefix and suffix spaces
    let [l:current_line_wosp, l:prefix_spaces_num] =
                \ s:delete_prefix_suffix_spaces(l:current_line, len(b:toggle_comments) == 2)
    echo l:current_line_wosp
    echo l:prefix_spaces_num
    " is current line comment
    let l:is_line_comment = v:false
    if stridx(l:current_line_wosp, b:toggle_comments[0]) == 0
        let l:is_line_comment = v:true
    endif
    if len(b:toggle_comments) == 2 && strridx(l:current_line_wosp, b:toggle_comments[0]) == 0
        let l:rev_current_line_wosp = s:str_reverse(l:current_line_wosp)
        let l:rev_suf_comment = s:str_reverse(b:toggle_comments[1])
        if stridx(l:rev_current_line_wosp, rev_suf_comment) == 0
            let l:is_line_comment = v:true
        endif
    endif
    " comment out
    if l:is_line_comment
        " uncomment
        if l:pre_comment_idx != -1
        endif
        if len(b:toggle_comments) == 2 && l:suf_comment_id != -1
        endif
    else
        " to comment
    endif


    return 1

    " set/remove comment prefix/suffix
    if len(b:toggle_comments) == 1

    elseif len(b:toggle_comments) == 2
        " call Error_msg('ERR: now making')
    else
        " call Error_msg('ERR: now making')
    endif

    echo b:toggle_comments
    return 1

    " " if b:ecom == "XXX"
    " "   call Error_msg('err: comments')
    " "   return 1
    " " endif
    " """ parameters
    " " let l:comtypes=[ ',:' , ',b:' ]
    " " detect comment character
    " if b:ecom == ""
    "   " get comment str
    "   let l:com=',' . &comments . ','
    "   for l:ct in l:comtypes
    "     let l:comPos=matchend(l:com,l:ct)
    "     if l:comPos != -1
    "       break
    "     endif
    "   endfor
    "   if l:comPos == -1
    "     call Error_msg('err: comments')
    "     let b:ecom="XXX"
    "     return 1
    "   endif
    " endif

    let l:com=strpart(l:com,l:comPos,1)
    " echo l:com
    " get line
    " let l:cpos=getpos('.')
    " let l:cline=getline(l:cpos[1])
    " if len(l:cline) == 0
    "   return 1
    " endif
    let l:start=matchend(l:cline,'^\s*')
    if match(l:cline,'^\s*\'.l:com) == -1
        " non comment line => insert comment string
        call setline(l:cpos[1],strpart(l:cline,0,l:start).l:com.' '.strpart(l:cline,l:start))
    else
        " comment line => remove comment string
        let l:start2=matchend(l:cline,'^\s*\'.l:com.'\s*')
        call setline(l:cpos[1],strpart(l:cline,0,l:start).strpart(l:cline,l:start2))
    endif
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" search
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" one char search in current line
function! s:one_char_search_current_line(bang)
    echo 'press search char: '
    let l:char = Getchar()
    if empty(a:bang)
        execute 'normal! f'.l:char
    else
        execute 'normal! F'.l:char
    endif
endfunction
" grep and quickfix
function! s:grep_quickfix(bang)
    if ! exists('b:grep_quickfix_search_word')
        let b:grep_quickfix_search_word = ''
    endif
    let l:current_window_num = winnr()
    let l:normal_q_maparg = maparg("q", "n", 0, 1)
    if len(l:normal_q_maparg) == 0 || l:normal_q_maparg["buffer"] == 0
        if empty(a:bang) || strlen(b:grep_quickfix_search_word) == 0
            let b:grep_quickfix_search_word = input('Enter grep pattern: ')
        endif
        if empty(b:grep_quickfix_search_word)
            return
        endif
        execute 'vimgrep /' . b:grep_quickfix_search_word . '/j %:p'
        if len(getqflist()) == 0
            return
        endif
        nnoremap <buffer><nowait> j :cnext<CR>zz
        nnoremap <buffer><nowait> k :cprevious<CR>zz
        nnoremap <buffer><nowait> q :GrepQuickfix<CR>
    else
        nmapclear <buffer>
        call setqflist([], 'r')
    endif
    execute 'cwindow ' . min([max([len(getqflist()), 1]), 5])
    execute l:current_window_num . 'wincmd w'
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pane
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" get visual selection
" " created by xolox
" " https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
" function! Get_visual_selection()
"   let [line_start, column_start] = getpos("'<")[1:2]
"   let [line_end, column_end] = getpos("'>")[1:2]
"   let lines = getline(line_start, line_end)
"   if len(lines) == 0
"     return ''
"   endif
"   let lines[-1] = lines[-1][: column_end - (&selection ==
"   'inclusive' ? 1 : 2)]
"   let lines[0] = lines[0][column_start - 1:]
"   return join(lines, "\n")
" endfunction

function! s:toggle_resize_panes()
    if !exists('b:toggleMaxPane')
        let b:toggleMaxPane=0
    endif
    if b:toggleMaxPane == 0
        execute "normal! \<C-w>_\<C-w>\<Bar>"
        let b:toggleMaxPane=1
    else
        execute "normal! \<C-w>="
        let b:toggleMaxPane=0
    endif
endfunction

function s:OpenFiler()
    if exists(":Fern")
        Fern .
    else
        edit .
    endif
endfunction
