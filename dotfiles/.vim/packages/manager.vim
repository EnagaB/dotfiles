if exists('g:loaded_packmgr')
    finish
endif
let g:loaded_packmgr = 1

" install package manager
let s:packmgr_pack_path = g:dotvim_dir . '/autoload_vim-plug'
let s:packmgr_path = g:dotvim_dir . '/autoload/plug.vim'
if ! filereadable(s:packmgr_path)
    call system('curl -fLo ' . s:packmgr_path
                \ . ' --create-dirs '
                \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
endif

" set packages
call plug#begin(s:packmgr_pack_path)
for _package in g:CONFIG['packages']
    if has_key(_package, 'on_demand')
        let _package_ondemand = _package['on_demand']
        if has_key(_package_ondemand, 'command')
            Plug _package['name'], {'on': _package_ondemand['command']}
        endif
    else
        Plug _package['name']
    endif
endfor
call plug#end()

" command
command! PackUpdate PlugUpdate! --sync
            \ | SetDefaultColorscheme
command! PackClean PlugClean
