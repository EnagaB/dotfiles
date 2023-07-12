" source vim scripts in given directory
function! SourceDirectory(dir)
  let l:files = split(glob(a:dir . "/*.vim"), "\n")
  call <SID>source_files(l:files)
endfunction

" source vim scripts whose name is matched by given pattern
function! SourceGlobpattern(globpat)
  let l:files = split(glob(a:globpat), "\n")
  call <SID>source_files(l:files)
endfunction

function! s:source_files(files)
  for l:file in a:files
    try
      execute "source " . l:file
    catch
      echo "Error sourcing file: " . l:file
    endtry
  endfor
endfunction

" for vim builtin sort function, sort in shorter order
function! Sort_comp_strlen(str1, str2)
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
