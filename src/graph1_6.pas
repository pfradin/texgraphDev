{Copyright (C) 2005-2015 (Patrick FRADIN)
Ce programme est libre, vous pouvez le redistribuer et/ou le modifier selon les termes de la Licence 
Publique Générale GNU publiée par la Free Software Foundation (version 2 ou bien toute autre version 
ultérieure choisie par vous).

Ce programme est distribué car potentiellement utile, mais SANS AUCUNE GARANTIE,
 ni explicite ni implicite, y compris les garanties de commercialisation ou d'adaptation dans un but spécifique.
 Reportez-vous à la Licence Publique Générale GNU pour plus de détails.

Vous devez avoir reçu une copie de la Licence Publique Générale GNU en même temps que ce programme;
 si ce n'est pas le cas, écrivez à la Free Software Foundation,
 Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, États-Unis.
 }

unit graph1_6;

{$MODE Delphi}

 {Définition des éléments graphiques première partie }
INTERFACE
Uses  SysUtils,untres,

  {$IFDEF GUI}
   Classes,Graphics,ExtCtrls,LclType,LclIntf, dialogs,BGRABitmaptypes, BGRABitmap, BGRACanvas,BGRAcanvas2D,BGRAPath,
   {$ELSE}
	Unitlog,classes,
  {$ENDIF}

calculs1{calculs}, listes2 {listes},
complex3{complexes},analyse4{analyseur}, command5 {commandes},command53d {3d};

const
        {$IFNDEF GUI}
	clBlack   = TColor($000000);
        clGreen   = TColor($00FF00);
        clGray    = TColor($808080);
        clRed     = TColor($0000FF);
        clYellow  = TColor($00FFFF);
        clBlue    = TColor($FF0000);
        clFuchsia = TColor($FF00FF);
        clAqua    = TColor($FFFF00);
        clWhite   = TColor($FFFFFF);
	{$ENDIF}

         ExtImg='.png';
        {$IFDEF UNIX}
           PrefScript=''; ExtScript='.sh';
        {$ENDIF}

         {$IFDEF MSWINDOWS}
          PrefScript=''; ExtScript='.bat';
         {$ENDIF}

      car_special='#'; {separateur dans les fichiers exportés}

      {$IFDEF GUI}
      ChangeFen:boolean=false; {indique si la fenetre a été modifiée}
      ExportJpeg:boolean=false;
      //ExportPrn:boolean=false;
      Apercu:boolean=false;
      PenMode1= pmNotXor;
      showlabelanchor:boolean=false;
      InThread:boolean=False;
      DifferedMessage:string='';
      {$ENDIF}
      DefaultLineWidth:longint=4;
      UseLabels:longint=0; //pour l'export eps
      
      latex=1;
      pstricks=2;
      teg=3;
      eps=4;
      pgf=5;
      pdf=6;
      tikz=7;
      compileEps=8;
      svg=9;
      compilePdf=10;
      psf=11;
      userExport=12;
      src4latex=13; //fichier source pour insertion dans un document latex
      obj=14; //export de la scene constuite avec Build3D
      geom=15; //export de la scene constuite avec Build3D, pour geomview
      jvx=16; //export de la scene constuite avec Build3D, pour javaView
      bmp=17;
      texsrc=18; //source écrit au format TeX
      htmlsrc=20; //source écrit au format html
      js=19; //export de la scene constuite avec Build3D, pour THREE.js

      TexDashStyle:string='\dashline{0.15}';
      TexDotStyle:string='\dottedline[\circle*{.01}]{0.1}';

      cat_element=0;   {categories d'éléments graphiques}
      cat_axes=1;
      cat_grille=2;
      cat_parametree=3;
      cat_dot=4;
      cat_ellipse=5;
      cat_droite=6;
      cat_cercle=7;
      cat_label=8;
      cat_Equadif=9;
      cat_implicit=10;
      cat_ellipticarc=11;
      cat_polygone=12;
      cat_VarPredef=13;
      cat_utilisateur=14;
      cat_MyExport=14;//export personnalisé, descendant de t_utilisateur, s'utilise en commande
                     // uniquement: MyExport(code, <paramètres>)
      cat_const=15;
      cat_mac=16;
      cat_bezier=17;
      cat_command=18;
      cat_spline=19;
      cat_input=20;
      cat_cartesienne=21;
      cat_polaire=22;
      cat_Path=23;
      cat_Saut=24;
      cat_Close=25;

      cat_fenetre=100;
      cat_marges=101;
      cat_macGraph2D=102;
      cat_macGraph3D=103;
      cat_VarGlob=104;
      cat_ModeInLine=200;

      colonnes=100;
      max_points:word=100;


      //FoncSpeciales:boolean=false;

      InPath:boolean=false;          //indique si on est dans une commande Path
      FirstInPath:boolean=false;    //indique si c'est le premier objet d'un Path
      Clipping:boolean=true;        // indique si on doit clipper on non la ligne
      Openfile:boolean=false;       // indique si un fichier a été ouvert en écriture par l'utilisateur

       ContexteUtilisateur:boolean=false;  //true dans element Utilisateur, false en dehors
       SetAttr: boolean=false; //pour la commande SaveAttr
       UsePsfrag: boolean=false;
       LabelPsfrag:longint=1;  //compteur de labels pour PSfrag

       pica= 28.34646; //1cm = 28.34646 pica

type
       {$ifndef GUI}
       TPointF = packed record x,y:single end;
       TRectF = record
                case Integer of
                0: (Left, Top, Right, Bottom: Single);
                1: (TopLeft, BottomRight: TPointF);
                end;
       {$endif}
         Tmatrix=array[1..6] of real;

         PEpsCoord=^TEpsCoord;
         TEpsCoord= object(Tcommande)
                      function executer(arg:PListe):Presult;virtual;
                     end;
         PSaveAttr=^TSaveAttr;
         TSaveAttr= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PGetAttr=^TGetAttr;
         TGetAttr= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;
                     
         PRestoreAttr=^TRestoreAttr;
         TRestoreAttr= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;
         PSetAttr=^TSetAttr;
         TSetAttr= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PChangeAttr=^TChangeAttr;
         TChangeAttr= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PDefaultAttr=^TDefaultAttr;
         TDefaultAttr= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         POpenFile=^TOpenFile;
         TOpenFile= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PWriteFile=^TWriteFile;
         TWriteFile= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;
                 
         PCloseFile=^TCloseFile;
         TCloseFile= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PFileExists=^TFileExists;
         TFileExists= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PFrame=^TFrame;
         TFrame= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PSpecial=^TSpecial;
         TSpecial= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PSetMatrix=^TSetMatrix;
         TSetMatrix= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PGetMatrix=^TGetMatrix;
         TGetMatrix= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PAddMatrix=^TAddMatrix;
         TAddMatrix= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PMtransform=^TMtransform;
         TMtransform= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

         PDefaultMatrix=^TDefaultMatrix;
         TDefaultMatrix= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

            t_element=object(TNoeud)         {cat 0 ancetre des éléments graphiques}
                    id: longint;             {code identification pour la souris -1 par défaut}
                    cat,ReCalcAuto:shortint; {attributs communs}
                    trait,couleur:longint;
		    {$IFDEF GUI}
                    pen_mode:TpenMode;
		    {$ENDIF}
                    LigneCommande:string;     {chaque élément est défini à partir d'une commande}
                    arbre:Pexpression;        {certains sont définis à partir d'un arbre}
                    DefCommande:boolean;      {indique si la définition vient d une commande ou un arbre}
                    donnees:Paffixe;          {évaluation de l'arbre}
                    liste_points:Pliste;      {liste des affixes des points constituant l'élément graphique}
                    visible,transform:boolean;
                    matrix:Tmatrix;           {transformation x'=a11x+a12y+tx, y'=a21x+a22t+ty}
                    stroke_opacity:real;
                    noClipList:type_liste;
                    X_min,X_max,Y_min,Y_max:real;

                    constructor init(const UnNom, UneCommande:string);
                    procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                    procedure recalculer;virtual;
                    procedure purger;virtual;
                    procedure clip;virtual;
                    procedure clipper;virtual; //lance le clipping écran
                    procedure lireAttributs;virtual;
                    procedure fixeAttributs;virtual;
                    
		    {$IFDEF GUI}
                    function CalcLabelSize(size:integer):integer;virtual;
		    function PenWidth:single;virtual;
                    procedure parametres_scr(var coul:longint);virtual;
                    procedure show; virtual;
                    procedure toPath(Var first:boolean; var p: TBGRAPath); virtual;
		    procedure dessiner; virtual;
		    {$ENDIF}

                    procedure Transformate; Virtual;
                    procedure DefTransform(a,b,c,d,t1,t2:real); Virtual;
                    
                    procedure enregistrer_userExport; virtual;

                    procedure BeginExportSvg;virtual;
                    procedure DoExportSvg;virtual;
                    procedure EndExportSvg;virtual;
                    procedure enregistrer_svg;virtual;

                    procedure enregistrer_latex; virtual;
                    procedure BeginExportLatex; virtual;
                    procedure DoExportLatex; virtual;
                    procedure EndExportLatex; virtual;

                    function parametres_pst:string;virtual;
                    procedure BeginExportPst;virtual;
                    procedure DoExportPst;virtual;
                    procedure EndExportPst;virtual;
                    procedure enregistrer_pst;virtual;

                    procedure BeginExportPgf;virtual;
                    procedure DoExportPgf;virtual;
                    procedure EndExportPgf;virtual;
                    procedure enregistrer_pgf;virtual;

                    procedure ClipExport(mode:byte); virtual;

                    procedure BeginExportEps;virtual;
                    procedure DoExportEps;virtual;
                    procedure EndExportEps;virtual;
                    procedure enregistrer_eps;virtual;


                    function parametres_teg:string;virtual;
                    procedure enregistrer_src4Latex;virtual;

                    procedure Exporter(mode:byte);virtual;

                    destructor detruire;virtual;
                    end;
      Pelement=^t_element;

      TSaut=object(t_element)  //pour les move dans l'instruction Path
              constructor init(const UnNom, UneCommande:string);
              {$IFDEF GUI}
              procedure toPath(Var first:boolean; var p: TBGRAPath); virtual;
	      {$ENDIF}
              procedure recalculer;virtual;
              procedure DoExportSvg;virtual;
              procedure DoExportPgf;virtual;
              procedure DoExportEps;virtual;
              procedure DoExportPst;virtual;
            end;
      PSaut=^tSaut;

     PLigne=^T_Ligne;
     t_ligne= object(t_element)
              ligne_style:shortint;
              fill_style,grad_style,fleche:byte;
              fill_color,grad_colorA,grad_colorB:longint;
              fill_opacity, grad_angle, grad_centerX,grad_centerY:real;

              linejoin_style,linecap_style,miterlimit_style: byte;
              nb_points:longint;
              fermee: byte;
              rayon:real;
              pattern:Paffixe;
              clippee,onlyData:boolean;// onlyData permet de n'exporter que les données en mode Path
              evenoddfill:boolean;
              ptsFleches:Pliste;

              constructor init(const UnNom, UneCommande:string;Closed:byte;Unrayon:real);
              procedure recalculer;virtual;
              procedure lireAttributs;virtual;
              procedure fixeAttributs;virtual;
              procedure calcul_fleches;virtual;
              procedure fillLatex(style:byte; mode:byte);virtual;
              procedure clip;virtual;
              procedure clipper;virtual; //lance le clipping écran
	      
	      {$IFDEF GUI}
              procedure toPath(Var first:boolean; var p: TBGRAPath); virtual;
              procedure parametres_scr(var coul:longint);virtual;
              procedure dessiner; virtual;
              procedure dessiner_fleches;
	      {$ENDIF}

              procedure BeginExportPgf; virtual;
              procedure pgffillstroke; virtual; //factorisation
              procedure DoExportPgf; virtual;
              procedure EndExportPgf;virtual;
              procedure enregistrer_pgf;virtual;

              procedure BeginExportLatex; virtual;
              procedure DoExportLatex; virtual;
              procedure EndExportLaTeX;virtual;
              procedure enregistrer_Latex;virtual;
              procedure fleches_latex(mode:byte);virtual;

              function parametres_pst:string;virtual;
              procedure BeginExportPst;virtual;
              procedure DoExportPst; virtual;
              procedure EndExportPst;virtual;
              procedure enregistrer_Pst;virtual;

              procedure enregistrer_eps; virtual;
              procedure BeginExportEps;virtual;
              procedure DoExportEps;virtual;
              procedure EndExportEps;virtual;

              procedure BeginExportSvg; virtual;
              procedure DoExportSvg;virtual;
              procedure EndExportSvg;virtual;
              procedure enregistrer_Svg;virtual;

              function parametres_teg:string;virtual;
              procedure enregistrer_src4Latex;virtual;

              function clipSeg(A,B:Paffixe):Paffixe;
              function intersec(A,B:Paffixe;i:integer):Paffixe;
              function IsIn(point:Paffixe;i:integer):boolean;

              destructor detruire;virtual;
              end;

              t_dot=object(t_element)   {cat 4}
                           enfants:Pliste;
                           dot_style:byte;
                           dot_scaleX, dot_scaleY, dot_angle,dot_size1,dot_size2:real;
                           fill_color:longint;

                           constructor init(const UnNom, UneCommande:string);
                           procedure lireAttributs;virtual;
                           procedure fixeAttributs;virtual;
                           procedure recalculer;virtual;

         		  {$IFDEF GUI}
                           procedure parametres_scr(var coul:longint);virtual;
                           procedure dessiner; virtual;
         		  {$ENDIF}
                           procedure enregistrer_Svg;virtual;
                           procedure DoExportSvg;virtual;
                           procedure enregistrer_LaTeX;virtual;
                           procedure DoExportLatex; virtual;

                           function parametres_pst:string;virtual;
                           procedure DoExportPst;virtual;

                           procedure enregistrer_Eps;virtual;
                           procedure DoExportEps;virtual;

                           procedure enregistrer_Pgf;virtual;
                           procedure DoExportPgf;virtual;

                           function parametres_teg:string;virtual;
                           procedure enregistrer_src4Latex;virtual;

                           destructor detruire;virtual;
                           end;
               Pdot=^t_dot;

     t_label=object(t_element)  {cat 8}
             Texte: string;
             style_label, framed:byte;
	     {$IFDEF GUI}
             formule:boolean;
             image: Timage;
	     {$ENDIF}
//alignement horizontal h= 0(centré), 1 (left)  2(right)
//alignement vertical v= 0(centré), 1 (top) ou  2(bottom), le code est alors h+4*v, en ajoutant: 16 pour framed,
//, 32 pour stacked et 64 pour special (label non affiché et exporté tel quel)
             size_label:byte;
             angle_label:real;

             ligne_style:shortint;
             fill_style:byte;
             fill_color:longint;
             fill_opacity:real;

             constructor init(const UnNom, UneCommande,UnTexte:string);
             procedure lireAttributs;virtual;
             procedure fixeAttributs;virtual;
             procedure recalculer;virtual;

	     {$IFDEF GUI}
             procedure parametres_scr(var coul:longint);virtual;
             procedure dessiner; virtual;
	     {$ENDIF}
             procedure DoExportSvg;virtual;
             procedure EndExportSvg;virtual;

             procedure DoExportLatex; virtual;

             function parametres_pst:string;virtual;
             procedure DoExportPst; virtual;

             procedure DoExportEps;virtual;

             procedure DoExportPgf;virtual;

             function parametres_teg:string;virtual;
             procedure enregistrer_src4Latex;virtual;

             destructor detruire;virtual;
             end;
     Plabel=^t_label;

       TClose=object(t_ligne)  //pour les close dans l'instruction Path
              constructor init(const UnNom, UneCommande:string);
              {$IFDEF GUI}
              procedure toPath(Var first:boolean; var p: TBGRAPath); virtual;
	      {$ENDIF}
              procedure recalculer;virtual;
              procedure DoExportSvg;virtual;
              procedure DoExportPgf;virtual;
              procedure DoExportEps;virtual;
              procedure DoExportPst;virtual;
            end;
      PClose=^TClose;
              

  TAttr = packed record
                 LabelStyle,DotStyle,Linestyle,LineWidth,linecolor,Arrows,FillStyle,FillColor,
                 GradStyle, GradColorA, GradColorB,
                 AutoReCalc,NbPoints,LabelSize,xyLabelPos, PenMode,linejoin,linecap, miterlimit,mouseCode:longint;
                 LabelAngle, DotAngle, xyticks, xylabelsep,FillOpacity,StrokeOpacity,
                 tmin, tmax,GradAngle,GradCenterX,gradCenterY:real;
                 ForMinToMax, TeXLabel, EstVisible, EoFill:boolean;
                 currentMatrix:Tmatrix;
                 currentPattern,DotScale,DotSize: Paffixe;
          end;
  PAttr=^TAttr;

  TOpenfiles =Class(Tobject)
                texte: TStringList;
                Constructor Create();
                destructor Destroy;override;
                end;

function palette(code:longint):string; //nom des couleurs basiques
procedure initialiser;
procedure fenetre(Xinf,Yinf,Xsup,Ysup,Xechelle,Yechelle:real);
procedure marges(gauche,droite,haut,bas:real);

procedure ajouter_element(p:Pelement);

procedure unite_graphique(res: integer; echelle:real);
{$IFDEF GUI}
procedure Canvas2dDrawPath(sender:T_ligne; p:TBGRAPath);
procedure dessiner_elements;
procedure draw_elements;
{$ENDIF}

procedure recalculer_elements(tous: boolean);

procedure enregistrer_elements(format: byte;bordure:boolean; const exportfilename: string);

procedure vider_liste;
function nomValide(nom:Tnom;modif:boolean):boolean;
function VariableValide(nom:Tnom;modif:boolean):boolean;
function NomMacroValide(nom:Tnom;modif:boolean):boolean;

procedure GetAttributs;
procedure SetAttributs;
procedure DefaultSettings;
procedure saveAttr;
procedure RestoreAttr;
procedure defAttr(var OriginalAttr: Tattr);
function DuplicAttr(OriginalAttr: Tattr):Pattr;
procedure CleanAttr(var OriginalAttr: Tattr);

procedure SystemExec(Const cmd:string; waitfor, window:boolean);
procedure AfficheMessage(const message:string);

Function Xreel(x:longint):Real;
Function Yreel(y:longint):Real;
Function XentierF(x:real): real;
Function YentierF(y:real): real;
Function Xentier(x:real): longint;
Function Yentier(y:real): longint;
Function longX(x:real): real;// conversion de longueur réelle vers pixel suivant Ox
Function longY(y:real): real;// conversion de longueur réelle vers pixel suivant Oy


Function XSvg(x:Real):Real;
Function YSvg(y:Real):Real;
function SvgWidth(trait:longint): string;
Function XTex(x:Real):Real;
Function YTex(y:Real):Real;
Function XEps(x:Real):Real;
Function YEps(y:Real):Real;
procedure TransformEllipse(m1:Tmatrix;xc,yc,rx,ry,inclin:real; var xcs,ycs,rxs,rys,inclins:real);


function StrColor(coul:longint; mode:byte):string;
procedure exportWriteln(const c:string); //ecrit dans le fichier d'exportation exportFile
procedure exportWrite(const c:string); //ecrit dans le fichier d'exportation exportFile

var
      {noms des éléments graphiques:}
      type_element:array[0..24] of string=
      ('',' (Axes)',' (Grid)',' (Parametric)',' (Dot)',' (Ellipse)',' (StraightL)',
      ' (Circle)',' (Label)', ' (Odeint)',' (Implicit)',' (EllipticArc)',
      ' (Line)',' (Predef Var) ',
      ' (User)', '(Constant)',' (Macro)', ' (Bezier)',' (Command)',' (Spline)',
      '',' (Cartesian)', ' (Polar)', ' (Path)', ' (Jump)');

    inclure_commentaires,cadre, OriginalCoord :boolean;

    InitialPath, UserMacPath, TmpPath, userPath, DocPath, MacPath, StrExport : string;

    Xmin,Xmax,Ymin,Ymax,Xscale,Yscale,margeH,margeB,margeG,margeD,AspectRatio:real;

    MaxX,MaxY,GmargeH,GmargeB,GmargeG,GmargeD:word;
    CurrentRes:word; //résolution du contexte en cours
    CurrentScale: real;  //echelle dans le contexte en cours

    liste_element:type_liste;
    liste_enfant:Pliste;
    psfrag:textFile;      //fichiers pour les enregistrements
    WriteMode:boolean;    //autorise les écritures dans le fichier d'exportation.

    //Attributs
    LabelStyle,DotStyle,Linestyle,LineWidth,linecolor,Arrows,FillStyle,FillColor,
    GradStyle, GradColorA, GradColorB,  AutoReCalc,mouseCode:longint;
    NbPoints,LabelSize,xyLabelPos, PenMode,linejoin,linecap, miterlimit:longint;
    LabelAngle,DotAngle, xyticks, xylabelsep,FillOpacity,StrokeOpacity:real;
    tmin, tmax,GradAngle,GradCenterX,GradCenterY:real;
    ForMinToMax, TeXLabel, EstVisible, EoFill:boolean;

    //currenttransform
      DefaultMatrix,CurrentMatrix:Tmatrix;

    //pattern for userdash
    defaultPattern, currentPattern,DotScale,DotSize: Paffixe;

    // constantes correspondantes
     PLabelStyle,PDotStyle,PDotScale,PDotAngle,PDotSize,PLinestyle,Pwidth,Pcolor,PArrows,PFillStyle,
     PGradStyle, PGradColor,PGradAngle,PGradCenter,
     PDashPattern,
     PFillColor,PFillOpacity,PStrokeOpacity,PNbPoints,Ptmin,Ptmax,PAutoReCalc, PLabelSize, PLabelAngle,
     //Pxyticks, Pxylabelsep, PxyLabelPos,
     PPenMode, PForMinToMax, Pcomptgraph, Pcomptlabel3d, PTeXLabel, PIsVisible, PEOfill,
     PLineJoin, PLineCap, PMiterLimit, PmouseCode: Pconstante;
     //fin

     
     couleur_courante,Texte_courant,epaisseur_courante,style_courant, courant_point_style,fill_courant,grad_courant,
     fillcolor_courant,hatchcolor_courant,LabelSize_courant, linejoin_courant,linecap_courant,
     miterlimit_courant:longint;
     opacity_courant, strokeOpacity_courant:real;
     eofill_courant:boolean;

     //epaisseur:array[0..2] of string[20];
     Unstyle:array[-1..3] of string[20];
     stylefill:array[0..8] of string[50];
     TailleLabel:array[0..9] of string[15];

     OxEps, OyEps, CpicaX, CpicaY: real;
     CrtClipX1, CrtClipX2, CrtClipY1, CrtClipY2: real; //clipping rectangulaire courant
     NbSvgClip, NbSvgGrad:longint;
     SvgClipName,SvgGradName:string;

     FileName:TFileName;  // Fichier courant
     ExportName: TFileName; // fichier d'exportation
     NumFormule:longint; //numero de formule.png  (sortie svg)
     OpenFilesList:TStringList; //listes des fichiers ouverts par l'utilisateur
     ExportFile:TextFile;
//     Canevas


{$IFDEF GUI}
     Yafond:boolean; //gestion du fond éventuel
     Fondname:TFileName;  //image de fond
     fondOrigX,fondOrigY,FondLarge,fondHaut:real;
{$ENDIF}

     ListAttr:TList; //pile pour les attributs;
     ListeFicMac:TStrings;//liste des fichiers mac chargés au démarrage

procedure deftransform(a,b,c,d,t1,t2:real);
procedure defaultTransform;
function IsGraphElem(Const nom:String):boolean;
//function pix: single; //cm en pixel

 IMPLEMENTATION
uses math,process;
{=======================}
 procedure AfficheMessage(const message:string);
 begin
 	{$IFDEF GUI}
 	if not InThread then Messagedlg(FormatString(message,70),mtWarning,[mbOk],0)
         else DifferedMessage+=message+CRLF
 	{$ELSE}
 	WriteLog(message)
 	{$ENDIF}
 end;
 {===================}
function pix:real;
begin
     result:=CurrentScale*CurrentRes/2.54;
end;
{=======================}
constructor TOpenFiles.Create;
begin
     inherited Create;
     texte:=TStringlist.Create
end;
{=======================}
destructor TOpenFiles.destroy;
begin
     texte.free;
     inherited destroy;
end;
{=======================}
function IsGraphElem(Const nom:String):boolean;
var aux:Pcellule;
begin
     aux:=liste_element.tete;
     while (aux<>nil) and (pelement(aux)^.nom<>nom) do
           aux:=aux^.suivant;
     result:=(aux<>Nil);
end;
{============================}
function VariableValide(Nom:Tnom;modif:boolean):boolean;
begin
      VariableValide:=identifierOk(nom) and ((constante(nom)=nil) or modif)
end;
{=======================}
function NomValide(Nom:Tnom;modif:boolean):boolean;
var ok:boolean;
    aux:Pelement;
begin
      ok:=VariableValide(Nom,modif);
      aux:=Pelement(liste_element.tete);
      while (aux<>nil) and ok do
       begin
            ok:=ok and ((aux^.nom<>nom) or modif);
            aux:=Pelement(aux^.suivant);
       end;
       nomValide:=ok
end;

{=======================}
function NomMacroValide(Nom:Tnom;modif:boolean):boolean;
var ok:boolean;
    i,k:longint;
    p:Pmacros;
begin
      result:=false;
      k:=length(Nom);
      if k=0 then exit;
      i:=1;
      if MacroStatut=usermac
        then initial_car:=initial_car1
        else initial_car := initial_car2; //initial identificateur
      ok:=Nom[i] in initial_car;
      while (i<=k) and (Nom[i] in Set_nom) do inc(i);
      ok:=ok and (i>k);
      if ok then p:=macros(nom) else p:=nil;
      ok:=ok and ((p=nil) or (modif and (p^.statut<>predefmac))) and (fonction(nom)=nil) and (commande(nom)=nil);
      NomMacroValide:=ok
end;
{=======================}
procedure SystemExec(Const cmd:string; waitfor, window:boolean);
var newprocess:Tprocess;
begin
     try
       newprocess:=Tprocess.create(nil);
       newprocess.commandline:=cmd;
       if window then newprocess.ShowWindow:=swoShow else newprocess.ShowWindow:=swoHide;
       if waitFor then newprocess.Options :=newprocess.Options+[poWaitOnExit];
       newprocess.execute;
     finally
        newprocess.free;
     end;
end;
{=======================}
procedure deftransform(a,b,c,d,t1,t2:real);
begin
        currentmatrix[1]:=a; currentmatrix[2]:=b; currentmatrix[3]:=c; currentmatrix[4]:=d;
        currentmatrix[5]:=t1; currentmatrix[6]:=t2;
end;
{=======================}
procedure Addtransform(a,b,c,d,t1,t2:real); //compose une matrice avec la matrice courante
var ap,bp,cp,dp,t1p,t2p:real;
begin
        ap:=currentmatrix[1]; bp:=currentmatrix[2]; cp:=currentmatrix[3];
        dp:=currentmatrix[4];  t1p:=currentmatrix[5]; t2p:=currentmatrix[6];
        currentmatrix[1]:=ajouter(multiplier(a,ap),multiplier(cp,b));
        currentmatrix[3]:=ajouter(multiplier(c,ap),multiplier(cp,d));
        currentmatrix[2]:=ajouter(multiplier(a,bp),multiplier(dp,b));
        currentmatrix[4]:=ajouter(multiplier(c,bp),multiplier(dp,d));
        currentmatrix[5]:=ajouter(ajouter(t1p,multiplier(ap,t1)),multiplier(cp,t2));
        currentmatrix[6]:=ajouter(ajouter(t2p,multiplier(bp,t1)),multiplier(dp,t2));
end;
{=======================}
function Mtransform( lst: Paffixe; matrix: Tmatrix): Paffixe;
var res:Type_liste;
    aux:Paffixe;
    a,b,x,y:real;
begin
     Mtransform:=Nil;
     aux:=lst; if aux=Nil then exit;
     res.init;
     while aux<>nil do
     begin
        if not Isjump(aux) then
          begin
               CalcError:=false;
               x:=aux^.x; y:=aux^.y;
               a:=ajouter(multiplier(matrix[1],x),multiplier(matrix[3],y));
               b:=ajouter(multiplier(matrix[2],x),multiplier(matrix[4],y));
               a:=ajouter(a,matrix[5]);
               b:=ajouter(b,matrix[6]);
               if not CalcError then res.ajouter_fin(new(Paffixe,init(a,b)));
          end
          else begin
               res.ajouter_fin(new(Paffixe,init(jump^.x,aux^.y)));
               end;
        aux:=Paffixe(aux^.suivant)
     end;
     Mtransform:=Paffixe(res.tete);
end;
{=======================}
procedure defaultTransform;
begin
        CurrentMatrix:=DefaultMatrix;
end;
{=======================}
function CompMatrix(M1,M2:Tmatrix):boolean;
begin
      result:=(M1[1]=M2[1]) And (M1[2]=M2[2]) And (M1[3]=M2[3]) And
              (M1[4]=M2[4]) And (M1[5]=M2[5]) And (M1[6]=M2[6])
end;
{=======================}
function TEpsCoord.executer(arg:PListe):Presult;
var T:Paffixe;
    f1:Pcorps;
    x,y:real;
begin
     executer:=nil;
     if (arg=nil) or (arg^.tete=nil) then exit;
     f1:=Pcorps(arg^.tete);
     T:=f1^.evalNum;
     if T=nil then exit;
     CalcError:=false;
     x:=multiplier(CpicaX,soustraire(T^.x,OxEps));
     y:=multiplier(CpicaY,soustraire(T^.y,OyEps));
     kill(Pcellule(T));
     if CalcError then  exit;
     executer:=New(Paffixe,init(x,y))
end;
{=======================}
function StrColor(coul:longint; mode:byte):string;
var chaine:string;
    red,green,blue,gris:real;
    nom:string;
    couleur:longint;
begin
     couleur:=convColor(coul);
     if mode=svg then
      begin
        red:=GetRvalue(couleur); green:= GetGvalue(couleur); blue:=GetBvalue(couleur);
      end
      else
      begin
        red:=GetRvalue(couleur)/255; green:= GetGvalue(couleur)/255; blue:=GetBvalue(couleur)/255;
      end;
     case mode of
     latex,pstricks:  if nom='' then
          chaine:= '[rgb]{'+Streel(red)+','+Streel(green)+','+Streel(blue)+'}'
          else chaine:='{'+nom+'}';
     eps: if nom='' then
          chaine:= Streel(red)+' '+Streel(green)+' '+Streel(blue)+' rgb '
          else chaine:=nom+' ';
 tikz,pgf: if nom='' then
          chaine:= '{rgb,1:red,'+Streel(red)+';green,'+Streel(green)+';blue,'+Streel(blue)+'}'
          else chaine:='{'+nom+'}';
     svg: if nom='' then
          chaine:= 'rgb('+Streel(red)+','+Streel(green)+','+Streel(blue)+')'
          else chaine:=nom;
     end;
     StrColor:=chaine;
end;
{========================}
function DuplicAttr(OriginalAttr: Tattr):Pattr;
var Attr:PAttr;
begin
     New(Attr); Attr^:=OriginalAttr;
     Attr^.dotscale:=OriginalAttr.dotscale^.evalNum;
     Attr^.dotsize:=OriginalAttr.dotsize^.evalNum;
     Attr^.currentpattern:=OriginalAttr.currentpattern^.evalNum;
     DuplicAttr:=Attr
end;
{========================}
procedure DefAttr(var OriginalAttr: Tattr);
begin
     OriginalAttr.dotscale:=nil;
     OriginalAttr.dotsize:=nil;
     OriginalAttr.currentpattern:=nil;
end;
{========================}
procedure CleanAttr(var OriginalAttr: Tattr);
begin
     Kill(Pcellule(OriginalAttr.dotscale));
     Kill(Pcellule(OriginalAttr.dotsize));
     Kill(Pcellule(OriginalAttr.currentpattern));
end;
{========================}
procedure saveAttr;
var Attr:PAttr;
begin
        New(Attr); GetAttributs;
        attr^.linestyle:=LineStyle;
        attr^.Linewidth:=Linewidth;
        attr^.linecolor:=linecolor;
        attr^.nbpoints:=nbpoints;
        attr^.dotstyle:=dotstyle;
        attr^.labelstyle:=labelstyle;
        attr^.mouseCode:=mouseCode;
        attr^.tmin:=tmin;
        attr^.tmax:=tmax;
        attr^.arrows:=arrows;
        attr^.fillstyle:=fillstyle;
        attr^.fillcolor:=fillcolor;
        attr^.gradstyle:=gradstyle;
        attr^.gradcolorA:=gradcolorA;
        attr^.gradcolorB:=gradcolorB;
        attr^.gradAngle:=gradAngle;
        attr^.gradcenterX:=gradcenterX;
        attr^.gradcenterY:=gradcenterY;
        attr^.AutoReCalc:=AutoReCalc;
        attr^.labelsize:=labelsize;
        attr^.labelangle:=labelangle;
        attr^.dotangle:=dotangle;
        attr^.dotscale:=dotscale^.evalNum;
        attr^.dotsize:=dotsize^.evalNum;
        attr^.xylabelsep:=xylabelsep;
        attr^.xyticks:=xyticks;
        attr^.xylabelpos:=xylabelpos;
        attr^.Penmode:=Penmode;
        attr^.ForMinToMax:=ForMinToMax;
        attr^.TeXLabel:=TeXLabel;
        attr^.FillOpacity:=FillOpacity;
        attr^.EstVisible:=EstVisible;
        Attr^.CurrentMatrix:=CurrentMatrix;
        attr^.StrokeOpacity:=StrokeOpacity;
        attr^.EOfill:=EOfill;
        attr^.linejoin:=linejoin;
        attr^.linecap:=linecap;
        attr^.miterlimit:=miterlimit;
        attr^.currentpattern:=currentpattern^.evalNum;
        ListAttr.Insert(0,Attr);
end;
{=======================}
procedure restoreAttr;
var Attr:PAttr;
begin
        if ListAttr.count<1 then exit;
        Attr:= ListAttr.Items[0];
        LineStyle:=attr^.linestyle;
        Linewidth:=attr^.Linewidth;
        linecolor:=attr^.linecolor;
        nbpoints:=attr^.nbpoints;
        mouseCode:=attr^.mouseCode;
        dotstyle:=attr^.dotstyle;
        labelstyle:=attr^.labelstyle;
        tmin:=attr^.tmin;
        tmax:=attr^.tmax;
        arrows:=attr^.arrows;
        dotangle:=attr^.dotangle;
        Kill(Pcellule(dotscale));
        dotscale:=attr^.dotscale;
        Kill(Pcellule(dotsize));
        dotsize:=attr^.dotsize;
        fillstyle:=attr^.fillstyle;
        fillcolor:=attr^.fillcolor;
        gradstyle:=attr^.gradstyle;
        gradcolorA:=attr^.gradcolorA;
        gradcolorB:=attr^.gradcolorB;
        gradangle:=attr^.gradangle;
        gradcenterX:=attr^.gradcenterX;
        gradcenterY:=attr^.gradcenterY;
        AutoReCalc:=attr^.AutoReCalc;
        labelsize:=attr^.labelsize;
        labelangle:=attr^.labelangle;
        xylabelsep:=attr^.xylabelsep;
        xyticks:=attr^.xyticks;
        xylabelpos:=attr^.xylabelpos;
        Penmode:=attr^.Penmode;
        ForMinToMax:=attr^.ForMinToMax;
        TeXLabel:=attr^.TeXLabel;
        FillOpacity:=attr^.FillOpacity;
        EstVisible:=attr^.EstVisible;
        CurrentMatrix:=Attr^.CurrentMatrix;
        StrokeOpacity:=attr^.StrokeOpacity;
        EOfill:=attr^.EOfill;
        linejoin:=attr^.linejoin;
        linecap:=attr^.linecap;
        miterlimit:=attr^.miterlimit;
        Kill(Pcellule(currentpattern));
        currentpattern:=attr^.currentpattern;
        SetAttributs;
        ListAttr.delete(0);
        dispose(Attr)
end;
{=======================}
function TSaveAttr.executer(arg:PListe):Presult;
begin
      executer:=nil;
      saveAttr;
end;
{=======================}
function TRestoreAttr.executer(arg:PListe):Presult;
begin
      executer:=nil;
      restoreAttr;
end;
{=======================}
function TGetAttr.executer(arg:PListe):Presult;
var f1:Pcorps;
    aux:Pelement;
    Anom:string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom
                                    else Anom:=MakeString(f1);
     aux:=Pelement(liste_element.tete);
     while (aux<>nil) and (aux^.nom<>Anom) do aux:=Pelement(aux^.suivant);
     if aux<>nil then aux^.lireAttributs;
end;
{=======================}
function TSetAttr.executer(arg:PListe):Presult;
begin
      executer:=nil;
      if not contexteUtilisateur then exit;
      SetAttr:=true;
      SaveAttr;
end;
{=======================}
function TChangeAttr.executer(arg:PListe):Presult;
var f1:Pcorps;
    aux:Pelement;
    Anom:string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     while f1<>nil do
      begin
        if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom
                                    else Anom:=MakeString(f1);
        aux:=Pelement(liste_element.tete);
        while (aux<>nil) and (aux^.nom<>Anom) do aux:=Pelement(aux^.suivant);
        if aux<>nil then begin
                         aux^.fixeAttributs;
                         aux^.recalculer //pour la matrice
                         end;
        f1:=Pcorps(f1^.suivant)
      end;
end;
{=======================}
function TDefaultAttr.executer(arg:PListe):Presult;
begin
      executer:=nil;
      DefaultSettings;
      SetAttributs;
end;
{=======================}
function TDefaultMatrix.executer(arg:PListe):Presult;
begin
      executer:=nil;
      CurrentMatrix:=DefaultMatrix
end;
{=======================}
function TSetMatrix.executer(arg:PListe):Presult;
var f1:Pcorps;
    T,aux:Paffixe;
    a,b,c,d,t1,t2:real;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     a:=1; b:=0; c:=0; d:=1; t1:=0; t2:=0;
     if f1<>nil then T:=f1^.evalNum else T:=nil;
     aux:=T;
     if T<>nil then begin  t1:=T^.x; t2:=T^.y;
                           T:=Paffixe(T^.suivant);
                     end;
      if T<>nil  then begin a:=T^.x; b:=T^.y;
                            T:=Paffixe(T^.suivant);
                      end;
      if T<>nil then begin  c:=T^.x; d:=T^.y;
                     end;
     Kill(Pcellule(aux));
     DefTransform(a,b,c,d,t1,t2);
end;
{=======================}
function TGetMatrix.executer(arg:PListe):Presult; //renvoie la matrice courante
var  T: type_liste;
begin
     executer:=nil;
     T.init;
     T.ajouter_fin(New(Paffixe,init(currentMatrix[5],currentMatrix[6])));
     T.ajouter_fin(New(Paffixe,init(currentMatrix[1],currentMatrix[2])));
     T.ajouter_fin(New(Paffixe,init(currentMatrix[3],currentMatrix[4])));
     executer:=Paffixe(T.tete)
end;
{=======================}
function TAddMatrix.executer(arg:PListe):Presult;
var f1:Pcorps;
    T,aux:Paffixe;
    a,b,c,d,t1,t2:real;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     a:=1; b:=0; c:=0; d:=1; t1:=0; t2:=0;
     if f1<>nil then T:=f1^.evalNum else T:=nil;
     aux:=T;
     if T<>nil then begin  t1:=T^.x; t2:=T^.y;
                           T:=Paffixe(T^.suivant);
                     end;
      if T<>nil  then begin a:=T^.x; b:=T^.y;
                            T:=Paffixe(T^.suivant);
                      end;
      if T<>nil then begin  c:=T^.x; d:=T^.y;
                     end;
     Kill(Pcellule(aux));
     AddTransform(a,b,c,d,t1,t2);
end;
{=======================}
function TMtransform.executer(arg:PListe):Presult;//transformation d'une liste par une matrice
 var f1,f2:Pcorps;
     T,aux,lst:Paffixe;
     matrix:Tmatrix;
     Del1:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     if (f1^.categorie=cat_constante) then begin Del1:=false; lst:=Paffixe(Pconstante(f1^.contenu)^.affixe) end
                                      else begin Del1:=true;  lst:=f1^.evalNum end;
     f2:=Pcorps(f1^.suivant);
     if f2=Nil then matrix:=currentmatrix
     else
         begin
              T:=f2^.evalNum; aux:=T;
              if T<>nil then begin  matrix[5]:=T^.x; matrix[6]:=T^.y;
                                    T:=Paffixe(T^.suivant);
                        end;
              if T<>nil  then begin matrix[1]:=T^.x; matrix[2]:=T^.y;
                                    T:=Paffixe(T^.suivant);
                              end;
              if T<>nil then begin  matrix[3]:=T^.x; matrix[4]:=T^.y;
                             end;
              Kill(Pcellule(aux));
         end;
     executer:=Mtransform(lst,matrix);
     if Del1 then Kill(Pcellule(lst));
end;
{=======================}
procedure TransformEllipse(m1:tmatrix; xc,yc,rx,ry,inclin:real; var xcs,ycs,rxs,rys,inclins:real);
var a,b,c,d,a1,b1,c1,delta,x,y,t,t2,t3,r1,r2:real;
begin
      xcs:=xc*m1[1]+yc*m1[3]+m1[5];ycs:=xc*m1[2]+yc*m1[4]+m1[6];  //centre transformé par la matrice courante
      CalcError:=false;
      r1:=multiplier(rx,rx); r2:=multiplier(ry,ry);
      a:= multiplier(Xscale, ajouter(m1[1]*cos(inclin), m1[3]*sin(inclin)));
      b:= multiplier(Xscale, ajouter(-m1[1]*sin(inclin), m1[3]*cos(inclin)));
      c:= multiplier(Yscale, ajouter(m1[2]*cos(inclin), m1[4]*sin(inclin)));
      d:= multiplier(Yscale, ajouter(-m1[2]*sin(inclin), m1[4]*cos(inclin)));
      a1:=ajouter( multiplier(r1, multiplier(a,a)) , multiplier(r2, multiplier(b,b)));
      b1:=ajouter( multiplier(r1,multiplier(a,c)), multiplier(r2,multiplier(b,d)));
      c1:=ajouter( multiplier(r1, multiplier(c,c)) , multiplier(r2, multiplier(d,d)));
      t:=ajouter(a1,c1); t2:=ajouter(a1,-c1); t3:=multiplier(b1,b1);
      delta:=sqrt(ajouter( multiplier(t2,t2), multiplier(4, t3)));
      rxs:=diviser(ajouter(t,delta),2); rys:=diviser(ajouter(t,-delta),2);
      if abs(b1)<1E-12 then if a1>c1 then begin x:=1; y:=0 end else begin x:=0; y:=1 end
      else begin x:=b1; y:=ajouter(rxs,-a1); end;
      rxs:=sqrt(rxs);rys:=sqrt(rys);
      if abs(x)<1E-12 then begin x:=0; inclins:=90 end else inclins:=arctan(diviser(y,x))*180/pi; //en degrés
      if CalcError or ((x=0) and (y=0)) then begin rxs:=0; rys:=0 end;
end;
{=======================}
procedure exportWriteln(const c: string); //utilisée en interne pour les exports à la place de writeln(f,..)
begin
     if WriteMode then writeln(exportFile, c)//dans fichier exportation
                  else
     if OpenFile then TOpenFiles(OpenFilesList.Objects[0]).texte.Add(c)//dans fichier perso
                  else StrExport += c+CRLF
end;
{=======================}
procedure exportWrite(const c: string); //utilisée en interne pour les exports à la place de write(f,..)
begin
     if WriteMode then write(exportFile, c)//dans fichier exportation
                 else
     if OpenFile then TOpenFiles(OpenFilesList.Objects[0]).texte.Add(c)//dans fichier perso
                 else StrExport += C
end;
{=======================}
function TOpenFile.executer(arg:PListe):Presult; //ouverture fichier texte en écriture
var f1:Pcorps;
    chaine:string;
    res:byte;
    p:Topenfiles;
    fichier:textFile;
begin
     executer:=nil; res:=1;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     chaine:=MakeString(f1);
     {$I-}
     AssignFile(fichier,chaine); rewrite(fichier); CloseFile(fichier);
     {$I+}
     if IOresult<>0 then
        begin
{$IFDEF GUI}
        AfficheMessage(TgCannotCreateFile+' '+chaine);
{$ELSE}
	WriteLog(TgCannotCreateFile+' '+chaine);
{$ENDIF}
        res:=0
        end
           else
               begin
                     OpenFile:=true;
                     p:=TOpenFiles.create;
                     openFileslist.InsertObject(0,chaine,p);
               end;
    executer:=New(Paffixe,init(res,0));
end;
{=======================}
function TWriteFile.executer(arg:PListe):Presult; //écriture fichier texte
var f1,f2:Pcorps;
    chaine,name:string;
    fichier:textFile;
    i:longint;
begin
     executer:=nil;
     if not (WriteMode Or OpenFile) then exit;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=Nil then  //un seul argument, c'est du texte à écrire
        begin
             chaine:=MakeString(f1); i:=0
         end else
        begin   //on a un nom de fichier (f1) suivi d'un texte à écrire (f2)
             name:= MakeString(f1); chaine:=MakeString(f2);
             i:=OpenFilesList.indexOf(name);
             if i<0 then exit; //fichier inexistant
        end;
        if WriteMode And (f2=Nil) then writeln(exportFile, chaine)
        else TopenFiles(OpenFilesList.objects[i]).texte.Add(chaine);
end;
{=======================}
function TCloseFile.executer(arg:PListe):Presult; // fermeture fichier texte
var f1:Pcorps;
    name:string;
    i:longint;
begin
     executer:=nil;
     if not OpenFile then exit; //pas de fichier d'ouvert
     if arg=nil then
        begin
                TopenFiles(OpenFilesList.objects[0]).texte.SaveToFile(OpenFilesList[0]);
                OpenFilesList.delete(0) //fermer le dernier fichier ouvert
        end
     else
     begin
          f1:=Pcorps(arg^.tete);
          while f1<>Nil do
                begin
                    name:=MakeString(f1);
                    i:=OpenFilesList.indexOf(name);
                    if i>=0 then
                       begin
                            TopenFiles(OpenFilesList.objects[i]).texte.SaveToFile(name);
                            OpenFilesList.delete(i);
                       end;
                    f1:=Pcorps(f1^.suivant)
                 end;
     end;
     if OpenFilesList.Count<=0 then OpenFile:=false;

end;
{=======================}
function TFileExists.executer(arg:PListe):Presult; // test existence
var f1:Pcorps;
    chaine:string;
begin
     executer:=nil;
     if arg=nil then f1:=Nil else f1:=Pcorps(arg^.tete);
     if f1=nil then chaine:='' else chaine:=MakeString(f1);
     if FileExists(chaine)
         then executer:=new(Paffixe,init(1,0))
         else executer:=new(Paffixe,init(0,0));
end;
{=======================}
function TFrame.executer(arg:PListe):Presult;
var f1:Pcorps;
    T:Paffixe;
begin
     executer:=nil;
     if arg=nil then
     begin
     executer:=New(Paffixe,init(byte(cadre),0));
     exit;
     end;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     T:=f1^.evalNum;
     if T=nil then exit;
     cadre:= Round(abs(T^.x)) mod 2 =1
end;
{=======================}
function TSpecial.executer(arg:PListe):Presult;
var f1:Pcorps;
    S:String;
    f:Pcorps;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_string) then exit;
     S:=Pstring(f1^.contenu)^.chaine;
     S:=MakeSpeciale(S);
     f:=DefCorps('[SaveAttr(), LabelStyle:=special, Label(0,'+S+'), RestoreAttr()]');
     if f<>nil then begin f^.evaluer; dispose(f,detruire) end;
end;
{=======================}
procedure SetAttributs;
begin
     if PLineStyle^.affixe<>nil then PLineStyle^.affixe^.setX(LineStyle)
               else PLineStyle^.affixe:=new(Paffixe,init(LineStyle,0));
     if Pwidth^.affixe<>nil then Pwidth^.affixe^.setX(Linewidth)
               else Pwidth^.affixe:=new(Paffixe,init(Linewidth,0));
     if Pcolor^.affixe<>nil then Pcolor^.affixe^.setX(linecolor)
               else Pcolor^.affixe:=new(Paffixe,init(linecolor,0));
     if PNbPoints^.affixe<>nil then PNbPoints^.affixe^.setX(NbPoints)
               else PNbPoints^.affixe:=new(Paffixe,init(NbPoints,0));
     if Pdotstyle^.affixe<>nil then Pdotstyle^.affixe^.setX(DotStyle)
               else Pdotstyle^.affixe:=new(Paffixe,init(DotStyle,0));
     if Plabelstyle^.affixe<>nil then Plabelstyle^.affixe^.setX(LabelStyle)
               else Plabelstyle^.affixe:=new(Paffixe,init(LabelStyle,0));
     if Ptmin^.affixe<>nil then Ptmin^.affixe^.setX(tmin)
               else Ptmin^.affixe:=new(Paffixe,init(tmin,0));
     if Ptmax^.affixe<>nil then Ptmax^.affixe^.setX(tmax)
               else Ptmax^.affixe:=new(Paffixe,init(tmax,0));
     if Parrows^.affixe<>nil then Parrows^.affixe^.setX(arrows)
               else Parrows^.affixe:=new(Paffixe,init(arrows,0));
     if Pfillstyle^.affixe<>nil then Pfillstyle^.affixe^.setX(FillStyle )
               else Pfillstyle^.affixe:=new(Paffixe,init(FillStyle,0));
     if Pfillcolor^.affixe<>nil then Pfillcolor^.affixe^.setX(FillColor)
               else Pfillcolor^.affixe:=new(Paffixe,init(FillColor,0));
     if Pgradstyle^.affixe<>nil then Pgradstyle^.affixe^.setX(GradStyle )
               else Pgradstyle^.affixe:=new(Paffixe,init(GradStyle,0));
     if Pgradcolor^.affixe<>nil then Pgradcolor^.affixe^.setXY(gradcolorA,gradcolorB)
               else Pgradcolor^.affixe:=new(Paffixe,init(gradcolorA,gradcolorB));
     if Pgradangle^.affixe<>nil then Pgradangle^.affixe^.setXY(gradangle,0)
               else Pgradangle^.affixe:=new(Paffixe,init(gradangle,0));
     if Pgradcenter^.affixe<>nil then Pgradcenter^.affixe^.setXY(gradcenterX,gradcenterY)
                    else Pgradcenter^.affixe:=new(Paffixe,init(gradcenterX,gradcenterY));
     if PAutoReCalc^.affixe<>nil then PAutoReCalc^.affixe^.setX(AutoReCalc)
               else PAutoReCalc^.affixe:=new(Paffixe,init(AutoReCalc,0));
     if PLabelSize^.affixe<>nil then PLabelSize^.affixe^.setX(LabelSize)
               else PLabelSize^.affixe:=new(Paffixe,init(LabelSize,0));
     if PLabelAngle^.affixe<>nil then PLabelAngle^.affixe^.setX(LabelAngle)
               else PLabelAngle^.affixe:=new(Paffixe,init(LabelAngle,0));
     if PDotAngle^.affixe<>nil then PDotAngle^.affixe^.setX(DotAngle )
               else PDotAngle^.affixe:=new(Paffixe,init(DotAngle,0));
     Kill(Pcellule(PDotScale^.affixe));
     PDotScale^.affixe:=DotScale^.evaluer;
      Kill(Pcellule(PDotSize^.affixe));
     PDotSize^.affixe:=DotSize^.evaluer;
    { if Pxylabelsep^.affixe<>nil then Pxylabelsep^.affixe^.setX(xylabelsep)
               else Pxylabelsep^.affixe:=new(Paffixe,init(xylabelsep,0));
     if Pxyticks^.affixe<>nil then Pxyticks^.affixe^.setX(xyticks)
               else Pxyticks^.affixe:=new(Paffixe,init(xyticks,0));
     if Pxylabelpos^.affixe<>nil then Pxylabelpos^.affixe^.setX(xylabelpos)
               else Pxylabelpos^.affixe:=new(Paffixe,init(xylabelpos,0));}
     if PPenMode^.affixe<>nil then PPenMode^.affixe^.setX(PenMode)
               else PPenMode^.affixe:=new(Paffixe,init(PenMode,0));
     if PForMinToMax^.affixe<>nil then PForMinToMax^.affixe^.setX(byte(ForMinToMax))
               else PForMinToMax^.affixe:=new(Paffixe,init(byte(ForMinToMax),0));
     if PTeXLabel^.affixe<>nil then PTeXLabel^.affixe^.setX(byte(TeXLabel))
               else PTeXLabel^.affixe:=new(Paffixe,init(byte(TeXLabel),0));
     if PFillOpacity^.affixe<>nil then PFillOpacity^.affixe^.setX(FillOpacity)
               else PFillOpacity^.affixe:=new(Paffixe,init(FillOpacity,0));
     if PStrokeOpacity^.affixe<>nil then PStrokeOpacity^.affixe^.setX(StrokeOpacity)
               else PStrokeOpacity^.affixe:=new(Paffixe,init(StrokeOpacity,0));
     if PIsVisible^.affixe<>nil then PIsVisible^.affixe^.setX(byte(EstVisible))
               else PIsVisible^.affixe:=new(Paffixe,init(byte(EstVisible),0));
     if PEOfill^.affixe<>nil then PEofill^.affixe^.setX(byte(Eofill))
               else PEofill^.affixe:=new(Paffixe,init(byte(Eofill),0));
     if Plinejoin^.affixe<>nil then Plinejoin^.affixe^.setX(byte(linejoin))
               else Plinejoin^.affixe:=new(Paffixe,init(byte(linejoin),0));
     if Plinecap^.affixe<>nil then Plinecap^.affixe^.setX(byte(linecap))
               else Plinecap^.affixe:=new(Paffixe,init(byte(linecap),0));
     if Pmiterlimit^.affixe<>nil then Pmiterlimit^.affixe^.setX(miterlimit)
               else Pmiterlimit^.affixe:=new(Paffixe,init(miterlimit,0));
     if PmouseCode^.affixe<>nil then PmouseCode^.affixe^.setX(mouseCode)
               else PmouseCode^.affixe:=new(Paffixe,init(mouseCode,0));
     Kill(Pcellule(PDashPattern^.affixe));
     PDashPattern^.affixe:=currentPattern^.evalNum;
end;
{========================}
procedure GetAttributs;
begin
     if Plinestyle^.affixe<>nil then Linestyle:=round(Plinestyle^.affixe^.getX) else LineStyle:=0;
     if Pwidth^.affixe<>nil then
     Linewidth:=round(abs(Pwidth^.affixe^.getX)) {mod 3} else LineWidth:=DefaultLineWidth;
     if Pcolor^.affixe<>nil then
     linecolor:=round(Pcolor^.affixe^.getX) else linecolor:=clblack;
     if PNbpoints^.affixe<>nil then
     NbPoints:=round(PNbpoints^.affixe^.getX) else NbPoints:=50;
     if Pdotstyle^.affixe<>nil then
     Dotstyle:=round(Pdotstyle^.affixe^.getX) mod 15 else DotStyle:=0;
     if Plabelstyle^.affixe<>nil then
     Labelstyle:=round(Plabelstyle^.affixe^.getX) else LabelStyle:=0;
     if Ptmin^.affixe<>nil then
     tmin:=Ptmin^.affixe^.getX else tMin:=Xmin;
     if Ptmax^.affixe<>nil then
     tmax:=Ptmax^.affixe^.getX else tMax:=Xmax;
     if Parrows^.affixe<>nil then
     Arrows:=round(Parrows^.affixe^.getX) mod 3 else Arrows:=0;
     if Pfillstyle^.affixe<>nil then
     Fillstyle:=round(Pfillstyle^.affixe^.getX) else FillStyle:=0;
     if Pfillcolor^.affixe<>nil then
     FillColor:=round(Pfillcolor^.affixe^.getX)  else FillColor:=clwhite;
     if Pgradstyle^.affixe<>nil then
     gradstyle:=round(Pgradstyle^.affixe^.getX) else gradStyle:=1;//linear
     if not(gradstyle in [1,2]) then gradStyle:=1;//linear or radial
     if Pgradcolor^.affixe<>nil then
     begin
          gradcolorA:=round(Pgradcolor^.affixe^.getX);
          gradcolorB:=round(Pgradcolor^.affixe^.getY);
     end
     else
     begin
          gradcolorA:=clwhite;
          gradcolorB:=clred;
     end;
     if Pgradcenter^.affixe<>nil then
     begin
          gradcenterX:=Pgradcenter^.affixe^.getX;
          gradcenterY:=Pgradcenter^.affixe^.getY;
     end
     else
     begin
          gradcenterX:=0.25;
          gradcenterY:=0.75;
     end;
     if Pgradangle^.affixe<>nil then
     gradangle:=Pgradangle^.affixe^.getX  else gradangle:=0;
     if PAutoReCalc^.affixe<>nil then
     AutoReCalc:=round(PAutoReCalc^.affixe^.getX) mod 2 else AutoReCalc:=1;
     if PLabelSize^.affixe<>nil then
     LabelSize:=round(PLabelSize^.affixe^.getX) mod 10 else LabelSize:=3;
     if PLabelAngle^.affixe<>nil then
     LabelAngle:=round(PLabelAngle^.affixe^.getX) else LabelAngle:=0;
     if PDotAngle^.affixe<>nil then
     DotAngle:=round(PDotAngle^.affixe^.getX) else DotAngle:=0;
     {if Pxyticks^.affixe<>nil then
     xyticks:=Pxyticks^.affixe^.getX else xyticks:=0.1;
     if Pxylabelsep^.affixe<>nil then
     xylabelsep:=Pxylabelsep^.affixe^.getX else xylabelsep:=0.105;
     if Pxylabelpos^.affixe<>nil then
     xylabelpos:=round(Pxylabelpos^.affixe^.getX) else xylabelsep:=9;//left+bottom}
     if PPenMode^.affixe<>nil then
     PenMode:=round(PPenMode^.affixe^.getX) mod 2 else PenMode:=0; //normal
     if PForMinToMax^.affixe<>nil then
     ForMinToMax:= (round(PForMinToMax^.affixe^.getX) mod 2=1) else ForMinToMax:=false;
     if PTeXLabel^.affixe<>nil then
     TeXLabel:= (round(PTeXLabel^.affixe^.getX) mod 2=1) else TeXLabel:=false;
     if PFillOpacity^.affixe<>nil then
     FillOpacity:= PFillOpacity^.affixe^.getX else FillOpacity:=1;
     if PStrokeOpacity^.affixe<>nil then
     StrokeOpacity:= PStrokeOpacity^.affixe^.getX else StrokeOpacity:=1;
     if PIsVisible^.affixe<>nil then
     EstVisible:= (round(PIsVisible^.affixe^.getX) mod 2=1) else EstVisible:=true;
     if PEofill^.affixe<>nil then
     Eofill:= (round(PEofill^.affixe^.getX) mod 2=1) else Eofill:=false;
     if Plinejoin^.affixe<>nil then
        linejoin:=round(abs(Plinejoin^.affixe^.getX)) mod 3 else linejoin:=1;
     if Plinecap^.affixe<>nil then
        linecap:=round(abs(Plinecap^.affixe^.getX)) mod 3 else linecap:=0;
     if Pmiterlimit^.affixe<>nil then
        miterlimit:=round(abs(Pmiterlimit^.affixe^.getX)) else miterlimit:=10;
     if PmouseCode^.affixe<>nil then
        mouseCode:=round(PmouseCode^.affixe^.getX) else mouseCode:=-1;
     Kill(Pcellule(CurrentPattern));
     if PDashPattern^.affixe<>nil then
        CurrentPattern:=PDashPattern^.affixe^.evalNum else CurrentPattern:=DefaultPattern^.evalNum;
     Kill(Pcellule(DotScale));
     if PDotScale^.affixe<>nil then
        DotScale:=PDotScale^.affixe^.evalNum else DotScale:=new(Paffixe,init(1,0));
     Kill(Pcellule(DotSize));
     if PDotSize^.affixe<>nil then
        DotSize:=PDotSize^.affixe^.evalNum else DotSize:=new(Paffixe,init(2,2));
end;
{========================}
procedure DefaultSettings;
begin
     Arrows:=0;LabelStyle:=0;DotStyle:=0;LineStyle:=0;
     Linewidth:=DefaultLineWidth;
     linecolor:=clblack;
     tmin:=Xmin;
     tmax:=Xmax;
     NbPoints:=50;
     FillStyle:=0;
     FillColor:=clwhite;
     GradStyle:=1;//linear
     GRadAngle:=0;
     GradCenterX:=0.25; GradCenterY:=0.75;
     GradColorA:=clwhite; GradColorB:=clred;
     AutoReCalc:=1;
     LabelSize:=3;
     LabelAngle:=0;
     xyticks:=0.2;
     xylabelsep:=0.1;
     xylabelpos:=9; //left(=1)+bottom(=8)
     PenMode:=0; //mode normal
     ForMinToMax:=false;
     TeXLabel:=false;
     FillOpacity:=1;
     StrokeOpacity:=1;
     EstVisible:=true;
     Eofill:=false;
     linejoin:=1;
     linecap:=0;
     miterLimit:=10;
     CurrentMatrix:=DefaultMatrix;
     Kill(Pcellule(CurrentPattern));
     CurrentPattern:=DefaultPattern^.evalNum;
     Kill(Pcellule(DotScale));
     DotScale:=new(Paffixe,init(1,0));
     Kill(Pcellule(DotSize));
     if PDotSize^.affixe<>nil then
        DotSize:=PDotSize^.affixe^.evalNum else DotSize:=new(Paffixe,init(2,2));
     mouseCode:=-1;
     Setattributs;
end;

function palette(code:longint): string;
begin
     case code of
      clblack: result:='black';
      clwhite: result:='white';
      clred:result:='red';
      clblue: result:='blue';
      clgray: result:='gray';
      claqua: result:='cyan';
      clFuchsia: result:='magenta';
      TColor($00FF00): result:='green';//erreur dans la définition de green de Graphics
     else result:=''
     end;
end;
{=======================}
procedure initialiser;
begin
     fenetre(-5,-5,5,5,1,1);
     marges(0.5,0.5,0.5,0.5);
     gestion_couleur:=true;
     inclure_commentaires:=true;
     liste_element.init;
     liste_enfant:=nil;;
     Unstyle[-1]:='none';
     Unstyle[0]:='solid';
     Unstyle[1]:='dashed';
     Unstyle[2]:='dotted';
     Unstyle[3]:='dashed';
     stylefill[0]:='none';
     stylefill[1]:='solid';
     stylefill[2]:='hlines,hatchwidth=0.2pt,hatchangle=45';
     stylefill[3]:='crosshatch,hatchwidth=0.2pt,hatchangle=0';
     stylefill[4]:='crosshatch,hatchwidth=0.2pt,hatchangle=45';
     stylefill[5]:='vlines,hatchwidth=0.2pt,hatchangle=45';
     stylefill[6]:='hlines,hatchwidth=0.2pt,hatchangle=0';
     stylefill[7]:='vlines,hatchwidth=0.2pt,hatchangle=0';
     stylefill[8]:='eofill';
     TailleLabel[0]:='\tiny'; TailleLabel[1]:='\scriptsize';
     TailleLabel[2]:='\footnotesize'; TailleLabel[3]:='\small';
     TailleLabel[4]:='\normalsize'; TailleLabel[5]:='\large';
     TailleLabel[6]:='\Large'; TailleLabel[7]:='\LARGE';
     TailleLabel[8]:='\huge'; TailleLabel[9]:='\Huge';
     cadre:=false;
     OriginalCoord:=true;
     DefaultMatrix[1]:=1;DefaultMatrix[2]:=0;DefaultMatrix[3]:=0;DefaultMatrix[4]:=1;
     DefaultMatrix[5]:=0;DefaultMatrix[6]:=0;
     currentPattern:=Nil;
     DotScale:=Nil;
     DotSize:=Nil;
end;
{======================}
procedure unite_graphique(res: integer; echelle:real);
begin
     CurrentRes:=res;
     CurrentScale:=echelle;
     AspectRatio:=echelle*CurrentRes/2.54;
     maxX:=round(AspectRatio*(Xmax-Xmin)*Xscale);
     maxY:=round(AspectRatio*(Ymax-Ymin)*Yscale);
     GmargeH:=round(AspectRatio*margeH);
     GmargeB:=round(AspectRatio*margeB);
     GmargeG:=round(AspectRatio*margeG);
     GmargeD:=round(AspectRatio*margeD);
end;
{=======================}
procedure fenetre(Xinf,Yinf,Xsup,Ysup,Xechelle,Yechelle:real);
begin
     Xmin:=Xinf;
     Ymin:=Yinf;
     Xmax:=Xsup;
     Ymax:=Ysup;
     Xscale:=Xechelle; Yscale:=Yechelle;
     PXmin^.affixe^.setx(Xmin);
     PXmax^.affixe^.setx(Xmax);
     PYmin^.affixe^.setx(Ymin);
     PYmax^.affixe^.setx(Ymax);
     PXscale^.affixe^.setx(Xscale);
     PYscale^.affixe^.setx(Yscale);
     maxX:=round(AspectRatio*(Xmax-Xmin)*Xscale);
     maxY:=round(AspectRatio*(Ymax-Ymin)*Yscale);
     CpicaX:=pica*Xscale;
     CpicaY:=pica*Yscale;
     OxEps:= Xmin-margeG/Xscale;
     OyEps:= Ymin-margeB/Yscale;
     {$IFDEF GUI}
     ChangeFen:=true;
     {$ENDIF}
end;
{=======================}
procedure marges(gauche,droite,haut,bas:real);
begin
     margeH:=haut;margeB:=bas;margeG:=gauche;margeD:=droite;
     GmargeH:=round(AspectRatio*margeH);
     GmargeB:=round(AspectRatio*margeB);
     GmargeG:=round(AspectRatio*margeG);
     GmargeD:=round(AspectRatio*margeD);
     constante('margeG')^.affixe^.setx(margeG);
     constante('margeD')^.affixe^.setx(margeD);
     constante('margeH')^.affixe^.setx(margeH);
     constante('margeB')^.affixe^.setx(margeB);
     CpicaX:=pica*Xscale;
     CpicaY:=pica*Yscale;
     OxEps:= Xmin-margeG/Xscale;
     OyEps:= Ymin-margeB/Yscale;
     {$IFDEF GUI}
     ChangeFen:=true;
     {$ENDIF}
end;
{=======================}
procedure ajouter_element(p:Pelement);
begin
     liste_element.ajouter_fin(p);
end;
{=======================}
procedure recalculer_elements(tous:boolean);
var aux:PCellule;
begin
     aux:=liste_element.tete;
     if tous then
       while (aux<>nil) and (not StopAll) do
        begin if Pelement(aux)^.visible then Pelement(aux)^.recalculer;
             aux:=aux^.suivant
        end
     else
       while (aux<>nil) and (not StopAll)do
          begin if (Pelement(aux)^.visible) and (Pelement(aux)^.ReCalcAuto=1)
              then Pelement(aux)^.recalculer;
              aux:=aux^.suivant
          end;
 end;
{$IFDEF GUI}
{=============}
procedure Canvas2dDrawPath(sender:T_ligne; p:TBGRAPath);
//pour le moment il y a deux passages remplissage puis contour (
//bug dans StrokeOverFill en mode alternate)
var f2:TBGRAcanvas2D;
    z:Paffixe;
    T:array of single; // style du trait
    compt,k:longint;
    style:tbrushstyle;   // pour hachures
    b: TBGRACustomBitmap;
    grad: IBGRACanvasGradient2D;
    R:TrectF;
    xc, yc, angle, r1,r2: single;
    center: TPointF;
begin
  if p.IsEmpty then exit;
  with sender do
  begin
     if (fill_style=0) and (ligne_style=-1) then exit; //rien à dessiner
     f2:=MyBitmap.canvas2D;
     if (fill_style>1) and (fill_style<8) then  //hachures
     begin
          case fill_style of
             2: style:=bsBdiagonal;
             3: style:=bsCross;
             4: style:=bsDiagcross;
             5: style:=bsFdiagonal;
             6: style:=bsHorizontal;
             7: style:=bsVertical;
          end;
          b := MyBitmap.CreateBrushTexture(style, fill_color, BGRAPixelTransparent);//remplissage avec le motif de la brosse
     end;
     if clippee then
         begin
              f2.save;
              f2.beginpath;
              f2.Rect(XentierF(X_min),YentierF(Y_max),XentierF(X_max)-XentierF(X_min),YentierF(Y_min)-YentierF(Y_max));
              f2.clip;
         end;
      case ligne_style of
      -1:f2.lineStyle(psClear);
      0: f2.lineStyle(psSolid);
      1: f2.lineStyle(psDash);
      2: f2.lineStyle(psDot);
      3: begin //line pattern (userdash)
               z:=pattern;
               if (z=Nil) or (z^.suivant=Nil) then f2.lineStyle(psDash)
               else
                    begin
                         compt:=0;
                         while z<>Nil do begin Inc(compt,1); z:=Paffixe(z^.suivant) end;
                         Setlength(T,2*compt); k:=compt;
                         z:=pattern; compt:=0;
                         while z<>nil do
                               begin
                                   T[compt]:=abs(z^.x)*AspectRatio/72.27; //quelle est l'unité réelle ? dépend de width ?
                                   T[compt+k]:=T[compt];
                                   Inc(compt,1); z:=Paffixe(z^.suivant)
                               end;
                         f2.lineStyle(T);
                         finalize(T)
                    end;
          end;
      end;//end case ligne_style
      if ligne_style<>-1 then
       begin
            f2.linewidth:=PenWidth;
            f2.strokestyle(convColor(couleur,round(255*stroke_opacity)));
            case lineCap_style of
             0:  f2.linecap:='butt';
             1:  f2.linecap:='round';
             2:  f2.linecap:='square';
           end;
           case linejoin_style of
             0:  f2.lineJoin:='miter';
             1:  f2.lineJoin:='round';
             2:  f2.lineJoin:='bevel';
           end;
           f2.miterlimit:= miterlimit_style;
       end;
      if (fill_style>=1) then //remplissage
            if evenoddfill then begin f2.fillmode:=fmAlternate end else f2.fillmode:=fmWinding;
      f2.path(p);
      if (fill_style=8) then //gradient
      begin
         R:=p.GetBounds();
         if grad_style=1 then //linear
            begin
                 if grad_angle<>0 then
                 begin
                      xc:=(R.Left+R.Right)/2; yc:=(R.Top+R.Bottom)/2;
                      angle:=grad_angle*pi/180;
                      f2.TRanslate(xc,yc); f2.rotate(-angle);
                      grad:=f2.createLinearGradient(R.Left-xc,0,R.Right-xc,0);
                      f2.rotate(angle); f2.TRanslate(-xc,-yc);
                 end
                 else grad:=f2.createLinearGradient(R.Left,yc,R.Right,yc);
                 grad.addColorStop(0.15, convColor(grad_colorA,round(255*fill_opacity)));
                 grad.addColorStop(0.85, convColor(grad_colorB,round(255*fill_opacity)));
            end
         else
             begin
                  center:=PointF(R.Left+grad_centerX*(R.Right-R.Left), R.Top+(1-grad_centerY)*(R.Bottom-r.Top));
                  r1:=VectLen(R.TopLeft-R.BottomRight); r2:=VectLen(center-R.BottomRight);
                  grad:=f2.createRadialGradient(center,r1/40,center,r1);
                  grad.addColorStop(0, convColor(grad_colorA,round(255*fill_opacity)));
                  grad.addColorStop(0.55, convColor(grad_colorB,round(255*fill_opacity)));
             end;
         f2.fillStyle(grad);
         f2.fill;
      end
      else //pas de gradient
      if fill_style>1 then  //remplissage hachures
      begin
          f2.fillstyle(b);
          f2.fill;
          b.free
      end
      else
      if (fill_style=1) then  //remplissage plein
         begin
             f2.FillStyle(convColor(fill_color,round(255*fill_opacity)));
             f2.fill;
         end;
       if ligne_style<>-1 then// contour
         begin
              f2.path(p);
              f2.stroke
         end;
      if fleche>0 then dessiner_fleches;//fleches basiques, pour elements héritant de T_ligne
      if clippee then f2.restore;
  end;
end;
{======================}
procedure draw_elements;
var aux:PCellule;
begin
     aux:=liste_element.tete;
     while aux<>nil do begin
     Pelement(aux)^.show; aux:=aux^.suivant end;
 end;
 {======================}
procedure dessiner_elements;
var feuille:TBGRACanvas2D;
begin
     if not exportJpeg  then
     begin
          feuille:=MyBitmap.Canvas2D;
          feuille.linestyle(psSolid);
          feuille.linewidth:=1;
          if cadre
             then
                 begin
                      feuille.strokestyle(clblack);
                      feuille.strokeRect( 0, 0, maxX+GmargeG+GmargeD, maxY+GmargeH+GmargeB);
                 end;
          feuille.linestyle(psDot);
          feuille.strokestyle(clLtGray);
          feuille.strokeRect(GmargeG, GmargeH, maxX, maxY);
     end;
     draw_elements;
end;
{$ENDIF}
 {======================}
procedure enregistrer_elements(format:byte;bordure:boolean;const exportfilename:string);
var aux:PCellule;
    aux2:string;
    a,b,I:longint;
    E:Pexpression;
    res:Presult;
    mac:Pmacros;
    old:boolean;
    oldechelle:real;
    oldcoord, okmac, okvar, oldsortietabulee:boolean;
    oldmatrix:Tmatrix;
    f1:Pcorps;
    {$IFDEF GUI}
    function accesfond: string;
    var aux1:string;
    begin
        if Apercu then
                begin
                  aux1:=changeFileExt(FondName,'');
                  aux1:=StringReplace(aux1,'\','/',[rfReplaceAll]);
                end else if format=svg then aux1:=ExtractFileName(FondName)
                                       else aux1:=changeFileExt(ExtractFileName(FondName),'');
        result:=aux1;
    end;
    {$ENDIF}
begin
     CrtClipX1:=Xmin-1; CrtClipX2:=Xmax; CrtClipY1:=Ymin; CrtClipY2:=Ymax; //svg, clipping rectangulaire initialement forcé
     NbSvgClip:=0;  //nombre de clips Svg
     NbSvgGRad:=0;  //nombre de gradients
     epaisseur_courante:=-1;
     eofill_courant:=false; //pour pgf
     style_courant:=0;
     grad_courant:=0;
     courant_point_style:=4;
     fill_courant:=0;
     fillcolor_courant:=-1;// pour pgf
     hatchcolor_courant:=0;
     couleur_courante:=-1;
     Texte_courant:=0;//pstrick
     LabelSize_courant:=-1;
     opacity_courant:=1;
     strokeOpacity_courant:=1;
     linejoin_courant:=0;
     linecap_courant:=0;
     miterlimit_courant:=10;

     AssignFile(ExportFile, ExportFileName);
     rewrite(exportFile);
     WriteMode:=true;

     if not (format in [svg,eps,userExport,src4LaTeX,obj,teg,geom,jvx,texsrc,htmlsrc,js])
        then exportwriteln('% TeXgraph version '+version);
     PExportMode^.affixe^.setX(format);
     //Execution de Bsave
     New(E,init);
     E^.definir('Bsave()');
     res:=E^.evaluer;
     Kill(Pcellule(res));
     dispose(E,detruire);

     case format of
     obj   : begin mac:=macros('SceneToObj');
                   if mac<>Nil then
                      begin
                           res:=mac^.executer(sceneCMD);
                           Kill(Pcellule(res));
                      end;
             end;
     geom  : begin mac:=macros('SceneToGeom');
                   if mac<>Nil then
                      begin
                           res:=mac^.executer(sceneCMD);
                           Kill(Pcellule(res));
                      end;
             end;
    jvx  : begin mac:=macros('SceneToJvx');
                   if mac<>Nil then
                      begin
                           res:=mac^.executer(sceneCMD);
                           Kill(Pcellule(res));
                      end;
             end;
    js   : begin mac:=macros('SceneToJs');
                   if mac<>Nil then
                      begin
                           res:=mac^.executer(sceneCMD);
                           Kill(Pcellule(res));
                      end;
             end;

    userExport:  begin
                      if liste_element.tete=nil then exit;
                      aux:=liste_element.tete;
                      while aux<>nil do begin Pelement(aux)^.Exporter(userExport);aux:=aux^.suivant end;
                 end;
     LaTeX:begin
             if liste_element.tete=nil then exit;
             oldCoord:=OriginalCoord; OriginalCoord:=false;
             exportwriteln('\unitlength 1cm');
             exportwriteln('\begin{picture}('+streel((Xmax-Xmin)*Xscale+margeG+margeD)+','+
             streel((Ymax-Ymin)*Yscale+margeH+margeB)+')('+streel(-margeG)+','+
             streel(-margeB)+')%');
             if bordure then
                begin
             exportwriteln('% Bordure');
             exportwriteln('\path('+streel(-margeG)+','+streel(-margeB)+')('+
             streel(-margeG)+','+streel(Ytex(Ymax)+margeH)+')('+
             streel(XTex(Xmax)+margeD)+','+streel(Ytex(Ymax)+margeH)+')('+
             streel(Xtex(Xmax)+margeD)+','+streel(-margeB)+')('+
             streel(-margeG)+','+streel(-margeB)+')');
               end;

             aux:=liste_element.tete;
             while aux<>nil do begin Pelement(aux)^.Exporter(latex);aux:=aux^.suivant end;
             exportwriteln('\end{picture}%');
             OriginalCoord:=oldCoord;
        end;
   pstricks: begin
             if liste_element.tete=nil then exit;
             exportwriteln('%\usepackage{pst-slpe}% declare this package if you use gradient');
             if OriginalCoord then
                  begin
                     exportwriteln('\psset{dimen=middle,xunit='+Streel(Xscale)+'cm, yunit='+Streel(Yscale)+'cm}%');
                     exportwriteln('\begin{pspicture}('+streel(Xmin-margeG/Xscale)+','+
                                streel(Ymin-margeB/Yscale)+')('+streel(Xmax+margeD/Xscale)+','+
                                streel(Ymax+margeH/Yscale)+')%');
                     if bordure then
                                begin
                        exportwriteln('% Bordure');
                        exportwriteln('\pspolygon('+streel(Xmin-margeG/Xscale)+','+streel(Ymin-margeB/Yscale)+')('+
                        streel(Xmin-margeG/Xscale)+','+streel(Ymax+margeH/Yscale)+')('+
                        streel(Xmax+margeD/Xscale)+','+streel(Ymax+margeH/Yscale)+')('+
                        streel(Xmax+margeD/Xscale)+','+streel(Ymin-margeB/Yscale)+')%');
                                end;
                  end
                else
                 begin
                        exportwriteln('\psset{dimen=middle,xunit=1cm, yunit=1cm}%');
                        exportwriteln('\begin{pspicture}('+streel(-margeG)+','+
                                streel(-margeB)+')('+streel(Xtex(Xmax)+margeD)+','+
                                streel(Ytex(Ymax)+margeH)+')%');
                        if bordure then
                                begin
                        exportwriteln('% Bordure');
                        exportwriteln('\pspolygon('+streel(-margeG)+','+streel(-margeB)+')('+
                        streel(-margeG)+','+streel(Ytex(Ymax)+margeH)+')('+
                        streel(Xtex(Xmax)+margeD)+','+streel(Ytex(Ymax)+margeH)+')('+
                        streel(Xtex(Xmax)+margeD)+','+streel(-margeB)+')');
                                end;
                 end;
             {$IFDEF GUI}
             if Yafond then
                begin
                  exportwriteln('% fond');
                  exportwriteln('\put('+streel(Xtex(fondOrigX))+','+streel(Ytex(fondOrigY-fondHaut))+'){'+
                  '\includegraphics[width='+streel(FondLarge*Xscale)+'cm]{'+AccesFond+'}}%');
                end;
             {$ENDIF}
             aux:=liste_element.tete;
             while aux<>nil do begin Pelement(aux)^.Exporter(pstricks);aux:=aux^.suivant end;
             exportwriteln('\end{pspicture}%');

        end;
 src4LaTeX,teg: begin
             DefaultSettings; oldmatrix:=CurrentMatrix;
             oldsortietabulee:=SortieTabulee; //tabulations insérées à chaque retour chariot
             SortieTabulee:=true;
             CurrentMatrix:=DefaultMatrix;
             if format=src4Latex then exportwriteln('\begin{texgraph}[file,call]') //annonce le mode inline pour LaTeX
             else
             //if format=teg then
                 begin
                      exportwriteln('TeXgraph#');
                      exportwriteln('{version '+version+'}')
                 end;
             //Fenetre
             res:=new(paffixe,init(Xmin,Ymax));
             exportwriteln('Cmd');
             aux2:=#9+'Window('+res^.en_chaine+', '; kill(Pcellule(res));
             res:=new(paffixe,init(Xmax,Ymin));
             aux2:=aux2+res^.en_chaine+', '; kill(Pcellule(res));
             res:=new(paffixe,init(Xscale,Yscale));
             aux2:=aux2+res^.en_chaine+'); '; kill(Pcellule(res));
             exportwriteln(aux2);
             //Marges
             aux2:=#9+'Margin('+streels(margeG)+', '+streels(margeD)+', '+streels(margeH)+', '+streels(margeB)+');';
             exportwriteln(aux2);
             //bordure
             exportwriteln(#9+'Border('+IntToStr(byte(cadre))+');');
             exportwriteln(#9+'[OriginalCoord('+IntToStr(byte(OriginalCoord))+'), IdMatrix()];');
             if Ptheta^.affixe=nil then Ptheta^.affixe:=New(Paffixe,init(pi/6,0));
             if Pphi^.affixe=nil then Pphi^.affixe:=New(Paffixe,init(pi/3,0));

             aux2:='[theta:='+streel(Ptheta^.affixe^.getX)+', phi:='+streel(Pphi^.affixe^.getX)+', IdMatrix3D()';
             if centrale then aux2:=aux2+', ModelView(central), DistCam('+Streel(Dcamera)+')]'
                     else aux2:=aux2+', ModelView(ortho)]';
             exportwriteln(#9+aux2+';');
             if format=teg then
                begin
                     exportwriteln(#9+'[GrayScale('+InttoStr(1-byte(gestion_couleur))+'), '+
                     'ComptGraph:='+Streel(PcomptGraph^.affixe^.getX)+'];');
                end
             else exportwriteln(#9+'GrayScale('+InttoStr(1-byte(gestion_couleur))+');');

             {$IFDEF GUI}
             if Yafond And (format=teg) then
                begin
                     //exportwriteln('');
                     exportwriteln('{background picture}');
                     exportwriteln(#9+'[$coin1:=Xmin+i*Ymax, $coin2:=Xmax+i*Ymin,'+
                        'Window('+streels(FondOrigX)+'+i*('+streels(FondOrigY)+'),'+
                        streels(FondOrigX+FondLarge)+'+i*('+streels(FondOrigY-FondHaut)+
                        ')), LoadImage("'+FondName+'"), Window(coin1,coin2)];');
                end;
	    {$ENDIF}
            if format=teg then
             begin
              mac:=macros('TegWrite');
              if (mac<>nil)
                 then
                     if mac^.contenu^.corps<>nil
                        then
                            begin
                                 aux2:=mac^.contenu^.corps^.en_chaine;
                                 aux2:=FormatString(aux2,80);
                                 //exportwriteln('');
                                 exportwriteln(#9+aux2+';');
                            end;
             end;
           aux:=VariablesGlobales^.tete;
           if (aux<>nil) then
            begin
                  // Déclaration des Variables Globales
                  okvar:=false;
                  while (aux<>nil) do
                   begin
                        if PVarGlob(aux)^.statut=0
                           then
                           begin
                             if not okvar then
                                begin
                                     exportwriteln('');
                                     exportwriteln('Var');
                                     okvar:=true
                                end;
                             if PVarGlob(aux)^.commande='' then
                                begin
                                     If PVarGlob(aux)^.variable^.affixe<>nil
                                        then PVarGlob(aux)^.commande:=PVarGlob(aux)^.variable^.affixe^.en_chaine
                                        else PVarGlob(aux)^.commande:='Nil'
                                end;
                             exportwriteln('    '+PVarGlob(aux)^.variable^.nom+' = '+
                                 FormatString(PVarGlob(aux)^.commande,70)+';');
                          end;
                        aux:=PVarGlob(aux^.suivant);
                   end;
                   //if okvar then exportwriteln('');
            end;
           if ListeFicMac.Count>0 then
            begin
               exportwriteln('');
               exportwriteln('Include');
               for a:=0 to ListeFicMac.Count-1 do
                   exportwriteln(#9+'"'+ListeFicMac[a]+'";');
               //exportwriteln('');
            end;
           //Déclaration des Macros
           okmac:=false;
           with LesMacros do
              for I:=0 to Count-1 do
            begin
                 aux:=List[I]^.Data;
                 if Pmacros(aux)^.statut=0 then
                    begin
                         if not okmac then
                            begin
                                 exportwriteln('');
                                 exportwriteln('Mac');
                                 okmac:=true
                            end;
                         exportwriteln('    '+Pmacros(aux)^.nom+' = '+
                            TabuleString(Pmacros(aux)^.commande)+';');
                         exportwriteln('');
                    end;
            end;
            aux:=liste_element.tete; // éléments graphiques
            if (aux<>nil) then
                begin
                        if not okmac then exportwriteln('');
                        // Déclaration des Eléments graphiques en un seul
                        //exportwriteln('Graph');// objet1 = [');
                         while aux<>nil do
                               begin Pelement(aux)^.Exporter(src4LaTeX);
                                     aux:=aux^.suivant;
                               end;
                        //exportwriteln('];')
                end;
             if format=src4Latex then exportwriteln('\end{texgraph}');
             Sortietabulee:=oldSortieTabulee;
             CurrentMatrix:=oldmatrix;
           end;
         
       eps: begin {format eps}
            if liste_element.tete=nil then exit;
            a:=round(XEps(Xmax+margeD/Xscale));
            b:=round(YEps(Ymax+margeH/Yscale));
            exportwriteln( '%!PS-Adobe-3.0 EPSF-3.0');
            exportwriteln( '%%Creator: TeXgraph');
            exportwriteln( '%%BoundingBox: 0 0 '+InttoStr(a)+' '+InttoStr(b));
            exportwriteln( '%%Page: 1 1');
            aux:=liste_element.tete;
            if (not UsePsfrag) and (UseLabels>0) then
          begin
            exportwriteln( '/encoding_vector [');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln('/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln('/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln('/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln('/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln('/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln('/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln('/.notdef      	/.notdef      	/.notdef      	/.notdef');

            exportwriteln( '/space        	/exclam       	/quotedbl     	/numbersign');
            exportwriteln( '/dollar       	/percent      	/ampersand    	/quoteright');
            exportwriteln( '/parenleft    	/parenright   	/asterisk     	/plus');
            exportwriteln( '/comma        	/minus        	/period       	/slash');
            exportwriteln( '/zero         	/one          	/two          	/three');
            exportwriteln( '/four         	/five         	/six          	/seven');
            exportwriteln( '/eight        	/nine         	/colon        	/semicolon');
            exportwriteln( '/less         	/equal        	/greater      	/question');

            exportwriteln( '/at           	/A            	/B            	/C');
            exportwriteln( '/D            	/E            	/F            	/G');
            exportwriteln( '/H            	/I            	/J            	/K');
            exportwriteln( '/L            	/M            	/N            	/O');
            exportwriteln( '/P            	/Q            	/R            	/S');
            exportwriteln( '/T            	/U            	/V            	/W');
            exportwriteln( '/X            	/Y            	/Z            	/bracketleft');
            exportwriteln( '/backslash    	/bracketright 	/asciicircum  	/underscore');

            exportwriteln( '/quoteleft    	/a            	/b            	/c');
            exportwriteln( '/d            	/e            	/f            	/g');
            exportwriteln( '/h            	/i            	/j            	/k');
            exportwriteln( '/l            	/m            	/n            	/o');
            exportwriteln( '/p            	/q            	/r            	/s');
            exportwriteln( '/t            	/u            	/v            	/w');
            exportwriteln( '/x            	/y            	/z            	/braceleft');
            exportwriteln( '/bar          	/braceright   	/tilde        	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/.notdef      	/.notdef      	/.notdef      	/.notdef');
            exportwriteln( '/space        	/exclamdown   	/cent         	/sterling');
            exportwriteln( '/currency     	/yen          	/brokenbar    	/section');
            exportwriteln( '/dieresis     	/copyright    	/ordfeminine  	/guillemotleft');
            exportwriteln( '/logicalnot   	/hyphen       	/registered   	/macron');
            exportwriteln( '/degree       	/plusminus    	/twosuperior  	/threesuperior');
            exportwriteln( '/acute        	/mu           	/paragraph    	/bullet');
            exportwriteln( '/cedilla      	/dotlessi     	/ordmasculine 	/guillemotright');
            exportwriteln( '/onequarter   	/onehalf      	/threequarters	/questiondown');
            exportwriteln( '/Agrave       	/Aacute       	/Acircumflex  	/Atilde');
            exportwriteln( '/Adieresis    	/Aring        	/AE           	/Ccedilla');
            exportwriteln( '/Egrave       	/Eacute       	/Ecircumflex  	/Edieresis');
            exportwriteln( '/Igrave       	/Iacute       	/Icircumflex  	/Idieresis');
            exportwriteln( '/Eth          	/Ntilde       	/Ograve       	/Oacute');
            exportwriteln( '/Ocircumflex  	/Otilde       	/Odieresis    	/multiply');
            exportwriteln( '/Oslash       	/Ugrave       	/Uacute       	/Ucircumflex');
            exportwriteln( '/Udieresis    	/Yacute       	/Thorn        	/germandbls');
            exportwriteln( '/agrave       	/aacute       	/acircumflex  	/atilde');
            exportwriteln( '/adieresis    	/aring        	/ae           	/ccedilla');
            exportwriteln( '/egrave       	/eacute       	/ecircumflex  	/edieresis');
            exportwriteln( '/igrave       	/iacute       	/icircumflex  	/idieresis');
            exportwriteln( '/eth          	/ntilde       	/ograve       	/oacute');
            exportwriteln( '/ocircumflex  	/otilde       	/odieresis    	/divide');
            exportwriteln( '/oslash       	/ugrave       	/uacute       	/ucircumflex');
            exportwriteln( '/udieresis    	/yacute       	/thorn        	/ydieresis');
            exportwriteln( '] def');
            exportwriteln( '/MF {');
            exportwriteln( '/newfontname exch def');
            exportwriteln( '  /fontname exch def');
            exportwriteln( '  /fontdict fontname findfont def');
            exportwriteln( '  /newfont fontdict maxlength dict def');
            exportwriteln( 'fontdict {');
            exportwriteln( '    exch');
            exportwriteln( '    dup /FID eq {');
            exportwriteln( '      pop pop');
            exportwriteln( '    } {');
            exportwriteln( '      exch newfont 3 1 roll put');
            exportwriteln( '    } ifelse');
            exportwriteln( '  } forall');
            exportwriteln( '  newfont /FontName newfontname put');
            exportwriteln( '  encoding_vector length 256 eq {');
            exportwriteln( '    newfont /Encoding encoding_vector put');
            exportwriteln( '  } if');
            exportwriteln( '  newfontname newfont definefont pop');
            exportwriteln( '} def');
            exportwriteln( '/Times-Roman /myfont MF');
            exportwriteln( '/myfont findfont 10 scalefont setfont');
          end
            else exportwriteln( '/Helvetica findfont 10 scalefont setfont');
            exportwriteln( '/gsave');
            exportwriteln( '37 dict begin');
            exportwriteln( '/bd{bind def} bind def /ld{load def}bd /gs/gsave ld /gr/grestore ld');
            exportwriteln( '/fact{0.333}bd');
            exportwriteln( '/h{-10 fact mul}def');
            exportwriteln( '/m/moveto ld /rm/rmoveto ld /l/lineto ld /rl/rlineto ld');
            exportwriteln( '/s/stroke ld /rgb/setrgbcolor ld /black{0 0 0 rgb} bd /white{1 1 1 rgb }bd');
            exportwriteln( '/red{1 0 0 rgb} bd /green{0 1 0 rgb} bd /blue{0 0 1 rgb} bd /yellow{1 1 0 rgb}bd');
            exportwriteln( '/cyan{0 1 1 rgb}bd /magenta{1 0 1 rgb}bd /gray{0.31 0.31 0.31 rgb}bd /thinlines{0.2 setlinewidth}bd');
            exportwriteln( '/thicklines{0.8 setlinewidth}bd /Thicklines{1.4 setlinewidth}bd /SolidLine{[] 0 setdash}bd');
            exportwriteln( '/DotLine{[0 2] 0 setdash}bd /DashLine{[2.5 2] 0 setdash}bd');
            if (not UsePsfrag) and (UseLabels>0) then
               begin
            exportwriteln( '/CenterH{dup stringwidth pop 2 div 0 exch sub}bd');
            exportwriteln( '/Right{dup stringwidth pop 0 exch sub}bd');
            exportwriteln('/Left{0}bd');
            exportwriteln('/CenterV{h rm show s}bd');
            exportwriteln('/Top{h 2 mul rm show s}bd');
            exportwriteln('/Bottom{0 rm show s}bd');
               end else
               begin
            exportwriteln( '/CenterH{show}bd /Left{show}bd /Right{show}bd /Top{s}bd');
            exportwriteln('/CenterV{s}bd');exportwriteln('/Bottom{s}bd')
               end;
            exportwriteln( '/dot{0.75 0 360 arc closepath gs s gr fill}bd /Bdot{1.5 0 360 arc closepath gs s gr fill}bd');
            exportwriteln( '/cross{m 3 neg 0 rm 6 0 rl 3 neg 3 neg rm 0 6 rl s}bd');
            exportwriteln( '/CM {matrix currentmatrix}bd');
            {pour le Gouraud shading}
            exportwriteln('/gfill{shfill}bd');
            exportwriteln('/sTs { << /ShadingType 4 /ColorSpace triCS /DataSource triDS >> gfill} def');
            exportwriteln('/triCS /DeviceRGB def');
            {pour le gradient}
            exportwriteln('/StartHSB{ /B1 exch def /S1 exch def /H1 exch def } def');
            exportwriteln('/EndHSB{ /B2 exch def /S2 exch def /H2 exch def');
            exportwriteln('         /Steps Nb 1 sub def');
            exportwriteln('         /Hstep H2 H1 sub Steps div def');
            exportwriteln('         /Sstep S2 S1 sub Steps div def');
            exportwriteln('         /Bstep B2 B1 sub Steps div def');
            exportwriteln('         } def');
            exportwriteln('/StepHSB{ /H1 H1 Hstep add def');
            exportwriteln('           /S1 S1 Sstep add def');
            exportwriteln('           /B1 B1 Bstep add def');
            exportwriteln('           H1 S1 B1 setrgbcolor');
            exportwriteln('         } def');
            if bordure then
               begin
                    exportwriteln( '%Bordure');
                    exportwriteln( 'thinlines 0.4 0.4 m 0.4 '+InttoStr(b)+' 0.4 sub l '+InttoStr(a)+
                               ' 0.4 sub '+InttoStr(b)+' 0.4 sub l '+InttoStr(a)+
                               ' 0.4 sub 0.4 l closepath s');
               end;
            aux:=liste_element.tete;
            LabelPsfrag:=1; {compteur de labels}
            if UsePsfrag then rewrite(psfrag);
            while aux<>nil do begin Pelement(aux)^.Exporter(eps);aux:=aux^.suivant end;
            exportwriteln('');
            exportwriteln('end');
            exportwriteln('%EOF');
            exportwriteln('%%Trailer');
            LabelPsfrag:=1;{compteur de labels}
            end;
tikz, pgf: begin {format pgf}
            if liste_element.tete=nil then exit;
            exportwriteln('\bgroup%');
            exportwriteln('%\shorthandoff{;:!?}% uncomment if problem with babel');
            exportwriteln('\pgfdeclarehorizontalshading[colorA,colorB]{myshading}{100bp}{color(0bp)=(colorA);color(75bp)=(colorB)}%');
            exportwriteln('\pgfdeclareradialshading[colorA,colorB]{mysphereshading}{\pgfpoint{\GradCenterX bp}{\GradCenterY bp}}{color(0bp)=(colorA); color(35bp)=(colorB)}%');
            exportwriteln('%\shorthandon{;:!?}% uncomment if problem with babel');
            if OriginalCoord then
                  begin
                    exportwriteln('\begin{tikzpicture}%');
                    //               else
                    //                exportwriteln('\begin{pgfpicture}{'+
                    //                  streel(Xmin*Xscale-margeG)+'cm}{'+
                    //                  streel(Ymin*Yscale-margeB)+'cm}{'+streel(Xmax*Xscale+margeD)+
                    //                  'cm}{'+streel(Ymax*Yscale+margeH)+'cm}%');
                    if Xscale<>1 then
                     exportwriteln('\pgfsetxvec{\pgfxy('+Streel(Xscale)+',0)}%');
                    if Yscale<>1 then
                     exportwriteln('\pgfsetyvec{\pgfxy(0,'+Streel(Yscale)+')}%');
                     exportwriteln('\useasboundingbox ('+streel(Xmin-margeG/Xscale)+','+
                                         streel(Ymin-margeB/Yscale)+')--('+
                                         streel(Xmax+margeD/Xscale)+','+
                                         streel(Ymax+margeH/Yscale)+');');
                     if bordure then
                                begin
                        exportwriteln('% Border');
                        exportwriteln('\pgfpathmoveto{\pgfxy('+streel(Xmin-margeG/Xscale)+','+streel(Ymin-margeB/Yscale)+')}%');
                        exportwriteln('\pgfpathlineto{\pgfxy('+streel(Xmax+margeD/Xscale)+','+ streel(Ymin-margeB/Yscale)+')}%');
                        exportwriteln('\pgfpathlineto{\pgfxy('+streel(Xmax+margeD/Xscale)+','+ streel(Ymax+margeH/Yscale)+')}%');
                        exportwriteln('\pgfpathlineto{\pgfxy('+ streel(Xmin-margeG/Xscale)+','+ streel(Ymax+margeH/Yscale)+')}%');
                        exportwriteln('\pgfclosestroke');
                                end;
                  end
                else
                 begin
                       exportwriteln('\begin{tikzpicture}%');
                       //            else
                       //             exportwriteln('\begin{pgfpicture}{'+
                       //                 streel(-margeG)+'cm}{'+streel(-margeB)+'cm}'+
                       //                 '{'+streel(Xtex(Xmax)+margeD)+'cm}{'+
                       //                 streel(Ytex(Ymax)+margeH)+'cm}%');
                        if bordure then
                          begin
                    exportwriteln('% Border');
                    exportwriteln('\pgfpathmoveto{\pgfxy('+streel(-margeG)+','+streel(-margeB)+')}%');
                    exportwriteln('\pgfpathlineto{\pgfxy('+streel(Xtex(Xmax)+margeD)+','+ streel(-margeB)+')}%');
                    exportwriteln('\pgfpathlineto{\pgfxy('+streel(Xtex(Xmax)+margeD)+','+ streel(Ytex(Ymax)+margeH)+')}%');
                    exportwriteln('\pgfpathlineto{\pgfxy('+ streel(-margeG)+','+ streel(Ytex(Ymax)+margeH)+')}%');
                    exportwriteln('\pgfclosestroke');
                          end;

                 end;
	    {$IFDEF GUI}
            if Yafond then
                begin
                  exportwriteln('% background');
                  exportwriteln('\pgfputat{\pgfxy('+streel(Xtex(fondOrigX))+','+
                     streel(Ytex(fondOrigY-fondHaut))+')}{'+
                     '\includegraphics[width='+streel(FondLarge*Xscale)+'cm]{'+AccesFond+'}}%');
                end;
	    {$ENDIF}
            aux:=liste_element.tete;
            while aux<>nil do begin Pelement(aux)^.Exporter(pgf);aux:=aux^.suivant end;
            exportwriteln('\end{tikzpicture}%');
                           //else exportwriteln('\end{pgfpicture}%');
            exportwriteln('\egroup%');
       end;
   svg: begin {format svg}
                NumFormule:=0;
                oldechelle:=CurrentScale;
                unite_graphique(CurrentRes, 1);
                exportwriteln('<?xml version="1.0" encoding="utf-8" standalone="no"?>');
                exportwrite('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"');
                exportwriteln(' "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg11.dtd">');
                {exportwriteln('<svg width="'+streel(margeG+margeD+Xscale*(Xmax-Xmin)) +
                'cm" height="'+ streel(margeH+margeB+Yscale*(Ymax-Ymin))+'cm"'+
                ' viewBox="0 0 '+streel(margeG+margeD+Xscale*(Xmax-Xmin))+
                ' '+ streel(margeH+margeB+Yscale*(Ymax-Ymin))+'"'+' overflow="hidden"');}
                exportwriteln('<svg width="'+streel(margeG+margeD+Xscale*(Xmax-Xmin)) +
                'cm" height="'+ streel(margeH+margeB+Yscale*(Ymax-Ymin))+'cm"'+
                ' viewBox="0 0 '+intToStr(GmargeG+GmargeD+maxX)+
                ' '+ IntToStr(GmargeH+GmargeB+maxY)+'"'+' overflow="hidden"');
                exportwriteln(' version="1.1" xmlns="http://www.w3.org/2000/svg" '+
                ' xmlns:xlink="http://www.w3.org/1999/xlink">');
                if bordure then
               begin
                    exportwriteln('<!-- Bordure -->');
                    {exportwriteln('<rect x="0" y="0" width="'+streel(Xscale*(Xmax-Xmin)+margeG+margeD)+
                    '" height="'+ streel(Yscale*(Ymax-Ymin)+margeH+margeB)+'" fill="none" stroke="black" stroke-width="0.05" />');}
                    exportwriteln('<rect x="0" y="0" width="'+IntToStr(maxX+GmargeG+GmargeD)+
                    '" height="'+ IntToStr(maxY+GmargeH+GmargeB)+'" fill="none" stroke="black" stroke-width="0.05cm" />');
               end;
               //exportwriteln('<clipPath id="MyClip">'); //pour les éventuels clippings
	       //exportwriteln('<rect x="'+Streel(margeG)+'" y="'+Streel(margeH)+'" width="'+
                //streel(Xscale*(Xmax-Xmin))+'" height="'+ streel(Yscale*(Ymax-Ymin))+'"/>');
               //exportwriteln('</clipPath>');
               {$IFDEF GUI}
               if Yafond then
                begin
                  exportwriteln('<!-- background -->');
                  exportwriteln('<image x="'+streel(Xsvg(fondOrigX))+'" y="'+streel(Ysvg(fondOrigY))+'" '
                     +'width="'+streel(FondLarge*Xscale)+'cm" height="'+streel(fondHaut*Yscale)+
                     'cm" xlink:href="'+AccesFond+'"/>');
                end;
               {$ENDIF}
               aux:=liste_element.tete;
               while aux<>nil do begin Pelement(aux)^.Exporter(svg);aux:=aux^.suivant end;
               exportwriteln('</svg>');
               unite_graphique(CurrentRes, oldechelle);
        end;
      end;
      //Execution de Esave
      New(E,init);
      E^.definir('Esave()');
      res:=E^.evaluer;
      Kill(Pcellule(res));
      dispose(E,detruire);

      WriteMode:=false;
      CloseFile(ExportFile);
      PExportMode^.affixe^.setX(0);//export fini
 end;
 {======================}
 procedure vider_liste;
 begin
        liste_element.detruire;
        PcomptGraph^.affixe^.setX(0)
 end;
 {======================}
Function Xreel(x:longint):Real;
begin Xreel:= Xmin+(x-GmargeG)*(Xmax-Xmin)/maxX
end;
{==================}
Function Yreel(y:longint):Real;
begin Yreel:=Ymax+(y-GmargeH)*(Ymin-Ymax)/maxY
end;
{==================}
Function XTeX(x:Real):Real;
begin
 if OriginalCoord then Result:=x
                  else Result:=(x-Xmin)*Xscale
end;
{==================}
Function YTeX(y:Real):Real;
begin
   if OriginalCoord then Result:=y
                    else Result:= (y-Ymin)*Yscale
end;
{==================}
Function XEps(x:Real):Real;
begin Result:= CpicaX*(x-OxEps)
end;
{==================}
Function YEps(y:Real):Real;
begin Result:=CpicaY*(y-OyEps)
end;
{==================}
Function XentierF(x:real): real;
begin
      XentierF:=((x-Xmin)*maxX/(Xmax-Xmin))+GmargeG
end;
{==================}
Function Xentier(x:real): longint;
begin
      Xentier:=round((x-Xmin)*maxX/(Xmax-Xmin))+GmargeG
end;
{==================}
Function YentierF(y:real): real;
begin
      YentierF:=((y-Ymax)*maxY/(Ymin-Ymax))+GmargeH
end;
{==================}
Function Yentier(y:real): longint;
begin
      Yentier:=round((y-Ymax)*maxY/(Ymin-Ymax))+GmargeH
end;
{==================}
Function longX(x:real): real;// conversion de longueur réelle vers pixel suivant Ox
begin
   result:=(x*maxX)/(Xmax-Xmin)
end;
{==================}
Function longY(y:real): real;// conversion de longueur réelle vers pixel suivant Oy
begin
   result:=(y*maxY)/(Ymax-Ymin)
end;
{==================}
Function XSvg(x:Real):real;
begin Result:=XentierF(x);//(x-Xmin)*Xscale+margeG
end;
{==================}
Function YSvg(y:Real):real;
begin Result:= YentierF(y);//(Ymax-y)*Yscale+margeH
end;
{==================}
function SvgWidth(trait:longint): string;
begin
        result:=streel(trait*0.0035146/2.54*96);//streel(trait*0.0035146)
end;
{==========================================Type t_element ==================}
constructor t_element.init(const UnNom, UneCommande:string);
begin
 TNoeud.init(UnNom);
 fixeAttributs;
 liste_points:=new(Pliste,init);
 noClipList.init;
 LigneCommande:=CleanString(UneCommande);
 arbre:=nil;
 donnees:=nil;
 DefCommande:=Unecommande<>'';
 //ConstruitArbre(nil);
 if DefCommande then Recalculer;
end;
{======================}
procedure t_element.ConstruitArbre(Unarbre:Pcorps);
begin
     if Unarbre<>nil
        then
            begin
             new(arbre,init);
             DefCommande:=false;
             arbre^.VarLoc:=LesVarLoc;
             arbre^.corps:=Unarbre;
        end
        else
            begin
                 if arbre<>nil then dispose(arbre,detruire);
                 new(arbre,init);
                 if not arbre^.definir(LigneCommande)
                    then begin
                           dispose(arbre,detruire);
                           arbre:=nil
                         end;
                 DefCommande:=true;
            end;
end;
{======================}
procedure t_element.fixeAttributs;
begin
      GetAttributs;
      X_min:=Xmin; X_max:=Xmax;
      Y_min:=Ymin; Y_max:=Ymax;
      matrix:=Currentmatrix;
      id:=mouseCode;
      Transform:=(matrix[5]<>0) or (matrix[6]<>0) or (matrix[1]<>1) or (matrix[3]<>0)
             or (matrix[2]<>0) or (matrix[4]<>1);
      visible:=EstVisible;
      couleur:=linecolor;
      trait:=Linewidth;
      if trait=0 then trait:=1;
      ReCalcAuto:=AutoReCalc;
{$IFDEF GUI}
      if PenMode=1 then pen_mode:=PenMode1 else pen_mode:=pmCopy;
{$ENDIF}
      stroke_opacity:=StrokeOpacity;

end;
{========================}
procedure t_element.lireAttributs;
begin
     EstVisible:=visible;
     linecolor:=couleur;
     linewidth:=trait;
     StrokeOpacity:=stroke_opacity;
     AutoReCalc:=ReCalcAuto;
     CurrentMatrix:=matrix;
     mouseCode:=id;
     Setattributs;
end;
{========================}
{$IFDEF GUI}
function t_element.PenWidth:single;
begin
        Result:=trait*CurrentScale*CurrentRes/722.7;
        if result<=0 then result:=2;
end;
{========================}
function t_element.CalcLabelSize(size:integer):integer;
begin
    Result:=2*size+10
end;
{$ENDIF}
{========================}
procedure t_element.recalculer;
var aux:Paffixe;
begin
     X_min:=Xmin; X_max:=Xmax;
     Y_min:=Ymin; Y_max:=Ymax;
     //if not visible then exit; //on ne recalcule pas les objets non visibles
     liste_points^.detruire;
     liste_points^.init;
     noClipList.detruire;
     //if not visible then exit; //on ne recalcule pas les objets non visibles
     if DefCommande then
        begin
             ConstruitArbre(nil);
             if arbre=nil then exit;
        end
        else if arbre=nil then exit;
     aux:=arbre.evalNum;
     if aux<>nil then
          liste_points^.ajouter_fin(aux);
end;
{=======================}
procedure t_element.Deftransform(a,b,c,d,t1,t2:real);
begin
        matrix[1]:=a; matrix[3]:=b; matrix[2]:=c; matrix[4]:=d;
        matrix[5]:=t1;matrix[6]:=t2;
        transform:=(t1<>0) or (t2<>0) or (a<>1) or (b<>0)
             or (c<>0) or (d<>1);
        ReCalculer;
end;
{======================}
procedure t_element.transformate;
var res:Type_liste;
    aux:Paffixe;
    a,b,x,y:real;
begin
     aux:=Mtransform(Paffixe(Liste_points^.tete),matrix);
     Liste_points^.detruire;
     Liste_points^.ajouter_fin(aux);
end;
{==========================}
procedure t_element.purger;
var aux,aux1:Paffixe;
    A,B,X,Y,epsilon:real;
begin
         epsilon:=0.00172805;
         aux:=Paffixe(Liste_points^.tete);
         if aux=nil then exit;
         while (aux<>nil) and Isjump(aux) do liste_points^.supprimer(Pcellule(aux));
         if aux=nil then exit;
         A:=aux^.x*Xscale;
         B:=aux^.y*Yscale;
         while aux<>nil do
             begin
             aux1:=Paffixe(aux^.suivant);
             if (aux1<>nil) and (not Isjump(aux1))
                then begin
                     X:=aux1^.x*Xscale;
                     Y:=aux1^.y*Yscale;
                     if (abs(A-X)<=epsilon) and  (abs(B-Y)<=epsilon) then
                        liste_points^.supprimer(Pcellule(aux))
                        else begin A:=X;B:=Y;aux:=aux1;end;
                     end
                else begin
                     if aux1<>nil then aux1:=Paffixe(aux1^.suivant);
                     while (aux1<>nil) and (IsJump(aux1)) do
                        liste_points^.supprimer(Pcellule(aux1));
                     aux:=aux1;
                     if aux<>nil then begin A:=aux^.x*Xscale;B:=aux^.y*Yscale; end
                     end
             end;
end;
{===========================}
procedure T_element.clip;
var aux:Paffixe;
begin
     aux:=Paffixe(Liste_points^.tete);
     if aux=nil then exit;
     while aux<>nil do
     if (aux^.y>=Y_min) and (aux^.y<=Y_max)
               and (aux^.x>=X_min) and (aux^.x<=X_max)
     then  aux:=Paffixe(aux^.suivant)
     else  Liste_points^.supprimer(Pcellule(aux));
end;
{=======================}
procedure T_element.clipper;
begin
        purger;
        if not Clipping then exit;
        Clip;
        purger;
end;
{======================}
{$IFDEF GUI}
procedure t_element.parametres_scr(var coul:longint);
var feuille:TBGRACanvas;
begin
       feuille:=MyBitmap.CanvasBGRA;
       coul:=convColor(couleur,round(255*stroke_opacity));
       feuille.pen.BGRAColor:=coul;
       //feuille.Pen.mode:=pen_mode;
       feuille.pen.style:=psSolid;
       feuille.Pen.width:=round(PenWidth); //(trait div 6)+1;
       feuille.Brush.style:=bsClear
end;
{=======================}
procedure t_element.show;
begin
    if visible then dessiner;
end;
{=======================}
procedure t_element.dessiner;
begin
end;
{=======================}
procedure t_element.toPath(Var first:boolean; var p: TBGRAPath);
begin
end;
{$ENDIF}
{=======================}
procedure t_element.ClipExport(mode:byte);
begin
        case mode of
        eps: exportwriteln( Streel(Xeps(X_min))+' '+Streel(Yeps(Y_min))+' m '+
                      Streel(Xeps(X_max))+' '+ Streel(Yeps(Y_min))+' l '+
                      Streel(Xeps(X_max))+' '+Streel(Yeps(Y_max))+' l '+
                      Streel(Xeps(X_min))+' '+Streel(Yeps(Y_max))+' l closepath clip newpath');
        svg: if  (CrtClipX1<>X_min) or (CrtClipX2<>X_max) or (CrtClipY1<>Y_min) or (CrtClipY2<>Y_max)
             then begin
                  Inc(NbSvgClip,1); SvgClipName:='Clip'+IntToStr(NbSvgClip);
                  CrtClipX1:=X_min; CrtClipX2:=X_max; CrtClipY1:=Y_min; CrtClipY2:=Y_max;
                  exportwriteln('<clipPath id="'+SvgClipName+'">'); //pour les éventuels clippings
	          exportwriteln('<rect x="'+Streel(Xsvg(X_min))+'" y="'+Streel(Ysvg(Y_max))+'" width="'+
                    streel(Xscale*(X_max-X_min))+'cm" height="'+ streel(Yscale*(Y_max-Y_min))+'cm"/>');
                  exportwriteln('</clipPath>');
                  end;
        pgf: begin
                exportwriteln('\begin{pgfscope}%');
                exportwrite('\pgfpathmoveto{\pgfxy('+streel(Xtex(X_min))+','+streel(Ytex(Y_min))+')}');
                exportwriteln('\pgfpathlineto{\pgfxy('+streel(Xtex(X_max))+','+streel(Ytex(Y_min))+')}%');
                exportwrite('\pgfpathlineto{\pgfxy('+streel(Xtex(X_max))+','+ streel(Ytex(Y_max))+')}');
                exportwriteln('\pgfpathlineto{\pgfxy('+streel(Xtex(X_min))+','+ streel(Ytex(Y_max))+')}\pgfclosepath%');
                exportwriteln('\pgfclip%');
             end;
   pstricks: exportwriteln('\psclip{\psframe[linestyle=none,fillstyle=none]('+
                        streel(Xtex(X_min))+','+ streel(Ytex(Y_min))+')('+
                        //streel(Xtex(X_min))+','+ streel(Ytex(Y_max))+')('+
                        streel(Xtex(X_max))+','+streel(Ytex(Y_max))+')}%');
                        //streel(Xtex(X_max))+','+streel(Ytex(Y_min))+')}%');
        end;
end;
{======================================== Enregistrer ==================================}
procedure t_element.Exporter(mode:byte);
begin
     if not (visible or (mode=teg) or (mode=src4latex)) then exit;
     case mode of
     latex:    enregistrer_latex;
     pstricks: enregistrer_pst;
     pgf,tikz:      enregistrer_pgf;
     eps:      enregistrer_eps;
     teg,src4latex: enregistrer_src4latex;
     userExport: enregistrer_userExport;
     svg:      enregistrer_svg;
     end;
end;
{====================================== userExport =================================}
procedure t_element.enregistrer_userExport;
begin
end;
{====================================== LaTeX =================================}
procedure t_element.enregistrer_latex;
begin
     if (liste_points^.tete=nil) and (cat<>cat_utilisateur) then exit;
     BeginExportLaTeX;
     DoExportLaTeX;
     EndExportLaTeX;
end;
{==============}
procedure t_element.BeginExportLatex;
var ok:boolean;
begin
     ok:=false;
     if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
     if (couleur<>couleur_courante)  and (cat<>cat_utilisateur)
     then begin
                 exportwriteln('\color'+StrColor(couleur,latex));ok:=true;
                 couleur_courante:=couleur
           end;
     if (trait<>epaisseur_courante) and (cat<>cat_label) and (cat<>cat_utilisateur)
      then begin
           case trait of
           2: exportwriteln('\thinlines ');
           8: exportwriteln('\thicklines ');
           14: exportwriteln('\Thicklines ');
           else exportwriteln('\allinethickness{'+streel(0.1*trait)+'pt}%');
           end;
           epaisseur_courante:=trait;ok:=true;
           end;
      if ok then exportwriteln('');
end;
{==============}
procedure t_element.DoExportLatex;
begin
end;
{==============}
procedure t_element.EndExportLatex;
begin
end;
{=================================== Pstricks ==================================}
function t_element.parametres_Pst:string;
var chaine:string;
begin
     chaine:='';
     if (couleur<>couleur_courante) then
        begin
             chaine:='linecolor='+StrColor(couleur,pstricks);
             couleur_courante:=couleur
           end;
      if (trait<>epaisseur_courante) then
      begin
        if chaine<>'' then chaine:=chaine+',';
        chaine:=chaine+'linewidth='+streel(0.1*trait)+'pt';
        epaisseur_courante:=trait
      end;
     parametres_pst:=chaine;
end;
{========================}
procedure t_element.BeginExportPst;
var chaine:string;
begin
     if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
     chaine:=parametres_pst;
     if chaine<>'' then exportwriteln('\psset{'+chaine+'}%');
end;
{=======================}
procedure t_element.DoExportPst;
begin
end;
{=======================}
procedure t_element.EndExportPst;
begin
end;
{=======================}
procedure t_element.enregistrer_pst;
begin
     if (liste_points^.tete=nil) and (cat<>cat_utilisateur) then exit;
     BeginExportpst;
     DoExportPst;
     EndExportPst;
end;
{========================================= teg ================================}
function t_element.parametres_teg:string;
var chaine:string;
begin
     chaine:='';
     if trait<>Linewidth then
         begin LineWidth:=trait; chaine:=chaine+',Width:='+Streel(trait);end;
     if couleur<>linecolor then
         begin linecolor:=couleur; chaine:=chaine+',Color:='+Streel(couleur);end;
     if Stroke_opacity<>strokeOpacity then
         begin Strokeopacity:=Stroke_opacity; chaine:=chaine+',StrokeOpacity:='+Streel(Stroke_opacity);end;
     if ReCalcAuto<>AutoReCalc then
         begin AutoReCalc:=ReCalcAuto; chaine:=chaine+',AutoReCalc:='+Streel(ReCalcAuto);end;
     if visible<>EstVisible then
         begin EstVisible:=visible; chaine:=chaine+',IsVisible:='+Streel(byte(visible)) end;
     if id<>mouseCode then begin mouseCode:=id; chaine:=chaine+',MouseCode:='+Streel(id) end;
     if not CompMatrix(matrix,CurrentMatrix) then
     begin CurrentMatrix:=matrix;
           chaine:=chaine+', SetMatrix(['+Streel(matrix[5])+'+i*('+Streel(matrix[6])+'),'+
                           Streel(matrix[1])+'+i*('+Streel(matrix[2])+'),'+
                           Streel(matrix[3])+'+i*('+Streel(matrix[4])+')])';
     end;
     parametres_teg:=chaine
end;
{========================}
procedure t_element.enregistrer_src4latex;
var chaine:string;
begin
     chaine:=parametres_teg;
     if chaine<>'' then
         begin
              delete(chaine,1,1); //on enlève la première virgule
              exportwriteln('Cmd'+#9+'['+chaine+'];');
         end;
     exportwrite('Graph '+nom+' = ');
end;
{======================================== EPS =================================}
procedure t_element.BeginExportEps;
begin
     if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
     if (cat=cat_utilisateur) then exit;
     if (couleur<>couleur_courante) then
        begin
             exportwriteln(StrColor(couleur,eps));
             couleur_courante:=couleur
        end;
     if (trait<>epaisseur_courante) then
      begin
       case trait of
       2:  exportwriteln('thinlines ');
       8: exportwriteln('thicklines ');
       14: exportwriteln('Thicklines ')
       else exportwriteln(streel(0.1*trait)+' setlinewidth ');
       end;
        epaisseur_courante:=trait
      end;
end;
{=========}
procedure t_element.DoExportEps;
begin
end;
{=========}
procedure t_element.EndExportEps;
begin
end;
{=========}
procedure t_element.enregistrer_eps;
begin
     if (liste_points^.tete=nil) and (cat<>cat_utilisateur) then exit;
     BeginExportEps;
     DoExportEps;
     EndExportEps;
end;
{======================================== Pgf ==================================}
procedure t_element.enregistrer_pgf;
begin
     if (liste_points^.tete=nil) and (cat<>cat_utilisateur) then exit;
     BeginExportPgf;
     DoExportPgf;
     EndExportPgf;
end;
{=========}
procedure t_element.BeginExportPgf;
begin
     if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
     if (cat=cat_utilisateur) then exit;
     if (couleur<>couleur_courante)
     then
        begin
              exportwriteln('\pgfsetstrokecolor'+StrColor(couleur,pgf)+'%');
              couleur_courante:=couleur
        end;
      if (trait<>epaisseur_courante)
      then
         begin
              exportwriteln('\pgfsetlinewidth{'+streel(0.1*trait)+'pt}%');
              epaisseur_courante:=trait
         end;
      if (Stroke_Opacity<>StrokeOpacity_courant)
      then
         begin
              exportwriteln('\pgfsetstrokeopacity{'+streel(Stroke_Opacity)+'}%');
              StrokeOpacity_courant:=Stroke_Opacity
         end;
end;
{=========}
procedure t_element.DoExportPgf;
begin
end;
{=========}
procedure t_element.EndExportPgf;
begin
end;
{========================================= Svg ================================}
procedure t_element.enregistrer_Svg;
begin
     if (liste_points^.tete=nil) and (cat<>cat_utilisateur) then exit;
     BeginExportSvg;
     DoExportSvg;
     EndExportSvg;
end;
{=========}
procedure t_element.BeginExportSvg;
begin
     if inclure_commentaires then exportwriteln('<!--'+nom+' '+type_element[cat]+' -->');
end;
{=========}
procedure t_element.DoExportSvg;
begin
end;
{=========}
procedure t_element.EndExportSvg;
begin
      exportwriteln('</g>');
end;
{======================= destruction ====}
destructor t_element.detruire;
begin
     if liste_points<>nil then dispose(liste_points,detruire);
     if arbre<>nil then
        if DefCommande then dispose(arbre,detruire) else dispose(arbre);
     Kill(Pcellule(donnees));
     noClipList.detruire;
     TNoeud.detruire;
end;

{===============================tSaut====================================}
constructor tSaut.init(const UnNom, UneCommande:string);
begin
     t_element.init(UnNom,UneCommande);
     cat:=cat_saut;
end;
{======================}
procedure tSaut.recalculer;
begin
     t_element.recalculer;
     if transform then transformate;
     Kill(Pcellule(donnees));
     if liste_points^.tete<>nil
        then begin
             donnees:=Paffixe(liste_points^.tete);
             liste_points.init;
             liste_points^.ajouter_debut(new(Paffixe,init(jump^.x,jump^.y)));
             end;
     //ce qui donne jump comme liste de points
end;
{======================}
{$IFDEF GUI}
procedure tSaut.toPath(Var first:boolean; var p: TBGRAPath);
begin
    if donnees=nil then exit;
    p.moveTo(XentierF(donnees^.x),YentierF(donnees^.y));
    first := False
end;
{$ENDIF}
{======================}
procedure tSaut.DoExportSvg;
begin
     if donnees=nil then exit;
     if not FirstInPath then
        exportwrite(' M'+Streel(XSvg(donnees^.x))+','+streel(YSvg(donnees^.y)))
     else exportwrite(Streel(XSvg(donnees^.x))+','+streel(YSvg(donnees^.y)));
end;
{======================}
procedure tSaut.DoExportPgf;
begin
     if donnees=nil then exit;
     exportwriteln('\pgfpathmoveto{\pgfxy('+Streel(Xtex(donnees^.x))+','+streel(Ytex(donnees^.y))+')}%');
end;
{======================}
procedure tSaut.DoExportEps;
begin
     if donnees=nil then exit;
     exportwriteln(Streel((XEps(donnees^.x)))+' '+streel((YEps(donnees^.y)))+' m ');
end;
{======================}
procedure tSaut.DoExportPst;
begin
     if donnees=nil then exit;
     exportwriteln('\moveto('+Streel(Xtex(donnees^.x))+','+streel(Ytex(donnees^.y))+')');
end;
{===============================tClose====================================}
constructor tClose.init(const UnNom, UneCommande:string);
begin
     t_ligne.init(UnNom,UneCommande,0,0);
     cat:=cat_Close;
end;
{======================}
procedure tClose.recalculer;
begin
     t_element.recalculer;
     if transform then transformate;
end;
{======================}
{$IFDEF GUI}
 procedure tClose.toPath(Var first:boolean; var p: TBGRAPath);
begin
    p.closepath;
    first := true
end;
{$ENDIF}
{======================}
procedure tClose.DoExportSvg;
begin
     exportwrite('z');
end;
{======================}
procedure tClose.DoExportPgf;
begin
     exportwriteln('\pgfclosepath%');
end;
{======================}
procedure tClose.DoExportEps;
begin
     exportwriteln('closepath ');
end;
{======================}
procedure tClose.DoExportPst;
begin
     exportwriteln('\closepath%');
end;
{===============================t_dot====================================}
constructor t_dot.init(const UnNom, UneCommande:string);
begin
     enfants:=nil;
     t_element.init(UnNom,UneCommande);
     cat:=cat_dot;
end;
{======================}
procedure t_dot.recalculer;
var res:Paffixe;
    oldliste:Pliste;
    oldcontexte:boolean;
    oldmatrix:Tmatrix;
    F:Pexpression;
    P:Pconstante;
begin
      if enfants<>nil then dispose(enfants,detruire);
      liste_points^.detruire;
      t_element.recalculer;

      lireAttributs;
      oldcontexte:=ContexteUtilisateur;
      ContexteUtilisateur:=true;
      oldmatrix:=Currentmatrix;
      Currentmatrix:=matrix;
      oldliste:=liste_enfant;
      New(liste_enfant,init);
      New(F,init); res:=Nil; P:=new(Pconstante,init('L',Paffixe(liste_points^.tete),true));
      F^.varloc^.ajouter_fin(P);
      if F^.definir('DrawDot($L)')
         then
             begin
                  res:=F^.evalNum;
                  P^.affixe:=Nil;
             end;
      dispose(F,detruire);
      if transform then transformate;
      clipper;
      enfants:=liste_enfant;
      liste_enfant:=oldliste;
      lireAttributs;

      ContexteUtilisateur:=oldcontexte;
      Currentmatrix:=oldmatrix;
      if res<>nil then Kill(Pcellule(res));
end;
{======================}
procedure t_dot.fixeAttributs;
begin
      t_element.fixeAttributs;
      //trait:=4;
      dot_style:=dotstyle;
      dot_angle:=dotangle;
      dot_scaleX:=DotScale^.x;
      if DotScale^.y=0 then dot_scaleY:=dot_scaleX
      else dot_scaleY:=DotScale^.y;
      dot_size1:=Dotsize^.x;
      dot_size2:=Dotsize^.y;
      fill_color:=fillcolor;
end;
{========================}
procedure t_dot.lireAttributs;
begin
     dotstyle:=dot_style;
     dotangle:=dot_angle;
     Kill(Pcellule(Dotscale));
     DotScale:=New(Paffixe,init(dot_scaleX,dot_scaleY));
     Kill(Pcellule(DotSize));
     DotSize:=New(Paffixe,init(dot_size1,dot_size2));
     fillcolor:=fill_color;
     t_element.lireAttributs;
end;
{========================}
{$IFDEF GUI}
procedure t_dot.parametres_scr(var coul:longint);
var feuille : TBGRACanvas;
begin
     t_element.parametres_scr(coul);
     feuille:=MyBitmap.CanvasBGRA;
     feuille.brush.style:= bsSolid;
     feuille.brush.BGRAColor:= convColor(coul);
end;
{========================}
procedure t_dot.dessiner;
var aux:type_liste;
begin
     if enfants=nil then exit;
     aux.tete:=liste_element.tete;
     aux.queue:=liste_element.queue;
     liste_element.tete:=enfants.tete;
     liste_element.queue:=enfants.queue;
     draw_elements;
     liste_element.tete:=aux.tete;
     liste_element.queue:=aux.queue;
end;
{$ENDIF}
{================================= LaTeX ======================================}
procedure t_dot.enregistrer_latex;
begin
       if enfants=nil then exit;
       t_element.enregistrer_latex;
end;
{====================}
procedure t_dot.DoExportLatex;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                aux^.enregistrer_latex;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
{================================== Pstricks ==================================}
function t_dot.parametres_pst;
var chaine:string;
    ok:boolean;
    oldfill:longint;
    z:Paffixe;
begin
     chaine:=t_element.parametres_pst;
     ok:=chaine<>'';
     if (fill_color<>fillcolor_courant) then
     begin
          if ok then chaine:=chaine+',';
                     chaine:=chaine+'fillcolor='+StrColor(fill_color,pstricks);
                     fillcolor_courant:=fill_color;
     end;
     parametres_pst:=chaine;
end;
{=======================}
procedure t_dot.DoExportPst;
var aux:Paffixe;
    x1,y1:real;
    points:word;
    chaine:string;
    ya:byte;
begin
     ya:=0;

     chaine:='\psdots';points:=0;
     if dot_style<>0 then
        begin
             chaine:=chaine+'[dotstyle=' ; ya:=1;
	     case   dot_style of
             1: chaine:=chaine+'o';
             2: chaine:=chaine+'square';
             3: chaine:=chaine+'square*';
             4: chaine:=chaine+'+';
             5: chaine:=chaine+'x';
             6: chaine:=chaine+'asterisk';
             7: chaine:=chaine+'oplus';
             8: chaine:=chaine+'otimes';
             9: chaine:=chaine+'diamond';
             10: chaine:=chaine+'diamond*';
             11: chaine:=chaine+'triangle';
             12: chaine:=chaine+'triangle*';
             13: chaine:=chaine+'pentagon';
             14: chaine:=chaine+'pentagon*';
             end;
        end;
     if (dot_size1<>2) Or (dot_size2<>2) then
        begin
	     if ya=1 then chaine:=chaine+',' else chaine:=chaine+'['; ya:=1;
	     chaine:=chaine+'dotsize='+Streel(dot_size1)+'pt '+Streel(dot_size2);
	end;
     if (dot_scaleX<>1) or (dot_scaleY<>1) then
        begin
	     if ya=1 then chaine:=chaine+',' else chaine:=chaine+'['; ya:=1;
	     chaine:=chaine+'dotscale='+Streel(dot_scaleX);
             if dot_scaleX<>dot_scaleY then chaine:=chaine+' '+Streel(dot_scaleY);
        end;
     if dot_angle<>0 then
          begin
	       if ya=1 then chaine:=chaine+',' else chaine:=chaine+'['; ya:=1;
	       chaine:=chaine+'dotangle='+Streel(dot_angle);
          end;
     if ya=1 then chaine:=chaine+']';
     aux:=Paffixe(liste_points^.tete);
     while aux<>nil do
           begin
     x1:=aux^.X; y1:=aux^.Y;
     if points>=Max_points then begin exportwriteln(FormatString(chaine,colonnes));
                                      chaine:='\psdots';points:=0;
                                end;
     chaine:=chaine+'('+streel(Xtex(x1))+','+streel(Ytex(y1))+')';
     inc(points);aux:=Paffixe(aux^.suivant)
           end;
     exportwriteln(FormatString(chaine,colonnes));
end;

{========================================== EPS ================================}
procedure t_dot.enregistrer_Eps;
begin
        if enfants=nil then exit;
        t_element.enregistrer_Eps;
end;
{=================}
procedure t_dot.DoExportEps;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(eps) else aux^.enregistrer_eps;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
{======================================= Pgf ==================================}
procedure t_dot.enregistrer_Pgf;
begin
        if enfants=nil then exit;
        t_element.BeginExportPgf;
        DoExportPgf
end;
{=================}
procedure t_dot.DoExportPgf;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(pgf) else aux^.enregistrer_pgf;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
{========================================= Svg =================================}
procedure t_dot.enregistrer_Svg;
begin
        if enfants=nil then exit;
        t_element.BeginExportSvg;
        DoExportSvg
end;
{=================}
procedure t_dot.DoExportSvg;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(svg) else aux^.enregistrer_svg;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
{========================================== teg ===============================}
function t_dot.parametres_teg:string;
var chaine:string;
 var res:Paffixe;
begin
     chaine:=t_element.parametres_teg;
     if dot_style<>DotStyle then
         begin DotStyle:=dot_style; chaine:=chaine+',DotStyle:='+Streel(dot_style);end;
     if dot_angle<>DotAngle then
         begin DotAngle:=dot_angle; chaine:=chaine+',DotAngle:='+Streel(dot_angle);end;
     if (dot_scaleX<>DotScale^.x) or  (dot_scaleY<>DotScale^.Y) then
         begin res:=New(Paffixe,init(dot_scaleX,dot_scaleY));
               Kill(Pcellule(DotScale));
               DotScale:=res; chaine:=chaine+',DotScale:='+res^.en_chaine;
         end;
     if (dot_size1<>DotSize^.x) or  (dot_size2<>DotSize^.Y) then
         begin res:=New(Paffixe,init(dot_size1,dot_size2));
               Kill(Pcellule(DotSize));
               DotSize:=res; chaine:=chaine+',DotSize:='+res^.en_chaine;
         end;
     if FillColor<>fill_color then
         begin FillColor:=fill_color; chaine:=chaine+',FillColor:='+Streel(fill_color);end;
     parametres_teg:=chaine
end;
{========================}
procedure t_dot.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     exportwriteln({ 'Graph '+nom+'=}'Point('+FormatString(LigneCommande,70)+');');
end;
{========================}
destructor t_dot.detruire;
begin
     if enfants<>nil then dispose(enfants,detruire);
     t_element.detruire
end;
{======================================= t_label ===============================}
constructor t_label.init(const UnNom,UneCommande,UnTexte:string);
var oldDir: string;
    f: textfile;
begin
     Texte:=UnTexte;
     t_element.init(UnNom,UneCommande);
     Inc(useLabels,1);
{$IFDEF GUI}
     image:=Timage.create(nil);
     if formule then
        begin //c'est une formule
             GetDir(0,oldDir); ChDir(TmpPath);
             AssignFile(f,'formula.tex');
             rewrite(f);
             writeln(f,texte);
             closefile(f);
             SystemExec('"'+InitialPath+PrefScript+'formule'+ExtScript+'"',true,false);
             try
               image.picture.LoadFromFile('formule1'+ExtImg)
             except
               formule:=false
             end;
             chdir(oldDir)
        end;
{$ENDIF}
     cat:=cat_label;
end;
{=======================}
procedure t_label.recalculer;
begin
     t_element.recalculer;
     if transform then transformate;
     if (style_label and 64=64) then {$IFDEF GUI} formule:=false {$ENDIF}//style spécial, pas de formule ni clipping
                                else clipper;
end;
{========================}
procedure t_label.fixeAttributs;
begin
      t_element.fixeAttributs;
      style_label:=labelstyle;
      size_label:=LabelSize;
      angle_label:= LabelAngle;
      ligne_style:=lineStyle;
      Fill_style:=fillstyle;
      fill_color:=fillcolor;
      fill_opacity:=fillOpacity;
{$IFDEF GUI}
      formule:=TeXLabel;
      if formule then ReCalcAuto:=0;
{$ENDIF}
end;
{========================}
procedure t_label.lireAttributs;
begin
     labelstyle:=style_label;
     LabelSize:=size_label;
     LabelAngle:=angle_label;
     LineStyle:=ligne_style;
     FillStyle:=fill_style;
     fillColor:=fill_color;
     fillOpacity:=fill_opacity;
{$IFDEF GUI}
     TeXLabel:=formule;
{$ENDIF}
     t_element.lireAttributs
end;
{========================}
{$IFDEF GUI}
procedure t_label.parametres_scr(var coul:longint);
var fillcoul:longint;
    feuille : TBGRACanvas;
begin
     t_element.parametres_scr(coul);
     feuille:=MyBitmap.CanvasBGRA;
     with feuille do
     begin
         case ligne_style of
        -1:  pen.style:=psClear;
         0:  pen.style:=psSolid;
       1,3:  pen.style:=psDash;
         2:  pen.style:=psDot;
         end;
         pen.width:=1;
         font.Color:=coul;
         font.Height:=CalcLabelSize(size_label);
         fillcoul:=convColor(fill_color, round(255*fill_opacity));
         Brush.BGRAColor:=convColor(fillcoul);
         if framed=1 then
         case fill_style of
                 0: Brush.style:=bsClear;
                 1: Brush.Style:=bsSolid;
                 2: Brush.style:=bsBdiagonal;
                 3: Brush.style:=bsCross;
                 4: Brush.style:=bsDiagcross;
                 5: Brush.style:=bsFdiagonal;
                 6: Brush.style:=bsHorizontal;
                 7: Brush.style:=bsVertical;
         end
         else Brush.style:=bsClear;
     end;
end;
{========================}
procedure t_label.dessiner;
var
    coul,hauteur,largeur,u,v,ureel,vreel,uref,vref:longint;
    theta,ctheta,stheta, oldLabelAngle:real;
    Points:Array of Tpoint;
    feuille:TBGRAcanvas;

    procedure rotate(xs,ys:integer);  //M'=C+exp(i*theta)(M-C)  où C(xreel,yreel) est le point d'affichage voulu
    var x,y:integer;
    begin
         x:=xs-ureel; y:=ys-vreel;
         v:=round(vreel+ctheta*y-stheta*x);
         u:=round(ureel+ctheta*x+stheta*y);
    end;
    
begin
     feuille:=MyBitmap.canvasBGRA;
     if liste_points^.tete=nil then exit;
     if (style_label and 64=64) then exit;//style spécial, pas d'affichage
     ureel:=Xentier(Paffixe(liste_points^.tete)^.X);
     vreel:=Yentier(Paffixe(liste_points^.tete)^.Y);
     framed:= byte((style_label And 16)=16);
     parametres_scr(coul);
     with feuille do
         begin
              if not formule then
                    begin
                            largeur:=TextWidth(Texte) div 2;
                            hauteur:=TextHeight(Texte) div 2;
                    end
                    else
                    begin
                            largeur:=image.picture.width div 2;
                            hauteur:=image.picture.height div 2;
                    end;
              Case (style_label) And 3 of  {horizontal}
                   1: {left}  uref:=ureel+framed*5;
                   0: {centré} uref:=ureel-largeur;
                   2: {right}  uref:=ureel-2*largeur-framed*5;
                   else uref:=ureel-largeur;
              end;
              Case (style_label) And  12 of   {vertical}
                   4: {top}   vref:=vreel+framed*5;
                0,12: {centré, baseline} vref:=vreel-hauteur;
                   8: {bottom} vref:=vreel-2*hauteur-framed*5;
                   else vref:=vreel-hauteur;
              end;
              if angle_label<>0 then
                 begin
                      Font.orientation:=round(10*angle_label);
                      theta:=angle_label*pi/180;
                      ctheta:=cos(theta); stheta:=sin(theta);
                 end;
              if (framed=1) then
                 if (angle_label<>0) then
                    begin
                         SetLength(Points,4);
                         rotate(uref-5,vref-5); Points[0].x:=u; Points[0].y:=v;
                         rotate(uref+2*largeur+5,vref-5); Points[1].x:=u; Points[1].y:=v;
                         rotate(uref+2*largeur+5,vref+2*hauteur+5); Points[2].x:=u; Points[2].y:=v;
                         rotate(uref-5,vref+2*hauteur+5); Points[3].x:=u; Points[3].y:=v;
                         polygon(Points);
                    end
                    else rectangle(uref-5,vref-5,uref+2*largeur+5,vref+2*hauteur+5);
              if angle_label<>0 then rotate(uref,vref) else begin u:=uref;v:=vref end;
              if (not formule)then  begin TextOut(u,v,texte);
                                         if showlabelanchor then
                                         begin
                                              MoveTo(ureel-4,vreel);lineTo(ureel+4,vreel);
                                              MoveTo(ureel,vreel-4);lineTo(ureel,vreel+4);
                                         end;
                                   end
                            else draw(u,v,image.picture.Bitmap);
              if angle_label<>0 then Font.orientation:=0;
         end;
end;
{$ENDIF}
{======================================== LaTeX ===============================}
procedure t_label.DoExportLatex;
var name,style,chaine:string;
    x1,y1:real;
    horizontal:boolean;
begin
     if (style_label And 64)=64
        then begin  //style spécial
                  exportwriteln(Texte);
                  exit
             end;
     //point d'affichage
     x1:=Xtex(Paffixe(liste_points^.tete)^.X);
     y1:=Ytex(Paffixe(liste_points^.tete)^.Y);
     horizontal:=true;
     case (style_label And 3) of
          1: style:='l';
          2: style:='r';
          else begin style:=''; horizontal:=false; end;
     end;
     case (style_label And  12) of
          4: if horizontal then style:=style+',t' else style:='t';
          8: if horizontal then style:=style+',b' else style:='b';
         12: if horizontal then style:=style+',B' else style:='B';
     end;
     if style<>'' then style:='['+style+']';
     //texte à afficher
     name:=Texte;
     if (style_label and 32)=32 then name:='\shortstack{'+name+'}'; //style stacked
     if ((style_label and 16)=16) And (ligne_style>-1)
       then name:='\framebox{'+name+'}'; //style framed
     name:=tailleLabel[size_label]+' '+name;
     //enregistrement
     chaine:='\put('+ streel(x1)+','+streel(y1)+'){';
     if angle_label=0 then exportwriteln(chaine+'\makebox(0,0)'+style+'{'+name+'}}%')
                      else exportwriteln(chaine+'\begin{rotate}{'+streel(angle_label)+'}\makebox(0,0)'+style+'{'+name+'}\end{rotate}}%');
end;
{========================================== Pstricks ===========================}
function t_label.parametres_pst;
var chaine:string;
    ok:boolean;
    oldfill:longint;
    z:Paffixe;
begin
     chaine:=t_element.parametres_pst;
     ok:=chaine<>'';
     if (couleur<>Texte_courant) and not UsePsFrag then
        begin
             exportwriteln('\color'+StrColor(couleur,latex));
             Texte_courant:=couleur;
        end;
     if (style_label And 16)=16 then //style framed
     begin

     if (ligne_style<>style_Courant) then
        begin if ok then chaine:=chaine+',';
              chaine:=chaine+'linestyle='+UnStyle[ligne_style];
              ok:=true;
              style_courant:=ligne_style
        end;
        if (fill_style<>fill_courant) then
        begin if ok then chaine:=chaine+',';
              chaine:=chaine+'fillstyle='+StyleFill[fill_style];
              ok:=true;
              fill_courant:=fill_style
           end;
        if (fill_style<>0)  then
        begin
          if fill_style=1 then   //remplissage solid
          begin
                if (fill_opacity<>opacity_courant)
                        then  begin
                                if ok then chaine:=chaine+',';
                                chaine:=chaine+'opacity='+Streel(fill_opacity);
                                opacity_courant:=fill_opacity;
                                ok:=true
                              end;
                if (fill_color<>fillcolor_courant)
                then begin
                        if ok then chaine:=chaine+',';
                        chaine:=chaine+'fillcolor='+StrColor(fill_color,pstricks);
                        fillcolor_courant:=fill_color;
                     end;
          end
          else
          if (fill_color<>hatchcolor_courant)
                then
                begin
              if ok then chaine:=chaine+',';
                         chaine:=chaine+'hatchcolor='+StrColor(fill_color,pstricks);
              hatchcolor_courant:=fill_color
                end;

           end;

        end;
        parametres_pst:=chaine;
end;
{=======================}
procedure t_label.DoExportPst;
var style,name:string;
    x1,y1:real;
begin
     if (style_label And 64)=64
        then begin  //style spécial
                  exportwriteln(Texte);
                  exit
             end;
     //point d'affichage
     x1:=Xtex(Paffixe(liste_points^.tete)^.X);
     y1:=Ytex(Paffixe(liste_points^.tete)^.Y);
     //type d'affichage
     case (style_label And 3) of
          1: style:='l';
          2: style:='r';
          else style:='';
     end;
     case (style_label And  12) of
          4: style:=style+'t';
          8: style:=style+'b';
          12: style:=style+'B';
     end;
     if style<>'' then style:='['+style+']';
     if angle_label=0 then style:=style+'(' else style:=style+'{'+streel(angle_label)+'}(';
     //texte à afficher
     name:=Texte;
     if (style_label and 32)=32 then name:='\shortstack{'+name+'}'; //style stacked
     if (style_label and 16)=16 then name:='\psframebox{'+name+'}'; //style framed
     name:=tailleLabel[size_label]+' '+name;
     //enregistrement
     exportwriteln('\rput'+style+streel(x1)+','+streel(y1)+'){'+name+'}%');
end;
{===================================== Pgf ====================================}
procedure t_label.DoExportPgf;
var anchor,style,name:string;
    x1,y1:real;
    rotate,ok:boolean;
    styleOK:integer;
begin
     if (style_label And 64)=64
        then begin  //style spécial
                  exportwriteln(Texte);
                  exit
             end;
     //point d'affichage
     x1:=Xtex(Paffixe(liste_points^.tete)^.X);
     y1:=Ytex(Paffixe(liste_points^.tete)^.Y);

     if ((style_label and 16)=16) //framed
        then
   begin
     ok:=false;
     if (couleur<>couleur_courante)
     then
        begin
              exportwriteln('\pgfsetstrokecolor'+StrColor(couleur,pgf)+'%'); ok:=true;
              couleur_courante:=couleur
        end;
      if (trait<>epaisseur_courante)
      then
         begin
              exportwriteln('\pgfsetlinewidth{'+streel(0.1*trait)+'pt}%');ok:=true;
              epaisseur_courante:=trait
         end;
      if (ligne_style<>style_Courant) or (ligne_style=3) then
        begin
             ok:=true;
             case ligne_style of
              0: exportwriteln( '\pgfsetdash{}{0pt}%');
              1: exportwriteln( '\pgfsetdash{{5pt}{3pt}}{0pt}%');
              2,3: exportwriteln( '\pgfsetdash{{0pt}{3pt}}{0pt}%');
               end;
              if ligne_style<>-1 then Style_Courant:=ligne_style
        end;
      //if ok then exportwriteln('');
     //type d'affichage
     rotate:=(angle_label<>0);
     case (style_label And  12) of
          4:  anchor:='north';
          8:  anchor:='south';
          12:  anchor:='base';
           else anchor:='';
     end;
     case (style_label And 3) of
          1: anchor:=anchor+' west';
          2: anchor:=anchor+' east';
     end;
     if anchor='' then anchor:='center';
     if anchor[1]=' ' then system.delete(anchor,1,1);
     //style
     if fill_style=1 then  //remplissage solide
        begin
              if  (fill_opacity<>opacity_courant) then
              begin
                   exportwriteln( '\pgfsetfillopacity{'+Streel(fill_opacity)+'}%');
                   opacity_courant:=fill_opacity
             end;
             if (fill_color<>fillcolor_courant)  then
                        begin
                                exportwriteln('\pgfsetfillcolor'+StrColor(fill_color,pgf)+'%');
                                fillcolor_courant:=fill_color
                        end;
             if ligne_style>-1 then style:='\pgfusepath{fill,stroke}'
                                else style:='\pgfusepath{fill}';
        end
        else //pas de remplisage solide
                if (ligne_style>-1) then style:='\pgfusepath{stroke}' else style:='\pgfusepath{}';

      //texte à afficher
     name:=Texte;
     name:=tailleLabel[size_label]+' '+name;
     if (style_label and 32)=32 then name:='\shortstack{'+name+'}'; //style stacked
     if (couleur<>fillcolor_courant)  then name:='\color'+StrColor(couleur,pgf)+name;
     //enregistrement
     if rotate then exportwriteln('{\pgftransformrotate{'+Streel(angle_label)+'}%');
     exportwrite('\pgfputat{\pgfxy('+ streel(x1)+','+streel(y1)+ ')}{\pgfnode{rectangle}{'+anchor+'}{');
     if (opacity_courant<>1) then  //pour ne pas que les labels soient transparents
        begin
             exportwrite('\pgfsetfillopacity{1}');
        end;
     exportwriteln(name+'}{}{'+style+'}}%');
     if rotate then exportwriteln('}\pgfstroke%') else exportwriteln('\pgfstroke%');
   end //framed
   else
        begin //NoFramed
        styleOK:=1;
     case (style_label And 3) of
          1: style:='left';
          2: style:='right';
          else begin style:=''; dec(styleOK) end;
     end;
     inc(styleOK);
     case (style_label And  12) of
          4: if styleOK=2 then style:=style+',top' else style:='top';
          8: if styleOK=2 then style:=style+',bottom' else style:='bottom';
          12: if styleOK=2 then style:=style+',base' else style:='base';
          else dec(styleOK)
     end;
     if angle_label=0
        then if styleOK>0 then style:='['+style+']{' else style:='{'
        else if styleOK>0 then style:='['+style+',rotate='+streel(angle_label)+']{'
                          else style:='[rotate='+streel(angle_label)+']{';
     //texte à afficher
     name:=Texte;
     if (style_label and 32)=32 then name:='\shortstack{'+name+'}'; //style stacked
     name:=tailleLabel[size_label]+' '+name;
     //enregistrement
     if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
     name:='\color'+StrColor(couleur,pgf)+name;

     exportwrite('\pgfputat{\pgfxy('+ streel(x1)+','+streel(y1)+ ')}{\pgftext'+style);
     if (opacity_courant<>1) then  //pour ne pas que les labels soient transparents
        begin
             exportwrite('\pgfsetfillopacity{1}');
        end;
     exportWriteln(name+'}}\pgfstroke%');
     end; //NoFramed
end;
{======================================= Svg ==================================}
procedure t_label.DoExportSvg;
var ureel, vreel, hauteur,largeur, decalx, decaly, uref,vref: real; //position sur le canevas
    large,haut:longint;
    FormuleName:TFileName;
    fichier:Text;
    oldDir,chaine:string;
    {$IFNDEF GUI}
const formule: boolean=false;
    {$ENDIF}
begin
     if (style_label And 64)=64
        then begin  //style spécial
                  exportwriteln(Texte);
                  exit
             end;

     ureel:=(Paffixe(liste_points^.tete)^.X); // point d'ancrage réel
     vreel:=(Paffixe(liste_points^.tete)^.Y);
    if formule then
     begin
         {$IFDEF GUI}
         Inc(NumFormule);
         FormuleName:=ChangeFileExt(ExportName,'')+Streel(NumFormule)+ExtImg;
         large:=image.picture.width div 2;
         largeur:=Xreel(large)-Xreel(0);
         haut:=image.picture.height div 2;
         hauteur:=Yreel(-haut)-Yreel(0);
         GetDir(0,oldDir); ChDir(TmpPath);
         try
                AssignFile(fichier,'formula.tex');
                rewrite(fichier);
                writeln(fichier,texte);
                close(fichier);
                SystemExec('"'+initialPath+PrefScript+'formule'+ExtScript+'"',true,false);
                {$IFDEF UNIX}
                SystemExec('cp -f formule1.png '+FormuleName,false,false)
                {$ENDIF}
                {$IFDEF MSWINDOWS}
                SystemExec('copy formule1.gif '+FormuleName,false,false)
                {$ENDIF}
         finally
         end;
         chdir(oldDir)
         {$ENDIF}
     end;
     decalx:=0.2/Xscale;//0.2mm autour des formules si cadre
     decaly:=0.2/Yscale;//0.2mm
     if formule then
     begin
        Case (style_label) And 3 of  {horizontal}             //point d'ancrage effectif
                       1: {left}  uref:=ureel+framed*decalx;
                       0: {centré} uref:=ureel-largeur;
                       2: {right}  uref:=ureel-2*largeur-framed*decalx;
                       else uref:=ureel-largeur;
        end;
        Case (style_label) And  12 of   {vertical}
                       4: {top}   vref:=vreel-framed*decaly;
                       0: {centré} vref:=vreel+hauteur;
                       8: {bottom} vref:=vreel+2*hauteur+framed*decaly;
                       else vref:=vreel+hauteur;
        end
     end
     else
     begin
        uref:=ureel; vref:=vreel
     end;
     if (framed=1) and formule then
      begin
        chaine:='<rect x="'+Streel(Xsvg(uref-decalx))+'" y="'+ Streel(Ysvg(vref+decaly))+
        '" width="'+Streel(2*(largeur+decalx)*Xscale)+'cm" height="'+Streel(2*(hauteur+decaly)*Yscale)+'cm" ';
        if fill_style=1 then chaine:=chaine+'fill="'+StrColor(fill_color,svg)+'" '
                        else chaine:=chaine+'fill="none"';
        if ligne_style>-1 then chaine:=chaine+' stroke="'+StrColor(couleur,svg)+'" stroke-width="'+SvgWidth(2)+'"';
        exportwriteln(chaine+'/>');
      end;
     if not formule then
        begin
           exportwriteln('<svg viewBox="0 0 '+Streel(GmargeG+GmargeD+maxX)+' '+Streel(GmargeH+GmargeB+maxY)+'">');
           chaine:='<text font-size="'+ SvgWidth(10*(size_label*2+4))+'px" '+
            'x="'+Streel(Xentier(uref))+'" y="'+Streel(Yentier(vref))+'" ';
           Case (style_label) And 3 of  {horizontal}             //point d'ancrage effectif
                       1: {left}  chaine:=chaine+'text-anchor="start" ';
                       0: {centré} chaine:=chaine+'text-anchor="middle" ';
                       2: {right}  chaine:=chaine+'text-anchor="end" ';
          end;
          Case (style_label) And  12 of   {vertical}
                       4: {top}   chaine:=chaine+'dominant-baseline="text-before-edge"';
                    0,12: {centré} chaine:=chaine+'dominant-baseline="middle"';
                       8: {bottom} ;
          end;
          exportwrite(chaine+' fill="'+StrColor(couleur,svg)+'"');
          if fill_opacity<1 then exportwrite( ' fill-opacity="'+Streel(fill_opacity)+'"');
          if angle_label<>0 then
             exportwrite(' transform="rotate('+Streel(-angle_label)+' '+Streel(Xentier(uref))+' '+Streel(Yentier(vref))+')"');
          exportwriteln('>');
          exportwriteln(Texte);
          exportwriteln('</text>');
          exportwriteln('</svg>')
        end
     else
        exportwriteln('<image x="'+Streel(Xsvg(uref))+'" y="'+Streel(Ysvg(vref))+
          '" width="'+Streel(2*largeur*Xscale)+'" '+
          'height="'+ Streel(2*hauteur*Yscale)+'" '+
          'xlink:href="'+ExtractFileName(FormuleName)+'"/>');
end;
{=================}
procedure t_label.EndExportSvg;
begin
        //if angle_label<>0 then exportwriteln('</g>');
end;
{========================================== EPS ===============================}
procedure t_label.DoExportEps;
var    x1,y1:real;
       name,epsname,style,options:string;
       rot,horizontal:boolean;
begin
     if (style_label And 64)=64
        then begin  //style spécial
                  exportwriteln(Texte);
                  exit
             end;
     // point d'affichage
     x1:=XEps(Paffixe(liste_points^.tete)^.X);
     y1:=YEps(Paffixe(liste_points^.tete)^.Y);
     epsname:=Texte;
     // début de l'enregistrement des paramètres dans le fichier Eps
     if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
     //si on utilise Psfrag, il y a une sortie semblable à la sortie LaTeX dans le fichier Psfrag
     if UsePsfrag then
     begin
      //type d'affichage
     case (style_label And 3) of
          1: style:='l';
          2: style:='r';
          else style:='';
     end;
     case (style_label And  12) of
          4: style:=style+'t';
          8: style:=style+'b';
     end;
        if style<>'' then style:='['+style+']';
        // texte à afficher réellement (name) et texte dans le fichier Eps (epsname)
        name:=Texte; epsname:='L'+IntToStr(LabelPsfrag); //codes L1, L2 ...etc dans le fichier Eps
        if (style_label and 32)=32 then name:='\shortstack{'+name+'}'; //style stacked
        if (style_label and 16)=16 then name:='\psframebox{'+name+'}'; //style framed
        name:=tailleLabel[size_label]+' '+name;
        if (couleur<>0) // on suppose que la couleur initiale dans le document est le noir
             then name:='\color'+StrColor(couleur,pstricks)+name ;  //on indique à Psfrag la couleur du label
        options:=parametres_pst;
        // enregistrement  dans Psfrag
        write(psfrag,'\psfrag{'+epsname+'}{\makebox(0,0)'+style+'{');
        if options<>'' then
        writeln(psfrag,'\psset{'+options+'}');  //on exporte les options
        writeln(psfrag,name+'}}');
        //incrémenter le compteur de labels
        Inc(LabelPsfrag,1);
     end
     else //pas de sortie Psfrag, les labels sont à enregistrer dans le fichier Eps
     begin
          if (couleur<>couleur_courante)
             then  begin
                        exportwrite( StrColor(couleur,eps));
                        couleur_courante:=couleur
                   end;
        if (size_label<> LabelSize_courant)
        then
            begin
                 exportwriteln( '/myfont findfont '+ streel(size_Label*2+4)+' scalefont setfont /h{-'+streel(size_Label*2+4)+' fact mul}def');
                 LabelSize_courant:= size_label;
            end;
     end;
     //Suite de l'enregistrement dans le fichier Eps
     epsname:='('+epsname+')';
     exportwrite( streel(x1)+' '+streel(y1)+' m '); // enregistrement du point courant
     rot:=(angle_label<>0); //rotation?
     if rot then exportwrite(streel(angle_label)+' rotate ');  // rotation s'il y a
     case (style_label And 3) of
          2  : exportwrite( epsname+' Right ');
          1  : exportwrite( epsname+' Left ');
          else exportwrite( epsname+' CenterH ');
     end;
     case (style_label And 12) of
     4: exportwrite('Top ');
     8: exportwrite( 'Bottom ');
     else exportwrite('CenterV ')
     end;
     if rot then exportwriteln(streel(-angle_Label)+' rotate ') else exportwriteln('');
end;
{========================================== teg ===============================}
function t_label.parametres_teg:string;
var chaine:string;
begin
     chaine:=t_element.parametres_teg;
     if style_label<>LabelStyle then
         begin LabelStyle:=style_label; chaine:=chaine+',LabelStyle:='+Streel(style_label);end;
     if size_label<>LabelSize then
         begin LabelSize:=size_label; chaine:=chaine+',LabelSize:='+Streel(size_label);end;
     if angle_label<>LabelAngle then
         begin LabelAngle:=angle_label; chaine:=chaine+',LabelAngle:='+Streel(angle_label);end;
     if ligne_style<>LineStyle then
         begin LineStyle:=ligne_style; chaine:=chaine+',LineStyle:='+Streel(ligne_style);end;
      if FillStyle<>fill_style then
         begin FillStyle:=fill_style; chaine:=chaine+',FillStyle:='+Streel(fill_style);end;
      if FillColor<>fill_color then
         begin FillColor:=fill_color; chaine:=chaine+',FillColor:='+Streel(fill_color);end;
      if FillOpacity<>fill_opacity then
         begin FillOpacity:=fill_opacity; chaine:=chaine+',FillOpacity:='+Streel(fill_opacity);end;
{$IFDEF GUI}
      if TeXLabel<>formule then
         begin TeXLabel:=formule; chaine:=chaine+',TeXLabel:='+Streel(byte(formule));end;
{$ENDIF}
     parametres_teg:=chaine
end;
{========================}
procedure T_Label.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     //exportwriteln({ 'Graph '+nom+'=}#9+'Label('+FormatString(LigneCommande,70)+',"'+Texte+'"),');
     exportwriteln({ 'Graph '+nom+'=}'Label('+FormatString(LigneCommande,70)+',"'+Texte+'");');
end;
{========================}
destructor T_Label.detruire;
begin
{$IFDEF GUI}
      image.free;
{$ENDIF}
      T_Element.detruire;
      Dec(useLabels,1);
end;
{================================ T_ligne =====================================}
constructor T_ligne.init(const UnNom, UneCommande:string;Closed:byte;Unrayon:real);
begin
     fermee:=closed;onlyData:=false;
     rayon:=Unrayon;
     noClipList.init; pattern:=Nil;
     PtsFleches:=new(Pliste,init);
     t_element.init(UnNom,UneCommande);
     cat:=cat_polygone;
end;
{============}
procedure t_ligne.fixeAttributs;
begin
      T_element.fixeAttributs;
      ligne_style:=lineStyle;
      fleche:=Arrows;
      nb_points:=NbPoints;
      Fill_style:=fillstyle;
      fill_color:=fillcolor;
      fill_opacity:=FillOpacity;
      grad_style:=gradstyle;
      grad_angle:=gradAngle;
      grad_colorA:=gradcolorA;
      grad_colorB:=gradcolorB;
      grad_centerX:=gradCenterX;
      grad_centerY:=gradCenterY;
      evenoddfill:=EOfill;
      linejoin_style:=linejoin;
      linecap_style:=linecap;
      miterlimit_style:=miterlimit;
      if ligne_Style=2{dotted} then linecap_style:=1;//round
      if ligne_Style=1{dashed} then linecap_style:=0;//butt
      Kill(PCellule(pattern));
      pattern:= currentPattern^.evalNum;
end;
{========================}
procedure t_ligne.lireAttributs;
begin
     LineStyle:=ligne_style;
     Arrows:=fleche;
     NbPoints:=nb_points;
     FillStyle:=fill_style;
     fillColor:=fill_color;
     GradStyle:=grad_style;
     GradAngle:=grad_angle;
     GradCenterX:=grad_centerX;
     GradCenterY:=grad_centerY;
     GradColorA:=grad_colorA;
     GradColorB:=grad_colorB;
     FillOpacity:=fill_opacity;
     EOfill:=evenoddfill;
     linejoin:=linejoin_style;
     linecap:=linecap_style;
     miterlimit:=miterlimit_style;
     Kill(Pcellule(currentPattern));
     if pattern=Nil then currentPattern:=defaultPattern^.evalNum
         else currentPattern:=pattern^.evalNum;
     t_element.lireAttributs
end;
{========================}
procedure T_ligne.recalculer;
var liste,UneListe,T,debut,fin:Paffixe;
    res:type_liste;
    FXY:Pexpression;
    varloc:Pconstante;
    //chaine:string;
    coul:real;
    AJump:boolean;
begin
     liste_points^.detruire;
     Kill(Pcellule(donnees));
     liste_points^.init;
     t_element.recalculer;
     if transform then transformate;

     liste:=Paffixe(liste_points^.tete);
     liste_points^.init;
     if liste=nil then exit;
     if rayon>0 then
     begin
        donnees:=liste^.evalNum;
        new(FXY,init);
        varloc:=new(Pconstante,init('L',UneListe,true));
        FXY^.varloc^.ajouter_fin(varloc);
        FXY^.varloc^.ajouter_fin(new(Pconstante,init('r',new(Paffixe,init(rayon,0)),true)));
        FXY^.varloc^.ajouter_fin(new(Pconstante,init('closed',new(Paffixe,init(fermee,0)),true)));
        FXY^.definir('if (Nops($L)>1) And ($r>0) then'+
'   $b:=L[1], $c:=L[2], Del(L,1,2),'+
'   if closed then Insert(L,[b,c]) else b fi,'+
'   b:=RealCoord(b), c:=RealCoord(c),'+
'   for $z in L do'+
'       $a:=b, b:=c, c:=RealCoord(z),'+
'       if (Re(a)=Re(jump)) Or (Re(c)=Re(jump)) then ScrCoord(b)'+
'       elif Re(b)=Re(jump) then jump'+
'       else'+
'            $alpha:=Arg((c-b)/(a-b))/2,'+
'            $sinalpha:=abs(sin(alpha)),'+
'            if (sinalpha=Nil) then ScrCoord(b)'+
'            elif (sinalpha<1) And (sinalpha>0)'+
'               then'+
'                   $u:=(c-b)/abs(c-b),'+
'                   $v:=(a-b)/abs(a-b),'+
'                   $O:=b+(u+v)/abs(u+v)*r/sinalpha,'+
'                   $O1:=b+v*r*cos(alpha)/sinalpha,'+
'                   $O2:=b+u*r*cos(alpha)/sinalpha,'+
'                   $U:=O1-O,'+
'                   $tf:=Arg((O2-O)/(O1-O)),'+
'                   $n:=Ent(abs(tf*NbPoints/(2*pi))),'+
'                   $pas:=tf/n, $t:=0,'+
'                    for $k1 from 0 to n do'+
'                        ScrCoord(O+U*exp(i*t)),'+
'                        Inc(t,pas)'+
'                    od'+
'            else ScrCoord(b)'+
'            fi'+
'       fi'+
'    od,'+
'    if closed=0 then ScrCoord(c) fi '+
'else L fi')
     end;
     debut:=liste;
     while debut<>nil do
     begin
        res.init;
        fin:=Paffixe(debut);
        while (fin<>nil) and (not IsJump(fin)) do fin:=Paffixe(fin^.suivant);
        if fin<>nil then begin Ajump:= true; coul:=fin^.y end else Ajump:=false; {coul:=jump^.y};
        if fin<>nil then if fin^.precedent<>nil then fin^.precedent^.suivant:=nil else liste:=nil;
        res.ajouter_fin(liste);
        liste:=fin;
        while (fin<>nil) and (IsJump(fin)) do
              begin
                   liste:=Paffixe(fin^.suivant);
                   dispose(fin,detruire);
                   fin:=liste;
              end;
        debut:=fin;
        UneListe:=Paffixe(res.tete);
        if UneListe<>nil then
        begin  {***}
               if (rayon=0) then
                  begin
                       liste_points^.ajouter_fin(UneListe);
                       if (fermee=1) then Liste_points^.ajouter_fin(new(Paffixe,init(UneListe^.x,UneListe^.y)));
                  end else
                  begin {**}
                        varloc^.affixe:=UneListe;
                        T:=FXY^.evalNum;
                        if T<>nil then
                           begin
                             liste_points^.ajouter_fin(T);
                             if fermee=1 then liste_points^.ajouter_fin(new(Paffixe,init(T^.x,T^.y)));
                           end;
                        Kill(Pcellule(varloc^.affixe));
                  end; {**}
        end;{***}
        if Ajump {debut<>nil} then
        begin
             liste_points^.ajouter_fin(new(Paffixe,init(jump^.x,coul)));
        end;
     end;
     if rayon>0 then dispose(FXY,detruire);
     clipper;
     if fleche>0 then calcul_fleches;
     Kill(Pcellule(liste));
end;
{============}
procedure t_ligne.calcul_fleches;
var xu,yu,xn,yn,xI,yI,n,x1,y1,x2,y2,x3,y3,x4,y4,large,long:real;
    aux,debut,fin:Paffixe;
    i:byte;
    compt:word;
begin
     if PtsFleches^.tete<>nil then PtsFleches^.detruire;
     if (liste_points^.tete=nil) or  (liste_points^.tete^.suivant=nil) then exit;
     large:=1/15;//0.5/7.5;
     long:=sqrt(3)/15;//sqrt(0.75)/7.5;
     debut:=Paffixe(liste_points^.tete);
     while debut<>nil do
      begin
       fin:=debut;compt:=1;
       while (Paffixe(fin^.suivant)<>nil) and (Not IsJump(Paffixe(fin^.suivant))) do
             begin inc(compt); fin:=Paffixe(fin^.suivant); end;
       if compt>1 then
       for i:=1 to fleche do
       begin
          if i=1 then
             begin
                  aux:=Paffixe(fin);
                  x2:=aux^.X;y2:=aux^.Y;aux:=Paffixe(aux^.precedent);
                  x1:=aux^.X; y1:=aux^.Y;
             end else begin
                 aux:=Paffixe(debut);
                 x2:=aux^.X;y2:=aux^.Y;aux:=Paffixe(aux^.suivant);
                 x1:=aux^.X;y1:=aux^.Y;
                      end;
     n:=sqrt(sqr(Xscale*(x2-x1))+sqr(Yscale*(y2-y1)));
     if n=0 then exit;
     xu:=(x2-x1)/n;yu:=(y2-y1)/n;
     xn:=-yu*Yscale/Xscale;yn:=xu*Xscale/Yscale;
     xI:=x2-long*xu;yI:=y2-long*yu;
     x3:=xI+large*xn;y3:=yI+large*yn;
     x4:=xI-large*xn;y4:=yI-large*yn;
     PtsFleches^.ajouter_fin(Pcellule(new(Paffixe,init(x3,y3))));
     PtsFleches^.ajouter_fin(Pcellule(new(Paffixe,init(x2,y2))));
     PtsFleches^.ajouter_fin(Pcellule(new(Paffixe,init(x4,y4))));
     PtsFleches^.ajouter_fin(Pcellule(new(Paffixe,init(x1,y1))));
       end ;
       debut:=Paffixe(fin^.suivant);
       if IsJump(debut) then debut:=Paffixe(debut^.suivant);
     end;
end;
{=======================}
function t_ligne.IsIn(point:Paffixe;i:integer):boolean;
    begin
         case i of
         1: IsIn:= (point^.x>=X_min);
         2: IsIn:=(point^.y>=Y_min);
         4: IsIn:=(point^.y<=Y_max);
         3: IsIn:=(point^.x<=X_max);
         else IsIn:=false;
         end;
    end;
{==============}
function t_ligne.intersec(A,B:Paffixe;i:integer):Paffixe;
var res:Paffixe;
begin
         case i of
         1: begin new(res,init(X_min,0));
                  CalcError:=false;
                  res^.y:=
                  ajouter(B^.y,multiplier(soustraire(A^.y,B^.y),diviser(soustraire(X_min,B^.x),soustraire(A^.x,B^.x))));
            end;
         3: begin new(res,init(X_max,0));
                  CalcError:=false;
                  res^.y:=
                  ajouter(B^.y,multiplier(soustraire(A^.y,B^.y),diviser(soustraire(X_max,B^.x),soustraire(A^.x,B^.x))));
            end;
         2: begin new(res,init(0,Y_min));
                  CalcError:=false;
                  res^.x:=
                  ajouter(B^.x,multiplier(soustraire(A^.x,B^.x),diviser(soustraire(Y_min,B^.y),soustraire(A^.y,B^.y))));
            end;
         4: begin new(res,init(0,Y_max));
                  CalcError:=false;
                  res^.x:=
                  ajouter(B^.x,multiplier(soustraire(A^.x,B^.x),diviser(soustraire(Y_max,B^.y),soustraire(A^.y,B^.y))));
            end;
         end;
         if CalcError then Kill(Pcellule(res));
         intersec:=res;

    end;
{================}
procedure T_ligne.clip;
var liste,aux,aux1,aux2:Paffixe;
    compt:integer;
    coul:real;
    AJump:boolean;

    procedure clipConnexe(De:Paffixe);
    var aux,T,lastOut,lastIn:Paffixe;
        listeAux:type_liste;
        i:integer;

    begin
         listeAux.init;
         listeAux.ajouter_fin(De);
         for i:=1 to 4 do
         begin
              lastOut:=nil;
              lastIn:=Nil;
              aux:=Paffixe(ListeAux.tete);
              while aux<>nil do
                    begin
                         if IsIn(aux,i)
                            then begin
                                 if lastOut<>nil then
                                          begin
                                          T:=intersec(lastOut,aux,i);
                                          if T<>nil then listeAux.inserer(T,Pcellule(aux));
                                          listeAux.supprimer(Pcellule(lastOut));
                                          clippee:=true;
                                          lastOut:=nil;
                                          end;
                                 lastIn:=aux;
                                 end
                            else begin
                                 if lastIn=nil
                                    then begin clippee:=true;listeAux.supprimer(Pcellule(lastOut)) end
                                    else begin
                                          T:=intersec(lastIn,aux,i);
                                          lastIn:=nil;
                                          if T<>nil then listeAux.inserer(T,Pcellule(aux));
                                          clippee:=true;
                                         end;
                                 lastOut:=aux;
                                 end;
                           aux:=Paffixe(aux^.suivant)
                    end;
              if lastOut<>nil then begin clippee:=true;listeAux.supprimer(Pcellule(lastOut)); end;
              if (fermee=1) and (listeAux.tete<>nil) then
         listeAux.ajouter_fin(new(Paffixe,init(Paffixe(listeAux.tete)^.x,Paffixe(listeAux.tete)^.y)));
         end;

         if listeAux.tete=nil then exit;

         liste_points^.ajouter_fin(Paffixe(listeAux.tete));
    end;

begin
     liste:=Paffixe(liste_points^.tete);
     if liste=nil then exit;
     aux2:=liste^.evalNum;
     liste_points^.init;
     aux:=liste;
     while aux<>nil do
          begin
               compt:=1; AJump:=false;
               aux1:=Paffixe(aux^.suivant);
               while (aux1<>nil) and (not IsJump(aux1)) do begin inc(compt);aux1:=Paffixe(aux1^.suivant) end;
               if aux1<>nil then begin Ajump:=true;
                                       coul:=aux1^.y
                                  end else coul:=jump^.y;
               if compt>1 then begin
                               if aux1<>nil then aux1^.precedent^.suivant:=nil;
                               ClipConnexe(aux);
                               end else dispose(aux,detruire);
               while (aux1<>nil) and (IsJump(aux1)) do begin liste:=Paffixe(aux1^.suivant);
                                                             dispose(aux1,detruire);
                                                             aux1:=liste;
                                                       end;
               aux:=aux1;
                {if (aux<>nil) and (not IsJump(Paffixe(liste_points^.queue)))
                  then}
                if AJump then
                   begin
                       liste_points^.ajouter_fin(new(Paffixe,init(jump^.x,coul)));
                   end;
          end;
     if clippee then noClipList.ajouter_fin(aux2) else Kill(Pcellule(aux2));
end;
{==========================}
procedure t_ligne.clipper; //lance le clipping écran
begin
        clippee:=false;
        t_element.clipper;
end;
{==========================}
{$IFDEF GUI}
procedure t_ligne.parametres_scr(var coul:longint);
var z:Paffixe;
    T:array of single;
    compt,k:longint;
    feuille : TBGRAcanvas;
begin
     t_element.parametres_scr(coul);
     feuille:=MyBitmap.CanvasBGRA;
     with feuille do
     begin
     {$IFDEF Windows}
      if (ligne_style<>0) then pen.width:=1;
     {$ENDIF}
     case ligne_style of
    -1:  pen.style:=psClear;
     0:  pen.style:=psSolid;
     1:  pen.style:=psDash;
     2:  pen.style:=psDot;
     3:  begin
              z:=pattern;
              if (z=Nil) or (z^.suivant=Nil) then pen.style:=psDash
              else
                  begin
                       pen.style:=psPattern;
                       compt:=0;
                       while z<>Nil do begin Inc(compt,1); z:=Paffixe(z^.suivant) end;
                       Setlength(T,compt);
                       z:=pattern; compt:=0;
                       while z<>nil do
                             begin
                                 T[compt]:=abs(z^.x)*96/72.27/2; //quelle est l'unité réelle ? dépend de width ?
                                 Inc(compt,1); z:=Paffixe(z^.suivant)
                             end;
                       Pen.CustomStyle := T;
                  end;
         end;
     end;
     case lineCap_style of
     0:  pen.EndCap:=pecFlat;
     1:  pen.EndCap:=pecRound;
     2:  pen.EndCap:=pecSquare;
     end;
     case linejoin_style of
     0:  pen.JoinStyle:=pjsMiter;
     1:  pen.JoinStyle:=pjsRound;
     2:  pen.JoinStyle:=pjsBevel;
     end;
     case fill_style of
             1: Brush.Style:=bsSolid;
             2: Brush.style:=bsBdiagonal;
             3: Brush.style:=bsCross;
             4: Brush.style:=bsDiagcross;
             5: Brush.style:=bsFdiagonal;
             6: Brush.style:=bsHorizontal;
             7: Brush.style:=bsVertical;
             0: Brush.style:=bsClear;
     end
     end;
end;
{============================}
 procedure t_ligne.toPath(Var first:boolean; var p: TBGRAPath); //une seule composante connexe uniquement (appelée par l'instruction Path)
var
   aux, aux1: Paffixe;
begin
     aux:=Nil;//Paffixe(noClipList.tete);
     if aux=Nil then aux:=Paffixe(liste_points^.tete);
     if aux=Nil then exit;
     while (aux<>Nil) do
     begin
         if first then p.moveTo(XentierF(aux^.x),YentierF(aux^.y));
         aux1:=Paffixe(aux^.suivant);
         while (aux1<>nil) and (not IsJump(aux1)) do
               begin
                    aux:=Paffixe(aux1^.suivant);
                    if ((aux=Nil) or Isjump(aux)) and (fermee=1) then
                       p.closepath()
                    else p.lineTo(XentierF(aux1^.x),YentierF(aux1^.y));
                    aux1:=aux

               end;
         while (aux1<>nil) and (IsJump(aux1)) do begin aux1:=Paffixe(aux1^.suivant) end;
         first:=true;
         aux:=aux1
     end;
     first := False
end;
{============}
 procedure T_ligne.dessiner; //une ligne peut être constituée de plusieurs composantes connexes
                             //ayant une couleur de fond différente, mais les attributs de trait sont communs.
 var aux,aux1:Paffixe;
     fillcoul, rcolor, gcolor,bcolor,oldfill_style:longint;
     Points:array of TPointF;
     i,compt,k:longint;
     p: TBGRAPath;
     f2:TBGRAcanvas2D; //grad: IBGRACanvasGradient2D;
     z:Paffixe;  // pattern du trait
     T:array of single; // style du trait
     style:tbrushstyle;   // pour hachures
     b: TBGRACustomBitmap; //pour hachures
     first: boolean;
 begin
      if (fill_style=8) or (fill_style=0) then //gradient ou pas de remplissage,
         begin
         first:=true; p:=TBGRAPath.create(); toPath(first,p);
         Canvas2DDrawPath(self,p);
         exit
         end;
     aux:=Nil; //Paffixe(noClipList.tete);
     if aux=Nil then aux:=Paffixe(liste_points^.tete);
     if aux=nil then exit;
     if (ligne_style=-1) and (fill_style=0) then exit;
     fillcoul:=fill_color;
     rcolor:=GetRvalue(fillcoul);
     gcolor:=GetGvalue(fillcoul);
     bcolor:=GetBvalue(fillcoul);
     //parametres à définir
     f2:=MyBitmap.canvas2D;
     if fill_style>1 then  //hachures
     begin
          case fill_style of
             2: style:=bsBdiagonal;
             3: style:=bsCross;
             4: style:=bsDiagcross;
             5: style:=bsFdiagonal;
             6: style:=bsHorizontal;
             7: style:=bsVertical;
          end;
          b := MyBitmap.CreateBrushTexture(style, fill_color, BGRAPixelTransparent);//remplissage avec le motif de la brosse
     end;
     if clippee then
         begin
              f2.save;
              f2.beginpath;
              f2.Rect(XentierF(X_min),YentierF(Y_max),XentierF(X_max)-XentierF(X_min),YentierF(Y_min)-YentierF(Y_max));
              f2.clip;
         end;
      case ligne_style of
      -1:f2.lineStyle(psClear);
      0: f2.lineStyle(psSolid);
      1: f2.lineStyle(psDash);
      2: f2.lineStyle(psDot);
      3: begin //line pattern (userdash)
               z:=pattern;
               if (z=Nil) or (z^.suivant=Nil) then f2.lineStyle(psDash)
               else
                    begin
                         compt:=0;
                         while z<>Nil do begin Inc(compt,1); z:=Paffixe(z^.suivant) end;
                         Setlength(T,2*compt); k:=compt;
                         z:=pattern; compt:=0;
                         while z<>nil do
                               begin
                                   T[compt]:=abs(z^.x)*AspectRatio/72.27; //quelle est l'unité réelle ? dépend de width ?
                                   T[compt+k]:=T[compt];
                                   Inc(compt,1); z:=Paffixe(z^.suivant)
                               end;
                         f2.lineStyle(T);
                         finalize(T)
                    end;
          end;
      end;//end case ligne_style
      if ligne_style<>-1 then
       begin
            f2.linewidth:=PenWidth;
            f2.strokestyle(convColor(couleur,round(255*stroke_opacity)));
            case lineCap_style of
             0:  f2.linecap:='butt';
             1:  f2.linecap:='round';
             2:  f2.linecap:='square';
           end;
           case linejoin_style of
             0:  f2.lineJoin:='miter';
             1:  f2.lineJoin:='round';
             2:  f2.lineJoin:='bevel';
           end;
           f2.miterlimit:= miterlimit_style;
       end;
      if (fill_style>=1) then //remplissage
            if evenoddfill then begin f2.fillmode:=fmAlternate end else f2.fillmode:=fmWinding;
      //fin parametres
      while aux<>nil do
           begin
                compt:=1;
                aux1:=Paffixe(aux^.suivant);
                while (aux1<>nil) and (not IsJump(aux1)) do
                      begin
                           inc(compt);aux1:=Paffixe(aux1^.suivant);
                      end;
                if (fill_Style=1) and (aux1<>nil) and (aux1^.y<>jump^.y) then
                   begin
                        fill_color:=convColor(getFillColor(rcolor,gcolor,bcolor,aux1^.y),round(255*fill_opacity));
                   end;
                 while (aux1<>nil) and (IsJump(aux1)) do begin aux1:=Paffixe(aux1^.suivant) end;
                 if fermee=1 then dec(compt); //le dernier point est identique au premier
                 if compt>1 then
                 try
                    SetLength(points,compt);
                    p:=TBGRAPath.create();
                    for i:=0 to compt-1 do
                    begin
                          //p:=TBGRAPath.create();
                          Points[i].x:=XentierF(aux^.x);
                          Points[i].y:=YentierF(aux^.y);
                          aux:=Paffixe(aux^.suivant);
                    end;
                    p.polylineTo(Points);
                    if fermee=1 then p.closepath;
                    f2.path(p);
                    if fill_style>1 then  //remplissage hachures
                    begin
                       f2.fillstyle(b);
                       f2.fill;
                    end
                    else
                    if (fill_style=1) then  //remplissage plein
                    begin
                         f2.FillStyle(convColor(fill_color,round(255*fill_opacity)));
                         f2.fill;
                    end;
                    if ligne_style<>-1 then// contour
                    begin
                         f2.path(p);
                         f2.stroke
                    end;
                 finally
                  finalize(points);
                 end;
                 aux:=aux1;
           end;
      if fill_style>1 then b.free;
      fill_color:=fillcoul;
      if fleche>0 then dessiner_fleches;
      if clippee then f2.restore;
 end;
 {============}
procedure t_ligne.dessiner_fleches;
var aux:Paffixe;
    Points:array of TPointF;
    feuille:TBGRAcanvas;
    coul:longint;
begin
     feuille:=MyBitmap.CanvasBGRA;
     parametres_scr(coul);
     if (fleche>0) and (PtsFleches^.tete<>nil)
     then  with feuille do
     begin    aux:=Paffixe(PtsFleches^.tete);
              SetLength(points,3);
              pen.EndCap:=pecFlat; pen.JoinStyle:=pjsMiter;
              while aux<>nil do
                    begin
              Points[0].x:=XentierF(aux^.x);Points[0].y:=YentierF(aux^.y);
              aux:=Paffixe(aux^.suivant);
              Points[1].x:=XentierF(aux^.x); Points[1].y:=YentierF(aux^.y);
              aux:=Paffixe(aux^.suivant);
              Points[2].x:=XentierF(aux^.x);Points[2].y:=YentierF(aux^.y);
              aux:=Paffixe(aux^.suivant);aux:=Paffixe(aux^.suivant);
              polyLineF(Points);
                    end;
              finalize(points);
              case lineCap_style of
              0:  pen.EndCap:=pecFlat;
              1:  pen.EndCap:=pecRound;
              2:  pen.EndCap:=pecSquare;
              end;
              case linejoin_style of
              0:  pen.JoinStyle:=pjsMiter;
              1:  pen.JoinStyle:=pjsRound;
              2:  pen.JoinStyle:=pjsBevel;
              end;
      end;
end;
{$ENDIF}
{=====================================}
function t_ligne.clipSeg(A,B:Paffixe):Paffixe;
var aux,T,lastOut,lastIn:Paffixe;
        listeAux:type_liste;
        i:integer;
begin
         listeAux.init;
         listeAux.ajouter_fin(new(Paffixe,init(A^.x,A^.y)));
         listeAux.ajouter_fin(new(Paffixe,init(B^.x,B^.y)));
         for i:=1 to 4 do
         begin
              lastOut:=nil;
              lastIn:=Nil;
              aux:=Paffixe(ListeAux.tete);
              while aux<>nil do
                    begin
                         if IsIn(aux,i)
                            then begin
                                 if lastOut<>nil then
                                          begin
                                          T:=intersec(lastOut,aux,i);
                                          if T<>nil then listeAux.inserer(T,Pcellule(aux));
                                          listeAux.supprimer(Pcellule(lastOut));
                                          lastOut:=nil;
                                          end;
                                 lastIn:=aux;
                                 end
                            else begin
                                 if lastIn=nil
                                    then listeAux.supprimer(Pcellule(lastOut))
                                    else begin
                                          T:=intersec(lastIn,aux,i);
                                          lastIn:=nil;
                                          if T<>nil then listeAux.inserer(T,Pcellule(aux));
                                         end;
                                 lastOut:=aux;
                                 end;
                            aux:=Paffixe(aux^.suivant)
                    end;
              if lastOut<>nil then listeAux.supprimer(Pcellule(lastOut));
         end;

      clipSeg:=Paffixe(listeAux.tete);
end;
{=============}
procedure T_ligne.fillLatex(style:byte; mode:byte);
var aux,aux1,Ak,Bk,save:Paffixe;
    compt,NbP:word;
    Xu,Yu,Xv,Yv,delta:real;
    LesPoints,LesReels:type_liste;
    j,maxj:integer;ok,oldclipping,wasclippee:boolean;

    function test(M:Paffixe):real;
    var V1,V2:Paffixe;
    begin
         V1:=soustraireC(M,Ak);
         V2:=New(Paffixe,init(Xu,Yu));
         CalcError:=false;
         test:=ajouter(multiplier(V1^.x*Xscale,V2^.x*Xscale),multiplier(V1^.y*Yscale,V2^.y*Yscale));
         Kill(Pcellule(V1));Kill(Pcellule(V2))
    end;

    function Lintersec(A,B:Paffixe):real;
    var V1,V2,V3:Paffixe;
    begin
         V1:=soustraireC(Bk,B);
         V2:=soustraireC(Bk,Ak);
         V3:=soustraireC(B,A);
         CalcError:=false;
         Lintersec:=diviser(det(V1,V3),det(V2,V3));
         Kill(Pcellule(V1));Kill(Pcellule(V2));Kill(Pcellule(V3));
    end;

    procedure ranger(x:real);
    var aux:Paffixe;
    begin
         aux:=Paffixe(LesReels.tete);
         while (aux<>nil) and (aux^.x<=x) do aux:=Paffixe(aux^.suivant);
         if aux=nil then LesReels.ajouter_fin(new(Paffixe,init(x,0)))
                    else LesReels.inserer(new(Paffixe,init(x,0)),aux)
    end;

    procedure fillConnexe(debut,fin:Paffixe);
    var A,B,C,D,debaux:Paffixe;
        k:word;
        positif:boolean;
        LeTest,Xa,Ya:real;
        
        procedure calc;
        begin
             LeTest:=test(B);
             if ((LeTest<0) and positif) or ((LeTest>0) and (not positif)) then
                begin
                     positif:=not positif;
                     ranger(Lintersec(A,B));
                     inc(compt);
                end;
        end;

    begin
         LesPoints.init;
         LesReels.init;
         case style of
         2: begin Ak^.x:=Xmin;Ak^.y:=Ymax end;
         5: begin Ak^.x:=Xmin;Ak^.y:=Ymin end;
         6: begin Ak^.x:=Xmin;Ak^.y:=Ymax end;
         7: begin Ak^.x:=Xmin;Ak^.y:=Ymax end;
         end;
         debaux:=debut;
         for k:=1 to NbP do
             begin
                  Ak^.x:=Ak^.x+Xu;Ak^.y:=Ak^.y+Yu;
                  Bk^.x:=Ak^.x+Xv;Bk^.y:=Ak^.y+Yv;
                  debut:=debaux;
                  A:=debut;
                  positif:= test(A)>0; B:=Paffixe(A^.suivant);
                  compt:=0;
                  while B<>fin do
                             if IsJump(B) then
                                begin
                                     if fermee=0 then
                                        begin
                                             C:=B; B:=debut;
                                             calc; B:=C
                                        end;
                                     while (B<>nil) and Isjump(B) do B:=Paffixe(B^.suivant);
                                     if B<>nil then
                                        begin A:=B; debut:=A; positif:= test(A)>0;
                                              B:=Paffixe(B^.suivant);
                                        end
                                        else A:=Nil;
                                end
                             else begin
                                       calc;
                                       A:=B;
                                       B:=Paffixe(B^.suivant);
                                  end;
                  if (fermee=0) and (A<>nil) then
                     begin
                          B:=debut;
                          calc;
                     end;
                  if not odd(compt) then
                     begin
                  A:=Paffixe(LesReels.tete);
                  while A<>nil do
                  begin
                       Xa:=-A^.x*Xv+Bk^.x;Ya:=-A^.x*Yv+Bk^.y;
                       LesPoints.ajouter_fin(new(Paffixe,init(Xa,Ya)));
                       A:=Paffixe(A^.suivant);
                  end;
                     end;
                 LesReels.detruire;
             end;
         A:=Paffixe(LesPoints.tete);
         if A=nil then exit;
         B:=Paffixe(A^.suivant);
         j:=0;
         if mode=svg then maxj:=2 else maxj:=3;
         while B<>nil do
               begin
                    inc(j);
                    C:=ClipSeg(A,B);
                    if (C<>nil) and (C^.suivant<>nil) then
                   begin
                    D:=Paffixe(C^.suivant);
                    case mode of
                    eps: exportwrite(Streel(Xeps(C^.X))+' '+Streel(Yeps(C^.Y))+' m '+
                                      Streel(Xeps(D^.X))+' '+Streel(Yeps(D^.Y))+' l s ');
                    LaTex: exportwrite('\path('+Streel(Xtex(C^.X))+','+Streel(Ytex(C^.Y))+')('+
                                      Streel(Xtex(D^.X))+','+Streel(Ytex(D^.Y))+')');
                    pgf: exportwrite('\pgfxyline('+Streel(Xtex(C^.X))+','+Streel(Ytex(C^.Y))+')('+
                                     Streel(Xtex(D^.X))+','+Streel(Ytex(D^.Y))+')');
                    pstricks: exportwrite('\psline('+Streel(Xtex(C^.X))+','+Streel(Ytex(C^.Y))+')('+
                                     Streel(Xtex(D^.X))+','+Streel(Ytex(D^.Y))+')');
                    svg: exportwrite( '<line x1="'+ Streel(Xsvg(C^.X))+'" y1="'+Streel(Ysvg(C^.Y))+'" x2="'
                        +Streel(Xsvg(D^.X))+'" y2="'+Streel(Ysvg(D^.Y))+'"/>');
                    end;
                    kill(Pcellule(C));
                  end;
                    if j=maxj then begin exportwriteln(''); j:=0 end;
                    A:=Paffixe(B^.suivant);
                    if A<>nil then B:=Paffixe(A^.suivant) else B:=nil;

               end;

         LesPoints.detruire;
         if j>0 then exportwriteln('');
    end;
begin
     if cat=cat_utilisateur then exit;//en cas d'appel utilisateur
     if clippee then aux:=Paffixe(noClipList.tete)
                else aux:=Paffixe(liste_points^.tete);
     delta:=0.15;
     New(Ak,init(0,0));
     New(Bk,init(0,0));

     case style of
     2 {bdiag}: begin
             Xu:=delta/(sqrt(2)*Xscale);Yu:=-delta/(sqrt(2)*Yscale);
             Xv:=Xu;Yv:=-Yu;
             NbP:=round(1+abs((Xmax-Xmin)*Xscale+(Ymax-Ymin)*Yscale)/sqrt(2)/delta);
                end;
     5 {fdiag}: begin
             Xu:=delta/(sqrt(2)*Xscale);Yu:=delta/(sqrt(2)*Yscale);
             Xv:=Xu;Yv:=-Yu;
             NbP:=round(1+abs((Xmax-Xmin)*Xscale+(Ymax-Ymin)*Yscale)/sqrt(2)/delta);
                end;
     6 {horizontal}: begin
             Xu:=0;Yu:=-delta/(Yscale);
             Xv:=-Yu;Yv:=0;
             NbP:=round(1+abs((Ymax-Ymin)*Yscale)/delta);
                end;
     7 {vertical}: begin
             Xu:=delta/Xscale;Yu:=0;
             Xv:=0;Yv:=Xu;
             NbP:=round(1+abs((Xmax-Xmin)*Xscale)/delta);
                end;
     else exit;
     end;

     ok:=false;
         if epaisseur_courante<>2 //2=thinlines
            then
                begin
                     case mode of
                     eps: exportwrite( ' thinlines ');
                     Latex:exportwrite( '\thinlines ');
                     pgf: exportwrite( '\pgfsetlinewidth{0.2pt}');
                     end;
                     epaisseur_courante:=2;ok:=true;
                end;
         if style_Courant<>0 then
                begin
                     case mode of
                     eps: exportwrite( ' SolidLine ');
                     pgf: exportwriteln( '\pgfsetdash{}{0pt}');
                     end;
                     style_Courant:=0; ok:=true;
                end;
         if (fill_color<>couleur_courante)
            then
                begin
                     case mode of
                     eps:exportwrite( StrColor(fill_color,eps));
                     LaTeX: exportwrite('\color'+StrColor(fill_color,latex));
                     pgf:  exportwrite('\pgfsetstrokecolor'+StrColor(fill_color,pgf));
                     end;
                     couleur_courante:=fill_color; ok:=true;
                end;
     if mode=pstricks then
        begin
             exportwriteln('\psset{fillstyle=none,linewidth=0.2pt,linestyle=solid,linecolor='+
                    StrColor(fill_color,pstricks)+'}%');
             epaisseur_courante:=2; style_Courant:=0;couleur_courante:=fill_color;
             fill_courant:=-1;
        end;

     if ok then exportwriteln('');
     if evenoddfill then
        begin
             compt:=1;
             FillConnexe(aux,nil)
        end
     else
     while aux<>nil do
          begin
               compt:=1;
               aux1:=Paffixe(aux^.suivant);
               while (aux1<>nil) and (not IsJump(aux1)) do
                     begin inc(compt);aux1:=Paffixe(aux1^.suivant) end;
               if compt>2 then FillConnexe(aux,aux1);
               while (aux1<>nil) and (IsJump(aux1)) do aux1:=Paffixe(aux1^.suivant);
               aux:=aux1;
          end;
     Kill(Pcellule(Ak));Kill(Pcellule(Bk));
end;
{====================================== LaTeX ==================================}
procedure T_ligne.enregistrer_latex;
begin
     if (liste_points^.tete=nil) then exit;
     if (ligne_style=-1) and (fill_style=0) then exit;
     BeginExportLatex;
     if (ligne_style=-1) then exit;
     DoExportLatex;
     EndExportLatex;
end;
{===================}
procedure T_ligne.BeginExportLatex;
var old:boolean;
begin
     if fill_style=0
        then t_element.BeginExportLatex
        else
            begin
                 if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
                 case fill_style of
                      2: fillLatex(2,LaTex);
                      3: begin fillLatex(6,LaTex);fillLatex(7,LaTex); end;
                      4: begin fillLatex(2,LaTex);fillLatex(5,LaTex); end;
                      5: FillLatex(5,LaTex);
                      6: fillLatex(6,LaTex);
                      7: fillLatex(7,LaTex);
                 end;
                 old:=inclure_commentaires;
                 inclure_commentaires:=false;
                 t_element.BeginExportLatex;
                 inclure_commentaires:=old;
            end;
end;
{==================}
procedure T_ligne.DoExportLaTeX;
var aux1:Paffixe;
    commande,chaine:string;
    points,nb_col,col_dep:word;
    ok,old:boolean;
begin
     if (ligne_style=-1) then exit;
     aux1:=Paffixe(liste_points^.tete);
     nb_col:=0;
             case ligne_style of
              0: begin commande:='\path'; col_dep:=5 end;
            1,3: begin commande:=TeXdashStyle;col_dep:=14 end;
              2: begin commande:=TexDotStyle;col_dep:=19 end;
              end;

          points:=0;
          while aux1<>nil do
          begin
               if not IsJump(aux1) then
                begin
                ok:=false;
                if (points=0) and (aux1^.suivant<>nil) and (not IsJump(Paffixe(aux1^.suivant)))
                    then begin  exportwrite(commande); nb_col:=col_dep;ok:=true end;
                if (points<>0) or ok then
                  begin
                  chaine:=streel(Xtex(aux1^.x))+','+streel(Ytex(aux1^.y));
                  inc(nb_col,length(chaine)+2);
                  exportwrite('('+chaine+')');inc(points);
                  if (aux1^.suivant=nil) then {exportwriteln('')}
                   else
                       if (not IsJump(Paffixe(aux1^.suivant))) and (points>=max_points)
                          then begin
                          exportwriteln('');
                          exportwrite(commande+'('+chaine+')');nb_col:=col_dep+length(chaine)+2;
                          points:=1;
                          end
                          else if (nb_col>colonnes) and (not IsJump(Paffixe(aux1^.suivant)))
                                  then begin exportwriteln('');nb_col:=0 end;
                   end;
                end else begin if points>0 then exportwriteln('');points:=0 end;

               aux1:=Paffixe(aux1^.suivant);
          end;
          if nb_col<>0 then exportwriteln('');
end;
{==================}
procedure T_ligne.EndExportLaTeX;
begin
      if (ligne_style<>-1) and (fleche>0) then fleches_latex(latex);
end;
{====================================== Pgf ===================================}
procedure T_ligne.enregistrer_pgf;
begin
     if (liste_points^.tete=nil) then exit;
     if (ligne_style=-1) and (fill_style=0) then exit;
     BeginExportPgf;
     DoExportPgf;
     EndExportPgf;
end;
{================================}
procedure T_ligne.BeginExportPgf;
var old:boolean;
    z:Paffixe;
begin
     t_element.BeginExportPgf;
     if (fill_style=8) then  //gradient
     begin
          exportwriteln('\colorlet{colorA}'+StrColor(grad_colorA,pgf)+'%');
          exportwriteln('\colorlet{colorB}'+StrColor(grad_colorB,pgf)+'%');
          if grad_style=2 then
             begin
                  exportwriteln('\def\GradCenterX{'+Streel(50*(grad_centerX-0.50))+'}%');
                  exportwriteln('\def\GradCenterY{'+Streel(50*(grad_centerY-0.50))+'}%');
             end
     end
     else
         if fill_style>1 then //hachures
         case fill_style of
              2: exportwriteln('\pgfsetfillpattern{north east lines}'+StrColor(fill_color,pgf)+'%'); //fillLatex(2,pgf);
              3: exportwriteln('\pgfsetfillpattern{grid}'+StrColor(fill_color,pgf)+'%');//begin fillLatex(6,pgf);fillLatex(7,pgf); end;
              4: exportwriteln('\pgfsetfillpattern{crosshatch}'+StrColor(fill_color,pgf)+'%');//begin fillLatex(2,pgf);fillLatex(5,pgf); end;
              5: exportwriteln('\pgfsetfillpattern{north west lines}'+StrColor(fill_color,pgf)+'%');//FillLatex(5,pgf);
              6: exportwriteln('\pgfsetfillpattern{horizontal lines}'+StrColor(fill_color,pgf)+'%');//fillLatex(6,pgf);
              7: exportwriteln('\pgfsetfillpattern{vertical lines}'+StrColor(fill_color,pgf)+'%');//fillLatex(7,pgf);
         end;
     (*if ligne_style<>-1 then fleches_LaTeX(pgf);*)
     if linecap_style<>linecap_courant then
     begin
        case linecap_style of
        0:  exportwriteln( '\pgfsetbuttcap%');
        1:  exportwriteln( '\pgfsetroundcap%');
        2:  exportwriteln( '\pgfsetrectcap%');
        end;
        linecap_courant:=linecap_style;
     end;
     if linejoin_style<>linejoin_courant then
     begin
        case linejoin_style of
        0:  exportwriteln( '\pgfsetmiterjoin%');
        1:  exportwriteln( '\pgfsetroundjoin%');
        2:  exportwriteln( '\pgfsetbeveljoin%');
        end;
        linejoin_courant:=linejoin_style
     end;
     if miterlimit_style<>miterlimit_courant then
        begin
             exportwriteln('\pgfsetmiterlimit{'+Streel(miterlimit_style)+'}%');
             miterlimit_courant:=miterlimit_style
        end;
     if (ligne_style<>style_Courant) or (ligne_style=3) then
        begin
             case ligne_style of
              0: exportwriteln( '\pgfsetdash{}{0pt}%');
              1: exportwriteln( '\pgfsetdash{{5pt}{3pt}}{0pt}%');
              2: exportwriteln( '\pgfsetdash{{0pt}{3pt}}{0pt}%');
              3: begin
                      z:=pattern;
                      if (z=Nil) or (z^.suivant=Nil) then exportwriteln( '\pgfsetdash{}{0pt}%')
                      else
                          begin
                              exportwrite( '\pgfsetdash{');
                              while z<>Nil do
                                    begin
                                         exportwrite('{'+Streel(abs(z^.x))+'pt}');
                                         z:=Paffixe(z^.suivant)
                                    end;
                              exportwriteln('}{0pt}%');
                          end;
                  end;
              end;
              if ligne_style<>-1 then Style_Courant:=ligne_style
        end;
     if ((fill_style=1) or (fill_style=8)) and (fill_opacity<>opacity_courant) then
        begin
             exportwriteln( '\pgfsetfillopacity{'+Streel(fill_opacity)+'}%');
             opacity_courant:=fill_opacity
        end;
    if evenoddfill<> eofill_courant then
       begin
            if evenoddfill then exportwriteln('\pgfseteorule') else exportwriteln( '\pgfsetnonzerorule');
            eofill_courant:=evenoddfill
       end;
    if clippee and (not OnlyData) then ClipExport(pgf);
    if (ligne_style<>-1) and (fleche>0)
    then
             case fleche of
             1: exportwriteln('\pgfsetarrows{-to}%');
             2: exportwriteln('\pgfsetarrows{to-to}%');
             3: exportwriteln('\pgfsetarrows{to-}%');
             end;
end;
{=============}
procedure T_ligne.pgffillstroke;
begin
     if (fill_style=8) then//gradient
           begin
              if grad_style=1 then //linear
                 exportwriteln('\pgfshadepath{myshading}{'+Streel(Grad_Angle)+'}%')
              else //radial
                   exportwriteln('\pgfshadepath{mysphereshading}{0}%');
              if ligne_style<>-1 then exportwriteln('\pgfusepath{stroke}%')
              else exportwriteln('\pgfusepath{}%');
           end
     else
        if fill_style>0
            then begin
                      if fill_style=1 //fillcolor<>fillcolor_courant
                         then
                         begin
                              fillcolor_courant:=fill_color;
                              exportwriteln('\pgfsetfillcolor'+StrColor(fill_color,pgf)+'%');
                         end;
                      if ligne_style=-1 then exportwriteln('\pgffill%') else exportwriteln('\pgffillstroke%');
                 end
            else exportwriteln('\pgfstroke%')
end;
{=============}
procedure T_ligne.DoExportPgf;
var aux1:Paffixe;
    points:integer;
    ligneVide, Ln:boolean;   //indique si la ligne comporte au plus 2 points
    fillColor,rcolor,gcolor,bcolor:longint;

    procedure compt;
    begin
         inc(points,1); Ln:=false;
         if points> 3 then
            begin
                 points:=0; Ln:=true;
                 exportwriteln('%')
            end;
    end;

    procedure trace;
    begin
          LigneVide:=true;
          while (aux1<>nil) and IsJump(aux1) do aux1:=Paffixe(aux1^.suivant);
           If aux1<>nil then
              If (aux1^.suivant<>nil) and (not Isjump(Paffixe(aux1^.suivant)))
              then
                   if (not InPath) And ((aux1^.suivant^.suivant=nil) or (Isjump(Paffixe(aux1^.suivant^.suivant))))
                      then
                          begin  {il n'y a que 2 points}
                               exportwrite('\pgfxyline('+streel(Xtex(aux1^.x))+','+streel(Ytex(aux1^.y))+')('+
                               streel(Xtex(Paffixe(aux1^.suivant)^.x))+','+streel(Ytex(Paffixe(aux1^.suivant)^.y))+')');
                               aux1:=Paffixe(aux1^.suivant^.suivant);
                               compt
                          end
                      else
                   begin
                        if (not InPath) or (FirstInPath) then
                        exportwriteln( '\pgfpathmoveto{\pgfxy('+streel(Xtex(aux1^.x))+','+streel(Ytex(aux1^.y))+')}%');
                        aux1:=Paffixe(aux1^.suivant);
                        while (aux1<>nil) and (not IsJump(aux1)) do
                         begin
                               if (fermee=1) and ((aux1^.suivant=nil) or IsJump(Paffixe(aux1^.suivant)) )
                                 then exportwrite('\pgfclosepath')
                                 else exportwrite( '\pgfpathlineto{\pgfxy('+streel(Xtex(aux1^.x))+','+streel(Ytex(aux1^.y))+')}');
                              compt;LigneVide:=false;
                              aux1:=Paffixe(aux1^.suivant);
                        end;
                       if (fill_style=1) and (aux1<>nil) and (aux1^.y<>jump^.y) then
                          fill_Color:=getFillColor(rcolor,gcolor,bcolor,aux1^.y)
                   end
              else aux1:=Paffixe(aux1^.suivant);
    end;

begin
     //if clippee then aux1:=Paffixe(noClipList.tete) else aux1:=Paffixe(liste_points^.tete);
     aux1:=Paffixe(liste_points^.tete);// il peut y avoir des débordements de calculs avec noClipList en pgf
     fillColor:=fill_color;
     rcolor:=GetRvalue(fillColor);
     gcolor:=GetGvalue(fillColor);
     bcolor:=GetBvalue(fillColor);
     points:=0; Ln:=true;
     Repeat
         trace;
         if not Ln then begin exportwriteln('%'); Ln:=true end;
         if (not Lignevide) and (not InPath) then pgffillstroke;
     until aux1=nil;
     fill_color:=fillcolor;
     if not Ln then exportwriteln('%');//LigneVide and (points>0) then exportwriteln('');
end;
{==================}
procedure T_ligne.EndExportPgf;
begin
      if (ligne_style<>-1) and (fleche>0) then exportwriteln( '\pgfsetarrows{-}%');
      if clippee and (not OnlyData) then exportwriteln( '\end{pgfscope}%');
end;
{====================================== Svg ===================================}
procedure T_ligne.enregistrer_Svg;
begin
     if (liste_points^.tete=nil) then exit;
     if (ligne_style=-1) and (fill_style=0) then exit;
     BeginExportSvg;
     //if (ligne_style=-1) and (fill_style<>1) then exit;
     DoExportSvg;
     EndExportSvg;
end;
{================================}
procedure T_ligne.BeginExportSvg;
var z:Paffixe;
    a:real;
begin
        t_element.BeginExportSvg;
        if (fill_style>1) and (fill_style<8) then
        begin
                exportwriteln('<g fill="none" stroke="'+StrColor(fill_color,svg)+'" stroke-width="'+SvgWidth(2)+'">');
                case fill_style of
                      2: fillLatex(2,svg);
                      3: begin fillLatex(6,svg);fillLatex(7,svg); end;
                      4: begin fillLatex(2,svg);fillLatex(5,svg); end;
                      5: FillLatex(5,svg);
                      6: fillLatex(6,svg);
                      7: fillLatex(7,svg);
                end;
                exportwriteln('</g>');
        end;
     if (ligne_style=-1) and not (fill_style in [1,8]) then exit;
     if (fill_style=8) then //définition gradient
     begin
        NbSvgGrad += 1;
        SvgGradName:='MyGradient'+IntToStr(NbSvgGrad);
        Exportwriteln('<defs>');
        if Grad_Style=2 then
           exportwrite('<radialGradient cx="'+Streel(grad_centerX)+'" cy="'+Streel(1-grad_centerY)+'" ')
        else
            begin
               exportwrite('<linearGradient ');
               while grad_angle>360 do grad_angle -=360; while grad_angle<0 do grad_angle+=360; a:=grad_angle*pi/180;
               if (0<=grad_angle) And (grad_angle<90) then
                   exportwrite('x1="0%" y1="100%" x2="'+Streel(100*cos(a))+'%" y2="'+Streel(100*(1-sin(a)))+'%"')
               else
               if (90<=grad_angle) And (grad_angle<180) then
                   exportwrite('x1="100%" y1="100%" x2="'+Streel(100*(1+cos(a)))+'%" y2="'+Streel(100*(1-sin(a)))+'%"')
               else
               if (180<=grad_angle) And (grad_angle<270) then
                   exportwrite('x1="100%" y1="0%" x2="'+Streel(100*(1+cos(a)))+'%" y2="'+Streel(-100*sin(a))+'%"')
               else
                  exportwrite('x1="0%" y1="0%" x2="'+Streel(100*cos(a))+'%" y2="'+Streel(-100*sin(a))+'%"');
            end;
        exportwriteln(' id="'+SvgGradName+'">');
        exportwriteln(' <stop offset="0%" stop-color="'+StrColor(Grad_colorA,svg)+'"/>');
        exportwriteln(' <stop offset="100%" stop-color="'+StrColor(Grad_colorB,svg)+'"/>');
        exportwrite('</');
        if Grad_Style=2 then exportwriteln('radialGradient>') else exportwriteln('linearGradient>');
        exportwriteln('</defs>');
     end;
     exportwrite('<g ');
     if (fill_style=1) or (fill_style=8) then
        begin
             if fill_opacity<1 then exportwrite( 'fill-opacity="'+Streel(fill_opacity)+'" ');
             if evenoddfill then exportwrite( 'fill-rule="evenodd" ');
             if fill_style=8 then exportwrite( 'fill="url(#'+SvgGradName+')" ');
        end else exportwrite( 'fill="none" ');
     if ligne_style>-1 then
        begin
             exportwrite( 'stroke="'+StrColor(couleur,svg)+'" stroke-width="'+ SvgWidth(trait)+'"');
             if stroke_opacity<1 then
                exportwrite( ' stroke-opacity="'+Streel(stroke_opacity)+'" ')
        end;
     if linecap_style<>0 {butt} then
        case linecap_style of
        0:  exportwrite(' stroke-linecap="butt" ');
        1:  exportwrite(' stroke-linecap="round" ');
        2:  exportwrite(' stroke-linecap="square" ');
        end;
     if linejoin_style<>0 {miter} then
        case linejoin_style of
        0:  exportwrite(' stroke-linejoin="miter" ');
        1:  exportwrite(' stroke-linejoin="round" ');
        2:  exportwrite(' stroke-linejoin="bevel" ');
        end;
     if (linejoin_style=0) And (miterlimit_style<>4)  then
             exportwrite(' stroke-miterlimit="'+Streel(miterlimit_style)+'" ');
     case ligne_style of
        1: exportwriteln(' stroke-dasharray="7.56,3.78">');//exportwriteln(' stroke-dasharray="0.2,0.1">');
        2: exportwriteln(' stroke-dasharray="0.378,3.78">');//exportwriteln(' stroke-dasharray="0.01,0.1">');
        3: begin
               z:=pattern;
               if (z=Nil) or (z^.suivant=Nil) then exportwriteln(' stroke-dasharray="none"')
               else
                  begin
                      exportwrite( ' stroke-dasharray="'+Streel(abs(z^.x*96/72.27)));//Streel(abs(z^.x*2.54/72.27)));
                      z:=Paffixe(z^.suivant);
                      while z<>Nil do
                             begin
                                  exportwrite(','+Streel(abs(z^.x*96/72.27)));//Streel(abs(z^.x*2.54/72.27)));
                                  z:=Paffixe(z^.suivant)
                             end;
                       exportwriteln('">');
                   end;
            end;
        else exportwriteln('>');
     end;

end;
{======================}
procedure T_ligne.DoExportSvg;
var aux1:Paffixe;
    points,nbpoints:integer;
    fillColor,fillColor1,rcolor,gcolor,bcolor:longint;
    listePoints:string;

    procedure compt;
    begin
         if points> 5 then
            begin
                 points:=0;
                 listePoints += chr(10)
            end else inc(points,1)
    end;

    procedure trace;
    begin
          listePoints:='';
          nbpoints:=0; points:=0;
          while (aux1<>nil) and IsJump(aux1) do aux1:=Paffixe(aux1^.suivant);
           If aux1<>nil then
              If (not InPath) or ((aux1^.suivant<>nil) and (not Isjump(Paffixe(aux1^.suivant))))
              then
                   begin
                        compt;
                        if (not InPath) then
                              listePoints += streel(XSvg(aux1^.x))+','+streel(YSvg(aux1^.y))
                              else
                        if  FirstInPath then
                                listePoints += streel(XSvg(aux1^.x))+' '+streel(YSvg(aux1^.y));
                        nbpoints:=1;
                        aux1:=Paffixe(aux1^.suivant);
                        while (aux1<>nil) and (not IsJump(aux1)) do
                         begin
                              if (fermee=1) and (aux1^.suivant=nil)
                                 then
                                 else
                                  begin
                                    compt;
                                    if InPath then
                                      listePoints += ' L'+streel(XSvg(aux1^.x))+' '+streel(YSvg(aux1^.y))
                                              else
                                      listePoints += ','+streel(XSvg(aux1^.x))+','+streel(YSvg(aux1^.y));
                                    inc(nbpoints,1);
                                  end;
                              aux1:=Paffixe(aux1^.suivant);
                        end;
                       if (fill_style=1) and (aux1<>nil) and (aux1^.y<>jump^.y) then
                          fillColor:=getFillColor(rcolor,gcolor,bcolor,aux1^.y)
                   end
              else aux1:=Paffixe(aux1^.suivant);
    end;

begin
     aux1:=Paffixe(liste_points^.tete);
     fillColor1:=fill_color;
     fillColor:=fillColor1;
     rcolor:=GetRvalue(fillColor1);
     gcolor:=GetGvalue(fillColor1);
     bcolor:=GetBvalue(fillColor1);
     points:=0;
     Repeat
                   trace;
                   if not InPath then
                     if nbpoints>=2 then
                        begin
                          if fermee=1 then exportwrite( '<polygon ') else exportwrite( '<polyline ');
                          if (fill_style=1) then exportwrite( 'fill="'+StrColor(fillColor,svg)+'" ');
                          exportwriteln( 'points="'+listePoints+'"/>');
                        end else
                   else exportwrite( listePoints)
     until aux1=nil;

end;
{=============}
procedure T_ligne.EndExportSvg;
begin
        if ligne_style<>-1 then fleches_latex(svg);
        if (ligne_style<>-1) or (fill_style=1) or (fill_style=8) then exportwriteln('</g>');
end;
{======================================== EPS =================================}
procedure T_ligne.enregistrer_eps;
begin
     if (liste_points^.tete=nil) then exit;
     if (ligne_style=-1) and (fill_style=0) then exit;
     BeginExportEps;
     DoExportEps;
     EndExportEps;
end;
{================================}
procedure T_ligne.BeginExportEps;
var old:boolean;
    z,aux:Paffixe;
    R:TrectF;
    G,Coin:TPointF;
    mat:Tmatrix;
    cn,sn,x,y,ray,large,haut: real;
    rcolorA,gcolorA,bcolorA,rcolorB,gcolorB,bcolorB:single;
begin
     if clippee and (not onlyData) then ClipExport(Eps);
     if (fill_style=0) or (fill_style=8)
        then t_element.BeginExportEps
        else
            begin
                 if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
                 case fill_style of
                      2: fillLatex(2,eps);
                      3: begin fillLatex(6,eps);fillLatex(7,eps); end;
                      4: begin fillLatex(2,eps);fillLatex(5,eps); end;
                      5: FillLatex(5,eps);
                      6: fillLatex(6,eps);
                      7: fillLatex(7,eps);
                 end;
                 old:=inclure_commentaires;
                 inclure_commentaires:=false;
                 t_element.BeginExportEps;
                 inclure_commentaires:=old;
            end;
    if linecap_style<>linecap_courant then
     begin
        exportwriteln(Streel(linecap_style)+' setlinecap');
        linecap_courant:=linecap_style;
     end;
     if linejoin_style<>linejoin_courant then
     begin
        exportwriteln(Streel(linejoin_style)+' setlinejoin');
        linejoin_courant:=linejoin_style
     end;
     if miterlimit_style<>miterlimit_courant then
        begin
             exportwriteln(Streel(miterlimit_style)+' setmiterlimit');
             miterlimit_courant:=miterlimit_style
        end;
    if (ligne_style<>style_Courant) or (ligne_style=3) then
        begin
             case ligne_style of
              0: exportwriteln( ' SolidLine ');
              1: exportwriteln( ' DashLine ');
              2: exportwriteln( ' DotLine ');
              3: begin
                  z:=pattern;
                  if (z=Nil) or (z^.suivant=Nil) then exportwriteln(' SolidLine ')
                  else
                     begin
                         exportwrite( '[');
                         while z<>Nil do
                             begin
                                  exportwrite(Streel(abs(z^.x))+' ');
                                  z:=Paffixe(z^.suivant)
                             end;
                          exportwriteln('] 0 setdash');
                     end;
                end;
              end;
              if ligne_style<>-1 then Style_Courant:=ligne_style
        end;
    if (fill_style=8) then //il y a un gradient
    begin
       rcolorA:=GetRvalue(grad_colorA)/255;gcolorA:=GetGvalue(grad_colorA)/255;bcolorA:=GetBvalue(grad_colorA)/255;
       rcolorB:=GetRvalue(grad_colorB)/255;gcolorB:=GetGvalue(grad_colorB)/255;bcolorB:=GetBvalue(grad_colorB)/255;
       aux:=Paffixe(NoClipList.tete); if aux=Nil then aux:=Paffixe(liste_points^.tete);
       R.TopLeft.x:=Xeps(aux^.x); R.TopLeft.y:=Yeps(aux^.y);
       R.BottomRight:=R.TopLeft;
       aux:=paffixe(aux^.suivant);
       while aux<>nil do   // on cherche la bounding box
          begin
              if not IsJump(aux) then
                 begin
                    x:=Xeps(aux^.x); y:=Yeps(aux^.y);
                    if R.Left>x then R.Left:=x
                    else if R.Right<x then R.Right:=x;
                    if R.Top<y then R.Top:=y
                    else if R.Bottom>y then R.Bottom:=y;
                 end;
              aux:=Paffixe(aux^.suivant);
          end;
       G.x:=(R.Left+R.right)/2; G.y:=(R.top+R.Bottom)/2;//centre du rectangle
       ray:=0; haut:=R.Top-R.Bottom; large:=R.Right-R.Left; Coin:=R.TopLeft;
       exportwriteln('gsave');
       exportwriteln('/currentClip{initclip '+ Streel(R.Left)+ ' '+ Streel(R.Bottom)+ ' m '+
       Streel(R.Right)+' '+Streel(R.Bottom)+ ' l '+ Streel(R.Right)+' '+Streel(R.Top)+' l '+
       Streel(R.Left)+' '+Streel(R.Top)+' l closepath clip}def');
       if grad_style=1 then //linear
        if grad_angle<>0 then //rotation de la bounding box autour de G
           begin
              cn:=cos(grad_angle*pi/180); sn:=-sin(grad_angle*pi/180);
              mat[1]:=cn; mat[2]:=-sn; mat[3]:=sn; mat[4]:=cn;
              mat[5]:=G.x*(1-cn)+G.y*sn; mat[6]:=G.y*(1-cn)-G.x*sn;
              aux:=new(Paffixe,init(R.Left,R.Top)); aux^.suivant:=new(Paffixe,init(R.Right,R.Top));
              aux^.suivant:=new(Paffixe,init(R.Right,R.Bottom));
              aux^.suivant:=new(Paffixe,init(R.Left,R.Bottom)); aux^.suivant:=Nil;
              z:=Mtransform(aux,mat);
              R.TopLeft.X:=z^.x; R.TopLeft.y:=z^.y; z:=Paffixe(z^.suivant);
              while z<>Nil do
                 begin
                 if R.Left>z^.x then R.Left:=z^.x
                    else if R.Right<z^.x then R.Right:=z^.x;
                 if R.Top<z^.y then R.Top:=z^.y
                    else if R.Bottom>z^.y then R.Bottom:=z^.y;
                 z:=Paffixe(z^.suivant);
                 end;
              Kill(Pcellule(aux)); Kill(Pcellule(z));
           end
        else
       else //radial
       begin
            G.X:=(R.Right-R.Left)*grad_centerX+R.Left; G.y:=(R.Top-R.Bottom)*grad_centerY+R.Bottom;
            aux:=Paffixe(NoClipList.tete); if aux=Nil then aux:=Paffixe(liste_points^.tete);
            while aux<>nil do   // on cherche le rayon optimal
                  begin
                       if not IsJump(aux) then
                           begin
                              x:=Xeps(aux^.x); y:=Yeps(aux^.y);
                              ray:=max(ray, sqrt( sqr(x-G.x)+sqr(y-G.y))); //VectLen(PointF(x,y)-G));
                           end;
                        aux:=Paffixe(aux^.suivant);
                  end;
       end;
       exportwrite('/Chem{newpath ');
       InPath:=true; FirstInPath:=true;
       DoExportEps;//on mémorise le chemin à tracer dans Chem
       exportwriteln('}def');
       Inpath:=false; FirstInPath:=false;
       exportwriteln('/Nb{'+IntToStr(round(sqrt(sqr(haut)+sqr(large))/3))+'}def');
       exportwriteln(Streel(rcolorB)+' '+Streel(gcolorB)+' '+Streel(bcolorB)+' StartHSB');
       exportwriteln(Streel(rcolorA)+' '+Streel(gcolorA)+' '+Streel(bcolorA)+' EndHSB');
       if grad_style=1 then //linear
          begin
             exportwriteln('/haut{'+ Streel(haut)+'}def /large{'+Streel(large)+'}def /Step{large Nb div}def');
             exportwriteln('0 1 Nb{/Large exch Step mul neg '+Streel(large)+' add def');
             exportwriteln('        H1 S1 B1 setrgbcolor');
             exportwrite('        newpath');
             if Grad_Angle<>0 then
                exportwriteln(' /mtr CM def '+Streel(G.x)+' '+ Streel(G.y)+' translate '+ Streel(Grad_Angle)+
                ' rotate '+ Streel(-G.x)+' '+Streel(-G.y)+' translate ')
             else exportwriteln('');
             exportwriteln('        '+Streel(Coin.x)+' '+Streel(Coin.y)+' moveto Large 0 rlineto 0 haut neg rlineto Large neg 0 rlineto closepath clip');
             exportwriteln('        H1 S1 B1 setrgbcolor');
               exportwrite('        Chem ');
             if Fill_Opacity<1 then exportwrite(streel(fill_opacity)+' .setopacityalpha ');
             if evenoddfill then exportwrite('eofill ') else exportwrite('fill ');
             if Grad_Angle<>0 then exportwrite('mtr setmatrix ');
             exportwriteln('currentClip StepHSB }for');
          end
       else //radial
           begin
             exportwriteln('/rayon{'+Streel(ray)+'}def');
             exportwriteln('/Step{rayon Nb div}def');
             exportwriteln('0 1 Steps{/ray exch Step mul neg rayon add def');
             exportwriteln('        H1 S1 B1 setrgbcolor');
             exportwriteln('        newpath');
             exportwriteln('        0 360 ray ray '+Streel(G.x)+' '+Streel(G.y)+
                           ' /mtr CM def translate scale 0 0 1 5 3 roll arc mtr setmatrix closepath clip');
             exportwriteln('        H1 S1 B1 setrgbcolor');
               exportwrite('        Chem ');
             if Fill_Opacity<1 then exportwrite(streel(fill_opacity)+' .setopacityalpha ');
             if evenoddfill then exportwriteln('eofill') else exportwriteln('fill');
             exportwriteln('        currentClip StepHSB }for');
           end;
       exportwriteln('grestore');
    end;
end;
{==============}
procedure T_ligne.DoExportEps;
var aux1,aux2:Paffixe;
    points:integer;
    ligneVide, Ln:boolean;    {indique si la ligne contient au plus 1 point}
    fillColor,rcolor,gcolor,bcolor:longint;
    StrFill, StrStroke:string;

    procedure compt;
    begin
         inc(points,1); Ln:=false;
         if points>4 then
            begin
                 points:=0; Ln:=true;
                 exportwriteln('')
            end;
    end;

    procedure trace;
    begin
          aux2:=aux1;
          ligneVide:=true;
          while (aux1<>nil) and IsJump(aux1) do aux1:=Paffixe(aux1^.suivant);
           If aux1<>nil then
              If (aux1^.suivant<>nil) and (not Isjump(Paffixe(aux1^.suivant)))
              then
              begin
                   if (not InPath) or (FirstInPath) then //premier point
                   exportwrite( streel(XEps(aux1^.x))+' '+streel(YEps(aux1^.y))+' m ');

                   compt;ligneVide:=false;
                   aux1:=Paffixe(aux1^.suivant);

                   while (aux1<>nil) and (not IsJump(aux1)) do
                         begin
                              if (fermee=1) and ((aux1^.suivant=nil) or IsJump(Paffixe(aux1^.suivant)) )
                                 then exportwrite( 'closepath ')
                                 else exportwrite( streel(XEps(aux1^.x))+' '+streel(YEps(aux1^.y))+' l ');
                              compt;
                              aux1:=Paffixe(aux1^.suivant);
                         end;
                         
                   if (fill_style=1) and (aux1<>nil) and (aux1^.y<>jump^.y) then
                      fillColor:=getFillColor(rcolor,gcolor,bcolor,aux1^.y)
              end
              else aux1:=Paffixe(aux1^.suivant);
    end;

begin
     aux1:=Nil;//Paffixe(NoClipList.tete);
     if aux1=Nil then aux1:=Paffixe(liste_points^.tete);
     if aux1=Nil then exit;
     fillColor:=fill_Color;
     rcolor:=GetRvalue(fill_color);
     gcolor:=GetGvalue(fill_color);
     bcolor:=GetBvalue(fill_color);
     if evenoddfill then StrFill:='eofill ' else StrFill:='fill '; StrStroke:='s ';
     //gestion de la transparence remplissage solide
     if (Fill_style=1) and (fill_opacity<1) then
                        StrFill:=Streel(fill_opacity)+' .setopacityalpha '+Strfill;
     //gestion du stroke en cas de transparence ou non
     if (ligne_style=-1) //pas de ligne
        then
            if ((Fill_style=1) or (fill_style=8)) and (fill_opacity<>1)
               then StrStroke:='1 .setopacityalpha s ' //il faut restaurer la non transparence
               else
        else //ligne
            if (stroke_opacity<1) then
                        StrStroke:=Streel(stroke_opacity)+' .setopacityalpha s 1 .setopacityalpha ';
                        
     points:=0; Ln:=true;
     if (not InPath) and (fill_style=8) then
     begin
        if  (ligne_style<>-1) then exportwriteln('Chem '+StrStroke);
        exit;
     end;
     Repeat
           trace;
           if not InPath then
             begin
                if not Ln then begin exportwriteln(''); Ln:=true end;
                if not Lignevide
                then
                 if (ligne_style<>-1)
                    then
                       if fill_style=1
                       then exportwriteln( 'gs '+StrColor(fillColor,eps)+StrFill+'gr '+StrStroke)
                       else exportwriteln( StrStroke)
                    else if fill_style=1
                         then exportwriteln( StrColor(fillColor,eps)+StrFill+StrStroke+
                                           StrColor(couleur_courante,eps));
                end;
     until aux1=nil;
     if not Ln then exportwriteln('');
 end;
{============}
procedure T_ligne.EndExportEps;
begin
     if (ligne_style<>-1) and (fleche>0) then fleches_latex(eps);
     if clippee and (not onlydata) then exportwriteln( 'initclip');
end;
{============================================= Pstricks ========================}
function t_ligne.parametres_pst;
var ok:boolean;
    chaine:string;
    oldFill:integer;
    z:Paffixe;
    procedure add(c:string);
    begin
        if ok then chaine+=',';
        chaine+=c; ok:=true;
    end;
begin
     chaine:=t_element.parametres_pst;
     ok:=chaine<>'';
     if ((ligne_style<>style_Courant) or (ligne_style=3)) then
        begin if ok then chaine+=',';
              chaine+='linestyle='+UnStyle[ligne_style];
              if ligne_style=3 {userdash} then
                    begin
                     z:=pattern;
                     if (z<>Nil) and (z^.suivant<>Nil) then
                        begin
                           chaine+=',dash='+Streel(abs(z^.x))+'pt';
                           z:=Paffixe(z^.suivant);
                           while z<>nil do
                                 begin
                                      chaine+=' '+Streel(abs(z^.x))+'pt';
                                      z:=Paffixe(z^.suivant)
                                 end;
                        end
                    end;
              ok:=true;
              style_courant:=ligne_style
           end;
     if (ligne_style<>-1) then //il y a ligne
        if (stroke_opacity<>strokeopacity_courant) then
           begin
              add('strokeopacity='+Streel(stroke_opacity));
              strokeopacity_courant:=stroke_opacity
           end;
     if (fill_style=8) then //gradient
     begin
          fill_courant:=-1;
          if grad_style=1 then
             add('fillstyle=slope,slopeangle='+Streel(grad_angle)+',slopesteps=500')
          else
             add('fillstyle=ccslope,slopecenter='+Streel(grad_centerX)+' '+Streel(grad_centerY));
          add('slopebegin='+StrColor(grad_colorA,pstricks)+',slopeend='+StrColor(grad_colorB,pstricks))
     end
     else
     begin //pas de gradient
       if evenoddfill then
          if (fill_style=1) then
          begin
                 add('fillstyle='+StyleFill[8]);//eofill
                 fill_courant:=8  //eofill
          end
          else
          if (fill_style>1) then //eofill et hachures
          begin
                 add('fillstyle='+StyleFill[0]); //fill_style]);
                 fill_courant:=0; //fill_style
          end;
       if (not evenoddfill) and (fill_style<>fill_courant) then
          begin
                 add('fillstyle='+StyleFill[fill_style]);
                 fill_courant:=fill_style
          end;
       if (fill_style=1) then   //remplissage solid
            begin
                  if (fill_opacity<>opacity_courant)
                          then  begin
                                  add('opacity='+Streel(fill_opacity));
                                  opacity_courant:=fill_opacity;
                                end;
                  if (fill_color<>fillcolor_courant)
                  then begin
                          add('fillcolor='+StrColor(fill_color,pstricks));
                          fillcolor_courant:=fill_color;
                       end;
            end
            else
            if (fill_style>1) and (fill_style<8) then  //hachures
               begin
                  if (fill_color<>hatchcolor_courant) and (not evenoddfill)
                  then begin
                          add('hatchcolor='+StrColor(fill_color,pstricks));
                          hatchcolor_courant:=fill_color
                        end;

               end;
     end;
     if linecap_style<>linecap_courant then
     begin
        add('linecap='+Streel(linecap_style));
        linecap_courant:=linecap_style;
     end;
     if linejoin_style<>linejoin_courant then
     begin
        add('linejoin='+Streel(linejoin_style));
        linejoin_courant:=linejoin_style
     end;
     if miterlimit_style<>miterlimit_courant then
        begin
             exportwriteln('\pstVerb{'+Streel(miterlimit_style)+' setmiterlimit}%');
             miterlimit_courant:=miterlimit_style
        end;
     parametres_pst:=chaine;
end;
{============}
procedure T_ligne.enregistrer_Pst;
var oldlignestyle:integer;
begin
      if (ligne_style=-1) and (fill_style=0) then exit;
      if (rayon<>0) and (donnees=nil) then exit;
      t_element.enregistrer_Pst;
end;
{=================}
procedure T_ligne.BeginExportPst;
var old:boolean;
begin
     if clippee and (not onlyData) then ClipExport(pstricks);
     if (fill_style>1) and evenoddfill  //si hachures et mode alternate
        then
            begin
                 if inclure_commentaires then exportwriteln('%'+nom+' '+type_element[cat]);
                 exportwriteln( '% hachures');
                 case fill_style of
                      2: fillLatex(2,pstricks);
                      3: begin fillLatex(6,pstricks);fillLatex(7,pstricks); end;
                      4: begin fillLatex(2,pstricks);fillLatex(5,pstricks); end;
                      5: FillLatex(5,pstricks);
                      6: fillLatex(6,pstricks);
                      7: fillLatex(7,pstricks);
                 end;
                 if fill_style>1 then
                  exportwriteln( '% fin hachures');
                  old:=inclure_commentaires;
                  inclure_commentaires:=false;
                  t_element.BeginExportPst;
                  inclure_commentaires:=old;
            end
            else t_element.BeginExportPst;
end;
{================================}
procedure T_ligne.DoExportPst;
var aux1,aux2:Paffixe;
    commande,chaine:string;
    points,nb_col,col_dep,oldMaxPoints,oldfleche:word;
    ok:boolean;
    fillColor,rcolor,gcolor,bcolor:longint;
begin
     if rayon>0 then aux1:=donnees
     else
     //if not Clippee then aux1:=Paffixe(liste_points^.tete) else aux1:=Paffixe(NoClipList.tete);
     aux1:=Paffixe(liste_points^.tete); //il peut y avoir des débordements de calculs avec noClipList
     if ligne_style=-1 then begin oldfleche:=fleche; fleche:=0 end;
     rcolor:=GetRvalue(fill_Color);
     gcolor:=GetGvalue(fill_Color);
     bcolor:=GetBvalue(fill_Color);
     if (fill_style<>0) or (fleche<>0) or (fermee=1) then
        begin oldMaxPoints:=max_points; max_points:=2000 end;
     if (fermee=0) or (fleche<>0) then begin commande:='\psline';col_dep:=7 end
                 else begin commande:='\pspolygon';col_dep:=10 end;
     if rayon>0 then commande += '[linearc='+Streel(rayon)+']';
     if fleche=1 then begin inc(col_dep,5); commande += '{->}' end
                 else
     if fleche=2 then begin inc(col_dep,6); commande += '{<->}';end
                 else
     if fleche=3 then begin inc(col_dep,5); commande += '{<-}';end;
     points:=0;nb_col:=0;
     if InPath and (not FirstInPath) then
        begin
                points:=1;
                if (aux1^.suivant<>nil) then
                        begin
                                exportwrite(commande);
                                nb_col:=col_dep;ok:=true
                        end;
                aux1:=Paffixe(aux1^.suivant);
        end;
     while aux1<>nil do
          begin
               aux2:=aux1;
               while (aux2<>nil) and (not Isjump(aux2)) do aux2:=Paffixe(aux2^.suivant);
               if (fill_style=1) and (aux2<>nil) and (aux2^.y<>jump^.y) then
                          begin
                               fillColor:=getFillColor(rcolor,gcolor,bcolor,aux2^.y);
                               if fillColor<>fillColor_courant
                                  then
                                      begin
                                           exportwriteln('\psset{fillcolor='+StrColor(fillColor,pstricks)+'}%');
                                           fillColor_courant:=fillColor
                                      end;
                          end;
               if not IsJump(aux1) then
                begin
                     ok:=false;
                     if (points=0) and (aux1^.suivant<>nil) and (not IsJump(Paffixe(aux1^.suivant)))
                        then begin  exportwrite(commande); nb_col:=col_dep;ok:=true end;
                     if (points<>0) or ok then
                        begin
                             chaine:=streel(Xtex(aux1^.x))+','+streel(Ytex(aux1^.y));
                             inc(nb_col,length(chaine)+2);
                             if  ((aux1^.suivant=nil) or IsJump(Paffixe(aux1^.suivant)))
                                 and (fermee=1) and (fleche=0) and (points>2) and (rayon=0)
                                 then //on n'exporte pas le dernier point avec pspolygon
                                 else begin exportwrite('('+chaine+')');inc(points); end;
                             if (aux1^.suivant=nil) then //exportwriteln('%')
                                else
                                    if (not IsJump(Paffixe(aux1^.suivant))) and (points>=max_points)
                                       then begin
                                                 exportwriteln('%');
                                                 exportwrite(commande+'('+chaine+')');nb_col:=col_dep+length(chaine)+2;
                                                 points:=1;
                                            end
                                       else
                                           if (nb_col>colonnes) and (not IsJump(Paffixe(aux1^.suivant)))
                                           then begin exportwriteln('%');nb_col:=0 end;
                        end;
                end
                else
                    begin
                         if points>0 then exportwriteln('%');points:=0;
                    end;
               aux1:=Paffixe(aux1^.suivant);
          end;
          if nb_col<>0 then exportwriteln('%');
          if (fill_style<>0) or (fleche<>0) then max_points:=oldMaxPoints;
          if ligne_style=-1 then fleche:=oldfleche;
end;
{==================================}
procedure t_ligne.EndExportPst;
begin
 if clippee and (not onlyData) then exportwriteln( '\endpsclip%');
end;
{================================================ teg ==========================}
function t_ligne.parametres_teg:string;
var chaine:string;
begin
     chaine:=t_element.parametres_teg;
     if fleche<>Arrows then
        begin Arrows:=fleche; chaine:=chaine+',Arrows:='+Streel(fleche);end;
      if ligne_style<>LineStyle then
         begin LineStyle:=ligne_style; chaine:=chaine+',LineStyle:='+Streel(ligne_style);end;
      if NbPoints<>nb_points then
         begin NbPoints:=nb_points; chaine:=chaine+',NbPoints:='+Streel(nb_points);end;
      if FillStyle<>fill_style then
         begin FillStyle:=fill_style; chaine:=chaine+',FillStyle:='+Streel(fill_style);end;
      if FillOpacity<>fill_opacity then
         begin FillOpacity:=fill_opacity; chaine:=chaine+',FillOpacity:='+Streel(fill_opacity);end;
      if FillColor<>fill_color then
         begin FillColor:=fill_color; chaine:=chaine+',FillColor:='+Streel(fill_color);end;
      if eofill<>evenoddfill then
         begin eofill:=evenoddfill; chaine:=chaine+',Eofill:='+Streel(byte(evenoddfill));end;
      if linejoin<>linejoin_style then
        begin linejoin:=linejoin_style; chaine:=chaine+',LineJoin:='+Streel(linejoin_style);end;
     if linecap<>linecap_style then
         begin linecap:=linecap_style; chaine:=chaine+',LineCap:='+Streel(linecap_style);end;
     if miterlimit<>miterlimit_style then
         begin miterlimit:=miterlimit_style; chaine:=chaine+',MiterLimit:='+Streel(miterlimit_style);end;
     if not CompResult(pattern,currentPattern) then
         begin if pattern=Nil then currentPattern:=defaultPattern^.evalNum
                              else currentPattern:=pattern^.evalNum;
               chaine:=chaine+',DashPattern:='+currentPattern^.en_chaine;end;
      parametres_teg:=chaine
end;
{==================}
procedure T_Ligne.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     //exportwrite(#9+'Ligne('+FormatString(LigneCommande,70)+','+InttoStr(fermee));
     exportwrite('Ligne('+FormatString(LigneCommande,70)+','+InttoStr(fermee));
     if (cat<>cat_ellipse) And (rayon>0)
        then exportwrite(','+Streel(rayon));
     //exportwriteln('),');
     exportwriteln(');');
end;
{============================================= fleches =============================}
procedure t_ligne.fleches_latex(mode:byte);
var x1,y1,x2,y2,x3,y3,x4,y4:real;
    aux:Paffixe;
    ok:boolean;
begin
     if (fleche>0) and (PtsFleches^.tete<>nil)
     then
     begin    ok:=false;
              aux:=Paffixe(PtsFleches^.tete);
              if aux<>nil then
              case mode of
              eps:  begin
                         if linejoin_style<>0 then
                           exportwriteln('0 setlinejoin ');
                        if linecap_style<>0 then
                                 exportwriteln('0 setlinecap ');
                         if style_courant<>0 then begin exportwrite(' SolidLine '); style_courant:=0 end;
                    end;

              pgf:  begin
                         exportwrite( '\pgfsetmiterjoin ');
                         if style_courant<>0
                           then
                               begin
                                    exportwrite( '\pgfsetdash{}{0pt}');
                                    style_courant:=0; ok:=true;
                               end;
                         if fillcolor_courant<>couleur
                            then
                                begin
                                     exportwrite('\pgfsetfillcolor'+StrColor(couleur,pgf));
                                     fillcolor_courant:=couleur;ok:=true;
                                end;
                    end;
              end;
              if ok then exportwriteln('');
              while aux<>nil do
                    begin
              x3:=aux^.x;y3:=aux^.y;aux:=Paffixe(aux^.suivant);if aux=nil then exit;
              x2:=aux^.x;y2:=aux^.y;aux:=Paffixe(aux^.suivant);if aux=nil then exit;
              x4:=aux^.x;y4:=aux^.y;aux:=Paffixe(aux^.suivant);if aux=nil then exit;
              x1:=(x3+x4)/4+x2/2;y1:=(y3+y4)/4+y2/2;aux:=Paffixe(aux^.suivant);
              case mode of
              eps:  begin
                              exportwriteln(streel(Xeps(x3))+' '+streel(Yeps(y3))+' m '+
                                     streel(Xeps(x2))+' '+streel(Yeps(y2))+' l '+
                                     streel(Xeps(x4))+' '+streel(Yeps(y4))+' l '+
                                     streel(Xeps(x1))+' '+streel(Yeps(y1))+' l closepath gs fill gr s');
                    end;
              LaTeX: begin
                        exportwriteln('\path('+streel(Xtex(x3))+','+streel(Ytex(y3))+')('+streel(Xtex(x2))+','+
              streel(Ytex(y2))+')('+ streel(Xtex(x4))+','+streel(Ytex(y4))+')');
                      end;
              pgf: exportwriteln('\pgfpathmoveto{\pgfxy('+streel(Xtex(x3))+','+streel(Ytex(y3))+')}\pgfpathlineto{\pgfxy('+streel(Xtex(x2))+','
              +streel(Ytex(y2))+')}\pgfpathlineto{\pgfxy('+ streel(Xtex(x4))+','+streel(Ytex(y4))+')}\pgfpathlineto{\pgfxy('+
              streel(Xtex(x1))+','+streel(Ytex(y1))+')}\pgfclosepath\pgffillstroke');
              svg: exportwriteln( '<polygon fill="'+StrColor(couleur,svg)+'" stroke-linejoin="miter" points="'+
                 streel(Xsvg(x3))+','+streel(Ysvg(y3))+','+streel(Xsvg(x2))+','+streel(Ysvg(y2))+','+
                 streel(Xsvg(x4))+','+streel(Ysvg(y4))+','+streel(Xsvg(x1))+','+streel(Ysvg(y1))+'"/>');
              end;
                  end;
              case mode of
              eps: begin
                        if linejoin_style<>0 then
                           exportwriteln( Streel(linejoin_style)+' setlinejoin ');
                        if linecap_style<>0 then
                                 exportwriteln(Streel(linecap_style)+' setlinecap ');
                   end;
              pgf: exportwriteln( '\pgfsetroundjoin%');
              end;
      end;
end;
{=============}
destructor t_ligne.detruire;
begin
     if PtsFleches<>nil then dispose(PtsFleches,detruire);
     t_element.detruire;
end;

var i:integer;
    r:type_liste;
Initialization;
     LesCommandes.ajouter_fin(new(PEpsCoord,init('EpsCoord')));
     LesCommandes.ajouter_fin(new(PSaveAttr,init('SaveAttr')));
     LesCommandes.ajouter_fin(new(Prestoreattr,init('RestoreAttr')));
     LesCommandes.ajouter_fin(new(PGetAttr,init('GetAttr')));
     LesCommandes.ajouter_fin(new(PSetAttr,init('SetAttr')));
     LesCommandes.ajouter_fin(new(PChangeAttr,init('ChangeAttr')));
     LesCommandes.ajouter_fin(new(PDefaultAttr,init('DefaultAttr')));
     LesCommandes.ajouter_fin(new(PWriteFile,init('WriteFile')));
     LesCommandes.ajouter_fin(new(POpenFile,init('OpenFile')));
     LesCommandes.ajouter_fin(new(PCloseFile,init('CloseFile')));
     LesCommandes.ajouter_fin(new(PFileExists,init('FileExists')));//1.96
     LesCommandes.ajouter_fin(new(PFrame,init('Border')));
     LesCommandes.ajouter_fin(new(PSpecial,init('Special')));
     LesCommandes.ajouter_fin(new(PSetMatrix,init('SetMatrix')));
     LesCommandes.ajouter_fin(new(PGetMatrix,init('GetMatrix')));
     LesCommandes.ajouter_fin(new(PAddMatrix,init('ComposeMatrix')));
     LesCommandes.ajouter_fin(new(PMtransform,init('Mtransform')));   //version 1.95
//Mtransform( liste <,matrice> ): renvoie la liste transformée par la matrice
     LesCommandes.ajouter_fin(new(PDefaultMatrix,init('IdMatrix')));

     PLineStyle:=new(Pconstante,init('LineStyle',new(Paffixe,init(0,0)),false));
     PWidth:=(new(Pconstante,init('Width',new(Paffixe,init(2,0)),false)));
     PColor:=(new(Pconstante,init('Color',new(Paffixe,init(0,0)),false)));
     PtMin:=(new(Pconstante,init('tMin',new(Paffixe,init(-5,0)),false)));
     PtMax:=(new(Pconstante,init('tMax',new(Paffixe,init(5,0)),false)));
     PNbPoints:=(new(Pconstante,init('NbPoints',new(Paffixe,init(50,0)),false)));
     PDotStyle:=(new(Pconstante,init('DotStyle',new(Paffixe,init(0,0)),false)));
     PDotAngle:=(new(Pconstante,init('DotAngle',new(Paffixe,init(0,0)),false)));
     PDotScale:=(new(Pconstante,init('DotScale',new(Paffixe,init(1,0)),false)));
     PDotSize:=(new(Pconstante,init('DotSize',new(Paffixe,init(2,2)),false)));
     PLabelstyle:=(new(Pconstante,init('LabelStyle',new(Paffixe,init(0,0)),false)));
     PArrows:=(new(Pconstante,init('Arrows',new(Paffixe,init(0,0)),false)));
     PFillStyle:=(new(Pconstante,init('FillStyle',new(Paffixe,init(0,0)),false)));
     PFillColor:=(new(Pconstante,init('FillColor',new(Paffixe,init(1,0)),false)));
     PGradStyle:=(new(Pconstante,init('GradStyle',new(Paffixe,init(1,0)),false)));
     PGradColor:=(new(Pconstante,init('GradColor',new(Paffixe,init(clwhite,clred)),false)));
     PGradAngle:=(new(Pconstante,init('GradAngle',new(Paffixe,init(0,0)),false)));
     PGradCenter:=(new(Pconstante,init('GradCenter',new(Paffixe,init(0.25,0.75)),false)));
     PAutorecalc:=(new(Pconstante,init('AutoReCalc',new(Paffixe,init(1,0)),false)));
     PLabelSize:=(new(Pconstante,init('LabelSize',new(Paffixe,init(3,0)),false)));
     PLabelAngle:=(new(Pconstante,init('LabelAngle',new(Paffixe,init(0,0)),false)));
     //Pxylabelsep:=(new(Pconstante,init('xylabelsep',new(Paffixe,init(0.105,0)),false)));
     //Pxyticks:=(new(Pconstante,init('xyticks',new(Paffixe,init(0.1,0)),false)));
     //PxylabelPos:=(new(Pconstante,init('xylabelpos',new(Paffixe,init(9,0)),false)));//left+bottom
     PPenMode:=(new(Pconstante,init('PenMode',new(Paffixe,init(0,0)),false)));
     PForMinToMax:=(new(Pconstante,init('ForMinToMax',new(Paffixe,init(0,0)),false)));
     PTeXLabel:=(new(Pconstante,init('TeXLabel',new(Paffixe,init(0,0)),false)));
     PComptGraph:=(new(Pconstante,init('ComptGraph',new(Paffixe,init(0,0)),false)));
     PComptlabel3d:=(new(Pconstante,init('ComptLabel3d',new(Paffixe,init(0,0)),false)));
     PFillOpacity:=(new(Pconstante,init('FillOpacity',new(Paffixe,init(1,0)),false)));
     PStrokeOpacity:=(new(Pconstante,init('StrokeOpacity',new(Paffixe,init(1,0)),false)));
     PIsVisible:=(new(Pconstante,init('IsVisible',new(Paffixe,init(1,0)),false)));
     PEoFill:=(new(Pconstante,init('Eofill',new(Paffixe,init(0,0)),false)));
     PLineJoin:=(new(Pconstante,init('LineJoin',new(Paffixe,init(1,0)),false)));
     PLineCap:=(new(Pconstante,init('LineCap',new(Paffixe,init(0,0)),false)));
     PMiterLimit:=(new(Pconstante,init('MiterLimit',new(Paffixe,init(10,0)),false)));
     PmouseCode:=(new(Pconstante,init('MouseCode',new(Paffixe,init(-1,0)),false)));

     Constpredefinie:=true;
     LesConstantes.ajouter_fin(new(Pconstante,init('black',new(Paffixe,init(clblack,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('white',new(Paffixe,init(clwhite,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('red',new(Paffixe,init(clred,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('green',new(Paffixe,init(rgb(0,255,0),0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('blue',new(Paffixe,init(clblue,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('yellow',new(Paffixe,init(clyellow,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('cyan',new(Paffixe,init(claqua,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('magenta',new(Paffixe,init(clFuchsia,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('gray',new(Paffixe,init(clgray,0)),false)));
     Constpredefinie:=false;

     r.init; r.ajouter_fin(new(Paffixe,init(2.5,0)));
     r.ajouter_fin(new(Paffixe,init(2,0)));
     defaultPattern:= Paffixe(r.tete);
     PDashPattern:=new(Pconstante,init('DashPattern',defaultPattern^.evaluer,false));
     LesConstantes.ajouter_fin(PDashPattern);
     r.init;
     
     LesConstantes.ajouter_fin(PLabelStyle);
     LesConstantes.ajouter_fin(PDotStyle);
     LesConstantes.ajouter_fin(PLinestyle);
     LesConstantes.ajouter_fin(Pwidth);
     LesConstantes.ajouter_fin(Pcolor);
     LesConstantes.ajouter_fin(PArrows);
     LesConstantes.ajouter_fin(PFillStyle);
     LesConstantes.ajouter_fin(PFillColor);
     LesConstantes.ajouter_fin(PGradStyle);
     LesConstantes.ajouter_fin(PGradColor);
     LesConstantes.ajouter_fin(PGradAngle);
     LesConstantes.ajouter_fin(PGradCenter);
     LesConstantes.ajouter_fin(PNbPoints);
     LesConstantes.ajouter_fin(Ptmin);
     LesConstantes.ajouter_fin(Ptmax);
     LesConstantes.ajouter_fin(PAutoReCalc);
     LesConstantes.ajouter_fin(PLabelSize);
     LesConstantes.ajouter_fin(PLabelAngle);
     //LesConstantes.ajouter_fin(Pxylabelsep);
     //LesConstantes.ajouter_fin(Pxyticks);
     //LesConstantes.ajouter_fin(Pxylabelpos);
     LesConstantes.ajouter_fin(PPenMode);
     LesConstantes.ajouter_fin(PForMinToMax);
     LesConstantes.ajouter_fin(PTeXLabel);
     LesConstantes.ajouter_fin(PFillOpacity);
     LesConstantes.ajouter_fin(PStrokeOpacity);
     LesConstantes.ajouter_fin(PComptGraph);
     LesConstantes.ajouter_fin(PComptLabel3d);
     LesConstantes.ajouter_fin(PIsVisible);
     LesConstantes.ajouter_fin(PEofill);
     LesConstantes.ajouter_fin(PLineJoin);
     LesConstantes.ajouter_fin(PLineCap);
     LesConstantes.ajouter_fin(PMiterLimit);
     LesConstantes.ajouter_fin(PDotAngle);
     LesConstantes.ajouter_fin(PDotScale);
     LesConstantes.ajouter_fin(PDotSize);
     LesConstantes.ajouter_fin(PmouseCode);

     Initialiser;
     DefaultSettings;
     ListAttr:=TList.Create;
     New(liste_enfant,init);
     WriteMode:=false;
     ListeFicMac:=TStringList.Create;
     OpenFilesList:=TStringList.Create;
     
Finalization
     ListeFicMac.Free;
     vider_liste;
     for i:=0 to ListAttr.Count-1 do Dispose(PAttr(ListAttr.items[i]));
     ListAttr.free;
     OpenFilesList.free;
     Kill(PCellule(currentPattern)); Kill(PCellule(DefaultPattern));
     Kill(PCellule(DotScale));
     dispose(liste_enfant,detruire)
End.
