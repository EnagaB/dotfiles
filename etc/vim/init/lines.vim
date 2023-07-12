" anywhere SID
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

highlight link User1 Visual
highlight link User2 PmenuSel
highlight link User3 DiffText
highlight link User4 DiffChange
highlight link User5 IncSearch
highlight link User6 StatusLineNC

set showtabline=2
set laststatus=2

" tab line
function! s:set_tab_line()
    let s = ''
    for i in range(1, tabpagenr('$'))
        let bufnrs = tabpagebuflist(i)
        let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
        let no = i  " display 0-origin tabpagenr.
        let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
        let title = fnamemodify(bufname(bufnr), ':t')
        let title = '[' . title . ']'
        let s .= '%'.i.'T'
        let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
        let s .= no . ':' . title
        let s .= mod
        let s .= '%#TabLineFill# '
    endfor
    let s .= '%#TabLineFill#%T%=%#TabLine#'
    return s
endfunction

" status line
function! s:set_status_line()
    if mode() =~ '^n'
        let l:c=1
        let l:m='NORMAL'
    elseif mode() =~ '^i'
        let l:c=2
        let l:m='INSERT'
    elseif mode() =~ '^\(v\|V\|\|s\|S\|\)'
        let l:c=3
        let l:m='VISUAL'
    elseif mode() =~ '^R'
        let l:c=3
        let l:m='REPLACE'
    elseif mode() =~ '^c'
        let l:c=4
        let l:m='COMMAND'
    else
        let l:c=5
        let l:m='OTHER'
    endif
    let l:s=''
    let l:s=l:s.'%'.l:c.'* '.l:m.' %*'
    let l:s=l:s.' %n:[%{expand("%:p:t")}] '
    let l:s=l:s.'%{(&modified?"+":(&modifiable?" ":"-"))} '
    let l:s=l:s.'%6*'
    let l:s=l:s.'%<'
    let l:s=l:s.'%='
    let l:s=l:s.'['.getcwd().'] '
    let l:s=l:s.'%{&filetype!=""?&filetype." ":""}%{&fenc!=""?&fenc:&enc}-%{&ff} '
    let l:s=l:s.'%*'
    let l:s=l:s.' %3p%% '
    let l:s=l:s.'%'.l:c.'* %3l:%-2c %*'
    return l:s
endfunction

execute 'set tabline=%!' . s:SID_PREFIX() . 'set_tab_line()'
execute 'set statusline=%!' . s:SID_PREFIX() . 'set_status_line()'
