let s:max_line_length = 5000
let s:spaces_pat = '\s*'
let s:init_spaces_pat = '^' . s:spaces_pat

function! comment_cmds#toggle_commentout() abort range
    if ! exists('b:comment_cmds_marks')
        let b:comment_cmds_marks = s:get_comment_marks()
    endif
    if b:comment_cmds_marks is v:null
        echomsg 'ERROR: Not support this filetype. :let b:comment_cmds_marks = COMMENT_MARK'
        return
    endif
    let l:lines = getline(a:firstline, a:lastline)
    if ! validate_lines(l:lines)
        return
    endif
    let n_lines = range(a:firstline, a:lastline)
    let l:init_spaces = s:get_init_spaces(l:lines)
    if type(b:comment_cmds_marks) == type('')
        call s:toggle_commentout_oneline(l:n_lines, l:lines, l:init_spaces)
    elseif type(b:comment_cmds_marks) == type([])
        " call comment_cmds#toggle_multiline_commentout(b:comment_cmds_marks)
        echomsg 'ERROR: Not support multiline comment'
        return
    endif
endfunction

" Note: support only one-line comment mark
function! s:get_comment_marks()
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
        echomsg 'Failed to get one-line comment mark'
        return v:null
    endif
    return l:oneline_comments
endfunction

function! s:validate_lines(lines)
    for l:line in a:lines
        if strlen(l:line) > s:max_line_length
            echoerr 'ERROR: Too long line.'
            return v:false
        endif
    endfor
    return v:true
endfunction

function! s:get_init_spaces(lines)
    let l:init_spaces = v:null
    for l:line in a:lines
        if s:is_empty_line(l:line)
            continue
        endif
        let l:matched = matchstr(l:line, s:init_spaces_pat)
        if l:init_spaces is v:null || strlen(l:init_spaces) > strlen(l:matched)
            let l:init_spaces = l:matched
        endif
    endfor
    return l:init_spaces
endfunction

function! s:is_empty_line(line)
    if strlen(a:line) == 0 || a:line =~ '^' . s:spaces_pat . '$'
        return v:true
    endif
    return v:false
endfunction

function! comment_cmds#_toggle_commentout_normal_mode()
    if type(b:comment_cmds_marks) == type('')
        call comment_cmds#_toggle_oneline_commentout()
    elseif type(b:comment_cmds_marks) == type([])
        " call comment_cmds#toggle_multiline_commentout(b:comment_cmds_marks)
        echomsg 'ERROR: Not support multiline comment'
        return
    endif
endfunction

function! comment_cmds#_toggle_commentout_visual()
    let n_begin_line = getpos("'<")[1]
    let n_finish_line = getpos("'>")[1]
    echo n_begin_line n_finish_line
endfunction

function! s:toggle_commentout_oneline(n_lines, lines, init_spaces)
    let l:cmt_mark_pat = s:init_spaces_pat . b:comment_cmds_marks . s:spaces_pat
    let l:is_comments = s:is_comments_oneline(a:lines, l:cmt_mark_pat)




    let l:n_line = getpos('.')[1]
    let l:line = getline(l:n_line)
    if comment_cmds#_is_empty_line(l:line)
        return
    endif
    let l:cmt_mark_pat = s:init_spaces_pat . b:comment_cmds_marks . s:spaces_pat
    if l:line =~ l:cmt_mark_pat
        call comment_cmds#_oneline_delete_comment_mark(l:line, l:n_line, l:cmt_mark_pat)
    else
        call comment_cmds#_oneline_commentout(l:line, l:n_line)
    endif
endfunction

function! s:is_comments_oneline(lines, cmt_mark_pat)
    for l:line in a:lines
        if s:is_empty_line(l:line)
            continue
        endif
        if l:line !~ a:cmt_mark_pat
            return v:false
        endif
    endfor
    return v:true
endfunction

function! comment_cmds#_oneline_delete_comment_mark(line, n_line, cmt_mark_pat)
    let l:init_spaces = matchstr(a:line, s:init_spaces_pat)
    let l:cmt = matchstr(a:line, a:cmt_mark_pat)
    let l:cmt_line = l:init_spaces . a:line[strlen(l:cmt):]
    call setline(a:n_line, l:cmt_line)
endfunction

function! comment_cmds#_oneline_commentout(line, n_line)
    let l:init_spaces = matchstr(a:line, s:init_spaces_pat)
    let l:cmt_line = l:init_spaces . b:comment_cmds_marks . ' ' . a:line[strlen(l:init_spaces):]
    call setline(a:n_line, l:cmt_line)
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
