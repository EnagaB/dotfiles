" add ftplugin netrw.vim

let g:netrw_home=g:dottmp
let g:netrw_liststyle=1
let g:netrw_banner   =0
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d %H:%M:%S"
let g:netrw_preview=1
map     <buffer>s     <Plug>e(pane)
noremap <buffer><S-d> <Nop>
noremap <buffer>r     <S-u>

" end
