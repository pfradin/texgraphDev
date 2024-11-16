latex -interaction=nonstopmode CompileEps.tex
dvips -E -o %1 CompileEps.dvi 
rem copy  CompileEps.ps %1.eps
