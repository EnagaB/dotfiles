#!/bin/perl
#======================================================================
# put this file in home directory or work directory. (~/.latexmkrc or WD/.latexmkrc)
# 1st : WD/.latexmkrc , if WD/.latexmkrc does not exist, load ~/.latexmkrc
# %O : option, %S : source file, %D : output file, $B : source file (non-extension)
#======================================================================
$latex    = 'uplatex  %O -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %S';
$pdflatex = 'pdflatex %O -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %S';
# $lualatex = 'lualatex %O -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %S';
$lualatex = 'lualatex %O -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %S';
#$xelatex  = 'xelatex  %O -synctex=1 -halt-on-error -interaction=nonstopmode -file-line-error %S';
$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
#$biber = 'biber --bblencoding=utf8 -u -U --output_safechars';
$bibtex = 'upbibtex %O %B';
$makeindex = 'upmendex %O -o %D %S';
#$makeindex = 'mendex %O -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode                    = 3;
$max_repeat                  = 5;
$pvc_view_file_via_temporary = 0;
# $pdf_previewer               = "evince";
$pdf_previewer               = "zathura";
#======================================================================
