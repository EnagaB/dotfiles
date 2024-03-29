set laststatus=2

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

" anywhere SID
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

execute 'set statusline=%!' . s:SID_PREFIX() . 'set_status_line()'
