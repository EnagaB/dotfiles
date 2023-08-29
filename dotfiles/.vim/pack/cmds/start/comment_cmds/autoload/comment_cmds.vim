" toggle commentout
" function! s:toggle_oneline_commentout(linenum)
function! comment_cmds#toggle_commentout()
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
    let l:flag_comments = split(&comments, ',')
    let l:flags = [':', 'b:']
    for l:flag in l:flags
        for l:flag_comment in l:flag_comments
            if stridx(l:flag_comment, l:flag) == 0
                let l:oneline_comments = l:flag_comment[strlen(l:flag):]
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

