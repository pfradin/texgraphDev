#!/bin/sh
latex -interaction=nonstopmode formule.tex
dvipng -bg transparent formule.dvi
#pngtopnm formule1.png | pnmcrop -white | pnmtopng >  formule1.png;

