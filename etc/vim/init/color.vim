""" color

""" color config
if has('termguicolors') | set termguicolors | endif " use guifg,guibg on CUI
let s:term=system('echo $TERM')
if s:term !~ '^xterm' && !has('gui_running')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

""" colorscheme
command! -nargs=1 SetColorscheme  call <SID>SetColorscheme(0,<f-args>)
command!          ShowColorscheme call <SID>SetColorscheme(1,100)
function! s:SetColorscheme(show,lind)
  if a:show == 1 | echo printf('%2s. %s',0,'default vim colorscheme') | endif
  " non-package colorscheme
  if a:lind == 0
    let l:cs='desert'
    let l:fn='colors/'.l:cs.'.vim'
    if !empty(globpath(&runtimepath,l:fn))
      execute 'colorscheme '.l:cs
    else
      colorscheme default
    endif
    let g:package_colorscheme=0
    return
  endif
  " package colorscheme
  let l:csnum=0
  let l:i1=0 | let l:i1max=len(g:params['pack']['colorscheme'])-1
  while l:i1 <= l:i1max
    let l:pac=g:params['pack']['colorscheme'][l:i1][0]
    let l:cs =g:params['pack']['colorscheme'][l:i1][1]
    let l:i2=2 | let l:i2max=len(g:params['pack']['colorscheme'][l:i1])-1
    while l:i2 <= l:i2max
      let l:bg=g:params['pack']['colorscheme'][l:i1][l:i2]
      let l:csnum+=1
      if a:show == 1 | echo printf('%2s. %5s %s',l:csnum,l:bg,l:cs) | endif
      if l:csnum == a:lind | break | endif
      let l:i2+=1
    endwhile
    if l:csnum == a:lind | break | endif
    let l:i1+=1
  endwhile
  if a:show == 1 | return | endif
  " check colorscheme exist
  let l:fn='colors/'.l:cs.'.vim'
  let l:sppac=split(l:pac,'/')
  if empty(globpath(&runtimepath,l:fn))
        \ && empty(globpath(&packpath,'pack/*/start/'.l:sppac[1].'/'.l:fn))
        \ && empty(globpath(&packpath,'pack/*/opt/'.l:sppac[1].'/'.l:fn))
    return
  endif
  if l:cs == 'gruvbox'
    let g:gruvbox_contrast_light='soft'
    let g:gruvbox_contrast_dark='medium'
  endif
  execute 'colorscheme '.l:cs
  if l:bg == ''
    set background&
  else
    execute 'set background='.l:bg
  endif
  let g:package_colorscheme=1
endfunction

""" default colorscheme
call <SID>SetColorscheme(0,1)
if !exists("g:package_colorscheme") || g:package_colorscheme == 0
  call <SID>SetColorscheme(0,0)
endif

""" map check color commands
noremap <Plug>e(func)colortest :<C-u>source $VIMRUNTIME/syntax/colortest.vim<CR>
noremap <Plug>e(func)hitest    :<C-u>source $VIMRUNTIME/syntax/hitest.vim<CR>

""" show syntax information under cursor
" cohama, http://cohama.hateblo.jp/entry/2013/08/11/020849
noremap <Plug>e(func)syntexInfo :<C-u>call <SID>get_syn_info()<CR>
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction

" end
