" function! Params(name)
"   execute 'return ' . 's:' . a:name
" endfunction

let g:CONFIG = {}

" path
let g:CONFIG['tmp_path'] = expand('$HOME/.local/tmp')
let g:CONFIG['tplfile_path_without_ext'] = expand('$HOME/.template/tpl')

" env
let g:CONFIG['term'] = expand("$TERM")

" install packages
let g:CONFIG['install_packages'] = [{'name': 'Shougo/denite.nvim'},
                                  \ {'name': 'easymotion/vim-easymotion'},
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
                                  \ {'name': 'lambdalisue/fern.vim'}]
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

" easymotion/vim-easymotion
let g:EasyMotion_do_mapping       = 0 " default mapping off
let g:EasyMotion_smartcase        = 1 " smartcase for EM
let g:EasyMotion_enter_jump_first = 1 " enter : move to first match
let g:EasyMotion_space_jump_first = 1 " space : move to first match
let g:EasyMotion_keys             = 'hjklyuiopnmgfdsatrewqbvcxz'

" tpope/vim-surround
let g:surround_no_mappings = 1

" lambdalisue/fern.vim
let g:fern_disable_startup_warnings = 1

" sheerun/vim-polyglot
let g:polyglot_disabled = ['csv']

" EOF
