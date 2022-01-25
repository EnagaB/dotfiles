set tabstop=2 shiftwidth=0 expandtab softtabstop=-1 smarttab
set autoindent smartindent

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

let g:tex_flavor='latex'

" EOF
