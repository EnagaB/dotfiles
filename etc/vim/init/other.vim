" clear e augroup
augroup eau
  autocmd!
  autocmd eau BufReadPost * delmarks!
augroup end
" clear registers
if has('vim_starting')
  for s:reg in Lowerlist()
    call setreg(s:reg,'')
  endfor
endif

" color
SetDefaultColorscheme

""" tab/indent
""" textwidth
set textwidth=100
set colorcolumn=+1
""" character encode
set encoding=utf-8
set fileencodings=utf-8,sjis,utf-16le,iso-2022-jp,euc-jp
set fileformats=unix,dos,mac
" scriptencoding utf-8
""" backup
set nobackup
set noswapfile
set autoread
set hidden
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set clipboard&
if has('unnamedplus')
  set clipboard^=unnamedplus
endif
set visualbell
set viminfo=
set noundofile
set viewdir=~/.vim_view
set shortmess+=I
set formatoptions-=t
set formatoptions-=c
set ruler wrap showcmd
set display=lastline
set pumheight=10
set foldmethod=marker
""" list
" insert unicode cmd in insert mode : C-v u (code) 
" unicode eol:U+21B5 , precedes:U+226A , extends:U+226B
" -> double length character is deprecated.
" hi option NonText    : eol, extends, precedes
"           SpecialKey : tab, trail, nbsp
set list " off cmd :set nolist
set listchars=
set listchars+=tab:>-
set listchars+=trail:-
set listchars+=eol:$
set listchars+=extends:>
set listchars+=precedes:<
" hi NonText    ctermbg=None ctermfg=59 guibg=NONE guifg=None
" hi SpecialKey ctermbg=None ctermfg=59 guibg=NONE guifg=None
set noshowmatch matchtime=1
let g:matchparen_timeout        = 10
let g:matchparen_insert_timeout = 10
" search
set ignorecase smartcase incsearch hlsearch
" indentkeys : add C-t , C-i
set indentkeys&
set indentkeys+=!^T
set indentkeys+=!^I

" EOF
