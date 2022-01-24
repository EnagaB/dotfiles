" basic keybindings

" prefix
" <C-x> prefix like emacs
map! <C-x> <Plug>e(ctrl-x)
" for TMUX
noremap <C-z> <Nop>

" move in normal mode
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

" move in insert and command mode
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

" backspace char and delete char, word, line
noremap! <C-h> <bs>
noremap! <C-d> <del>
inoremap <M-d> <C-o>diw
" inoremap <C-k> <C-o>:<C-u>call<Space><SID>emacs_ctrl_k()<CR>
inoremap <C-k> <C-o>:EmacsCtrlk<CR>

" paste
inoremap <C-y> <C-o>p
cnoremap <C-y> <C-r>"

" save
inoremap <Plug>e(ctrl-x)<C-s> <C-o>:<C-u>w<CR>

" forward and backward search
inoremap <C-s> <C-o>/
inoremap <C-r> <C-o>?

" insert original key
noremap! <C-q> <C-v>

" EOF
