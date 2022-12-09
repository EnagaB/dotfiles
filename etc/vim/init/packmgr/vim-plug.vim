if ! g:use_packmgr_vim_plug || exists('g:loaded_packmgr')
  finish
endif
let g:loaded_packmgr = 1

" install package manager
let s:packmgr_pack_path = g:dotvim_dir . '/autoload_vim-plug'
let s:packmgr_path = g:dotvim_dir . '/autoload/plug.vim'
if ! filereadable(s:packmgr_path)
  call system('curl -fLo ' . s:packmgr_path
        \ . ' --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn'
        \ . '/vim-plug/master/plug.vim')
endif

" set packages
call plug#begin(s:packmgr_pack_path)
for _p in Params('install_packs')
  let _pack = _p[0]
  let _attr = _p[1]
  let _on_idx = index(_attr, 'on')
  if len(_attr) == 0
    Plug _pack
  elseif _on_idx != -1
    Plug _pack, {'on': _attr[_on_idx+1]}
  endif
endfor
call plug#end()

" command
command! PackUpdate PlugUpdate! --sync
      \ | SetDefaultColorscheme
command! PackClean PlugClean

" EOF
