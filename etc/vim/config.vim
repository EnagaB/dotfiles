let g:CONFIG = {}
let g:CONFIG["min_required"] = 800

" path
let g:CONFIG['tmp_path'] = expand('$HOME/.local/tmp')
let g:CONFIG['tplfile_path_without_ext'] = expand('$HOME/.template/tpl')

" env
let g:CONFIG['term'] = expand("$TERM")

" install packages
let g:CONFIG['install_packages'] = [
            \ {'name': 'Shougo/denite.nvim'},
            \ {'name': 'tpope/vim-surround'},
            \ {'name': 'tyru/caw.vim'},
            \ {'name': 'vim-jp/cpp-vim'},
            \ {'name': 'octol/vim-cpp-enhanced-highlight'},
            \ {'name': 'sheerun/vim-polyglot'},
            \ {'name': 'morhetz/gruvbox'},
            \ {'name': 'gosukiwi/vim-atom-dark'},
            \ {'name': 'jacoborus/tender.vim'},
            \ {'name': 'raphamorim/lucario'},
            \ {'name': 'arcticicestudio/nord-vim'},
            \ {'name': 'junegunn/goyo.vim',
            \  'on_demand': {'command': 'Goyo'}},
            \ {'name': 'lambdalisue/fern.vim'}
            \ ]
let g:CONFIG['install_package_names'] = []
for s:i in g:CONFIG['install_packages']
    call add(g:CONFIG['install_package_names'], s:i['name'])
endfor

" colorscheme
let g:CONFIG['colorscheme'] = 'lucario_noitalic'
let g:CONFIG['colorscheme_without_packs'] = 'desert'
let g:CONFIG['background'] = 'dark'

" keybinding
let g:CONFIG['kbd_macro_register'] = 'y'
let g:CONFIG['hilight_word_register'] = 'z'
let g:CONFIG['line_margin'] = 2

" preinstall filetype settings
let g:tex_flavor='latex'

" tpope/vim-surround
let g:surround_no_mappings = 1

" lambdalisue/fern.vim
let g:fern_disable_startup_warnings = 1
let g:fern#default_hidden = 1
let g:fern#disable_default_mappings = 1
function! s:init_fern() abort
    nmap <buffer><nowait> C <Plug>(fern-action-copy)
    nmap <buffer><nowait> M <Plug>(fern-action-move)
    nmap <buffer><nowait> N <Plug>(fern-action-new-file)
    nmap <buffer><nowait> <C-m> <Plug>(fern-action-open-or-enter)
    nmap <buffer><nowait> <CR> <Plug>(fern-action-open-or-enter)
    nmap <buffer><nowait> <C-h> <Plug>(fern-action-leave)
    nmap <buffer><nowait> <BS> <Plug>(fern-action-leave)
    nmap <buffer><nowait> ? <Plug>(fern-action-help:all)
endfunction
augroup fern_custom
    autocmd! *
    autocmd FileType fern call s:init_fern()
augroup end

" sheerun/vim-polyglot
let g:polyglot_disabled = ['csv']
let g:vim_markdown_new_list_item_indent = 2
