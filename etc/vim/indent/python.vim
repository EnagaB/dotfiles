""" additional settings for indent/python.vim
if exists("b:did_e_indent_python") | finish | endif
let b:did_e_indent_python=1

set tabstop=4 shiftwidth=0 expandtab softtabstop=-1 smarttab

" neovim
let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth() * 2'
let g:python_indent.nested_paren = 'shiftwidth()'
let g:python_indent.continue = 'shiftwidth() * 2'

""" END
