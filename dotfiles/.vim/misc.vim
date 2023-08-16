" reset registers
if has('vim_starting')
    for s:reg in map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
        call setreg(s:reg, '')
    endfor
endif

" delete marks
augroup delete_marks
    autocmd!
    autocmd BufReadPost * delmarks!
augroup end

" filetype
augroup add_filetype
    autocmd BufNewFile,BufRead *.dockerfile set filetype=dockerfile
    autocmd BufNewFile,BufRead *.Dockerfile set filetype=dockerfile
augroup end

" insert template file
augroup insert_template
    autocmd!
    let s:tplfile_list = split(glob(g:CONFIG['tplfile_path_without_ext'] . '.*'), "\n")
    let s:len_tplfile_path_without_ext = strlen(g:CONFIG['tplfile_path_without_ext'])
    call sort(s:tplfile_list, "CompareStringLength")
    call reverse(s:tplfile_list)
    for ff in s:tplfile_list
        let s:ext = ff[s:len_tplfile_path_without_ext:]
        execute 'autocmd BufNewFile *' . s:ext . ' InsertFileOnlyOnce ' . ff
    endfor
augroup end

" set color
SetDefaultColorscheme

" tab and indent
if has('vim_starting')
    set tabstop=4 shiftwidth=0 expandtab softtabstop=-1 smarttab
    set autoindent smartindent
endif

" character encode
set fileencodings=utf-8,sjis,utf-16le,iso-2022-jp,euc-jp
set fileformats=unix,dos,mac

" show textwidth textwidth
if has('vim_starting')
    set textwidth=100
    set colorcolumn=+1
endif

" backups
set nobackup
set noswapfile
set noundofile
set viewoptions=
set viminfo=
execute 'set directory=' . g:CONFIG['tmp_path']
execute 'set viewdir=' . g:CONFIG['tmp_path']
execute 'set backupdir=' . g:CONFIG['tmp_path']
execute 'set undodir=' . g:CONFIG['tmp_path']

" clipboard
set clipboard&
if has('unnamedplus')
    set clipboard^=unnamedplus
endif

" list
set nolist
set listchars=
set listchars+=tab:>-
set listchars+=trail:-
set listchars+=eol:$
set listchars+=extends:>
set listchars+=precedes:<

" indentkeys
set indentkeys&
set indentkeys+=!^T
set indentkeys+=!^I

" search
set ignorecase smartcase incsearch hlsearch

" other
set autoread
set hidden
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set visualbell
set shortmess+=I
set formatoptions-=t
set formatoptions-=c
set ruler wrap showcmd
set display=lastline
set pumheight=10
set foldmethod=marker
set noshowmatch matchtime=1
let g:matchparen_timeout        = 10
let g:matchparen_insert_timeout = 10
