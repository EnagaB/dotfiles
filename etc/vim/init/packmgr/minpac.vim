" minpac: enhanced vim default plugin manager
" package load order: 1. in    vimrc   , packadd/packadd! opt-plugins
"                   : 2. after vimrc   , start-plugins
"                   : 3. after initload, packadd opt-plugins

if ! g:use_packmgr_minpac || exists('g:loaded_packmgr')
  finish
endif
let g:loaded_packmgr = 1

" autoinstall by git
let s:minpac_packpath = g:base_path . '/autoload_minpac'
if match(&packpath, s:minpac_packpath) == -1
  execute 'set packpath ^=' . s:minpac_packpath
endif
let s:packmgr_path = s:minpac_packpath . '/pack/minpac/opt/minpac'
if ! isdirectory(s:packmgr_path)
  call system('git clone --depth 1 https://github.com/k-takata/minpac.git '.shellescape(s:packmgr_path))
endif

" init function
function! s:PackInit() abort
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  for s:pack in Params('install_packs')
    call minpac#add(s:pack[0])
  endfor
endfunction

" load function
function! s:PackLoad() abort
  let l:paclist=keys(minpac#getpluglist())
  " start
  packloadall!
  " opt
  for l:pac in l:paclist
    execute 'packadd '.l:pac
  endfor
endfunction

" command
command! PackUpdate source $MYVIMRC
      \ | call <SID>PackInit()
      \ | call minpac#update()
command! PackLoad source $MYVIMRC
      \ | call <SID>PackInit()
      \ | call <SID>PackLoad()
command! PackClean  source $MYVIMRC
      \ | call <SID>PackInit()
      \ | call minpac#clean()

" EOF
