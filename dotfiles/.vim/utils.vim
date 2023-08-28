" source vim script with error handling
function! SourceFile(file)
    try
        execute "source " . a:file
    catch
        echo "Error occurred: " . v:exception
        echo "Error sourcing file: " . a:file
    endtry
endfunction

" source vim scripts in given directory
function! SourceDirectory(dir)
  let l:files = split(glob(a:dir . "/*.vim"), "\n")
  for l:file in l:files
      call SourceFile(l:file)
  endfor
endfunction

" source vim scripts whose name is matched by given pattern
function! SourceGlobpattern(globpat)
  let l:files = split(glob(a:globpat), "\n")
  for l:file in l:files
      call SourceFile(l:file)
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
