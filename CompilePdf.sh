#!/bin/sh
cat > CompilePdf.tex <<EOF
\documentclass[11pt,frenchb]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
%\usepackage[upright]{fourier}
\usepackage[svgnames]{xcolor}
\usepackage{tikz,amssymb,amsmath,amsfonts,siunitx}%,babel}
\usetikzlibrary{patterns}
\usepackage[a4paper,margin=0cm,pdftex]{geometry}
\usepackage[active,tightpage]{preview}
\pagestyle{empty}
\begin{document}
\newcounter{compt}
\setcounter{compt}{1}
\loop
\begin{preview}
\input{frame\thecompt.pgf}% 
\end{preview}
\ifnum\thecompt<$1 \addtocounter{compt}{1}
\repeat
\end{document}
EOF
pdflatex -interaction=nonstopmode CompilePdf.tex
cp -f CompilePdf.pdf "$2"
