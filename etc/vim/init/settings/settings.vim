function! Params(name)
  execute 'return ' . 's:' . a:name
endfunction

let s:tpl_path = expand('$HOME/.template')
let s:tmp_path = expand('$HOME/.local/tmp')

let s:install_packs = [
      \ ['Shougo/denite.nvim', []],
      \ ['easymotion/vim-easymotion', []],
      \ ['tpope/vim-surround', []],
      \ ['tyru/caw.vim', []],
      \ ['vim-jp/cpp-vim', []],
      \ ['octol/vim-cpp-enhanced-highlight', []],
      \ ['sheerun/vim-polyglot', []],
      \ ['morhetz/gruvbox', []],
      \ ['gosukiwi/vim-atom-dark', []],
      \ ['jacoborus/tender.vim', []],
      \ ['raphamorim/lucario', []],
      \ ['dracula/vim', []],
      \ ['arcticicestudio/nord-vim', []],
      \ ['junegunn/goyo.vim', ['on', 'Goyo']]
      \ ]

let s:install_packs_name = []

" let s:colorscheme = 'gruvbox'
let s:colorscheme = 'nord'
let s:colorscheme_without_packs = 'desert'
let s:background = 'dark'

let s:kbd_macro_register = 'y'
let s:hilight_word_register = 'z'

let s:line_margin = 2

" EOF
