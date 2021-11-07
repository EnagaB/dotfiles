""" package manager

""" minpac: enhanced vim default plugin manager
" package load order: 1. in    vimrc   , packadd/packadd! opt-plugins
"                   : 2. after vimrc   , start-plugins
"                   : 3. after initload, packadd opt-plugins

""" autoinstall by git
let s:pmRepo = g:params['path']['base'] . '/pack/minpac/opt/minpac'
if ! isdirectory(s:pmRepo)
  call system('git clone --depth 1 https://github.com/k-takata/minpac.git '.shellescape(s:pmRepo))
endif

""" main function
function! s:PackInit() abort
  packadd minpac
  call minpac#init()
  call minpac#add('k-takata/minpac',{'type':'opt'})
  """ start
  for s:pack in g:params['pack']['start']
    call minpac#add(s:pack)
  endfor
  """ opt
  for s:pack in g:params['pack']['opt']
    call minpac#add(s:pack,{'type':'opt'})
  endfor
  """ colorschemes
  for s:list in g:params['pack']['colorscheme']
    call minpac#add(s:list[0],{'type':'opt'})
  endfor
endfunction

""" load function
function! s:PackLoad() abort
  let l:paclist=keys(minpac#getpluglist())
  " start
  packloadall!
  " opt
  for l:pac in l:paclist
    execute 'packadd '.l:pac
  endfor
endfunction

""" command
" install/update packages
command! PackUpdate source $MYVIMRC | call <SID>PackInit() | call minpac#update()
" uninstall unnecessary packages
command! PackClean  source $MYVIMRC | call <SID>PackInit() | call minpac#clean()
" load all packages
command! PackLoad source $MYVIMRC | call <SID>PackInit() | call <SID>PackLoad()

" end
