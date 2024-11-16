unit untres;

{$mode fpc}{$H+}

interface

Uses Classes, SysUtils;

Const  LF = LineEnding;

{$IFDEF GUI}
Resourcestring
{$ENDIF}

  {All}
{============= Menu fenêtre principale =================}
  TgFile              = 'File';
  TgNew               = 'New';
  TgOpen              = 'Open';
  TgSave              = 'Save';
  TgSaveAs            = 'Save as';
  TgRecent            = 'Recent';
  TgLoadMac           = 'Load mac file';
  TgLoadMod           = 'Load mod file';
  TgLoadPicture       = 'Load a picture';
  TgDelPicture        = 'Delete picture';
  TgExportToEepic     = 'Export to eepic';
  TgExportToPstricks  = 'Export to pstricks';
  TgExportToPgf       = 'Export to pgf';
  TgExportToTikz      = 'Export to tikz';
  TgExportToEps       = 'Export to eps';
  TgExportToPsf       = 'Export to psf (eps+Psfrag)';
  TgExportToEpsc      = 'Export to compiled eps';
  TgExportToPdf       = 'Export to pdf';
  TgExportToPdfc      = 'Export to compiled pdf';
  TgExportToSvg       = 'Export to svg';
  TgExportSrcToTeX    = 'Export source to tex';
  TgExportToObj       = 'Export 3d scene to obj';
  TgExportToGeom      = 'Export 3d scene to geom';
  TgExportToJvx       = 'Export 3d scene to jvx';
  TgExportToJs        = 'Export 3d scene to js';
  TgExit              = 'Exit';
  TgEdit              = 'Edit';
  TgUndo              = 'Undo';
  TgRedo              = 'Redo';
  TgEditWindow        = 'Edit window';
  TgParameter         = 'Parameters';
  TgView              = 'View';
  TgMargin            = 'Margin';
  TgBorder            = 'Export border';
  TgColor             = 'Export colors';
  TgComment           = 'Export comments';
  TgChangeUnit        = 'Change unit';
  TgOrthoProj         = '[3D] orthographic projection';
  TgCentralProj       = '[3D] central projection';
  TgCamera            = 'Camera';
  TgShowVarScreen     = 'Show variables on screen';
  TgShowLabelAnchor   = 'Show labels anchor';
  TgShowRightColumn   = 'Show right column';
  TgShowLeftColumn    = 'Show left column';
  TgConfigFile        = 'Open config file';
  TgCreate            = 'Create';
  TgGraphicObjects    = 'Graphic objects';
  TgGrid              = 'Grid';
  TgAxes              = 'Axes';
  TgCurves            = 'Curves';
  TgCartesian         = 'Cartesian';
  TgParametric        = 'Parametric';
  TgPolar             = 'Polar';
  TgOdeSolution       = 'Ode solution';
  TgImplicit          = 'Implicit';
  TgBezier            = 'Bezier';
  TgCubicSpline       = 'Cubic spline';
  TgDroite            = 'Straight line';
  TgPoints            = 'Dots';
  TgPolyLine          = 'Polygonal line';
  TgChemin            = 'Path';
  TgEllipseCercle     = 'Ellipse/Circle';
  TgCircleArc         = 'Circle Arc';
  TgEllipticArc       = 'Elliptic arc';
  TgLabel             = 'Label';
  TgSurface           = 'Surface';
  TgUserObject        = 'User object';
  TgOther2D           = 'Others 2D objects';
  TgOther3D           = 'Others 3D objects';
  TgVarglobs          = 'Define a global variable';
  TgMacros            = 'Define a macro';
  TgAide              = 'Help';
  TgOuvrirlaide       = 'Open html help';
  TgOuvrirForum       = 'Texgraph forum (fr)';
  Tgdocpdf            = 'Open pdf doc';
  TgTeXgraph_Docpdf   = 'TeXgraph doc';
  TgMouse_Docpdf      = 'Mouse doc';
  TgModels_Docpdf     = 'Models doc';
  TgMisesAjourModelesLogiciel = 'Update';
  TgMisesAJourModeles = 'Update mod files';
  TgMisesAJourLogiciel= 'Update program';
  TgApropos           = 'About';
  TgUser              = 'User';
  TgLicence           = 'This program is free, you may redistribute it under certain conditions (see the help file).'+
                        'This program is distributed WITHOUT ANY WARRANTY.';
{======================= fin menu fenêtre principale ========================================}
{======================= autres labels fenêtre principale ===================================}
  TgCommandLine       = 'Command ='; //ligne de commande
  TgShowResult        = 'Show the command result';
  TgAttributesHint    = 'Modify attributes';
  TgDelete            = 'Del';
  TgDeleteHint        = 'Delete selected objects';
  TgAll               = 'All';
  TgAllHint           = 'Delete all';
  TgVarGLob           = 'Global variables'; //groupbox2
  TgNewGlobVarHint    = 'Create a global variable';

  TgMacrosBox         = 'Macros'; //groupbox3
  TgNewMacroHint      = 'Create a new macro';
  TgOk                = 'OK'; //bouton ok

  TgTabSheet1         = 'Standard';
  TgToolButton36      = 'New graph (Ctrl+N)';
  TgToolButton1       = 'Open a *.teg file (Ctrl+O)';
  TgToolButton39      = 'Save (Ctrl+S)';
  TgToolButton3       = 'Reload file';
  TgToolSnapshot      = 'Snapshot (png or jpg)';
  TgToolButton5       = 'Copy to clipboard';
  TgToolButton6       = 'Overview (Alt+Maj+V)';
  TgToolButton11      = 'Grid (Ctrl+G)';
  TgToolButton12      = 'Axes (Ctrl+G)';
  TgToolButton13      = 'Cartesian curve (Ctrl+R)';
  TgToolButton14      = 'Parametric curve (Ctrl+P)';
  TgToolButton15      = 'Polar curve (Alt+Maj+O)';
  TgToolButton16      = 'Ode solution (Ctrl+E)';
  TgToolButton17      = 'Implicit curve (Ctrl+I)';
  TgToolButton18      = 'Bezier curve (Ctrl+B)';
  TgToolButton19      = 'Cubic spline (Alt+Maj+S)';
  TgToolButton20      = 'Straight line (Ctrl+D)';
  TgToolButton22      = 'Dot(s) (Alt+Maj+P)';
  TgToolButton25      = 'Polygonal line (Ctrl+L)';
  TgToolButton34      = 'Path (Ctrl+H)';
  TgEllipse           = 'Ellipse (Ctrl+C)';
  TgArcButton         = 'Circle arc (Alt+A)';
  TgEllipseArc        = 'Elliptic arc (Alt+Maj+A)';
  TgToolButton76      = 'Label (Alt+Maj+L)';
  TgToolButton27      = 'User defined (Ctrl+U)';
  TgToolZoomOut       = 'Zoom out';
  TgToolReCalc        = 'Recalculate all';
  TgToolLoadMouse     = 'Load Mouse.mod';
  TgToolZoomIn        = 'Zoom in';
  TgToolCursNormal    = 'Normal cursor';
  TgToolCursSelect    = 'Select and zoom';
  TgToolCursDeplace   = 'Move the graph';
  TgToolCursTourne    = 'Turn in space';
  TgComboBox3         = 'Screen resolution';


  TgTabSheet2         = 'Other 2D';
  TgToolButton41      = 'Perpendicular to the line';
  TgToolButton35      = 'Parallel to the line';
  TgToolButton42      = 'Bissector of the angle';
  TgToolButton43      = 'Parallelogram';
  TgToolButton44      = 'Rectangle';
  TgToolButton45      = 'Square';
  TgToolButton46      = 'Regular polygon';
  TgToolButton48      = 'Mediator of the segment';
  TgToolButton50      = 'Draw an angle';
  TgToolButton51      = 'Mark a segment';
  TgToolButton52      = 'Mark a circle arc';
  TgToolButton53      = 'Half-line';
  TgToolButton54      = 'Graduate straight line';
  TgToolButton47      = '2d dot + Global variable';
  TgToolIntersection  = 'Intersection of two objects';
  TgToolCercle        = 'Circle';

  TgTabSheet3         = 'Other 3D';
  TgToolButton28      = 'theta and phi (angles for 3D scene)';
  TgToolButton29      = 'Increase theta';
  TgToolButton32      = 'Decrease theta';
  TgToolButton31      = 'Increase phi';
  TgToolButton30      = 'Decrease phi';
  TgToolButton21      = 'Surface (Crtl+F)';
  TgToolButton55      = '3D axes';
  TgToolButton56      = '3D parametric curve';
  TgToolButton57      = 'Cone';
  TgToolButton58      = 'Cylinder';
  TgToolButton59      = 'Sphere';
  TgToolButton60      = 'Parallelepiped';
  TgToolButton61      = 'Tetrahedron';
  TgToolButton67      = 'Prism';
  TgToolButton68      = 'Pyramid';
  TgToolButton64      = 'Plane in space';
  TgToolButton66      = 'Line in space';
  TgToolButton65      = 'Polyline in space';
  TgToolButton70      = 'Circle in space';
  TgToolButton69      = 'Arc circle in space';
  TgToolButton62      = '3d dot + global variable';
  TgToolJavaView      = 'Show the scene (Build3D) in javaview';
  TgToolGeomView      = 'Show the scene (Build3D) in geomview';
  TgToolWebGL         = 'Show the scene (Build3D) in WebGL';

//unit1
  TgLargeur           = 'Width=';
  TgHauteur           = 'Height=';
  TgModified          = 'Modified';
  TgEditAText         = 'Edit a text';
  TgNewMacro          = 'New macro';
  TgNewUserObject     = 'New user object';
  TgGraphElement      = 'Graph object ';
  TgAttributesWin     = 'Attributes-';
  TgAttributesSelection = 'Attributes-Selection';
  TgSupprimer         = 'Delete the selected objects?';
  TgSupprimerTout     = 'Delete all the objects?';
  TgGiveThetaPhi      = 'Give theta and phi (degrees)';
  TgSourceFile        = 'Source file';
  TgModelFile         = 'Model file';
  TgFileLoaded        = 'file already loaded';
  TgResultOf          = 'Result of';
  TgPdfFile           = 'Pdf file';
  TgAskSaveFile       = 'Do you want to save';
  TgOpenBackground    = 'Open a background picture';
  TgPictureFile       = 'Picture';
  TgExportLatexTitle  = 'Export to LaTeX (epic/eepic)';
  TgExportLatexFilter = 'tex file';
  TgExportPstTitle    = 'Export to pstricks';
  TgExportPstFilter   = 'pst file';
  TgExportEpsTitle    = 'Export to eps';
  TgExportEpsFilter   = 'eps file';
  TgExportEpscTitle   = 'Compile and export to eps';

  TgExportPsfTitle    = 'Export to psf (eps file + psfrag file)';
  TgExportPsfFilter   = 'psf file';
  TgExportPgfTitle    = 'Export to pgf';
  TgExportPgfFilter   = 'pgf file';
  TgExportPdfTitle    = 'Export to pdf (eps->pdf)';
  TgExportPdfFilter   = 'pdf file';
  TgExportPdfcTitle   = 'Compile and export to pdf';

  TgExportTkzTitle    = 'Export to tikz';
  TgExportTkzFilter   = 'tkz file';

  TgExportSvgTitle    = 'Export to svg';
  TgExportSvgFilter   = 'svg file';

  TgExportObjTitle    = 'Export 3d scene (Build3d) to obj';
  TgExportObjFilter   = 'obj file';
  TgExportGeomTitle   = 'Export 3d scene (Build3d) to geomview';
  TgExportGeomFilter  = 'geom file';
  TgExportJvxTitle    = 'Export 3d scene (Build3d) to javaview';
  TgExportJvxFilter   = 'jvx file';
  TgExportJsTitle    = 'Export 3d scene (Build3d) to javascript';
  TgExportJsFilter   = 'js file';

  TgExportSrcTitle    = 'Export colored source for TeX';
  TgExportSrcFilter   = 'src file';

// Editeur
  TgOpenAFile         = 'Open a file';
  TgWantToSave        = 'The text has been modified. Do you want to save it';
  TgName              = 'Name =';
  Tg10CarMax          = '(10 char. max, begins with a letter)';
  TgCommand           = 'Command= (F2 for completion)';
  TgAttributes        = 'Attributes';
  TgColoration        = 'Coloring';
  TgSource            = 'Load source file';
  TgEffacer           = 'Clean all';
  TgSelectAll         = 'Select all';
  TgCouper            = 'Cut';
  TgCopier            = 'Copy';
  TgColler            = 'Paste';
  TgCopier_en_TeX     = 'Copy to TeX';
  TgCopier_en_Html    = 'Copy to html';
  TgChercher          = 'Find';
  TgChercherRegExp    = 'Find (RegExp)';
  TgRemplacer         = 'Replace';
  TgRemplacerRegExp   = 'Replace (RegExp)';
  TgFermer            = 'Close';
  TgMessageInterrupted= 'Interrupted.';
  TgExecuter          = 'Execute';

//Attributs.pas
  TgParametert        = 'Parameter t';
  TgInterval          = 'Interval';
  TgDotHelp           = '* DotScale := scaleX + i*scaleY'+LF+
                        'Can be used to enlarge or reduce the size of '+
                        'the dot, when the imaginary part is zero, '+
                        'we agree that scaleY=scaleX.'+LF+
                        'DotScale default value is 1.'+LF+
                        '* DotAngle := angle in degrees (default 0).'+LF+
                        '* DotSize := nb1 + i*nb2'+LF+
                        'nb1 and nb2 are two lengths in TeX points (pt), the '+
                        'diameter of the dot is nb1 + nb2 x (line width).'+LF+
                        'DotSize default value is 2+2*i.';
 TgMatrixHelp         = 'Matrix := [u, v, w]'+LF+
                        'If f is a affin transformation of the plane, '+
                        'its matrix is the list [u, v, w] where:'+LF+
                        'u = f(0)  [translation vector]'+LF+
                        'v = f(1) - u [image of the first vector of the base by the linear part]'+LF+
                        'w = f(i) - u [image of the second vector of the base by the linear part]';
//camera.pas
  TgCameraHelp        = 'Camera always looks at the origin, on the axe directed by the vector wich is orthogonal'+
                        ' to the plane projection, the origin is in this plane.';
  TgDefinition        = 'Define';
  TgPosition          = 'Camera position';
  TgDistance          = 'Distance camera - origin';

//command9
  TgObject            = 'object';
//command10
  TgNotInDir          = 'is not in directory ';
  TgDataError         = 'Corrupted data in ';
  TgNotExist          = 'I can''t find ';
  TgIdentifierExpected= 'Identifier expected';
  TgStringExpected   = 'A string is expected';
  TgAnd               = ' and ';
  Tgfound             = ' found';
  TgSymbolequal       = 'symbol = expected';
  TgSymbolPV          = 'symbol ; expected';
  TgExpectedNotFound  = 'symbol ; expected but not found.';
  TgNameError         = 'invalide name [Cancel to stop warning]';
  TgEmptyString       = 'Your command is an empty string!';
  TgNumericError      = 'error in numeric conversion';
  TgLine              = 'line';
  TgReading           = 'Reading';
  TgEndReading        = 'end of reading';
  TgIsNotIn           = 'is not in';
//analyse4
  TgStringError       = 'Error in the string';
  TgValueOutOfLimits  = 'value out of bounds';
  TgAccFMissing       = 'End of comment "}" is missing.';
  TgAccOmissing       = 'Begin of comment "{" is missing.';
  TgEqualMissing      = 'Symbol = is missing after';
  TgCrochetsNonEquilibres = 'Unbalanced brackets';
  TgOdFiSansAndfi     = 'There is an "odfi" but "andif" is missing';
  TgOdfiSansDO        = 'There is an "odfi" but "do" is missing';
  TgFiSansIf          = 'There is a "fi" but "if" is missing';
  TgOdSansDo          = 'There is an "od" but "do" or "repeat" is missing';
  TgParenthesesNonEquilibrees = 'Unbalanced parenthesis';
  TgErrorAfterPourcent= 'Error, an integer is expected after "%"';
  TgInvalidCharAfter = 'Invalid char after';
  TgIdentifierAfter  = 'An identifier is expected after';
  TgUnknownChar      =  'Unknown char';
  TgIsMissing        = 'is missing';
  TgMissingCommaAfter = 'Missing comma after';
  TgEmptyArg          = 'Empty argument';
  TgSyntaxErrorAfter  = 'Syntax error after';
  TgMissingParenthesisAfter = 'Parenthesis or comma is missing after';
// commmand11
  TgMacFilesLoaded     = '*.mac files loaded';
  TgPredefinies       = 'Predefined';
  TgWordsList         = 'List of words';
  TgButtonExists      = 'This button already exists';
  TgSliderExists      = 'This slider already exists';
  TgFindFile          = 'Needs file';
  TgMacFile           = 'Files of macros (*.mac)';
  TgFileNotFound      = 'file not found';
  TgStopReading       = 'stop reading';
  TgRepositoryNotFound= 'directory not found';
  TgCannotCreateFile  = 'Impossible to create file';
  TgEndStringMissing  = 'End of string is missing';
  TgErrorWhileReading = 'error while reading';
//update13
  TgEnvironmentVariableNotDef ='this environment variable mut be défined';

  //barre standard
  TgCat_dotHelp       = '[//draw("dot",list of points, [options]) : draw a list of points (affixes)'+LF+LF+
'draw("dot",'+LF+
'   [for k from 1 to 6 do exp(i*k*pi/3) od],  //list of points'+LF+
'   [//local options : Color, DotStyle, DotScale...'+LF+
'   ]),'+LF+
']';
  TgDroiteHelp        = '[//draw("straightL",a*x+b*y=c or [a,b,c] or [A,B], [options]) : draw a straight line'+LF+
'draw("straightL",'+LF+
'   2*x-y=1,   //cartesian equation or a list of two points (complex numbers)'+LF+
'   [//local options  and default values'+LF+
'    anchor:=Nil,    //position (complex) of the label (if there is)'+LF+
'    rotation:=1,    //rotate label (0/1)'+LF+
'    labelpos:=0.5,  //number in [0; 1] for the position of the label along the segment (if anchor=Nil)'+LF+
'    labelsep:=0.35, //distance between the label and the line'+LF+
'    legend:="",    //a label'+LF+
'    //additional local options (line), ex: Color,...'+LF+
'    '+LF+
'   ]),'+LF+
']';
  TgEllipseHelp       = '[//draw("ellipse",[center, Xradius, Yradius, direction in degrees], [options]) :'+LF+
'//draw an ellipse. The direction with the horizontal axis is by default set to zero.'+LF+LF+
'draw("ellipse",'+LF+
'  [0,     //center''s affixe'+LF+
'   3,     //Xradius'+LF+
'   2,     //Yradius'+LF+
'   0],    //direction with the horizontal axis (degrees)'+LF+
'   [//local options (path), example :'+LF+
'    marker:=Nil'+LF+
'   ]),'+LF+
']';
  TgSplineHelp        = '[//draw("spline",[V1,A1,...An,Vn], [options]) : draw a cubic spline'+LF+
'// A1,...,An (complex numbers) are the points interpolated by the curve'+LF+
'//v0 and v1 are the affixes of the tangent vectors at the ends (if zero : there is no restraint).'+LF+LF+
'draw("spline",'+LF+
'   [0, -1, i, 1, 2-i, 3, 2*i],  //list [V1,A1,...An,Vn]'+LF+
'   [//local options (path), example :'+LF+
'    marker:=Nil'+LF+
'   ]),'+LF+
']';
  TgBezierHelp        = '[//draw("bezier",[A1,c1,c2,A2,c3,c4,A3,...], [options]) :'+LF+
'//draw successive Bezier curves with 2 control points, through the points A1,...,An.'+LF+
'//c1,c2,c3,c4,... are then control points,'+LF+
'//the control points can be replaced with the jump constant. In that case, we jump directly from A1 to A2 with a line segment.'+LF+LF+
'draw("bezier",'+LF+
'   [-2, -1+i, i, 1, jump, 1-i, jump, -2-i, jump, -2],  //list [A1,c1,c2,A2,c3,c4,A3,...]'+LF+
'   [//local options (path), example :'+LF+
'    marker:=Nil'+LF+
'   ]),'+LF+
']';
  TgImplicitHelp      = '[//draw("implicit",f(x,y), [options]) : implicit curve f(x,y)=0'+LF+
'draw("implicit",'+LF+
'   sin(x*y),   //expression f(x,y)'+LF+
'   [//local options and default values'+LF+
'    limits:=[jump,jump],  //range for x and y (jump=current range)'+LF+
'    grid:=[50,50],        //subdivisions for x and y'+LF+
'    //additionnal options (line), ex: Color,...'+LF+
'    '+LF+
'   ]),'+LF+
']';
  TgLabelHelp         = '[//draw("label",label1, [options1], label2, [options2],...) : draw one label or more'+LF+LF+
'draw("label",'+LF+
'   "Texte1",//premier label'+LF+
'   [//local options and default values'+LF+
'    anchor:=0,       //complex number for the label position'+LF+
'    labeldir:=Nil,   //direction of the label from the point of anchoring (North/NE/East/SE/South/SW/West/NW)'+LF+
'    labelsep:=0.25,  //distance between label and line if labeldir<>Nil'+LF+
'    showdot:=0,      /to show or not the anchoring point'+LF+
'    //additionnal options : Color, LabelSize, LabelAngle...'+LF+
'    '+LF+
'   ]),'+LF+
']';
  TgPolylineHelp      = '[//draw("line", list of points, [options]) : draw a poly-line'+LF+LF+
'draw("line",'+LF+
'   [-2,3*i,2,3-3*i], //list of complex numbers'+LF+
'   [//local options and default values'+LF+
'    close:=0,        //close line or not (0/1)'+LF+
'    radius:=0,       //a radius (>0) for rounded angles'+LF+
'    showdot:=0,      //to show or not the points (0/1)'+LF+
'    dotcolor:=Color, //color of points (if visibles)'+LF+
'    marker:=Nil,     //list [pos1, marker1, pos2,marker2,...] with pos in [0;1]'+LF+
'    scale:=1,        //for the markers'+LF+
'    legend:="",      //a label'+LF+
'    anchor:=Nil,     //complex number for the label position'+LF+
'    labelpos:=Nil,   //number in [0;1] position of the label along the line (if anchor=Nil)'+LF+
'    labelsep:=0.25,  //distance between label and line'+LF+
'    labeldir:=Nil,   //direction of the label from the point of anchoring (North/NE/East/SE/South/SW/West/NW)'+LF+
'    doubleline:=0,   //double line or not (0/1)'+LF+
'    doublesep:=1.25*Width, //thickness of the middle line when double line'+LF+
'    doublecolor:=white,    //color of the middle line when double line'+LF+
'    lineborder:=0,         //to add a border on either side of the line of the desired thickness'+LF+
'    bordercolor:=white,    //color of the border'+LF+
'    //additionnal options : Width, Color, FillStyle,...'+ LF+
'    '+LF+
'   ]),'+LF+
']';
  TgPathHelp         =  '[//draw("path", [chemin], [options]) : draw a path'+LF+LF+
'draw("path",'+LF+
'   [-3+2*i,-3,-2,line,0,2,2,-1,arc,3,3+3*i,0.5,linearc,1,-1+5*i,-3+2*i,bezier], //the path'+LF+
'   [//local options and default values'+LF+
'    marker:=Nil,     //list [pos1, marker1, pos2,marker2,...] with pos in [0;1]'+LF+
'    scale:=1,//for the markers'+LF+
'    legend:="",      //a label'+LF+
'    anchor:=Nil,     //complex number for the label position'+LF+
'    labelpos:=Nil,   //number in [0;1] position of the label along the line (if anchor=Nil)'+LF+
'    labelsep:=0.25,  //distance between label and line'+LF+
'    labeldir:=Nil,   //direction of the label from the point of anchoring (North/NE/East/SE/South/SW/West/NW)'+LF+
'    doubleline:=0,   //double line or not (0/1)'+LF+
'    doublesep:=1.25*Width, //thickness of the middle line when double line'+LF+
'    doublecolor:=white,    //color of the middle line when double line'+LF+
'    lineborder:=0, //to add a border on either side of the line of the desired thickness'+LF+
'    bordercolor:=white,    //color of the border'+LF+
'    //additionnal options : Width, Color, FillStyle,...'+LF+
'    '+LF+
'   ]),'+LF+LF+
'{A path is a list of points (complex numbers) and instructions that indicate what the points correspond to. These instructions are:'+LF+
'- line: link the points with a polyline,'+LF+
'- linearc: link the points with a polyline but the angles are rounded with an arc. The value preceeding the linearc command is interpreted as the arc''s radius.'+LF+
'- clinearc: as linearc, but the polyline is closed.'+LF+
'- arc: draw an arc of circle. It needs four arguments: 3 points and the radius, plus eventually a fifth argument: (+/-1). 1 (default) for counterclockwise.'+LF+
'- ellipticArc: draw an arc of ellipse. That needs five arguments: 3 points, the Xradius, the Yradius, plus eventually a fifth argument: (+/-1). 1 (default) for counterclockwise, and eventually a seventh argument: the direction angle (degrees) of the great axis with the horizontal axis.'+LF+
'- curve: link the points with a natural cubic spline.'+LF+
'- bezier: link the first and the fourth point with a Bézier curve (the second and third points are the control points).'+LF+
'- circle: draw a circle. Needs two arguments: one point and the center, or three arguments that are three points of the circle.'+LF+
'- ellipse: draw an ellipse, the arguments are: one point, the center, rX radius, rY radius, great axis direction in degrees (optional).'+LF+
'- move: a move without drawind anything.'+LF+
'- closepath: close the current component.}'+LF+
']';
  TgEllipticArcHelp   = '[//draw("ellipticArc",[B,A,C,rX,rY,sens,direction in degrees],[options])'+LF+
'//dreaw an elliptic arc where A is the center''s affix,'+LF+
'//the starting point of the arc is on the half-line [AB), the last point on the half-line [A, C),'+LF+
'//sens=1/-1, 1 for counterclockwise,'+LF+
'//the direction with the horizontal axis is by default set to zero).'+LF+LF+
'draw("ellipticArc",'+LF+
'  [1+i,     //affix of B'+LF+
'   0,       //affix of A'+LF+
'   1,       //affix of C'+LF+
'   2,       //rX radius'+LF+
'   3,       //rY radius'+LF+
'   1,       //sens 1 or -1, 1 for counterclockwise'+LF+
'   0],      //direction in degrees'+LF+
'   [//local options (path), example :'+LF+
'    marker:=Nil'+LF+
'   ])'+LF+
']';
  TgArcHelp           =  '[//draw("arc",[B,A,C,r,sens],[options])'+LF+
'//draw an circle arc where A is the center''s affix,'+LF+
'//the starting point of the arc is on the half-line [AB), the last point on the half-line [A, C),'+LF+
'//sens=1/-1, 1 for counterclockwise,'+LF+LF+
'draw("arc",'+LF+
'  [1+i,     //affix of B'+LF+
'   0,       //affix of A'+LF+
'   1,       //affix of C'+LF+
'   2,       //radius r'+LF+
'   1,       //sens 1 or -1, 1 for counterclockwise'+LF+
'   0],      //direction in degrees'+LF+
'   [//local options (path), example :'+LF+
'    marker:=Nil'+LF+
'   ])'+LF+
']';

  TgEquaDiffHelp      = '[//draw("odeint", ["f(t,Y)", t0, Y0], [options]) : ordinary differential equation Y''=f(t,Y)'+LF+
'//"f(t,Y)" is a string representing the expression f(t,Y))'+LF+
'//t0, Y0 represents the initial condition'+LF+LF+
'draw("odeint",//example: Y''=Y with Y(0)=1'+LF+
'   "Y",//expression f(t,Y)'+LF+
'   0,  //t0 value'+LF+
'   1,  //Y0 value'+LF+
'   [//local options and default values'+LF+
'    t:=[tMin,tMax],       //range resolution'+LF+
'    odeMethod:="rk4",     //ou "rkf45" (Runge-Kutta-Fehlberg)'+LF+
'    odeReturn:="t+i*Y",   //expression of return'+LF+
'    //additionnal options (line), eg: Color, NbPoints...'+LF+
'    '+LF+
'   ]),'+LF+
']';
//AxesGrille
  TgAxesHelp          = '[//draw("axes", [A,Xgrad+i*Ygrad], [options]) : draw axes with origin A'+LF+LF+
'draw("axes",'+LF+
'   [0,1+i],     //affix of origin, and the graduations on Ox and Oy'+LF+
'   [//local options and default values:'+LF+
'    showaxe:=[1,1], //show or not the axes (0/1), [1,1] by default'+LF+
'    drawbox:=0, //draw a box or not (0/1), 0 by default'+LF+
'  //graduations'+LF+
'    limits:=[jump,jump], //[N1+i*N2, N1+i*N2] range representing the segment [A+N1*u, A+N2*u], jump by default for the full line'+LF+
'    gradlimits:=[jump,jump], //[N1+i*N2, N1+i*N2] range for graduations (integers), by default, equal to limit.'+LF+
'    unit:=[1,1], //value of a graduation, [1,1] by default'+LF+
'    nbsubdiv:=[0,0], //number of subdivisions, [0,0] by default'+LF+
'    tickpos:=[0.5,0.5], //position of graduations (in [0;1]), [0.5,0.5] by default'+LF+
'    tickdir:=[jump,jump], //direction of graduations (jump by default for orthogonal)'+LF+
'    xyticks:=[0.2,0.2], //length of graduations, [0.2,0.2] by default'+LF+
'    xylabelsep:=[0.1,0.1], //distance labels-graduations, [0.1,0.1] by default'+LF+
'  //origine'+LF+
'    originpos:=[right,top], //position of origin''s label (center/jump/center/left/right), [right,top] by default'+LF+
'    originnum:=[0,0], //labels are compute with: (originnum + unit*n)"labeltext"/labelden, [0,0] by default'+LF+
'    originloc:=jump, //complex representing the origin for graduations, jump means that it is A'+LF+
'  //labels'+LF+
'    labelpos:=[bottom,left], //position of the labels with respect to the axes (jump=no label), [bottom, left] by default'+LF+
'    labelden:=[1,1], //denominator (integer) of the labels, [1,1] by default'+LF+
'    labeltext:=["",""], //text added to labels, empty by default'+LF+
'    labelstyle:=[top,right], //style of the labels (ortho, right, left,...), [top,right] by default'+LF+
'    labelshift:=[jump,jump], //systematic offset of the labels along the axis, jump=auto grid=1'+LF+
'    nbdeci:=[2,2], //number of decimals, [2,2] by default'+LF+
'    numericFormat:=[0,0], //display Format, (0=by default, 1=scientific, 2=engineer), [0,0] by default'+LF+
'    myxlabels := Nil, //list of personal labels on Ox axis, of the form [index1, text1 index2, text2, ...],'+LF+
'     //index1 is the abscissa on the graduated axis, if the imaginary part of index1 is non-zero,'+LF+
'     //then a point is drawn on the axis (with DotStyle).'+LF+
'    myylabels := Nil, //list of personal labels on Oy axis, of the form [index1, text1 index2, text2, ...],'+LF+
'     //index1 is the abscissa on the graduated axis, if the imaginary part of index1 is non-zero,'+LF+
'     //then a point is drawn on the axis (with DotStyle).'+LF+
'  //légende'+LF+
'    legend:=["",""], //legends of axes, empty by default'+LF+
'    legendpos:=[0.975,0.975], //position of the legend along the axes, [0.975,0.975] by default'+LF+
'    legendsep:=[0.5,0.5], //distance between legend and axis, [0.5,0.5] by default'+LF+
'    legendangle:=[jump,jump], //angle in degrees, jump=parallel to the axis, [jump,jump] by default'+LF+
'  //grille'+LF+
'    grid:=0, //draw a grid or not (0/1), 0 by default'+LF+
'    gridstyle:=solid, //line style for the primary grid, solid by default'+LF+
'    subgridstyle:=solid, //line style for the secondary grid, solid by default'+LF+
'    gridcolor:=gray, //color of the primary grid, gray by default'+LF+
'    subgridcolor:=lightgray, //color of the secondary grid, lightgray by default'+LF+
'    gridwidth:=Nil, //line thickness for the primary grid (same as primary graduations by default)'+LF+
'    subgridwidth:=Nil, //line thickness for the secondary grid (same as secondary graduations by default)'+LF+
'  //Others'+LF+
'    Arrows:=1'+LF+
'   ])'+LF+
']';
  TgGridHelp          = '[//draw("grid", [left bottom corner, right top corner], [options]) : draw a grid'+LF+LF+
'draw("grid",'+LF+
'   [-5-5*i,5+5*i],   //left bottom corner, right top corner'+LF+
'   [//options locales et valeurs par défaut'+LF+
'    unit:=[1,1], //value of a graduation, [1,1] by default'+LF+
'    nbsubdiv:=[0,0], //number of subdivisions, [0,0] by default'+LF+
'    gridstyle:=solid, //line style for the primary grid, solid by default'+LF+
'    subgridstyle:=solid, //line style for the secondary grid, solid by default'+LF+
'    gridcolor:=gray, //color of the primary grid, gray by default'+LF+
'    subgridcolor:=lightgray, //color of the secondary grid, lightgray by default'+LF+
'    gridwidth:=Nil, //line thickness for the primary grid (same as primary graduations by default)'+LF+
'    subgridwidth:=Nil, //line thickness for the secondary grid (same as secondary graduations by default)'+LF+
'    originloc:=jump, //complex representing the origin for graduations, jump means that it is the left bottom corner'+LF+
'   ])'+LF+
']';
//config.pas
  TgConfigFileForm    = 'Config file';
  TgWorkDir           = 'Work directory';
  TgInterfaceFont     = 'Font for interface';
  TgEditionFont       = 'Font for edition';
  TgJavaviewDir       = 'javaview.jar directory';
  TgDownLoads         = 'Download with';
  TgProgrammes        = 'Programs';
  TgWorkDirNotValid   = 'The work directory is not valid';
  TgJavaViewDirNotValid= 'The javaview directory is not valid';
//fenetre.pas
  TgViewHelp          = 'Define a window for the graph';
  TgHeightAndWidth    = 'Height and width (without margins)';
  TgWidth             = 'Width=Xscale*(Xmax-Xmin)';
  TgHeight            = 'Height=Yscale*(Ymax-Ymin)';
//marges.pas
  TgMarginTitle       = 'Margins [in cm] around the graph';
  TgLeft              = 'Left';
  TgRight             = 'Right';
  TgTop               = 'Top';
  TgBottom            = 'Bottom';
//Message.pas
  TgSaveAFile         = 'Save file';
  TgClose             = 'Close';
  TgCopyClose         = 'Copy and close';
  TgSaveClose         = 'Save and close';
//Parametrees.pas
  TgParametricHelp    = '[//draw("parametric", f(t), [options]) : draw a parametric curve'+LF+LF+
'draw("parametric",'+LF+
'   2*cos(3*t)+i*2*sin(2*t),  //expression f(t)'+LF+
'   [//local options and default values'+LF+
'    t:=[-pi,pi],  //range for t, the défault is [tMin,tMax]'+LF+
'    discont:=0, //discontinuity or not (0/1)'+LF+
'    nbdiv:=5,   //every setp can be divide by 2,4,...,2^nbdiv'+LF+
'    //additionnal options  (line), eg: Color, NbPoints...'+LF+
'    '+LF+
'   ])'+LF+
']';
  TgCartesianHelp     = '[//draw("cartesian", f(x), [options]) : draw a cartesian curve'+LF+LF+
'draw("cartesian",'+LF+
'   x^2,  //expression f(x)'+LF+
'   [//local options and default values'+LF+
'    x:=[-5,5],  //range for x, the défault is [tMin,tMax]'+LF+
'    discont:=0, //Discontinuity or not (0/1)'+LF+
'    nbdiv:=5,   //every step can be divide by 2,4,...,2^nbdiv'+LF+
'    //additionnal options  (line), eg: Color, NbPoints...'+LF+
'    '+LF+
'   ])'+LF+
']';
  TgPolarHelp         = '[//draw("polar", r(t), [options]) : draw a polar curve'+LF+LF+
'draw("polar",'+LF+
'   4*cos(5*t/6),      //expression r(t)'+LF+
'   [//local options and default values'+LF+
'    t:=[-6*pi,6*pi],  //range for t, the défault is [tMin,tMax]'+LF+
'    discont:=0,       //discontinuity or not (0/1)'+LF+
'    nbdiv:=5,         //every step can be divide by 2,4,...,2^nbdiv'+LF+
'    //additionnal options  (line), eg: Color, NbPoints...'+LF+
'    '+LF+
'   ])'+LF+
']';
//pressepap.pas
  TgClipBoardCaption  = 'Clipboard';
  TgFormatCopy        = 'Format of copy';
  TgExportTeg         = 'teg (source file for TeXgraph)  ';
  TgExportSrc4LaTeX   = 'src4LaTeX (source file for LaTeX)  ';
  TgExportSrc         = 'texsrc (colored source for TeX)  ';

  //snapshot.pas
  TgSnapshotWait      = 'Please wait ...';
  TgInvalidName       = 'Invalid name';
  TgSnapshotTitle     = 'Snapshot (export + conversion png/jpg)';
  TgChoixExport       = 'Export';
  TgConversion        = 'Conversion (be patient)';
  TgExport1           = 'eps (Gouraud possible, no transparency, no TeX labels)  ';
  TgExport2           = 'epsc (Gouraud possible, transparency, TeX labels)  ';
  TgExport3           = 'pdf (Gouraud possible, transparency but no TeX label)  ';
  TgExport4           = 'pdfc (transparency, TeX labels, but no Gouraud shading)  ';
  TgExport5           = 'bmp (screenshot of the graph)  ';

  TgChoixDensite      = 'Create a picture for';
  TgDensite1          = 'screen (96 dpi)  ';
  TgDensite2          = 'printer (300 dpi)  ';
  TgMontrer           = 'Show';
//varglobs.pas
  TgGlobalVar         = 'Global variable';
  TgValue             = 'Value';
  TgVarGlobHelp       = 'Value is an expression, the result must be a complex number or a list of complex numbers.';
//main
  TgRemove            = 'Remove';
  TgExportTo          = 'Export to';
  TgNoGraphElement    = 'WARNING: no graphic objects in this file';
  TgExportFinished    = 'End of export';
  TgNoExport          = 'No export';
  TgEmptyFile         = 'Empty file';
  TgServerMode        = 'Ouverture du programme TeXgraphCmd en mode serveur';
// barre 2D
  TgCircleHelp        = '[//Dcircle(O,R,Nil,(options]) or Dcircle(A,B,C,[options]) : draw a'+LF+
'//circle with O as center and R as radius, or interpolating three points A,B and C'+LF+LF+
'Dcircle('+LF+
'   0,       //affix of the center or point on the circle'+LF+
'   1,       //radius or affix of a second point'+LF+
'   Nil,     //Nil or affix of a third point'+LF+
'   []       //options, eg: LineStyle:=userdash'+LF+
'    )'+LF+
']';
  TgDparallelHelp    = '[//Dparallel([A,B], C, [options]) : draw the'+LF+
'//parallel to the line [A,B] passing through C'+LF+LF+
'Dparallel('+LF+
'   [0, 1], //affixes of A and B'+LF+
'   i,      //affix of C'+LF+
'   []      //options, eg: LineStyle:=userdash'+LF+
'    )'+LF+
']';
  TgDperpHelp    = '[//Dperp([A,B], C, right angle, [options]) : draw the'+LF+
'//perpendicular to the line [A,B] passing through C'+LF+LF+
'Dparallel('+LF+
'   [0, 1], //affixes of A and B'+LF+
'   i,      //affix of C'+LF+
'   0,      //draw a right angle (0/1)'+LF+
'   []      //options, eg: LineStyle:=userdash'+LF+
'    )'+LF+
']';

  TgDmedpHelp    = '[//Dmed(A, B, right angle, [options]) : draw the'+LF+
'//mediator of the segment [A,B]'+LF+LF+
'Dmed('+LF+
'   0,  //affix of A'+LF+
'   1,  //affix of B'+LF+
'   0,  //draw a right angle (0/1)'+LF+
'   []  //options, eg: LineStyle:=userdash'+LF+
'    )'+LF+
']';
  TgDbissecpHelp    = '[//Dbissec(B, A, C, internal, [options]) : draw the'+LF+
'//bisector of the angle BAC'+LF+LF+
'Dbissec('+LF+
'   i,  //affix of B'+LF+
'   0,  //affix of A'+LF+
'   1,  //affix of C'+LF+
'   1,  //internal or not (0/1)'+LF+
'   []  //options, eg: LineStyle:=userdash'+LF+
'    )'+LF+
']';
  TgDparalleloHelp = '[//Dparallelo(A,B,C, [options]) : draw the parallelogram'+LF+
'//with consecutive vertices A, B and C.'+LF+LF+
'Dparallelo('+LF+
'   0,      //affix of A'+LF+
'   1,      //affix of B'+LF+
'   2+i,    //affix of C'+LF+
'   []      //options, eg: [radius:=0.25, Width:=12]'+LF+
'    )'+LF+
']';
  TgDrectangleHelp = '[//Drectangle(A,B,C, [options]) : draw the rectangle'+LF+
'//with consecutive vertices A, B, the opposite side passing through C.'+LF+LF+
'Drectangle('+LF+
'   0,      //affix of A'+LF+
'   1,      //affix of B'+LF+
'   3+2*i,  //affix of C'+LF+
'   []      //options, eg: [radius:=0.25, Width:=12]'+LF+
'    )'+LF+
']';
  TgDcarreHelp    = '[//Dcarre(A,B,sens, [options]) : draw the square'+LF+
'//with consecutive vertices <A> and <B> counterclockwise'+LF+
'//if the third parameter is 1, (clockwise for −1)'+LF+LF+
'Dcarre('+LF+
'   0,      //affix of A'+LF+
'   1,      //affix of B'+LF+
'   1,      //sens 1=counterclockwise, -1=clockwise'+LF+
'   []      //options, eg: [radius:=0.25, Width:=12]'+LF+
'    )'+LF+
']';
  TgDpolyregHelp = '[//Dpolyreg(center,vertice,sides number,[options]) or Dpolyreg(vertice1,vertice2,sides number +direction*i,[options])'+LF+
'//draw the regular polygon defined by the sides number and '+LF+
'//the center and a vertice, or two consecutive vertices>,'+LF+
'//and the <direction> (1 for counterclockwise −1 for clockwise).'+LF+LF+
'Dpolyreg('+LF+
'   0,      //affix of the center (or vertice1)'+LF+
'   1,      //affix of a vertice (or vertice2)'+LF+
'   3,      //sides number (or sides number+direction*i)'+LF+
'   []      //options, eg: [radius:=0.25, Width:=12]'+LF+
'    )'+LF+
']';
  TgangleDHelp  = '[//angleD(B,A,C,r,[options]) : '+LF+
'//draw the BAC angle with a parallelogram with side r (two sides are drawn)'+LF+LF+
'angleD('+LF+
'   1+i,     //affix of B'+LF+
'   0,       //affix of A'+LF+
'   1,       //affix of C'+LF+
'   0.5,     //side length'+LF+
'   []       //options, eg: [FillStyle:=full, FillColor:=cyan]'+LF+
'    )'+LF+
']';
  TgmarksegHelp = '[//markseg(A,B,n,spacing,length,angle) :'+LF+
'//marks the segment [A,B] with n small marks (segments)'+LF+LF+
'markseg('+LF+
'   -1,      //affix of A'+LF+
'   1,       //affix of B'+LF+
'   2,       //number of marks'+LF+
'   0.15,    //spacing between marks'+LF+
'   0.45,    //length of the marks'+LF+
'   45       //angle (degrees) of the marks with respect to the line (AB)'+LF+
'    )'+LF+
']';
  TgmarkangleHelp = '[//markangle(B,A,C,r,n,spacing,length)'+LF+
'//marks the circle arc BAC (radius r) with n small marks (segments)'+LF+LF+
'markangle('+LF+
'   1+2*i,   //affix of B'+LF+
'   0,       //affix of A'+LF+
'   1,       //affix of C'+LF+
'   1,       //radius r'+LF+
'   2,       //number of marks'+LF+
'   0.1,     //spacing between marks'+LF+
'   0.45,    //length of the marks'+LF+
'    )'+LF+
']';
  TgddroiteHelp  = '[//Ddroite(A,B, [options]) : draw the half-line [A,B)'+LF+LF+
'Ddroite('+LF+
'   0,       //affix of A'+LF+
'   1+i,     //affix of B'+LF+
'   []      //options, eg: [legend:="$D$",labelpos:=0.5,labeldir:="S"]'+LF+
'    )'+LF+
']';
  TgIntersecHelp = '[//Draw the intersection point list of the two given graphical objects.'+LF+
'//Intersec( objet1, objet2) : returns this list'+LF+LF+
'draw("dot",'+LF+
'   Intersec('+LF+
'     Cercle(0,1),     //name of the first object or a graphical command'+LF+
'     Cartesian(x^2)   //name of the second object or a graphical command'+LF+
'   ),'+LF+
'   []      //options (dot), eg: [Color:=blue, DotStyle:=circle]'+LF+
'    )'+LF+
']';
  TgGradDroiteHelp = '[//draw("gradLine", [A,u], <options>) graduate the straight line (A,u)'+LF+
'// with graduations at evry A+n*u where n is an integer'+LF+LF+
'draw("gradLine",'+LF+
'   [0,1],   //affixes of A and the vector u'+LF+
'   [//local options and default values'+LF+
'    showaxe:=1, //show or not the axes (0/1), 1 by default'+LF+
'    limits:=jump, //N1+i*N2 represents the segment [A+N1*u, A+N2*u], jump by default for the full line'+LF+
'    gradlimits:=jump, //N1+i*N2 represents the range for graduations (integers), by default, equal to limit.'+LF+
'    unit:=1, //value of a graduation, 1 by default'+LF+
'    nbsubdiv:=0, //number of subdivisions, 0 by default'+LF+
'    tickpos:=0.5, //position of graduations (in [0;1]), 0.5 by default'+LF+
'    tickdir:=ortho, //direction of graduations, ortho by default'+LF+
'    xyticks:=0.2, //length of graduations, 0.2 by default'+LF+
'    xylabelsep:=0.1, //distance labels-graduations, 0.1 by default'+LF+
'    originpos:=center, //position of origin''s label (center/jump/center/left/right), center by default'+LF+
'    originnum:=0, //labels are compute with: (originnum + unit*n)"labeltext"/labelden, 0 by default'+LF+
'    labelpos:=bottom, //position of the labels with respect to the axes (jump=no label), bottom by default'+LF+
'    labelden:=1, //denominator (integer) of the labels, 1 by default'+LF+
'    labeltext:="", //text added to labels, empty by default'+LF+
'    labelstyle:=ortho, //style of the labels (ortho, right, left,...), ortho by default'+LF+
'    labelshift:=0, //systematic offset of the labels along the axis, 0 by default'+LF+
'    mylabels := Nil, //list of personal labels of the form [index1, text1 index2, text2, ...],'+LF+
'     //index1 is the abscissa on the graduated axis, if the imaginary part of index1 is non-zero,'+LF+
'     //then a point is drawn on the axis (with DotStyle).'+LF+
'    nbdeci:=2, //number of decimals, 2 by default'+LF+
'    numericFormat:=0, //display Format, (0=by default, 1=scientific, 2=engineer), 0 by default'+LF+
'    legend:="", //legends of axes, empty by default'+LF+
'    legendpos:=0.9, //position of the legend along the axes, 0.9 by default'+LF+
'    legendsep:=0.5, //distance between legend and axis, 0.5 by default'+LF+
'    legendangle:=jump, //angle in degrees, jump=parallel to the axis, jump by default'+LF+
'    //Additionnal options, eg Color, LineStyle,...'+LF+
'    '+LF+
'    ])'+LF+
']';
  // barre 3D
  TgDsurfaceHelp  = '[//Dsurface(f(u,v), uMin+i*uMax, vMin+i*vMax, uNbLg+i*vNbLg, smooth+i*contrast)'+LF+
'//draw a surface parametrized by f(u,v), with values in the space.'+LF+LF+
'Dsurface('+LF+
'   M(u,v,sin(u)+cos(v)),   //parametrization, we can also write [u+i*v,sin(u)+cos(v)]'+LF+
'   -2*pi+2*i*pi, //uMin+i*uMax : range for the parameter u'+LF+
'   -2*pi+2*i*pi, //vMin+i*vMax : range for the parameter v'+LF+
'   35+i*35,    //uNbLg+i*vNbLg : nomber of sudivisions for u and v'+LF+
'   i           //smooth+i*contraste (smooth=0/1 and contrast in [0;1], use FillColor)'+LF+
'   )'+LF+
']';

  TgAxes3DHelp = '[//Axes3D(Ox, Oy, Oz, gradX, gradY, gradZ)'+LF+
  '//draw axes in space.'+LF+LF+
  'Axes3D('+LF+
  '   0, // first cartesian coordinate of origin'+LF+
  '   0, // second cartesian coordinate of origin'+LF+
  '   0, //third cartesian coordinate of origin'+LF+
  '   1, // graduation step on Ox'+LF+
  '   1, // graduation step on Oy'+LF+
  '   1, // graduation step on Oz'+LF+
  '    )'+LF+
  ']';

   TgBoxAxes3DHelp = '[//BoxAxes3D(option1, option2,...)'+LF+
  '//draw boxed axes in space. See Help for all options.'+LF+LF+
  'BoxAxes3D('+LF+
  '   grid:=1, // shows the grid'+LF+
  '   xlimits:=[-3,3], // range for x'+LF+
  '   ylimits:=[-3,3], // range for y'+LF+
  '   zlimits:=[-3,3], // range for z'+LF+
  '   FillStyle:=full, // fills the grid'+LF+
  '   FillColor:=lightgray, '+LF+
  '    )'+LF+
  ']';

  TgCourbe3DHelp = '[//Courbe3D( M(x(t), y(t), z(t)), number of divisions, discontinuity (0/1))'+LF+
  '//draw a parametric curve in space, t in [tMin, tMax]'+LF+LF+
  'Courbe3D( M('+LF+
  '    2*cos(t) , //x(t)'+LF+
  '    t/2,       //y(t)'+LF+
  '    2*sin(t)   //z(t)'+LF+
  '           ),'+LF+
  '    5, // number of divisions'+LF+
  '    0, // discontinuity (0/1)'+LF+
  '    )'+LF+
  ']';

  TgDconeHelp ='[//Dcone(vertex, vectorr, radius, mode)'+LF+
  '//draw a cone from a vertex, a vector of the axis, and a radius'+LF+
  '//the mode can be 0 = wire, 1 = visible outlines only (filling possible), 2 = visible outlines + hidden edges (filling possible).'+LF+
  '//use HideStyle, HideWidth and HideColor variables to modify hidden egdes style.'+LF+LF+
  'Dcone('+LF+
  '    M(0,0,0), // a vertex (3D point)'+LF+
  '    3*vecK,   // a vector'+LF+
  '    2,        // a radius'+LF+
  '    0         // mode'+LF+
  '    )'+LF+
  ']';

  TgDcylindreHelp ='[//Dcylindre( vertex, vector, radius, mode)'+LF+
  '//draw a cylinder from a vertex, a vector of the axis, and a radius'+LF+
  '//the mode can be 0 = wire, 1 = visible outlines only (filling possible), 2 = visible outlines + hidden edges (filling possible).'+LF+
  '//use HideStyle, HideWidth and HideColor variables to modify hidden egdes style.'+LF+LF+
  'Dcylindre('+LF+
  '    M(0,0,0), // a vertex (3D point)'+LF+
  '    3*vecK,   // a vector'+LF+
  '    2,        // a radius'+LF+
  '    0         // mode'+LF+
  '    )'+LF+
  ']';

  TgDsphereHelp ='[//Dsphere( center (3D point), radius, mode)'+LF+
  '//draw a sphere from a center (3D point), and a radius'+LF+
  '//the mode can be 0 = wire, 1 = visible outlines only (filling possible), 2 = visible outlines + hidden edges (filling possible).'+LF+
  '//use HideStyle, HideWidth and HideColor variables to modify hidden egdes style.'+LF+LF+
  'Dsphere('+LF+
  '    M(0,0,0), // a center (3D point)'+LF+
  '    3,        // a radius'+LF+
  '    0         // mode'+LF+
  '    )'+LF+
  ']';

  TgDparallelepHelp = '[//Dparallelep( vertex (3D point), 3Dvector_1, 3Dvector_2, 3Dvector_3, mode, contrast)'+LF+
  '//draw a parallelepiped starting from a vertex and three vectors, supposed to be positively oriented'+LF+
  '//the mode can be 0 = wire, 1 or 3 = visible facets (possibly full), 2 or 4 = visible facets + hidden edges.'+LF+
  '//use HideStyle, HideWidth and HideColor variables to modify hidden egdes style.'+LF+
  '//when mode=4, the parameter contrast is (a positive number, 1 by default) permits to modify or not the contrast of the color of the facets,'+LF+
  '//the value 0 will give a solid color like the modes 1 and 2.'+LF+LF+
  'Dparallelep('+LF+
  '    M(0,0,0), // a vertex (3D point)'+LF+
  '    M(4,0,0), // 3Dvector_1'+LF+
  '    M(0,4,0), // 3Dvector_2'+LF+
  '    M(1,1,3), // 3Dvector_3'+LF+
  '    0,        // mode'+LF+
  '    1,        // contrast'+LF+
  '    )'+LF+
  ']';

  TgDtetraedreHelp= '[//Dtetraedre( vertex (3D point), 3Dvector_1, 3Dvector_2, 3Dvector_3, mode, contrast)'+LF+
  '//draw a tetrahedronvector starting from a vertex and three vectors, supposed to be positively oriented'+LF+
  '//the mode can be 0 = wire, 1 or 3 = visible facets (possibly full), 2 or 4 = visible facets + hidden edges.'+LF+
  '//use HideStyle, HideWidth and HideColor variables to modify hidden egdes style.'+LF+
  '//when mode=4, the parameter contrast is (a positive number, 1 by default) permits to modify or not the contrast of the color of the facets,'+LF+
  '//the value 0 will give a solid color like the modes 1 and 2.'+LF+LF+
  'Dtetraedre('+LF+
  '    M(0,0,0), // a vertex (3D point)'+LF+
  '    M(2,0,0), // 3Dvector_1'+LF+
  '    M(0,3,0), // 3Dvector_2'+LF+
  '    M(1,1,2), // 3Dvector_3'+LF+
  '    0,        // mode'+LF+
  '    1,        // contrast'+LF+
  '    )'+LF+
  ']';

  TgDprismeHelp=  '[//Dprisme( basis, 3Dvector , mode, contrast)'+LF+
  '//draw a prism starting from one basis and a 3Dvector representing the'+LF+
  '//translation vector from one basis to the opposite one.'+LF+
  '//the basis is a list of coplanar 3Dpoints, that list has to be in the positive orientation,'+LF+
  '//given that the plane is oriented by the translation vector.'+LF+
  '//the mode can be 0 = wire, 1 or 3 = visible facets (possibly full), 2 or 4 = visible facets + hidden edges.'+LF+
  '//use HideStyle, HideWidth and HideColor variables to modify hidden egdes style.'+LF+
  '//when mode=4, the parameter contrast (a positive number, 1 by default) permits to modify or not the contrast of the color of the facets,'+LF+
  '//the value 0 will give a solid color like the modes 1 and 2.'+LF+LF+
  'Dprisme('+LF+
  '    [M(3,0,0), M(0,3,0), M(-3,0,0)], // a list of coplanar 3D points'+LF+
  '    3*vecK, // 3Dvector'+LF+
  '    0,        // mode'+LF+
  '    1,        // contrast'+LF+
  '    )'+LF+
  ']';

  TgDpyramideHelp = '[//Dpyramide( basis, tip , mode, contrast)'+LF+
  '//draw a pyramid starting from one basis and a tip (3Dpoint)'+LF+
  '//the basis is a list of coplanar 3Dpoints, that list has to be in the positive orientation,'+LF+
  '//given that the plane is oriented by the tip.'+LF+
  '//the mode can be 0 = wire, 1 or 3 = visible facets (possibly full), 2 or 4 = visible facets + hidden edges.'+LF+
  '//use HideStyle, HideWidth and HideColor variables to modify hidden egdes style.'+LF+
  '//when mode=4, the parameter contrast (a positive number, 1 by default) permits to modify or not the contrast of the color of the facets,'+LF+
  '//the value 0 will give a solid color like the modes 1 and 2.'+LF+LF+
  'Dpyramide('+LF+
  '    [M(0,-4,0), M(4,0,0), M(0,4,0),M(-4,0,0)], // a list of coplanar 3D points'+LF+
  '    3*vecK, // tip'+LF+
  '    0,      // mode'+LF+
  '    1,      // contrast'+LF+
  '    )'+LF+
  ']';

  TgLigne3DHelp = '[//Ligne3D( list of 3D points, closed (0/1))'+LF+
  '//draw a 3d polyline in space.'+LF+LF+
  'Ligne3D('+LF+
  '        [M(3,0,0), M(0,4,0), M(0,0,4)], //list of 3D points'+LF+
  '         1  //closed (1=Yes)'+LF+
  '        )'+LF+
  ']';

  TgArc3DHelp = '[//Arc3D( begin (3D point), center (3D point), end (3D point), radius, orientation [,normal 3D vector])'+LF+
  '//draw an arc  staying in the plane defined by the three points, positively oriented if orientation is strictly positive,'+LF+
  '//a normal 3D vector can be given when the three points are aligned.'+LF+LF+
  'Arc3D('+LF+
  '       M(0,1,0), //begin point'+LF+
  '       Origin,   // center point'+LF+
  '       M(1,0,0), // end point'+LF+
  '       2,        // radius'+LF+
  '       -1        // orientation'+LF+
  '     )'+LF+
  ']';

  TgCercle3DHelp = '[//Cercle3D( center (3D point), radius, normal 3D vector)'+LF+
  '//draw a circle in the plane defined by the center and the normal vector.'+LF+LF+
  'Cercle3D('+LF+
  '       Origin,   // center point'+LF+
  '       3,        // radius'+LF+
  '       M(0,0,1)  // normal vector'+LF+
  '     )'+LF+
  ']';

  TgDrawDroiteHelp = '[//DrawDroite( [3D point, direction (3D vector)], length1, length2)'+LF+
  '//draw a line of the space represented with the list [3D point, 3D direction vector].'+LF+
  '//If there is no other argument, then the line is entirely drawn. If there are two other parameters'+LF+
  '//then if A is the point and u the direction vector, this is the segment joining'+LF+
  '//A-length1*u/||u|| to A+length1*u/||u|| that is drawn.'+LF+LF+
  'DrawDroite('+LF+
  '           [Origin, M(1,-1,0)] // 3D point and direction'+LF+
  '           , 1, 1   //length1 and length2'+LF+
  '          )'+LF+
  ']';

  TgDrawPlanHelp = '[//DrawPlan( [3D point, normal 3D vector], vector of plane, length1, length2, mode)'+LF+
  '//draw a plane of the space, the plane is represented with the list [3Dpoint, 3D normal vector],'+LF+
  '//let be A the point and u the 3D normal vector, the following parameter is a vector of the plane (call it v),'+LF+
  '//the macro computes the vectorial product w = u ∧ v and determine a parallelogram with v and w,'+LF+
  '//possible mode values are : -1, -2, -3, -4, 1, 2, 3, 4.'+LF+LF+
  'DrawPlan('+LF+
  '          [Origin, vecK] //the plane'+LF+
  '          ,vecI          // vector of the plane'+LF+
  '          ,4,3          // length 1 and 2'+LF+
  '          //,1             // mode'+LF+
  '           )'+LF+
  ']';

implementation

end.

