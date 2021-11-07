""" mapping / keybindings
" :(|nore)map(|!)      : map/noremap for normal,visual(insert,command) mode
" :(n|v|i|c)(|nore)map : map/noremap for normal/visual/insert/command  mode
" mode change by default (esc:normal end, C-c:forced end)
" normal <-[esc,C-c] [i,a,o,...]-> insert
"        <-[esc,C-c] [v,S-v,C-v]-> visual
"        <-[esc,C-c] [:        ]-> command
"        <-[:visual] [Q        ]-> Ex
" <S-a>=A,<C-a>=ctrl-a,<M-a>=alt-a
" not use <C-S-[a-z]>,<M-S-[a-z]>=crtl-[A-Z],meta-[A-Z]
" in     normal mode, not available keys = <C-[>=<Esc>
" in non-normal mode, not available keys =
" <C-i>=<Tab>,<C-m><CR>,<C-j>=<NL>,<C-[>=<Esc>,<C-h>=<BS>

""" setting
set notimeout
set ttimeoutlen=10
" tmux prefix key
noremap <C-z> <Nop>

""" meta-keybindings <M-[a-z]> are available
" <M-[a-z]> = <Esc>[a-z] : the meta keys use <Esc> as prefix key
" if editor is nvim, the meta keys work by default and do not use <Esc> prefix
if has('unix') && !has('nvim')
  for s:ii in Lowerlist()
    execute 'map  <Esc>'.s:ii.' <M-'.s:ii.'>'
    execute 'map! <Esc>'.s:ii.' <M-'.s:ii.'>'
  endfor
  " set <Esc><Esc> as original <Esc> operation
  noremap  <nowait><Esc><Esc> <Esc>
  noremap! <nowait><Esc><Esc> <Esc>
endif

""" core-keybindings
""" normal/visual mode h,j,l,k: <,^,v,>
"                   char:k,paragraph:S-k,page:C-k
"                              ^
" char:h,word:S-h,line:C-h < cursor > char:l,word:S-l,line:C-l
"                              v
"                   char:j,paragraph:S-j,page:C-j
noremap j gj
noremap k gk
noremap <S-h> b
noremap <S-j> }
noremap <S-k> {
noremap <S-l> e
noremap <C-h> 0
noremap <C-j> <C-f>
noremap <C-k> <C-b>
noremap <C-l> $

""" prefix
let mapleader='\'
map <Leader> <Plug>e(spc)
map <Space>  <Plug>e(spc)
map s        <Plug>e(pane)
map b        <Plug>e(buffer)
map t        <Plug>e(tab)
map m        <Plug>e(mark)
map <S-m>    <Plug>e(func)moveToMark
map <C-t>    <Plug>e(pef)
" pef-cmd
map <Plug>e(pef)<C-t>  <Plug>e(cmd)
" pef-otherprefix
map <Plug>e(pef)<Leader> <Plug>e(spc)
map <Plug>e(pef)<Space>  <Plug>e(spc)
map <Plug>e(pef)s        <Plug>e(pane)
map <Plug>e(pef)b        <Plug>e(buffer)
map <Plug>e(pef)t        <Plug>e(tab)
map <Plug>e(pef)m        <Plug>e(mark)
map <Plug>e(pef)<S-m>    <Plug>e(func)moveToMark

" Leader/spc prefix
noremap <Plug>e(spc)c     :<C-u>cd<space>
noremap <Plug>e(spc)<S-c> :<C-u>cd %:h<CR>
noremap <Plug>e(spc)q     :<C-u>.,$s///gc<Left><Left><Left><Left>
map     <Plug>e(spc)s     <Plug>e(func)grepQuickfix
map     <Plug>e(spc)<S-s> <Plug>e(func)regrepQuickfix
noremap <Plug>e(spc)w     :<C-u>w<CR>
noremap <Plug>e(spc)<S-w> :<C-u>w<Space>
noremap <Plug>e(spc)p     :<C-u>RegisterWord<CR>:HighlightRegisterWord<CR>
noremap <Plug>e(spc)<S-p> :<C-u>HighlightRegisterWord<CR>
noremap <Plug>e(spc)<C-p> :<C-u>HighlightRegister<CR>
noremap <Plug>e(spc)r     <C-o>
noremap <Plug>e(spc)o     :<C-u>e<Space>
noremap <Plug>e(spc)<S-o> :<C-u>e<Space>~/
noremap <Plug>e(spc)f     :<C-u>echo expand("%:p")<CR>

" pane prefix
noremap <Plug>e(pane)h     :<C-u>split<CR>
noremap <Plug>e(pane)v     :<C-u>vsplit<CR>
noremap <Plug>e(pane)n     <C-w>w
noremap <Plug>e(pane)p     <C-w><S-w>
noremap <Plug>e(pane)s     <C-w>w
noremap <Plug>e(pane)<S-s> <C-w>r
noremap <Plug>e(pane)x     :q<CR>
map     <Plug>e(pane)z     <Plug>e(func)toggleResizePane

" buffer prefix
noremap <Plug>e(buffer)n     :<C-u>bnext<CR>
noremap <Plug>e(buffer)p     :<C-u>bprev<CR>
noremap <Plug>e(buffer)b     :<C-u>bnext<CR>
noremap <Plug>e(buffer)<S-n> :<C-u>Buffers<CR>:<C-u>Buffer<Space>
noremap <Plug>e(buffer)l     :<C-u>Buffers<CR>
noremap <Plug>e(buffer)x     :<C-u>Bclose<CR>
noremap <Plug>e(buffer)o     :<C-u>e<Space>
noremap <Plug>e(buffer)<S-o> :<C-u>e<Space>~/
" noremap <Plug>e(buffer)<S-x> :<C-u>buffers<CR>:<C-u>echo 'enter num/C-c'<CR>:<C-u>bdelete<Space>
for s:ii in range(1,9)
  execute 'noremap <Plug>e(buffer)'.s:ii.' :<C-u>Buffer '.s:ii.'<CR>'
endfor

" tab prefix
noremap <Plug>e(tab)n     :tabnext<CR>
noremap <Plug>e(tab)p     :tabprevious<CR>
noremap <Plug>e(tab)t     :tabnext<CR>
noremap <Plug>e(tab)<S-n> :tabmove +1<CR>
noremap <Plug>e(tab)<S-p> :tabmove -1<CR>
noremap <Plug>e(tab)c     :tablast<bar>tabnew<CR>
noremap <Plug>e(tab)x     :tabclose<CR>
for s:ii in range(1,9)
  execute 'noremap <Plug>e(tab)'.s:ii.' :<C-u>tabnext '.s:ii.'<CR>'
endfor

" mark prefix
noremap <Plug>e(mark)m     :<C-u>AutoMark <CR>
noremap <Plug>e(mark)<S-m> :<C-u>AutoMark!<CR>
noremap <Plug>e(mark)n     ]`
noremap <Plug>e(mark)p     [`
noremap <Plug>e(mark)l     :<C-u>marks<CR>
    map <Plug>e(mark)x     <Plug>e(func)delmark
noremap <Plug>e(mark)<S-x> :<C-u>delmarks!<CR>

" cmd prefix
noremap <Plug>e(cmd)c     :ShowColorscheme<CR>:SetColorscheme<Space>
noremap <Plug>e(cmd)e     :messages<CR>
noremap <Plug>e(cmd)g     :<C-u>packadd<Space>goyo.vim<CR>:<C-u>Goyo<CR>
noremap <Plug>e(cmd)m     :verbose map<CR>
noremap <Plug>e(cmd)<S-m> :verbose map<Space>
noremap <Plug>e(cmd)<C-e> :execute '! '.expand('%:p')<CR>
noremap <Plug>e(cmd)p     :PackUpdate<CR>
noremap <Plug>e(cmd)<S-p> :PackClean<CR>
noremap <Plug>e(cmd)<C-p> :PackLoad<CR>
noremap <Plug>e(cmd)r     :InsertRandom 4<CR>
noremap <Plug>e(cmd)<S-r> :InsertRandom 8<CR>
noremap <Plug>e(cmd)<C-r> :<C-u>source $MYVIMRC<CR>:<C-u>echo 'resource ~/.vimrc'<CR>
map     <Plug>e(cmd)s     <Plug>e(func)syntexInfo
map     <Plug>e(cmd)t     <Plug>e(func)TEST
map     <Plug>e(cmd)<S-t> <Plug>e(func)TEST
map     <Plug>e(cmd)<C-t> <Plug>e(func)TEST
noremap <Plug>e(cmd)v     :verbose<Space>
noremap <Plug>e(cmd)E     g<S-q>

""" other
""" search
noremap <C-s> /
noremap <C-r> ?
noremap <expr>n     v:searchforward ? "n"      : "\<S-n>"
noremap <expr><S-n> v:searchforward ? "\<S-n>" : "n"
" vim-easymotion
map  <S-s> <Plug>(easymotion-bd-f)
nmap <S-s> <Plug>(easymotion-overwin-f)
" nmap <C-s> <Plug>(easymotion-overwin-f2)
map  <C-f> <Plug>(easymotion-bd-w)
nmap <C-f> <Plug>(easymotion-overwin-w) 
" one-char one-line search in normal and visual mode
" imiaru?
nnoremap    f       :OneCLsearch<CR>
nnoremap <S-f>      :OneCLsearch!<CR>
noremap <expr>w     getcharsearch().forward ? ';' : ','
noremap <expr><S-w> getcharsearch().forward ? ',' : ';'
command! -bang OneCLsearch call <SID>OneCLsearch(<q-bang>)
function! s:OneCLsearch(bang)
  echo 'press search char: '
  let l:char = Getchar()
  if empty(a:bang)
    execute 'normal! f'.l:char
  else
    execute 'normal! F'.l:char
  endif
endfunction
" insert 1 line
noremap <C-o> o<Esc>
" indent
nnoremap <C-i> ==
vnoremap <C-i> =
nnoremap e     >>
nnoremap <S-e> <<
" yank(copy) from cursor to end-of-line (crsp D)
noremap Y y$
" toggle start/end record keyboard macro and call the keyboard macro
execute 'noremap <S-q> :normal! q' . g:params['register']['kbd_macro'] . '<CR>'
execute 'noremap <C-q> @' . g:params['register']['kbd_macro']
" undo/redo
noremap u     u
noremap <S-u> r
noremap r     <C-r>
" no hilight
noremap <C-n> :nohlsearch<CR>
" increment/decrement number
noremap +     <C-a>
noremap -     <C-x>
" non-use nameless register and use underscore register
noremap x "_x
" zt/zb insert margin
let s:line_margin_x3 = g:params['line_margin'] * 3
execute 'nnoremap zt zt' . g:params['line_margin'] . '<C-y>'
execute 'nnoremap zb zb' . g:params['line_margin'] . '<C-e>'
execute 'nnoremap z<S-t> zt' . s:line_margin_x3 . '<C-y>'
execute 'nnoremap z<S-b> zb' . s:line_margin_x3 . '<C-e>'

""" toggle comment out
nmap c     <Plug>e(func)toggleCommentline
nmap <S-c> <Plug>e(func)toggleCommentline
""" tyru/caw.vim: toggle comment out
if match(g:params['pack']['start'], 'caw.vim')
  nmap c     <Plug>(caw:hatpos:toggle)
  vmap c     <Plug>(caw:hatpos:toggle)
  nmap <S-c> <Plug>(caw:hatpos:toggle)
  vmap <S-c> <Plug>(caw:hatpos:toggle)
endif

" jiangmiao/auto-pairs
xmap s     <Plug>VSurround
xmap <S-s> <Plug>VgSurround
" fold open/close = zo z<S-o> <S-z><S-o>/ zc z<S-c> <S-z><S-c>
noremap  <S-z><S-c> z<S-m>
noremap  <S-z><S-o> z<S-r>
""" unavailable
nnoremap <S-z><S-q> <Nop>
nnoremap <S-z><S-z> <Nop>
noremap  <C-a>      <Nop>
noremap  <C-x>      <Nop>
noremap  za         <Nop>
noremap  z<S-a>     <Nop>
noremap  zr         <Nop>
noremap  zm         <Nop>
vnoremap u          <Nop>
vnoremap <S-u>      <Nop>

""" grep and quickfix
noremap <Plug>e(func)grepQuickfix   :<C-u>call <SID>grepQuickfix(v:true )<CR>
noremap <Plug>e(func)regrepQuickfix :<C-u>call <SID>grepQuickfix(v:false)<CR>
function! s:grepQuickfix(sch)
  if !exists('b:qf_gpword')   | let b:qf_gpword=''   | endif
  if !exists('b:qf_savemaps') | let b:qf_savemaps={} | endif
  let l:curwinnr=winnr()
  let l:qfwinid=getqflist({'winid':0})
  let l:qf_chkeys = ['j', 'k', 'q']
  if l:qfwinid["winid"] == 0
    """ vimgrep and open cwindow
    if a:sch
      let b:qf_gpword=input('Enter grep pattern: ')
    endif
    if empty(b:qf_gpword) | return | endif
    execute 'vimgrep /'.b:qf_gpword.'/j %:p'
    if len(getqflist()) == 0 | return | endif
    if empty(b:qf_savemaps)
      let b:qf_savemaps=Save_mappings(l:qf_chkeys,'n',v:false)
      nnoremap <buffer>j :cnext<CR>zz
      nnoremap <buffer>k :cprevious<CR>zz
      nnoremap <buffer>q :GrepQuickFix<CR>
    endif
  else
    """ close cwindow
    call setqflist([],'r')
    if !empty(b:qf_savemaps)
      for l:ii in l:qf_chkeys
        execute 'nunmap <buffer>'.l:ii
      endfor
      call Restore_mappings(b:qf_savemaps)
      let b:qf_savemaps={}
    endif
  endif
  execute 'cwindow '.min([max([len(getqflist()), 1]), 5])
  execute l:curwinnr.'wincmd w'
endfunction

""" highlight word commands
command! RegisterWord          execute 'let @' . g:params['register']['hilight_word'] . '=expand("<cword>")'
command! HighlightRegister     set nohlsearch | let @/=eval('@' . g:params['register']['hilight_word']) | set hlsearch
command! HighlightRegisterWord set nohlsearch | let @/='\<' . eval('@' . g:params['register']['hilight_word']) . '\>' | set hlsearch

""" toggle pane size maximized/balanced
noremap <Plug>e(func)toggleResizePane :call <SID>toggleResizePane()<CR>
function! s:toggleResizePane()
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

""" buffer functions
let s:bufcharlist = Numlist() + Lowerlist()
""" close buffer without closing pane
command! -bang -complete=buffer -nargs=* Bclose call <SID>Bclose(<q-bang>, <q-args>)
function! s:Bclose(bang, buffer)
  if v:version < 700 || &compatible | return | endif
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
""" modified :buffers (:ls)
" buffer-number is not in the order (1,2,3,...)
" this function set the new buffer-number
command! Buffers call <SID>Buffers()
function! s:Buffers()
  let l:bufinfo=getbufinfo({'buflisted':1})
  " let l:bufinfo=getbufinfo({'bufloaded':1})
  " let l:bufinfo=getbufinfo({'bufmodified':1})
  " let l:bufinfo=getbufinfo()
  let l:lenbufi=len(l:bufinfo)
  let l:currbufnr=bufnr()
  let l:ii=0
  echo 'key : buffer-name'
  while l:ii < l:lenbufi
    echo CorrStrlength(GetStrlist(s:bufcharlist,l:ii+1),3)
    if l:currbufnr == l:bufinfo[l:ii]["bufnr"]
      echon ' % '
    else
      echon ' : '
    endif
    echon l:bufinfo[l:ii]["name"]
    let l:ii=l:ii+1
  endwhile
endfunction
""" modified :buffer
" use buffer-number by function s:Buffers()
command! -nargs=1 Buffer call <SID>Buffer(<f-args>)
function! s:Buffer(key)
  let l:bufinfo=getbufinfo({'buflisted':1})
  " let l:bufinfo=getbufinfo()
  let l:jj=MatchStrlist(s:bufcharlist,a:key)
  if l:jj <= 0 || l:jj > len(l:bufinfo)
    echo 'err: miss key'
    return
  endif
  execute 'buffer '.l:bufinfo[l:jj-1]['bufnr']
endfunction

""" mark functions
let s:marklist = Lowerlist()
command! -bang AutoMark call <SID>AutoMark(<q-bang>)
function! s:AutoMark(bang)
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
noremap <Plug>e(func)delmark :<C-u>call <SID>deleteMark()<CR>
function! s:deleteMark()
  echon 'delete mark: '
  let l:mark=Getchar()
  echon l:mark
  execute 'delmarks '.l:mark
endfunction
noremap <Plug>e(func)moveToMark :<C-u>call <SID>moveToMark()<CR>
function! s:moveToMark()
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

""" insert random word (alnum)
command! -nargs=1 InsertRandom call <SID>insertRandom(<f-args>)
function! s:insertRandom(len)
  " get insert-word
  let l:insstr=''
  while v:true
    let l:rstr=system('cat /dev/random | base64 | head -n 1 | sed -r -e "s/[^[:alnum:]]//g"')
    let l:insstr=l:insstr.l:rstr
    if len(l:insstr) >= a:len | break | endif
  endwhile
  let l:insstr=strpart(l:insstr,0,a:len)
  " insert
  let l:curpos=getpos('.')
  let l:curline=getline(l:curpos[1])
  call setline(l:curpos[1],strpart(l:curline,0,l:curpos[2]).l:insstr.strpart(l:curline,l:curpos[2]))
  " move cursor
  let l:curpos[2]=l:curpos[2]+a:len
  call setpos('.',l:curpos)
endfunction

""" toggle comment out
" not visual mode: mod in visual mode, getpos("'<") ~ getpos("'>")
noremap <Plug>e(func)toggleCommentline :<C-u>call <SID>toggleCommentline()<CR>
function! s:toggleCommentline()
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
function! s:toggleCommentline_v2()
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

" end
