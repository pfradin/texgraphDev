
(echo \documentclass[11pt,frenchb]{article}
echo \usepackage[utf8]{inputenc}
echo \usepackage[T1]{fontenc}
echo \usepackage{lmodern}
echo \usepackage{tikz,amssymb,amsmath,amsfonts,siunitx}%,babel}
echo \usetikzlibrary{patterns}
echo \usepackage[a4paper,margin=0cm,pdftex]{geometry} 
echo \usepackage[active,tightpage]{preview}
echo \pagestyle{empty}
echo \begin{document}
echo \newcounter{compt}
echo \setcounter{compt}{1}
echo \loop
echo \begin{preview}
echo \input{frame\thecompt.pgf}
echo \end{preview}
echo \ifnum \thecompt^<%1\addtocounter{compt}{1}
echo \repeat 
echo \end{document}) > CompilePdf.tex

pdflatex -interaction=nonstopmode CompilePdf.tex
copy CompilePdf.pdf %2

