""" insert/command mode mappings like emacs/UNIX

""" prefix
map! <C-x> <Plug>e(ctrl-x)

""" move
"                   char:C-p,paragraph:M-p,page:M-v
"                                ^
" char:C-b,word:M-b,line:C-a < cursor > char:C-f,word:M-f,line:C-e
"                                v
"                   char:C-n,paragraph:M-n,page:C-v
noremap! <C-f> <right>
noremap! <C-b> <left>
inoremap <C-n> <C-o>gj
inoremap <C-p> <C-o>gk
cnoremap <C-n> <down>
cnoremap <C-p> <up>
inoremap <M-f> <C-o>e
inoremap <M-b> <C-o>b
inoremap <M-n> <C-o>}
inoremap <M-p> <C-o>{
cnoremap <M-f> <S-right>
cnoremap <M-b> <S-left>
inoremap <C-v> <C-o><C-b>
inoremap <M-v> <C-o><C-f>
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$
cnoremap <C-a> <C-b>
cnoremap <C-e> <C-e>

""" edit
" backspace:C-h
" delete: char:C-d,word:M-d
noremap! <C-h> <bs>
noremap! <C-d> <del>
inoremap <M-d> <C-o>diw

""" delete/copy/paste
" inoremap <C-k> <C-o><S-d>
inoremap <C-k> <C-o>:<C-u>call<Space><SID>emacs_ctrl_k()<CR>
inoremap <C-y> <C-o>p
cnoremap <C-y> <C-r>"
" save
inoremap <Plug>e(ctrl-x)<C-s> <C-o>:<C-u>w<CR>

""" search
inoremap <C-s> <C-o>/
inoremap <C-r> <C-o>?

""" adv. insert/command mode
" insert original key
noremap! <C-q> <C-v>

""" search/i-search function
" function! s:emacs_search(bang)
"   if !exists('b:emacsSearchStr')
"     let b:emacsSearchStr=''
"   endif
"   if b:emacsSearchStr == ''
"     let b:qf_gpword=input('Enter search pattern: ')
"   endif
" endfunction

""" emacs C-k
function! s:emacs_ctrl_k()
  let l:cpos=getpos('.')
  if len(getline(l:cpos[1])) == 0
    normal! dd
  else
    normal! D
    call setpos('.',l:cpos)
  endif
endfunction

" end
