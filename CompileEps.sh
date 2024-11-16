#!/bin/sh
latex -interaction=nonstopmode CompileEps.tex
dvips -E -o "$1" CompileEps.dvi 
#cp -f CompileEps.ps $1.eps
