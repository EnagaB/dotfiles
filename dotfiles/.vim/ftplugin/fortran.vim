" first ftplugin fortran.vim

setlocal comments=:!
setlocal textwidth=132
setlocal tabstop=2 shiftwidth=0 expandtab softtabstop=0 smarttab
" setlocal textwidth=132
" setlocal textwidth=72
" setlocal textwidth=0
let b:fortran_do_enddo     = 1
" let   fortran_more_precise = 1
let b:fortran_indent_more  = 1
unlet! fortran_have_tabs

" map
let s:mflist=[
      \ ['q'     , 'ToggleEFortranDeclarationInsert(0)'    ],
      \ ['<S-q>' , 'ToggleEFortranDeclarationInsert(1)'    ],
      \ ['o1'    , 'EFortranInsertOpenmp(1,0)'             ],
      \ ['o2'    , 'EFortranInsertOpenmp(2,0)'             ],
      \ ['ob'    , 'EFortranInsertOpenmp(1,0)'             ],
      \ ['oe'    , 'EFortranInsertOpenmp(2,0)'             ],
      \ ['op'    , 'EFortranInsertOpenmp(3,1)'             ],
      \ ['d'     , 'EFortranInsertDo(0)'                   ],
      \ ['<S-d>' , 'EFortranInsertDo(1)'                   ],
      \ ['i'     , 'EFortranInsertIf()'                    ],
      \ ['<S-i>p', 'EFortranInsertPrgBlock(1,"program")'   ],
      \ ['<S-i>s', 'EFortranInsertPrgBlock(1,"subroutine")']
      \ ]
let s:ii=0 | while s:ii <= len(s:mflist)-1
  execute 'nnoremap <buffer><Plug>e(pef)'.s:mflist[s:ii][0].' :call <SID>'.s:mflist[s:ii][1].'<CR>'
  let s:ii+=1
endwhile
" " insert line
" nmap <buffer><Plug>e(pef)l3 :call EnInsert_AnyNumTimes(1,'!','=',36)<CR>
" nmap <buffer><Plug>e(pef)l4 :call EnInsert_AnyNumTimes(1,'!','=',45)<CR>
" nmap <buffer><Plug>e(pef)l5 :call EnInsert_AnyNumTimes(1,'!','=',54)<CR>
" nmap <buffer><Plug>e(pef)l6 :call EnInsert_AnyNumTimes(1,'!','=',63)<CR>
" nmap <buffer><Plug>e(pef)l7 :call EnInsert_AnyNumTimes(1,'!','=',72)<CR>
" nmap <buffer><Plug>e(pef)ll :call EnInsert_AnyNumTimes(1,'!','=',72)<CR>

" insert do
function! s:EFortranInsertDo(noind)
  let l:cline=line(".")
  if a:noind == 0
    execute "normal! i" . "do "
    call append(l:cline  ,"enddo")
    execute "normal! \<S-v>j="
  elseif a:noind == 1
    call append(l:cline  ,"do ")
    call append(l:cline+1,"enddo")
    execute "normal! j\<S-v>j="
    execute "normal! <<"
    execute "normal! j<<k"
    " execute "normal! 0".shiftwidth()."x"
    " execute "normal! j0".shiftwidth()."xk"
  endif
  execute "normal! $"
  startinsert!
endfunction

" insert if
function! s:EFortranInsertIf()
  let l:cline=line(".")
  execute "normal! i" . "if () then"
  call append(l:cline  ,"endif")
  execute "normal! \<S-v>j="
  execute "normal! $5h"
  startinsert
endfunction
let s:DLine='! dec-part '
let s:ELine='! exe-part '
let s:DELineCol=54
function! s:EFortranInsertPrgBlock(impnone,name)
  let l:pos=getpos(".")
  call EnInsert(0,0,a:name)
  let l:lnum=0
  call EnInsert(1,l:lnum,s:DLine) | let l:lnum+=1
  if a:impnone == 1
    call EnInsert(1,l:lnum,'implicit none') | let l:lnum+=1
  endif
  call EnInsert(1,l:lnum,s:ELine) | let l:lnum+=1
  call EnInsert(1,l:lnum,'end'.a:name) | let l:lnum+=1
  for itm in range(1,2)
    if a:impnone == 0
      normal! j
    elseif a:impnone == 1
      execute "normal! ".itm."j"
    endif
    call EnInsert_AnyNumTimes(1,'!','=',s:DELineCol)
  endfor
  call setpos('.',l:pos)
  execute "normal! \<S-v>".l:lnum."j="
  call setpos('.',l:pos)
  execute "normal! $a\<Space>" | startinsert!
endfunction
" insert openmp
function! s:EFortranInsertOpenmp(pat,nw)
  if a:nw == 1
    normal! $
    execute "normal! a" . " &"
    execute "normal! o"
  endif
  execute "normal! a" . "!$omp "
  execute "normal! =="
  normal! $
  if     a:pat == 1 | execute "normal! a" . "parallel do"
  elseif a:pat == 2 | execute "normal! a" . "end parallel do"
  elseif a:pat == 3 | execute "normal! a" . "private()"
  elseif a:pat == 4 | execute "normal! a" . "reduction(:)"
  endif
  if     a:pat == 3
    startinsert
  elseif a:pat == 4
    normal! h
    startinsert
  endif
endfunction
" Toggle EFortran Dec mode
function! s:ToggleEFortranDeclarationInsert(newline)
  if !exists("b:fortran_dec_ins")
    let b:fortran_dec_ins = 0
  endif
  " delete buffer nmap
  " for i in map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
  "    execute 'noremap <buffer>'.i.' <Nop>'
  " endfor
  if   b:fortran_dec_ins == 0
    let b:fortran_dec_ins = 1
    if a:newline == 1
      normal! o
    endif
    let b:fortran_ch_keys =[
          \   'q', 'i',  'r',  'c',  'h', 'l',
          \   'p', 'a', 'ti', 'to', 'tp'
          \ ]
    let b:fortran_save_map = Save_mappings(b:fortran_ch_keys,'n',0)
    nnoremap <buffer>q  :call <SID>ToggleEFortranDeclarationInsert(0)<CR>
    nnoremap <buffer>i  :call <SID>EFortranDecIns('i',1)<CR> 
    nnoremap <buffer>r  :call <SID>EFortranDecIns('r',1)<CR>
    nnoremap <buffer>c  :call <SID>EFortranDecIns('c',1)<CR>
    nnoremap <buffer>h  :call <SID>EFortranDecIns('h',2)<CR>
    nnoremap <buffer>l  :call <SID>EFortranDecIns('l',1)<CR>
    nnoremap <buffer>p  :call <SID>EFortranDecIns('p',0)<CR>
    nnoremap <buffer>a  :call <SID>EFortranDecIns('a',0)<CR>
    nnoremap <buffer>ti :call <SID>EFortranDecIns('ti',0)<CR>
    nnoremap <buffer>to :call <SID>EFortranDecIns('to',0)<CR>
    nnoremap <buffer>tp :call <SID>EFortranDecIns('tp',0)<CR>
  elseif b:fortran_dec_ins ==1
    let b:fortran_dec_ins = 0
    for i in b:fortran_ch_keys
      execute 'nunmap <buffer>'.i
    endfor
    call Restore_mappings(b:fortran_save_map)
    normal! $
    execute "normal! a" . " :: "
    startinsert!
  endif
endfunction
" insert declaration
function! s:EFortranDecIns(key,ind)
  normal! $
  if     a:key == 'i'  | execute "normal! a" . "integer"
  elseif a:key == 'r'  | execute "normal! a" . "real *8"
  elseif a:key == 'c'  | execute "normal! a" . "complex *16"
  elseif a:key == 'h'  | execute "normal! a" . "character(len=)"
  elseif a:key == 'l'  | execute "normal! a" . "logical"
  elseif a:key == 'p'  | execute "normal! a" . ",parameter"
  elseif a:key == 'a'  | execute "normal! a" . ",allocatable"
  elseif a:key == 'ti' | execute "normal! a" . ",intent(in)"
  elseif a:key == 'to' | execute "normal! a" . ",intent(out)"
  elseif a:key == 'tp' | execute "normal! a" . ",intent(inout)"
  endif
  if     a:ind == 1 | execute "normal! =="
  elseif a:ind == 2 | execute "normal! ==$" | startinsert
  endif
endfunction
""" command
" insert
" insert word (any-#) times
function! EnInsert(type,line,word)
  " type=0/1 : insert word at end-of-current-line/new-line.
  let l:pos=getpos(".")
  if     a:type == 0
    let l:absline=abs(a:line)
    if     a:line > 0 | execute "normal ".a:absline."j"
    elseif a:line < 0 | execute "normal ".a:absline."k" | endif
    execute "normal! $a".a:word
    call setpos('.',l:pos)
  elseif a:type == 1
    let l:addline=pos[1]+a:line
    if l:addline < 0 | return | endif
    call append(l:addline,a:word)
  endif
endfunction
function! EnInsert_AnyNumTimes(type,se,word,num)
  " insert words at end of current line.
  " type = 0   : word * num
  "      = 1   : word * (until column num)
  " se   = ""  : (word*num) for type=0
  "      = "A" : A(word*(num-2))A for type=0
  normal! $
  let l:col=col('.')
  let l:loopnum=0
  " insert type
  if  a:type == 0
    let l:loopnum=a:num
  elseif a:type == 1
    if a:num > l:col
      let l:loopnum=a:num-l:col
      if l:col==1 | let l:loopnum+=1 | endif
    else
      let l:loopnum=0
    endif
  endif
  let l:ins=''
  if a:se != ""
    let l:ins=l:ins.a:se
    let l:loopnum-=2
  endif
  while l:loopnum > 0
    let l:ins=l:ins.a:word
    let l:loopnum-=1
  endwhile
  execute "normal! $a".l:ins
  if a:se != "" | execute "normal! $a".a:se | endif
endfunction
" insert
" insert word (any-#) times
"======================================================================"
function! EnIndentLines(linenum)
  let l:pos=getpos(".")
  let l:abslinenum=abs(a:linenum)
  if a:linenum == 0
    execute "normal! \<S-v>="
  elseif a:linenum > 0
    execute "normal! \<S-v>".l:abslinenum."j="
  elseif a:linenum < 0
    execute "normal! \<S-v>".l:abslinenum."k="
  endif
  call setpos('.',l:pos)
endfunction

" end
