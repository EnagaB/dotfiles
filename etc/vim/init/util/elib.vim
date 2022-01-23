""" library

""" list
let s:__lists = {}
" lower/number list (range in ASCII code)
let s:__lists['lower'] = map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
let s:__lists['num'] = map(range(char2nr('0'),char2nr('9')),'nr2char(v:val)')
" get functions
function! Lowerlist()
  return s:__lists['lower']
endfunction
function! Numlist()
  return s:__lists['num']
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

""" save/restore mapping
" https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping
" example : use <C-a>,<C-b>,<C-c> on normal-mode and global
" save : let iii_save_map = Save_mappings(['<C-a>','<C-b>','<C-c>'],'n',1)
" load : call Restore_mappings(iii_save_map)
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

" end
