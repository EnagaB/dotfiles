" setting
set notimeout
set ttimeoutlen=10

" meta-keybindings <M-[a-z]> are available
if has('unix') && !has('nvim')
  for s:ii in Lowerlist()
    execute 'map  <Esc>'.s:ii.' <M-'.s:ii.'>'
    execute 'map! <Esc>'.s:ii.' <M-'.s:ii.'>'
  endfor
  " set <Esc><Esc> as original <Esc> operation
  noremap  <nowait><Esc><Esc> <Esc>
  noremap! <nowait><Esc><Esc> <Esc>
endif

""" prefix
let mapleader='\'
map <Leader> <Plug>e(spc)
map <Space>  <Plug>e(spc)
map s        <Plug>e(pane)
map b        <Plug>e(buffer)
map t        <Plug>e(tab)
map m        <Plug>e(mark)
map <S-m>    <Plug>e(func)moveToMark
map <C-t>    <Plug>e(pef)
" pef-cmd
map <Plug>e(pef)<C-t>  <Plug>e(cmd)
" pef-otherprefix
map <Plug>e(pef)<Leader> <Plug>e(spc)
map <Plug>e(pef)<Space>  <Plug>e(spc)
map <Plug>e(pef)s        <Plug>e(pane)
map <Plug>e(pef)b        <Plug>e(buffer)
map <Plug>e(pef)t        <Plug>e(tab)
map <Plug>e(pef)m        <Plug>e(mark)
map <Plug>e(pef)<S-m>    <Plug>e(func)moveToMark

" Leader/spc prefix
noremap <Plug>e(spc)c     :<C-u>cd<space>
noremap <Plug>e(spc)<S-c> :<C-u>cd %:h<CR>
noremap <Plug>e(spc)q     :<C-u>.,$s///gc<Left><Left><Left><Left>
map     <Plug>e(spc)s     :<C-u>GrepQuickfix<CR>
map     <Plug>e(spc)<S-s> :<C-u>GrepQuickfix!<CR>
noremap <Plug>e(spc)w     :<C-u>w<CR>
noremap <Plug>e(spc)<S-w> :<C-u>w<Space>
noremap <Plug>e(spc)p     :<C-u>RegisterWord<CR>:HighlightRegisterWord<CR>
noremap <Plug>e(spc)<S-p> :<C-u>HighlightRegisterWord<CR>
noremap <Plug>e(spc)<C-p> :<C-u>HighlightRegister<CR>
noremap <Plug>e(spc)r     <C-o>
noremap <Plug>e(spc)o     :<C-u>e<Space>
noremap <Plug>e(spc)<S-o> :<C-u>e<Space>~/
" noremap <Plug>e(spc)f     :<C-u>echo expand("%:p")<CR>
noremap <Plug>e(spc)f     :<C-u>ShowFilepath<CR>

" pane prefix
noremap <Plug>e(pane)h     :<C-u>split<CR>
noremap <Plug>e(pane)v     :<C-u>vsplit<CR>
noremap <Plug>e(pane)n     <C-w>w
noremap <Plug>e(pane)p     <C-w><S-w>
noremap <Plug>e(pane)s     <C-w>w
noremap <Plug>e(pane)<S-s> <C-w>r
noremap <Plug>e(pane)x     :q<CR>
map     <Plug>e(pane)z     :<C-u>ToggleResizePanes<CR>

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

" tab prefix
noremap <Plug>e(tab)n     :tabnext<CR>
noremap <Plug>e(tab)p     :tabprevious<CR>
noremap <Plug>e(tab)t     :tabnext<CR>
noremap <Plug>e(tab)<S-n> :tabmove +1<CR>
noremap <Plug>e(tab)<S-p> :tabmove -1<CR>
noremap <Plug>e(tab)c     :tablast<bar>tabnew<CR>
noremap <Plug>e(tab)x     :tabclose<CR>
for s:ii in range(1,9)
  execute 'noremap <Plug>e(tab)'.s:ii.' :<C-u>tabnext '.s:ii.'<CR>'
endfor

" mark prefix
noremap <Plug>e(mark)m     :<C-u>SetMarkAuto<CR>
noremap <Plug>e(mark)<S-m> :<C-u>SetMarkAuto!<CR>
noremap <Plug>e(mark)n     ]`
noremap <Plug>e(mark)p     [`
noremap <Plug>e(mark)l     :<C-u>marks<CR>
    map <Plug>e(mark)x     :<C-u>DeleteMark<CR>
noremap <Plug>e(mark)<S-x> :<C-u>delmarks!<CR>

" cmd prefix
noremap <Plug>e(cmd)e     :messages<CR>
noremap <Plug>e(cmd)g     :<C-u>Goyo<CR>
noremap <Plug>e(cmd)m     :verbose map<CR>
noremap <Plug>e(cmd)<S-m> :verbose map<Space>
noremap <Plug>e(cmd)p     :<C-u>PackUpdate<CR>
noremap <Plug>e(cmd)<S-p> :<C-u>PackClean<CR>
noremap <Plug>e(cmd)r     :<C-u>ReloadVimrc<CR>:<C-u>echo 'Reload vimrc.'<CR>
map     <Plug>e(cmd)s     :<C-u>ShowSyntaxInfo<CR>
noremap <Plug>e(cmd)<S-e> g<S-q>

""" other
""" search
noremap <C-s> /
noremap <C-r> ?
noremap <expr>n     v:searchforward ? "n"      : "\<S-n>"
noremap <expr><S-n> v:searchforward ? "\<S-n>" : "n"
" vim-easymotion
map  <S-s> <Plug>(easymotion-bd-f)
nmap <S-s> <Plug>(easymotion-overwin-f)
" nmap <C-s> <Plug>(easymotion-overwin-f2)
map  <C-f> <Plug>(easymotion-bd-w)
nmap <C-f> <Plug>(easymotion-overwin-w) 
" one-char one-line search in normal and visual mode
" imiaru?
nnoremap    f       :OneCharSearchCL<CR>
nnoremap <S-f>      :OneCharSearchCL!<CR>
noremap <expr>w     getcharsearch().forward ? ';' : ','
noremap <expr><S-w> getcharsearch().forward ? ',' : ';'
" insert 1 line
noremap <C-o> o<Esc>
" indent
nnoremap <C-i> ==
vnoremap <C-i> =
nnoremap e     >>
nnoremap <S-e> <<
" yank(copy) from cursor to end-of-line (crsp D)
noremap Y y$
" toggle start/end record keyboard macro and call the keyboard macro
execute 'noremap <S-q> :normal! q' . Params('kbd_macro_register') . '<CR>'
execute 'noremap <C-q> @' . Params('kbd_macro_register')
" undo/redo
noremap u     u
noremap <S-u> r
noremap r     <C-r>
" no hilight
noremap <C-n> :nohlsearch<CR>
" increment/decrement number
noremap +     <C-a>
noremap -     <C-x>
" non-use nameless register and use underscore register
noremap x "_x
" zt/zb insert margin
let s:line_margin_x3 = Params('line_margin') * 3
execute 'nnoremap zt zt' . Params('line_margin') . '<C-y>'
execute 'nnoremap zb zb' . Params('line_margin') . '<C-e>'
execute 'nnoremap z<S-t> zt' . s:line_margin_x3 . '<C-y>'
execute 'nnoremap z<S-b> zb' . s:line_margin_x3 . '<C-e>'

""" toggle comment out
nmap c     :<C-u>ToggleCommentout<CR>
nmap <S-c> :<C-u>ToggleCommentout<CR>
""" tyru/caw.vim: toggle comment out
if match(Params('install_packs'), 'caw.vim')
  nmap c     <Plug>(caw:hatpos:toggle)
  vmap c     <Plug>(caw:hatpos:toggle)
  nmap <S-c> <Plug>(caw:hatpos:toggle)
  vmap <S-c> <Plug>(caw:hatpos:toggle)
endif

" jiangmiao/auto-pairs
xmap s     <Plug>VSurround
xmap <S-s> <Plug>VgSurround
" fold open/close = zo z<S-o> <S-z><S-o>/ zc z<S-c> <S-z><S-c>
noremap  <S-z><S-c> z<S-m>
noremap  <S-z><S-o> z<S-r>
""" unavailable
nnoremap <S-z><S-q> <Nop>
nnoremap <S-z><S-z> <Nop>
noremap  <C-a>      <Nop>
noremap  <C-x>      <Nop>
noremap  za         <Nop>
noremap  z<S-a>     <Nop>
noremap  zr         <Nop>
noremap  zm         <Nop>
vnoremap u          <Nop>
vnoremap <S-u>      <Nop>

" EOF
