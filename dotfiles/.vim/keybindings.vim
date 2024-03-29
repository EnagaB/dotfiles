" parameters
let s:kbd_macro_register = 'y'
let s:hilight_word_register = 'z'
let s:line_margin = 2

" commmand and functions
command! RegisterWord
            \ execute 'let @' . s:hilight_word_register . '=expand("<cword>")'
command! HighlightRegisterWord
            \ set nohlsearch |
            \ let @/='\<' . eval('@' . s:hilight_word_register) . '\>' | set hlsearch
command! HighlightRegister
            \ set nohlsearch |
            \ let @/=eval('@' . s:hilight_word_register) | set hlsearch
command! ShowFilepath echo expand("%:p")
command! Pwf ShowFilepath
command! ReloadVimrc source $MYVIMRC

command! ToggleResizePanes call <SID>toggle_resize_panes()
function! s:toggle_resize_panes()
    if !exists('b:toggleMaxPane')
        let b:toggleMaxPane=0
    endif
    if b:toggleMaxPane == 0
        execute "normal! \<C-w>_\<C-w>\<Bar>"
        let b:toggleMaxPane=1
    else
        execute "normal! \<C-w>="
        let b:toggleMaxPane=0
    endif
endfunction

command! OpenFiler call <SID>OpenFiler()
function s:OpenFiler()
    if exists(":Fern")
        Fern .
    else
        edit .
    endif
endfunction

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
if IsInstalledPackageName('hop.nvim')
    noremap <Plug>(e:spc)e :<C-u>HopWord<CR>
endif

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
noremap <Plug>(e:buffer)N :<C-u>buffers<CR>:<C-u>buffer<Space>
noremap <Plug>(e:buffer)l :<C-u>buffers<CR>
noremap <Plug>(e:buffer)x :<C-u>Bclose<CR>

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
noremap <Plug>(e:mark)m :<C-u>SetMarkAuto<CR>
noremap <Plug>(e:mark)M :<C-u>SetMarkAuto!<CR>
noremap <Plug>(e:mark)n ]`
noremap <Plug>(e:mark)p [`
noremap <Plug>(e:mark)N :<C-u>MoveToMark<CR>
noremap <Plug>(e:mark)l :<C-u>marks<CR>
noremap <Plug>(e:mark)x :<C-u>DeleteMark<CR>
noremap <Plug>(e:mark)X :<C-u>delmarks!<CR>

" yank(copy) from cursor to end-of-line (crsp D)
noremap Y y$

" toggle start/end record keyboard macro and call the keyboard macro
execute 'noremap <S-q> :normal! q' . s:kbd_macro_register . '<CR>'
execute 'noremap <C-q> @' . s:kbd_macro_register

" no hilight
noremap <C-n> :nohlsearch<CR>

" non-use nameless register and use underscore register
noremap x "_x

" zt/zb insert margin
execute 'nnoremap zt zt' . s:line_margin . '<C-y>'
execute 'nnoremap zb zb' . s:line_margin . '<C-e>'

" toggle comment out
" noremap <C-k> :<C-u>ToggleCommentout<CR>
if IsInstalledPackageName('caw.vim')
    nmap <C-k> <Plug>(caw:hatpos:toggle)
    vmap <C-k> <Plug>(caw:hatpos:toggle)
endif
