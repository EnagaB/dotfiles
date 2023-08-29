" source vim scripts in given directory
function! SourceDirectory(dir)
    let l:files = split(glob(a:dir . "/*.vim"), "\n")
    for l:file in l:files
        SourceVimFile l:file
    endfor
endfunction

" source vim scripts whose name is matched by given pattern
function! SourceGlobpattern(globpat)
    let l:files = split(glob(a:globpat), "\n")
    for l:file in l:files
        SourceVimFile l:file
    endfor
endfunction

" comparison function for sorting in shorter order
" usage: call sort(list, name_of_comparation_function)
function! CompareStringLength(str1, str2)
    let l:l1 = strlen(a:str1)
    let l:l2 = strlen(a:str2)
    return l:l1 == l:l2 ? 0 : l:l1 > l:l2 ? 1 : -1
endfunction

" set colorscheme from settings
command! SetDefaultColorscheme call <SID>set_default_colorscheme()
function! s:set_default_colorscheme()
    let l:colorscheme_rel_path = 'colors/' . g:CONFIG['colorscheme'] . '.vim'
    if ! empty(globpath(&runtimepath, l:colorscheme_rel_path))
        execute 'colorscheme ' . g:CONFIG['colorscheme']
    else
        execute 'colorscheme ' . g:CONFIG['colorscheme_without_packs']
    endif
    execute 'set background =' . g:CONFIG['background']
endfunction

" Return true if given name is installed package name
function! IsInstalledPackageName(name)
    if match(&runtimepath, a:name) != -1
        return v:true
    endif
    return v:false
endfunction

" Return true if given name is install package name
function! IsInstallPackageName(name)
    for l:package in g:CONFIG['packages']
        if l:package['name'].split("/")[-1] == a:name
            return v:true
        endif
    endfor
    return v:false
endfunction

" Insert template file
command! -nargs=1 InsertTemplateFile call <SID>insert_template_file(<f-args>)
function! s:insert_template_file(file)
    if exists('b:did_insert_template_file')
        return
    endif
    let b:did_insert_template_file = 1
    execute ':1r ' . a:file
    execute ':1s/\n//'
endfunction

" modified append(): append string based on the cursor position
" a:line  = 0 => insert string at the cursor
"        >= 1 => append line at cursor-line + a:line and insert string
" if you insert lines, :let l:ii=0 | let l:ii=FUNC(l:ii,string) | ...
function! Append(line, string)
    let l:curpos = getpos('.')
    if a:line == 0
        let l:curline = getline(l:curpos[1])
        call setline(l:curpos[1],
                    \      strpart(l:curline,0,l:curpos[2]).a:string.strpart(l:curline,l:curpos[2]))
    elseif a:line >= 1
        call append(l:curpos[1]+a:line-1, a:string)
    endif
    return a:line+1
endfunction

" Save and restore mappings
" https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping
" saved_maps = SaveMappings(['a', 'b'], 'n', v:false)
" call RestoreMappings(saved_maps)
function! SaveMappings(keys, mode, global) abort
    let mappings = {}
    if a:global
        for l:key in a:keys
            let buf_local_map = maparg(l:key, a:mode, 0, 1)
            sil! exe a:mode.'unmap <buffer> '.l:key
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                        \     ? map_info
                        \     : {
                        \ 'unmapped' : 1,
                        \ 'buffer'   : 0,
                        \ 'lhs'      : l:key,
                        \ 'mode'     : a:mode,
                        \ }
            call Restore_mappings({l:key : buf_local_map})
        endfor
    else
        for l:key in a:keys
            let map_info        = maparg(l:key, a:mode, 0, 1)
            let mappings[l:key] = !empty(map_info)
                        \     ? map_info
                        \     : {
                        \ 'unmapped' : 1,
                        \ 'buffer'   : 1,
                        \ 'lhs'      : l:key,
                        \ 'mode'     : a:mode,
                        \ }
        endfor
    endif
    return mappings
endfunction
function! RestoreMappings(mappings) abort
    for mapping in values(a:mappings)
        if !has_key(mapping, 'unmapped') && !empty(mapping)
            exe     mapping.mode
                        \ . (mapping.noremap ? 'noremap   ' : 'map ')
                        \ . (mapping.buffer  ? ' <buffer> ' : '')
                        \ . (mapping.expr    ? ' <expr>   ' : '')
                        \ . (mapping.nowait  ? ' <nowait> ' : '')
                        \ . (mapping.silent  ? ' <silent> ' : '')
                        \ .  mapping.lhs
                        \ . ' '
                        \ . substitute(mapping.rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')
        elseif has_key(mapping, 'unmapped')
            sil! exe mapping.mode.'unmap '
                        \ .(mapping.buffer ? ' <buffer> ' : '')
                        \ . mapping.lhs
        endif
    endfor
endfunction
