TeXgraph#
{version 1.96}
Cmd [Fenetre(-5+5*i,5-5*i,1+i), Marges(0.5,0.5,0.5,0.5), Border(0)];
    [OriginalCoord(1),IdMatrix()];
    [theta:=0.5236, phi:=1.0472, IdMatrix3D(), ModelView(ortho)];
    [GrayScale(0), ComptGraph:=0];

Var
    lieuVer = 0.4;
    DotAff = Nil;
    UseDot = Nil;
    DotName = Nil;
    CtrlColorDot = blue;
    CtrlDotScale = 1.5;
    CtrlDotStyle = dot;
    CtrlColorAssign = gray;
    DelayAnim = 100;
    SaveAnim = 0;
    Dotperline = 25;

Include 
    "Capture.mod";
    "lieu.mac";

Mac
    Init = ReCalc();

