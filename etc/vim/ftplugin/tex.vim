""" first ftplugin tex.vim
" before did_ftplugin

""" mappings
" insert begin/end block
nnoremap <buffer><Plug>e(pef)ib :<C-u>TeXInsertBeginEndBlock<Space>
nnoremap <buffer><Plug>e(pef)ie :<C-u>TeXInsertBeginEndBlock<Space>align<CR>
nnoremap <buffer><Plug>e(pef)if :<C-u>call <SID>TeXInsertFigureBlock()<CR>

""" syntax
" highlight link texOnlyMath Delimiter
let g:tex_fast='cmMprsSvV'
let g:tex_no_error=1

""" other
let g:tex_conceal=''

""" insert begin/end block function
command! -nargs=1 TeXInsertBeginEndBlock call <SID>TeXInsertBeginEndBlock(<f-args>)
function! s:TeXInsertBeginEndBlock(cmdname)
  let l:bword='\begin{'.a:cmdname.'}'
  let l:eword='\end{'.a:cmdname.'}'
  let l:ii=0
  let l:ii=Append(l:ii,l:bword)
  let l:ii=Append(l:ii,l:eword)
endfunction

""" insert figure block function
function! s:TeXInsertFigureBlock()
  call <SID>TeXInsertBeginEndBlock('figure')
  let l:shift=repeat(' ',shiftwidth())
  let l:ii=1
  let l:ii=Append(l:ii,l:shift.'\centering')
  let l:ii=Append(l:ii,l:shift.'\includegraphics[width=0.8\linewidth]{}')
  let l:ii=Append(l:ii,l:shift.'\caption{}')
  let l:ii=Append(l:ii,l:shift.'\label{fg:}')
endfunction

" end
