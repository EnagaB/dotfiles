" buffer
command! -bang -complete=buffer -nargs=* Bclose
            \ call <SID>close_buffer_without_closing_pane(<q-bang>, <q-args>)
command! Buffers call <SID>Buffers()
command! -nargs=1 Buffer call <SID>Buffer(<f-args>)
" syntax
command! ShowSyntaxInfo call <SID>show_syntax_info()
command! ShowColors source $VIMRUNTIME/syntax/colortest.vim
command! ShowHilightgroup verbose highlight
" edit
command! -nargs=1 InsertFileOnlyOnce call <SID>insert_file_only_once(<f-args>)
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" util "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Show_filepath()
    echo expand("%:p")
endfunction

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
""" get a char
function! Getchar()
    let l:c=getchar()
    if l:c =~ '^\d\+$'
        let l:c=nr2char(l:c)
    endif
    return l:c
endfunction
""" modified append(): append string based on the cursor position
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
""" string list
" get/match the list of strings as base len(list) num (1-3 digits)
" recommand that a:list[0]='0'
function! GetStrlist(list,num)
    let l:str=''
    let l:len=len(a:list)
    let l:l1=l:len      | let l:l2=l:len*l:len       | let l:l3=l:l2*l:len
    let l:d1=a:num%l:l1 | let l:d2=(a:num/l:l1)%l:l1 | let l:d3=a:num/l:l2
    if a:num < l:l1
        let l:str=a:list[l:d1]
    elseif a:num < l:l2
        let l:str=a:list[l:d2].a:list[l:d1]
    elseif a:num < l:l3
        let l:str=a:list[l:d3].a:list[l:d2].a:list[l:d1]
    else
        echon 'err: large-num'
        return
    endif
    return l:str
endfunction
function! MatchStrlist(list,str)
    let l:num=-1
    let l:str=''
    let l:len=len(a:list)
    let l:l1=l:len      | let l:l2=l:len*l:len       | let l:l3=l:l2*l:len
    let l:ii=0
    while l:ii < l:l3
        let l:d1=l:ii%l:l1 | let l:d2=(l:ii/l:l1)%l:l1 | let l:d3=l:ii/l:l2
        if l:ii < l:l1
            let l:str=a:list[l:d1]
        elseif l:ii < l:l2
            let l:str=a:list[l:d2].a:list[l:d1]
        elseif l:ii < l:l3
            let l:str=a:list[l:d3].a:list[l:d2].a:list[l:d1]
        endif
        if l:str == a:str
            let l:num=l:ii
            break
        endif
        let l:ii=l:ii+1
    endwhile
    return l:num
endfunction
""" correct string-length
function! CorrStrlength(str,len)
    let l:len=len(a:str)
    let l:dlen=a:len-l:len
    if l:dlen <= 0
        return a:str
    endif
    let l:str=repeat(' ',l:dlen)
    " let l:str=''
    " let l:ii=1
    " while l:ii <= l:dlen
    "   let l:str=l:str.' '
    "   let l:ii=l:ii+1
    " endwhile
    let l:str=l:str.a:str
    return l:str
endfunction
" save and restore mapping
" https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping
function! Save_mappings(keys, mode, global) abort
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
function! Restore_mappings(mappings) abort
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buffer "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buffer functions
" let s:bufcharlist = Numlist() + Lowerlist()
let s:bufcharlist = map(range(char2nr('0'),char2nr('9')),'nr2char(v:val)')
            \             + map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
" close buffer without closing pane
function! s:close_buffer_without_closing_pane(bang, buffer)
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
" modified :buffers (:ls)
" set new buffer-number :buffers
function! s:Buffers()
    let l:buffer_info = getbufinfo({'buflisted': 1})
    let l:num_buffer = len(l:buffer_info)
    let l:current_buffer_num = bufnr("")
    let l:ii = 0
    echo 'key : buffer-name'
    while l:ii < l:num_buffer
        echo CorrStrlength(GetStrlist(s:bufcharlist, l:ii+1), 3)
        if l:current_buffer_num == l:buffer_info[l:ii]["bufnr"]
            echon ' % '
        else
            echon ' : '
        endif
        echon l:buffer_info[l:ii]["name"]
        let l:ii = l:ii + 1
    endwhile
endfunction
" modified :buffer
" use buffer-number by function s:Buffers()
function! s:Buffer(key)
    let l:bufinfo = getbufinfo({'buflisted':1})
    let l:jj = MatchStrlist(s:bufcharlist, a:key)
    if l:jj <= 0 || l:jj > len(l:bufinfo)
        return
    endif
    execute 'buffer ' . l:bufinfo[l:jj-1]['bufnr']
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" show syntax information under cursor
" cohama, http://cohama.hateblo.jp/entry/2013/08/11/020849
function! s:show_syntax_id(transparent)
    let synid = synID(line("."), col("."), 1)
    if a:transparent
        return synIDtrans(synid)
    else
        return synid
    endif
endfunction
function! s:show_syntax_attr(synid)
    let name = synIDattr(a:synid, "name")
    let ctermfg = synIDattr(a:synid, "fg", "cterm")
    let ctermbg = synIDattr(a:synid, "bg", "cterm")
    let guifg = synIDattr(a:synid, "fg", "gui")
    let guibg = synIDattr(a:synid, "bg", "gui")
    return {
                \ "name": name,
                \ "ctermfg": ctermfg,
                \ "ctermbg": ctermbg,
                \ "guifg": guifg,
                \ "guibg": guibg}
endfunction
function! s:show_syntax_info()
    let baseSyn = s:show_syntax_attr(s:show_syntax_id(0))
    echo "name: " . baseSyn.name .
                \ " ctermfg: " . baseSyn.ctermfg .
                \ " ctermbg: " . baseSyn.ctermbg .
                \ " guifg: " . baseSyn.guifg .
                \ " guibg: " . baseSyn.guibg
    let linkedSyn = s:show_syntax_attr(s:show_syntax_id(1))
    echo "link to"
    echo "name: " . linkedSyn.name .
                \ " ctermfg: " . linkedSyn.ctermfg .
                \ " ctermbg: " . linkedSyn.ctermbg .
                \ " guifg: " . linkedSyn.guifg .
                \ " guibg: " . linkedSyn.guibg
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" init insert file
function! s:insert_file_only_once(file)
    if exists('b:did_insert_file_only_once')
        return
    endif
    let b:did_insert_file_only_once = 1
    execute ':1r ' . a:file
    execute ':1s/\n//'
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
