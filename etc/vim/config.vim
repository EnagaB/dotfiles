function! Params(name)
  execute 'return ' . 's:' . a:name
endfunction

" path
let s:tmp_path = expand('$HOME/.local/tmp')
let s:tplfile_path_without_ext = expand('$HOME/.template/tpl')

" env
" let s:term = getenv('TERM')
let s:term = expand("$TERM")

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
" let s:colorscheme = 'nord'
let s:colorscheme = 'lucario'
let s:colorscheme_without_packs = 'desert'
let s:background = 'dark'

let s:kbd_macro_register = 'y'
let s:hilight_word_register = 'z'

let s:line_margin = 2

" preinstall filetype settings
let g:tex_flavor='latex'

""" easymotion/vim-easymotion
let g:EasyMotion_do_mapping       = 0 " default mapping off
let g:EasyMotion_smartcase        = 1 " smartcase for EM
let g:EasyMotion_enter_jump_first = 1 " enter : move to first match
let g:EasyMotion_space_jump_first = 1 " space : move to first match
let g:EasyMotion_keys             = 'hjklyuiopnmgfdsatrewqbvcxz'

""" tpope/vim-surround
let g:surround_no_mappings = 1

" EOF
