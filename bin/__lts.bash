#!/usr/bin/env bash
set -eu
#======================================================================#
# $1  = 0          : open tex and pdf file
# $1 does not exit : TexName in this shell
# $1 /= 0          : TexName=$1
#======================================================================#
# tex-file-name A.tex -> TexName="A.tex"
# If $1 exist, TexName=$1
TexName="none"
# TexName auto check or written in shell
# TexFileAutoCh  = 1 : auto check (1-tex-file in directory)
#               /= 1 : written in shell
TexFileAutoCh=1
# Nplatex  = 1 : uplatex + dvipdfmx (jpn)
#         /= 1 : pdflatex           (eng only, high-speed)
Nplatex=0
# output color
tputcol=$COL1
#======================================================================#

echo $(tput setaf $tputcol) lts.sh begin $(tput sgr0)

source $ELIB_BASH
# search or check texname
if   [ $# -eq 1 ] ;then
  TexName=$1
else
  if existFD "*.tex" ;then
    RES=`find . -maxdepth 1 -name "*.tex" 2> /dev/null`
    TexName=`basename $RES`
  else
    echo " [error] texfile does not exist"
    exit 1
  fi
else
  if ! existFD "$TexName" ;then
    echo " [error] $TexName does not exist"
    exit 1
  fi
fi

PdfName=`ChangeExtension pdf $TexName`

if [ $# -ge 1 ] && [ $1 -eq 0 ];then
  Cmd="$TexEditCmd $TexName" ; eval $Cmd
  Cmd="$PdfViewCmd $PdfName" ; eval $Cmd
  exit 0
fi

# tex to dvi,pdf
if [ $Nplatex -eq 1 ];then
  echo $(tput setaf $tputcol) tex to dvi $(tput sgr0)
  # echo $(tput setaf $tputcol) dvi to pdf $(tput sgr0)
else
  echo $(tput setaf $tputcol) tex to pdf $(tput sgr0)
fi
mc1=0
for f in 1st 2nd 3rd final out; do
  if [ $f = "out" ];then
    echo " [error] non-get cross-references right"
    exit 1
  fi
  echo "=== $f try ==="
  # if [ $Nplatex = 0 ];then
  # 	platex -interaction=nonstopmode $TexName < /dev/null || mc1=1
  # elif [ $Nplatex = 1 ];then
  # 	uplatex -interaction=nonstopmode $TexName < /dev/null || mc1=1
  # elif [ $Nplatex = 2 ];then
  # 	pdflatex -interaction=nonstopmode $TexName < /dev/null || mc1=1
  # fi
  # if   [ $Nplatex = 1 ];then
  #   uplatex -interaction=nonstopmode $TexName < /dev/null || mc1=1
  # elif [ $Nplatex = 2 ];then
  #   pdflatex -interaction=nonstopmode $TexName < /dev/null || mc1=1
  # fi
  if   [ $Nplatex -eq 1 ];then
    uplatex -interaction=nonstopmode $TexName < /dev/null || mc1=1
  else
    pdflatex -interaction=nonstopmode $TexName < /dev/null || mc1=1
  fi
  if [ $mc1 -eq 1 ];then
    echo " [error] tex -/-> dvi,pdf"
    exit 1
  fi
  # grep 'Rerun to get cross-references right.' $LogName || break;
  # In pdflatex, Warning message : Rerun to get cross-references right .
  # space before last dot !!!
  grep 'Rerun to get cross-references right' $LogName || break;
done
if [ $Nplatex -eq 1 ];then
  echo $(tput setaf $tputcol) dvi to pdf $(tput sgr0)
  dvipdfmx $DviName
fi

echo $(tput setaf $tputcol) lts.sh end $(tput sgr0)
exit 0
#======================================================================#
