TeXgraph#
{Mouse.mod version 0.3 du 22/08/2021}

Var MouseVer = 0.3;

Include "Mouse.mac";

Cmd IsVisible:=0;
Graph repere = [LineStyle:=0, LabelSize:=footnotesize,
    FillStyle:=none, Width:=0, Color:=Rgb(0.75,0.75,0.75),
    Grille(0,(1+i)/GridNbDiv), Color:=0, Axes(Xmin+i*Ymin,1+i)];

Cmd FillColor:=1; IsVisible:=1;
Graph etat = Nil;
