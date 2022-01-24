" insert template
augroup eau:instpl
  autocmd!
  autocmd BufNewFile *.dat     InsertTemplateFile tpl.dat
  autocmd BufNewFile *.f90     InsertTemplateFile tpl.f90
  autocmd BufNewFile *.c       InsertTemplateFile tpl.c
  autocmd BufNewFile *.atc.cpp InsertTemplateFile tpl.atc.cpp
  autocmd BufNewFile *.cpp     InsertTemplateFile tpl.cpp
  autocmd BufNewFile *.py      InsertTemplateFile tpl.py
  autocmd BufNewFile *.tex     InsertTemplateFile tpl.tex
  autocmd BufNewFile *.sh      InsertTemplateFile tpl.sh
  autocmd BufNewFile *.bash    InsertTemplateFile tpl.bash
  autocmd BufNewFile *.zsh     InsertTemplateFile tpl.zsh
  autocmd BufNewFile *.ps1.bat InsertTemplateFile tpl.ps1.bat
  autocmd BufNewFile *.bat     InsertTemplateFile tpl.bat
  autocmd BufNewFile *.ps1     InsertTemplateFile tpl.ps1
augroup end

" filetype
augroup eau:ft
  autocmd!
  autocmd BufRead,BufNewFile *.tex setlocal filetype=tex
  autocmd BufRead,BufNewFile *.f90 setlocal filetype=efortran
augroup end

" tab and indent
augroup eau:tab
  autocmd!
  autocmd BufRead,BufNewFile *.f90 setlocal tabstop=2
  autocmd BufRead,BufNewFile *.cpp setlocal tabstop=2
augroup end

" textwidth
augroup eau:textwidth
  autocmd!
  autocmd BufRead,BufNewFile *.vim setlocal textwidth=100
  autocmd BufRead,BufNewFile *.f   setlocal textwidth=72
  autocmd BufRead,BufNewFile *.f90 setlocal textwidth=132
  autocmd BufRead,BufNewFile *.cpp setlocal textwidth=100
  autocmd BufRead,BufNewFile *.py  setlocal textwidth=100
augroup end

" EOF
