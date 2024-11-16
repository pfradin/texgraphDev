#!/bin/sh
# CalcDim.sh $1 où $1 est le nombre de formules à traiter
# elles sont dans les fichiers formula1.tex, formula2.tex, ...
cat > dimensions.tex <<EOF
\documentclass[12pt]{article}
\usepackage{lmodern}
\usepackage{amsmath,amssymb,calc}
\pagestyle{empty}
\begin{document}
\newcounter{compt}\setcounter{compt}{1}%
\newsavebox{\textbox}%
\newwrite\OutFile%
\immediate\openout\OutFile dimensions.txt\relax%
\loop
\setbox\textbox\hbox\bgroup\input{formula\thecompt.tex}\egroup%
\newlength{\larg}\setlength{\larg}{\widthof{\usebox\textbox}}%
\newlength{\haut}\setlength{\haut}{\totalheightof{\usebox\textbox}}%
\immediate\write\OutFile{\the\larg}%
\immediate\write\OutFile{\the\haut}%
\ifnum\thecompt<$1 \addtocounter{compt}{1}
\repeat
\immediate\closeout\OutFile%
\end{document}
EOF
latex -interaction=nonstopmode dimensions.tex

