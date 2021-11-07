""" file extension

""" insert template
augroup eau:instpl
  autocmd!
  autocmd BufNewFile *.dat     call <SID>insert_template('tpl.dat')
  autocmd BufNewFile *.f90     call <SID>insert_template('tpl.f90')
  autocmd BufNewFile *.c       call <SID>insert_template('tpl.c')
  autocmd BufNewFile *.atc.cpp call <SID>insert_template('tpl.atc.cpp')
  autocmd BufNewFile *.cpp     call <SID>insert_template('tpl.cpp')
  autocmd BufNewFile *.py      call <SID>insert_template('tpl.py')
  autocmd BufNewFile *.tex     call <SID>insert_template('tpl.tex')
  autocmd BufNewFile *.sh      call <SID>insert_template('tpl.sh')
  autocmd BufNewFile *.bash    call <SID>insert_template('tpl.bash')
  autocmd BufNewFile *.zsh     call <SID>insert_template('tpl.zsh')
  autocmd BufNewFile *.ps1.bat call <SID>insert_template('tpl.ps1.bat')
  autocmd BufNewFile *.bat     call <SID>insert_template('tpl.bat')
  autocmd BufNewFile *.ps1     call <SID>insert_template('tpl.ps1')
augroup end
function! s:insert_template(tplfile)
  if exists('b:did_instpl') | return | endif
  execute ':1r '.g:dottpl.'/'.a:tplfile
  execute ':1s/\n//'
  let b:did_instpl=1
endfunction

""" filetype
augroup eau:ft
  autocmd!
  autocmd BufRead,BufNewFile *.tex setlocal filetype=tex
  autocmd BufRead,BufNewFile *.f90 setlocal filetype=efortran
augroup end

""" tab/indent
augroup eau:tab
  autocmd!
  autocmd BufRead,BufNewFile *.f90 setlocal tabstop=2
  autocmd BufRead,BufNewFile *.cpp setlocal tabstop=2
augroup end

""" textwidth
augroup eau:textwidth
  autocmd!
  autocmd BufRead,BufNewFile *.vim setlocal textwidth=100
  autocmd BufRead,BufNewFile *.f   setlocal textwidth=72
  autocmd BufRead,BufNewFile *.f90 setlocal textwidth=132
  autocmd BufRead,BufNewFile *.cpp setlocal textwidth=100
  autocmd BufRead,BufNewFile *.py  setlocal textwidth=100
augroup end

" end
