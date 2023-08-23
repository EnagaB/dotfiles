let g:CONFIG = {}
let g:CONFIG["min_required"] = 800

" path
let g:CONFIG["after_dir"] = g:dotvim_dir . '/after'
let g:CONFIG['tmp_path'] = expand('$HOME/.local/tmp')
let g:CONFIG['tplfile_path_without_ext'] = expand('$HOME/.template/tpl')

" env
let g:CONFIG['term'] = expand("$TERM")

" packages
let g:CONFIG['packages'] = [
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
            \ {'name': 'EdenEast/nightfox.nvim'},
            \ {'name': 'arcticicestudio/nord-vim'},
            \ {'name': 'junegunn/goyo.vim',
            \  'on_demand': {'command': 'Goyo'}},
            \ ]
let g:CONFIG["conditional_packages"] = [
            \ {"condition": has('patch-8.1-2269') || has('nvim-0.4.4'),
            \  "packages": [{'name': 'lambdalisue/fern.vim'}]}
            \ ]
for s:cond_packages in g:CONFIG['conditional_packages']
    if ! s:cond_packages['condition']
        continue
    endif
    let g:CONFIG['packages'] += s:cond_packages['packages']
endfor

" colorscheme
" let g:CONFIG['colorscheme'] = 'lucario_noitalic'
let g:CONFIG['colorscheme'] = 'nightfox'
let g:CONFIG['colorscheme_without_packs'] = 'desert'
let g:CONFIG['background'] = 'dark'

" user highlight
highlight link User1 Visual
highlight link User2 PmenuSel
highlight link User3 DiffText
highlight link User4 DiffChange
highlight link User5 IncSearch
highlight link User6 StatusLineNC
"
" keybinding
let g:CONFIG['kbd_macro_register'] = 'y'
let g:CONFIG['hilight_word_register'] = 'z'
let g:CONFIG['line_margin'] = 2
