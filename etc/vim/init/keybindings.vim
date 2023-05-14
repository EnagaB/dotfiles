" keybindings

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" prefix
" <C-x> prefix like emacs
map! <C-x> <Plug>e(ctrl-x)
" for TMUX
noremap <C-z> <Nop>

" move in normal mode
noremap j gj
noremap k gk

" insert and command modes like emacs
" char
noremap! <C-f> <right>
noremap! <C-b> <left>
inoremap <C-n> <C-o>gj
inoremap <C-p> <C-o>gk
cnoremap <C-n> <down>
cnoremap <C-p> <up>
" word
inoremap <M-f> <C-o>e
inoremap <M-b> <C-o>b
cnoremap <M-f> <S-right>
cnoremap <M-b> <S-left>
" line
inoremap <C-a> <C-o>0
inoremap <C-e> <C-o>$
cnoremap <C-a> <C-b>
cnoremap <C-e> <C-e>
" paragraph
inoremap <M-n> <C-o>}
inoremap <M-p> <C-o>{
" page
inoremap <C-v> <C-o><C-b>
inoremap <M-v> <C-o><C-f>
" backspace, delete
noremap! <C-h> <bs>
noremap! <C-d> <del>
" delete after cursor in line
inoremap <C-k> <C-o>D
" paste
inoremap <C-y> <C-o>p
cnoremap <C-y> <C-r>"
" search
inoremap <C-s> <C-o>/
inoremap <C-r> <C-o>?
" insert original key
noremap! <C-q> <C-v>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if v:version < 800
  finish
endif

" source keybind functions
" let s:src_dir = expand("<sfile>:p:h")
" execute 'source ' . s:src_dir . '/keybindings_functions.vim'

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

" prefix keys
" s = cl, S = cc
" t, T are similar to f, F
" mark m, M are hard to use
let mapleader='\'
map <Leader> <Plug>e(spc)
map <Space>  <Plug>e(spc)
map <Space> <Leader>

map s        <Plug>e(pane)
map t        <Plug>e(tab)
map <S-t>    <Plug>e(buffer)
map m        <Plug>e(mark)

" Leader/spc prefix
noremap <Plug>e(spc)q     :<C-u>.,$s///gc<Left><Left><Left><Left>
noremap <Plug>e(spc)s     :<C-u>GrepQuickfix<CR>
noremap <Plug>e(spc)<S-s> :<C-u>GrepQuickfix!<CR>
noremap <Plug>e(spc)w     :<C-u>w<CR>
noremap <Plug>e(spc)<S-w> :<C-u>w<Space>
noremap <Plug>e(spc)p     :<C-u>RegisterWord<CR>:HighlightRegisterWord<CR>
noremap <Plug>e(spc)<S-p> :<C-u>HighlightRegisterWord<CR>
noremap <Plug>e(spc)<C-p> :<C-u>HighlightRegister<CR>
noremap <Plug>e(spc)o     :<C-u>e<Space>
noremap <Plug>e(spc)<S-o> :<C-u>e<Space>~/
noremap <Plug>e(spc)f     :<C-u>Fern .<CR>

" pane
noremap <Plug>e(pane)h     :<C-u>split<CR>
noremap <Plug>e(pane)v     :<C-u>vsplit<CR>
noremap <Plug>e(pane)s     <C-w>w
noremap <Plug>e(pane)<S-s> <C-w>r
noremap <Plug>e(pane)x     :q<CR>
noremap <Plug>e(pane)z     :<C-u>ToggleResizePanes<CR>

" tab
noremap <Plug>e(tab)n     :tabnext<CR>
noremap <Plug>e(tab)p     :tabprevious<CR>
noremap <Plug>e(tab)<S-n> :tabmove +1<CR>
noremap <Plug>e(tab)<S-p> :tabmove -1<CR>
noremap <Plug>e(tab)c     :tablast<bar>tabnew<CR>
noremap <Plug>e(tab)x     :tabclose<CR>
for s:ii in range(1,9)
  execute 'noremap <Plug>e(tab)'.s:ii.' :<C-u>tabnext '.s:ii.'<CR>'
endfor

" buffer prefix
noremap <Plug>e(buffer)n     :<C-u>bnext<CR>
noremap <Plug>e(buffer)p     :<C-u>bprev<CR>
noremap <Plug>e(buffer)b     :<C-u>bnext<CR>
noremap <Plug>e(buffer)<S-n> :<C-u>Buffers<CR>:<C-u>Buffer<Space>
noremap <Plug>e(buffer)l     :<C-u>Buffers<CR>
noremap <Plug>e(buffer)x     :<C-u>Bclose<CR>
noremap <Plug>e(buffer)o     :<C-u>e<Space>
noremap <Plug>e(buffer)<S-o> :<C-u>e<Space>~/
for s:ii in range(1,9)
  execute 'noremap <Plug>e(buffer)'.s:ii.' :<C-u>Buffer '.s:ii.'<CR>'
endfor

" mark prefix
noremap <Plug>e(mark)m     :<C-u>SetMarkAuto<CR>
noremap <Plug>e(mark)<S-m> :<C-u>SetMarkAuto!<CR>
noremap <Plug>e(mark)n     ]`
noremap <Plug>e(mark)p     [`
noremap <Plug>e(mark)l     :<C-u>marks<CR>
noremap <Plug>e(mark)x     :<C-u>DeleteMark<CR>
noremap <Plug>e(mark)<S-x> :<C-u>delmarks!<CR>

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
if match(g:CONFIG['install_package_names'], 'tyru/caw.vim')
  nmap <C-k> <Plug>(caw:hatpos:toggle)
  vmap <C-k> <Plug>(caw:hatpos:toggle)
endif

""" unavailable
nnoremap <S-k>      <Nop>
nnoremap <S-z><S-q> <Nop>
nnoremap <S-z><S-z> <Nop>
noremap  za         <Nop>
noremap  z<S-a>     <Nop>
noremap  zr         <Nop>
noremap  zm         <Nop>
vnoremap u          <Nop>
vnoremap <S-u>      <Nop>
