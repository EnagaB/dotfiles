" tpope/vim-surround
let g:surround_no_mappings = 1

" lambdalisue/fern.vim
let g:fern_disable_startup_warnings = 1
let g:fern#default_hidden = 1
let g:fern#disable_default_mappings = 1
function! s:init_fern() abort
    nmap <buffer><nowait> C <Plug>(fern-action-copy)
    nmap <buffer><nowait> M <Plug>(fern-action-move)
    nmap <buffer><nowait> N <Plug>(fern-action-new-file)
    nmap <buffer><nowait> <C-m> <Plug>(fern-action-open-or-enter)
    nmap <buffer><nowait> <CR> <Plug>(fern-action-open-or-enter)
    nmap <buffer><nowait> <C-h> <Plug>(fern-action-leave)
    nmap <buffer><nowait> <BS> <Plug>(fern-action-leave)
    nmap <buffer><nowait> ? <Plug>(fern-action-help:all)
endfunction
augroup fern_custom
    autocmd! *
    autocmd FileType fern call s:init_fern()
augroup end
