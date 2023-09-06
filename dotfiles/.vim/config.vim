let g:CONFIG = {}

" path
let g:CONFIG['tmp_dir'] = expand('$HOME/.local/tmp')
let g:CONFIG['template_dir'] = expand('$HOME/.template')

" env
let g:CONFIG['term'] = expand("$TERM")

" packages
let g:CONFIG['packages'] = [
            \ {'name': 'Shougo/denite.nvim'},
            \ {'name': 'tpope/vim-surround'},
            \ {'name': 'tyru/caw.vim'},
            \ {'name': 'vim-jp/cpp-vim'},
            \ {'name': 'octol/vim-cpp-enhanced-highlight'},
            \ {'name': 'morhetz/gruvbox'},
            \ {'name': 'gosukiwi/vim-atom-dark'},
            \ {'name': 'jacoborus/tender.vim'},
            \ {'name': 'raphamorim/lucario'},
            \ {'name': 'arcticicestudio/nord-vim'},
            \ {'name': 'junegunn/goyo.vim',
            \  'on_demand': {'command': 'Goyo'}},
            \ {'name': 'arcticicestudio/nord-vim'},
            \ {'name': 'vim-python/python-syntax',
            \  'for': 'python'},
            \ {'name': 'Vimjas/vim-python-pep8-indent',
            \  'for': 'python'},
            \ {'name': 'godlygeek/tabular'},
            \ {'name': 'preservim/vim-markdown',
            \  'for': 'markdown'},
            \ {'name': 'lunacookies/vim-sh',
            \  'for': 'sh'},
            \ ]

let g:CONFIG["cond_packages"] = {
            \ 'fern.vim': {'condition': has('patch-8.1.2269') || has('nvim-0.4.4'),
            \              'package': {'name': 'lambdalisue/fern.vim'}},
            \ 'nightfox.nvim': {'condition': (has('patch-9.0.0') && has('lua')) || has('nvim-0.8.0'),
            \                   'package': {'name': 'EdenEast/nightfox.nvim'}},
            \ 'hop.nvim': {'condition': has('nvim-0.5.0'),
            \              'package': {'name': 'phaazon/hop.nvim'}},
            \ }
for [s:package_key, s:package] in items(g:CONFIG['cond_packages'])
    if ! s:package['condition']
        continue
    endif
    let g:CONFIG['packages'] += [s:package['package']]
endfor

" colorscheme
if g:CONFIG['cond_packages']['nightfox.nvim']['condition']
    let g:CONFIG['colorscheme'] = 'nordfox'
else
    let g:CONFIG['colorscheme'] = 'lucario_noitalic'
endif
let g:CONFIG['colorscheme_without_packs'] = 'desert'
let g:CONFIG['background'] = 'dark'

" user highlight
highlight link User1 Visual
highlight link User2 PmenuSel
highlight link User3 DiffText
highlight link User4 DiffChange
highlight link User5 IncSearch
highlight link User6 StatusLineNC
