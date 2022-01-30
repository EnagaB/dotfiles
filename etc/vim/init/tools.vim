" buffer
command! -bang -complete=buffer -nargs=* Bclose call <SID>Bclose(<q-bang>, <q-args>)
command! Buffers call <SID>Buffers()
command! -nargs=1 Buffer call <SID>Buffer(<f-args>)
" mark
command! -bang SetMarkAuto call <SID>set_mark_auto(<q-bang>)
command! DeleteMark call <SID>delete_mark()
command! MoveToMark call <SID>move_to_mark()
" syntax
command! SetDefaultColorscheme call <SID>Set_default_colorscheme()
command! ShowSyntaxInfo call <SID>show_syntax_info()
command! ShowColors source $VIMRUNTIME/syntax/colortest.vim
command! ShowHilightgroup verbose highlight
" edit
command! EmacsCtrlk call <SID>emacs_ctrl_k()
command! -nargs=1 InsertFileOnlyOnce call <SID>insert_file_only_once(<f-args>)
command! RegisterWord
      \ execute 'let @' . Params('hilight_word_register') . '=expand("<cword>")'
command! HighlightRegisterWord
      \ set nohlsearch |
      \ let @/='\<' . eval('@' . Params('hilight_word_register')) . '\>' | set hlsearch
command! HighlightRegister
      \ set nohlsearch |
      \ let @/=eval('@' . Params('hilight_word_register')) | set hlsearch
" noremap <Plug>e(func)toggle_comment_out :<C-u>call <SID>toggle_comment_out()<CR>
" search
command! -bang OneCharSearchCL call <SID>one_char_search_current_line(<q-bang>)
" command! -bang GrepQuickfix call <SID>grep_quickfix(<q-bang>)
command! ToggleCommentout call <SID>toggle_comment_out_v2()
command! ToggleResizePanes call <SID>toggle_resize_panes()
" other
command! ShowFilepath echo expand("%:p")
command! ReloadVimrc source $MYVIMRC

" lower-case alphabet and num list
let s:lists = {}
let s:lists['lower'] = map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
let s:lists['num'] = map(range(char2nr('0'),char2nr('9')),'nr2char(v:val)')
function! Lowerlist()
  return s:lists['lower']
endfunction
function! Numlist()
  return s:lists['num']
endfunction

" init insert file
function! s:insert_file_only_once(file)
  if exists('b:did_insert_file_only_once')
    return
  endif
  let b:did_insert_file_only_once = 1
  execute ':1r ' . a:file
  execute ':1s/\n//'
endfunction

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
  if ! exists('b:grep_quickfix_save_maps')
    let b:grep_quickfix_save_maps = {}
  endif
  let l:current_window_num = winnr()
  let l:quickfix_window_id = getqflist({'winid': 0})
  let l:quickfix_change_keys = ['j', 'k', 'q']
  if l:quickfix_window_id["winid"] == 0
    " vimgrep and open cwindow
    if empty(a:bang)
      let b:grep_quickfix_search_word = input('Enter grep pattern: ')
    endif
    if empty(b:grep_quickfix_search_word)
      return
    endif
    execute 'vimgrep /' . b:grep_quickfix_search_word . '/j %:p'
    if len(getqflist()) == 0
      return
    endif
    if empty(b:grep_quickfix_save_maps)
      let b:grep_quickfix_save_maps = Save_mappings(l:quickfix_change_keys, 'n', v:false)
      nnoremap <buffer>j :cnext<CR>zz
      nnoremap <buffer>k :cprevious<CR>zz
      nnoremap <buffer>q :GrepQuickfix<CR>
    endif
  else
    " close cwindow
    call setqflist([], 'r')
    if ! empty(b:grep_quickfix_save_maps)
      for l:ii in l:quickfix_change_keys
        execute 'nunmap <buffer>' . l:ii
      endfor
      call Restore_mappings(b:grep_quickfix_save_maps)
      let b:grep_quickfix_save_maps={}
    endif
  endif
  execute 'cwindow ' . min([max([len(getqflist()), 1]), 5])
  execute l:current_window_num . 'wincmd w'
endfunction

" emacs C-k function
function! s:emacs_ctrl_k()
  let l:cpos=getpos('.')
  if len(getline(l:cpos[1])) == 0
    normal! dd
  else
    normal! D
    call setpos('.',l:cpos)
  endif
endfunction

""" toggle comment out
" not visual mode: mod in visual mode, getpos("'<") ~ getpos("'>")
function! s:toggle_comment_out()
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

let b:ecom=""
function! s:toggle_comment_out_v2()
  call Error_msg('ERR: now making')
  return 1

  if b:ecom == "XXX"
    call Error_msg('err: comments')
    return 1
  endif
  """ parameters
  let l:comtypes=[ ',:' , ',b:' ]
  " detect comment character
  if b:ecom == ""
    " get comment str
    let l:com=',' . &comments . ','
    for l:ct in l:comtypes
      let l:comPos=matchend(l:com,l:ct)
      if l:comPos != -1
        break
      endif
    endfor
    if l:comPos == -1
      call Error_msg('err: comments')
      let b:ecom="XXX"
      return 1
    endif
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

" toggle pane size maximized or balanced
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

" buffer functions
let s:bufcharlist = Numlist() + Lowerlist()
" close buffer without closing pane
function! s:Bclose(bang, buffer)
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

" mark functions
let s:marklist = Lowerlist()
" set mark whose symbol is selected automatically
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
" delete mark
function! s:delete_mark()
  echon 'delete mark: '
  let l:mark=Getchar()
  echon l:mark
  execute 'delmarks '.l:mark
endfunction
" move to given mark
function! s:move_to_mark()
  echon 'move to mark: '
  let l:mark=Getchar()
  echon l:mark
  let l:line=execute("echon line(\"\'".l:mark."\")")
  if l:line != 0
    execute 'normal! `'.l:mark.'zz'
  else
    echon '; err: the mark does not exist.'
  endif
endfunction

""" library

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

" set colorscheme from settings
function! s:Set_default_colorscheme()
  let l:colorscheme_rel_path = 'colors/' . Params('colorscheme') . '.vim'
  if ! empty(globpath(&runtimepath, l:colorscheme_rel_path))
    execute 'colorscheme ' . Params('colorscheme')
  else
    execute 'colorscheme ' . Params('colorscheme_without_packs')
  endif
  execute 'set background =' . Params('background')
endfunction

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

" for sort function, sort in shorter order
function! Sort_comp_strlen(str1, str2)
  let l:l1 = strlen(a:str1)
  let l:l2 = strlen(a:str2)
  return l:l1 == l:l2 ? 0 : l:l1 > l:l2 ? 1 : -1
endfunction

" EOF