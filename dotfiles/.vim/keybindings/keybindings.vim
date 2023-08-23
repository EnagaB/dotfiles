" move in normal mode
noremap j gj
noremap k gk
" insert and command modes like emacs
" char
noremap! <C-f> <right>
noremap! <C-b> <left>
" line
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$
cnoremap <C-a> <C-b>
cnoremap <C-e> <C-e>
" backspace, delete
noremap! <C-h> <bs>
noremap! <C-d> <del>
" paste
inoremap <C-y> <C-o>p
cnoremap <C-y> <C-r>"
" insert original key
noremap! <C-q> <C-v>
" unavailable
nnoremap K <Nop>
nnoremap ZQ <Nop>
nnoremap ZZ <Nop>
noremap  za <Nop>
noremap  zA <Nop>
noremap  zr <Nop>
noremap  zm <Nop>
vnoremap u <Nop>
vnoremap U <Nop>

if v:version < g:CONFIG["min_required"]
    finish
endif

" load
let s:script_dir = expand("<sfile>:p:h")
call SourceGlobpattern(s:script_dir . "/*_cmds.vim")

" setting
set notimeout
set ttimeoutlen=10

" meta-keybindings <M-[a-z]> are available
if has('unix') && !has('nvim')
    for s:ii in map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
        execute 'map  <Esc>'.s:ii.' <M-'.s:ii.'>'
        execute 'map! <Esc>'.s:ii.' <M-'.s:ii.'>'
    endfor
    " set <Esc><Esc> as original <Esc> operation
    noremap  <nowait><Esc><Esc> <Esc>
    noremap! <nowait><Esc><Esc> <Esc>
endif

" Leader and space 
let mapleader='\'
map <Leader> <Plug>(e:spc)
map <Space>  <Plug>(e:spc)
noremap <Plug>(e:spc)q :<C-u>.,$s///gc<Left><Left><Left><Left>
noremap <Plug>(e:spc)s :<C-u>GrepQuickfix<CR>
noremap <Plug>(e:spc)S :<C-u>GrepQuickfix!<CR>
noremap <Plug>(e:spc)w :<C-u>w<CR>
noremap <Plug>(e:spc)W :<C-u>w!<CR>
noremap <Plug>(e:spc)p     :<C-u>RegisterWord<CR>:HighlightRegisterWord<CR>
noremap <Plug>(e:spc)<S-p> :<C-u>HighlightRegisterWord<CR>
noremap <Plug>(e:spc)<C-p> :<C-u>HighlightRegister<CR>
noremap <Plug>(e:spc)o :<C-u>e<Space>
noremap <Plug>(e:spc)f :<C-u>OpenFiler<CR>
noremap <Plug>(e:spc)t :<C-u>term<CR>
noremap <Plug>(e:spc)c :<C-u>syntax off<CR>:<C-u>syntax enable<CR>

" pane
map s <Plug>(e:pane)
noremap <Plug>(e:pane)s <C-w>w
noremap <Plug>(e:pane)S <C-w>r
noremap <Plug>(e:pane)h :<C-u>split<CR>
noremap <Plug>(e:pane)v :<C-u>vsplit<CR>
noremap <Plug>(e:pane)x :q<CR>
noremap <Plug>(e:pane)z :<C-u>ToggleResizePanes<CR>

" buffer prefix
map S <Plug>(e:buffer)
noremap <Plug>(e:buffer)S :<C-u>bnext<CR>
noremap <Plug>(e:buffer)n :<C-u>bnext<CR>
noremap <Plug>(e:buffer)p :<C-u>bprev<CR>
noremap <Plug>(e:buffer)N :<C-u>Buffers<CR>:<C-u>Buffer<Space>
noremap <Plug>(e:buffer)l :<C-u>Buffers<CR>
noremap <Plug>(e:buffer)x :<C-u>Bclose<CR>
noremap <Plug>(e:buffer)o :<C-u>e<Space>
noremap <Plug>(e:buffer)O :<C-u>e<Space>~/
for s:ii in range(1,9)
    execute 'noremap <Plug>(e:buffer)'.s:ii.' :<C-u>Buffer '.s:ii.'<CR>'
endfor

" tab
map t <Plug>(e:tab)
noremap <Plug>(e:tab)t :tabnext<CR>
noremap <Plug>(e:tab)n :tabnext<CR>
noremap <Plug>(e:tab)p :tabprevious<CR>
noremap <Plug>(e:tab)N :tabmove +1<CR>
noremap <Plug>(e:tab)P :tabmove -1<CR>
noremap <Plug>(e:tab)c :tablast<bar>tabnew<CR>
noremap <Plug>(e:tab)x :tabclose<CR>
for s:ii in range(1,9)
    execute 'noremap <Plug>(e:tab)'.s:ii.' :<C-u>tabnext '.s:ii.'<CR>'
endfor

" mark prefix
map m <Plug>(e:mark)
noremap <Plug>(e:mark)m     :<C-u>SetMarkAuto<CR>
noremap <Plug>(e:mark)<S-m> :<C-u>SetMarkAuto!<CR>
noremap <Plug>(e:mark)n     ]`
noremap <Plug>(e:mark)p     [`
noremap <Plug>(e:mark)l     :<C-u>marks<CR>
noremap <Plug>(e:mark)x     :<C-u>DeleteMark<CR>
noremap <Plug>(e:mark)<S-x> :<C-u>delmarks!<CR>

" yank(copy) from cursor to end-of-line (crsp D)
noremap Y y$

" toggle start/end record keyboard macro and call the keyboard macro
execute 'noremap <S-q> :normal! q' . g:CONFIG['kbd_macro_register'] . '<CR>'
execute 'noremap <C-q> @' . g:CONFIG['kbd_macro_register']

" no hilight
noremap <C-n> :nohlsearch<CR>

" non-use nameless register and use underscore register
noremap x "_x

" zt/zb insert margin
let s:line_margin_x3 = g:CONFIG['line_margin'] * 3
execute 'nnoremap zt zt' . g:CONFIG['line_margin'] . '<C-y>'
execute 'nnoremap zb zb' . g:CONFIG['line_margin'] . '<C-e>'
execute 'nnoremap z<S-t> zt' . s:line_margin_x3 . '<C-y>'
execute 'nnoremap z<S-b> zb' . s:line_margin_x3 . '<C-e>'

""" toggle comment out
nmap <C-k>     :<C-u>ToggleCommentout<CR>
""" tyru/caw.vim: toggle comment out
if IsInstallPackageName('tyru/caw.vim')
    nmap <C-k> <Plug>(caw:hatpos:toggle)
    vmap <C-k> <Plug>(caw:hatpos:toggle)
endif
