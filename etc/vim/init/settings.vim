function! Params(name)
  execute 'return ' . 's:' . a:name
endfunction

" path
" let s:tpl_path = expand('$HOME/.template')
let s:tmp_path = expand('$HOME/.local/tmp')

let s:tplfile_without_ext = expand('$HOME/.template/tpl')

" env
let s:term = getenv('TERM')

" install packages
let g:use_packmgr_minpac = 0
let g:use_packmgr_vim_plug = 1
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
      \ ['arcticicestudio/nord-vim', []],
      \ ['junegunn/goyo.vim', ['on', 'Goyo']]
      \ ]

" colorscheme
" let s:colorscheme = 'gruvbox'
let s:colorscheme = 'nord'
let s:colorscheme_without_packs = 'desert'
let s:background = 'dark'

let s:kbd_macro_register = 'y'
let s:hilight_word_register = 'z'

let s:line_margin = 2

" preinstall filetype settings
let g:tex_flavor='latex'

" EOF
