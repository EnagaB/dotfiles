" Load Once
if exists('g:loaded_syntax_cmds') && g:loaded_syntax_cmds
    finish
endif
let g:loaded_syntax_cmds = 1

command! ShowSyntaxInfo call syntax_cmds#ShowSyntaxInfo()
command! ShowColors source $VIMRUNTIME/syntax/colortest.vim
command! ShowHilightgroup verbose highlight
