TeXgraph#
{ctrdot.mac création de points de contrôle déplaçables à la souris}

Var
    ctrl = Nil;

Include "ctrldot.mac";

Graph
    show_ctrldot = draw("ctrldot", [freeCtrldotColor:=blue, assignCtrldotColor:=gray, 
                 DotScale:=2, DotStyle:=square',ctrldotLabelPos:="N", 
                 magneticGrid:=1]);
