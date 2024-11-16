{Copyright (C) 2005-2018 (Patrick FRADIN)
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
unit Unit1;

{$MODE Delphi}

 {unité principale}

interface
Uses
  SysUtils,Classes,LcLType,LclIntf,
  
      Graphics, Controls, Forms,
      StdCtrls, ExtCtrls, ComCtrls, Menus, Dialogs,
      LazHelpHTML,HelpIntfs, BGRAbitmaptypes, BGRABitmap, //BGRAPAth,

  calculs1, listes2, complex3, analyse4, command5, command53d, graph1_6,
  graph2_7, command9, command10, LResources, Buttons, SynHighlighterAny, SynHighlighterAny2,
  gettext,untres,translations;

type

  { TMainForm }

  TMainForm = class(TForm)
    Arc: TToolButton;
    Chargerdesmacros1: TMenuItem;
    Cercle: TToolButton;
    Enregistrer: TMenuItem;
    EnregistrerSous: TMenuItem;
    ExporterenEPS: TMenuItem;
    ExporterenLatex: TMenuItem;
    ExporterenPgf1: TMenuItem;
    ExporterenPsTricks: TMenuItem;
    ExporterenPdf: TMenuItem;
    Fichier1: TMenuItem;
    fond: TImage;
    HTMLBrowserHelpViewer1: THTMLBrowserHelpViewer;
    HTMLHelpDatabase1: THTMLHelpDatabase;


    Importerunmodle1: TMenuItem;
    Label1: TLabel;
    Memo1: TMemo;
    Edition: TMenuItem;
    Annuler: TMenuItem;
    ExporterenObj: TMenuItem;
    ExporterenJvx: TMenuItem;
    CircleArc: TMenuItem;
    ExporterSrcToTeX: TMenuItem;
    ExporterenJs: TMenuItem;
    Mouse_Doc: TMenuItem;
    TeXgraph_Doc: TMenuItem;
    Models_Doc: TMenuItem;
    MisesAJourModeles: TMenuItem;
    MisesAJourLogiciel: TMenuItem;
    MisesAjourModelesLogiciel: TMenuItem;
    N9: TMenuItem;
    OuvrirForum: TMenuItem;
    Menushowlabelanchor: TMenuItem;
    MenuItem2: TMenuItem;
    Editer: TMenuItem;
    LeftColumn: TMenuItem;
    MenuItem3: TMenuItem;
    docpdf: TMenuItem;
    MenuItem4: TMenuItem;
    fichierconfig: TMenuItem;
    ExporterenGeom: TMenuItem;
    N11: TMenuItem;
    optionCamera: TMenuItem;
    PaintBox1: TPaintBox;
    projOrtho: TMenuItem;
    projCentrale: TMenuItem;
    Refaire: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Nouveau1: TMenuItem;
    Ouvrir: TMenuItem;
    Quitter: TMenuItem;
    Panel1: TScrollBox;
    ScrollBox1: TScrollBox;
    StopButton: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Parametres: TMenuItem;
    Afficherlesvariableslcran: TMenuItem;
    N5: TMenuItem;
    Commentaires: TMenuItem;
    N6: TMenuItem;
    Marge: TMenuItem;
    Fenetre: TMenuItem;
    Creer: TMenuItem;
    Macros1: TMenuItem;
    SynAnySyn1: TSynAnySyn;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolWebGL: TToolButton;
    Toolgeomview: TToolButton;
    ToolJavaview: TToolButton;
    ToolButton49: TToolButton;
    ToolButton8: TToolButton;
    Intersection: TToolButton;
    ToolCursTourne: TToolButton;
    ToolCursNormal: TToolButton;
    ToolCursSelect: TToolButton;
    ToolCursDeplace: TToolButton;
    ToolZoomIn: TToolButton;
    Ellipse: TToolButton;
    Varglobs: TMenuItem;
    Elementsgraphiques: TMenuItem;
    Utilisateur: TMenuItem;
    Surface: TMenuItem;
    Label2: TMenuItem;
    EllipticArc: TMenuItem;
    EllipseCercle: TMenuItem;
    Lignepolygonale: TMenuItem;
    Points: TMenuItem;
    Droite: TMenuItem;
    Courbes: TMenuItem;
    Splinecubique: TMenuItem;
    Bezier: TMenuItem;
    Implicite: TMenuItem;
    Equadiff: TMenuItem;
    Parametrique: TMenuItem;
    Axes: TMenuItem;
    Grille: TMenuItem;
    Aide1: TMenuItem;
    Apropos1: TMenuItem;
    N7: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    opBordure: TMenuItem;
    opCouleurs: TMenuItem;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    GroupBox2: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    ListBox2: TListBox;
    Button5: TButton;
    GroupBox3: TGroupBox;
    Button6: TButton;
    Button7: TButton;
    ListBox3: TListBox;
    Button8: TButton;
    ToolBar1: TToolBar;
    ComboBox1: TComboBox;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    toolSnapshot: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolZoomOut: TToolButton;
    ToolButton27: TToolButton;
    Button10: TButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ExporterenPsf: TMenuItem;
    CheckBox1: TCheckBox;
    ComboBox2: TComboBox;
    Chargerunfond1: TMenuItem;
    Supprimerlefond1: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    ComboBox3: TComboBox;
    ToolButton36: TToolButton;
    Button9: TButton;
    Rouvrir1: TMenuItem;
    Cartesienne: TMenuItem;
    Polaire: TMenuItem;
    ToolButton39: TToolButton;
    RightColumn: TMenuItem;
    Timer1: TTimer;
    ToolBar2: TToolBar;
    AutresElements2D: TMenuItem;
    AutresElements3D: TMenuItem;
    ToolBar4: TToolBar;
    ToolButton35: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    ToolButton43: TToolButton;
    ToolButton44: TToolButton;
    ToolButton45: TToolButton;
    ToolButton46: TToolButton;
    ToolButton47: TToolButton;
    ToolButton48: TToolButton;
    ToolButton34: TToolButton;
    ToolButton50: TToolButton;
    ToolButton51: TToolButton;
    ToolButton52: TToolButton;
    ToolButton53: TToolButton;
    ToolButton54: TToolButton;
    ToolButton55: TToolButton;
    ToolButton56: TToolButton;
    ToolButton57: TToolButton;
    ToolButton58: TToolButton;
    ToolButton59: TToolButton;
    ToolButton60: TToolButton;
    ToolButton61: TToolButton;
    ToolButton62: TToolButton;
    ToolReCalc: TToolButton;
    ToolButton64: TToolButton;
    ToolButton65: TToolButton;
    ToolButton66: TToolButton;
    ToolButton67: TToolButton;
    ToolButton68: TToolButton;
    ToolButton69: TToolButton;
    ToolButton70: TToolButton;
    ToolLoadMouse: TToolButton;
    ExporterenSvg: TMenuItem;
    ExporterenEpsc: TMenuItem;
    ExporterenPdfc: TMenuItem;
    Chemin: TMenuItem;
    ToolButton76: TToolButton;
    EllipseArc: TToolButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Exporterentikz1: TMenuItem;
    ChangerRepere: TMenuItem;
    ActiveCurs: TToolButton;

    procedure ClicReCentFile(Sender: TObject);
    procedure ClicMacroGraph(Sender: TObject);
    procedure ComboBox2Enter(Sender: TObject);
    procedure ComboBox2Exit(Sender: TObject);
    procedure EditerClick(Sender: TObject);
    procedure EllipseArcClick(Sender: TObject);
    procedure EllipseClick(Sender: TObject);
    procedure ExporterenJsClick(Sender: TObject);
    procedure ExporterenJvxClick(Sender: TObject);
    procedure ExporterSrcToTeXClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Mouse_DocClick(Sender: TObject);
    procedure MenushowlabelanchorClick(Sender: TObject);
    procedure MisesAJourLogicielClick(Sender: TObject);
    procedure MisesAjourModelesClick(Sender: TObject);
    procedure Models_DocClick(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure ExporterenGeomClick(Sender: TObject);
    procedure LeftColumnClick(Sender: TObject);
    procedure ListBox2MouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox2MouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox3MouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox3MouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuDefaireClick(Sender: TObject);
    procedure ExporterenObjClick(Sender: TObject);
    procedure MenuRefaireClick(Sender: TObject);
    procedure OuvrirForumClick(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure OuvrirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PaintBox1Paint(Sender: TObject);
    procedure QuitterClick(Sender: TObject);
    procedure ScrollBox1Click(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure TeXgraph_DocClick(Sender: TObject);

    procedure ToolAnnuleZoomDeplace(Sender: TObject);
    procedure CursNormalClick(Sender: TObject);
    procedure IntersectionClick(Sender: TObject);
    procedure ToolgeomviewClick(Sender: TObject);
    procedure ToolJavaviewClick(Sender: TObject);
    procedure ToolWebGLClick(Sender: TObject);
    procedure ToolLabelDot3D(Sender: TObject);
    procedure ToolZoomInClick(Sender: TObject);
    procedure fichierconfigClick(Sender: TObject);
    procedure gererBoutons(Sender: TObject);
    procedure gererTRackBar(Sender: TObject);

    procedure EnregistrerClick(Sender: TObject);
    procedure EnregistrerSousClick(Sender: TObject);
    procedure Nouveau1Click(Sender: TObject);
    procedure ExporterenLatexClick(Sender: TObject);
    procedure ExporterenPsTricksClick(Sender: TObject);
    procedure ExporterenEPSClick(Sender: TObject);
    procedure ExporterenPdfClick(Sender: TObject);
    procedure ExporterenPsfClick(Sender: TObject);
    procedure ExporterenPgf1Click(Sender: TObject);

    procedure ToolCopierColler(Sender: TObject); //copie presse-papier

    procedure Importerunmodle1Click(Sender: TObject);
    procedure Chargerdesmacros1Click(Sender: TObject);

    procedure Chargerunfond1Click(Sender: TObject);
    procedure Supprimerlefond1Click(Sender: TObject);

    procedure FenetreClick(Sender: TObject);
    procedure MargeClick(Sender: TObject);
    procedure opBordureClick(Sender: TObject);
    procedure opCouleursClick(Sender: TObject);
    procedure AfficherlesvariableslcranClick(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure VarglobsClick(Sender: TObject);
    procedure Macros1Click(Sender: TObject);

    procedure Button1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox2KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure ListBox3KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure GrilleClick(Sender: TObject);
    procedure AxesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ParametriqueClick(Sender: TObject);
    procedure CartesienneClick(Sender: TObject);
    procedure PolaireClick(Sender: TObject);
    procedure UtilisateurClick(Sender: TObject);
    procedure PointsClick(Sender: TObject);
    procedure DroiteClick(Sender: TObject);
    procedure CercleClick(Sender: TObject);
    procedure SplinecubiqueClick(Sender: TObject);
    procedure BezierClick(Sender: TObject);
    procedure ImpliciteClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure LignepolygonaleClick(Sender: TObject);
    procedure ArcClick(Sender: TObject);
    procedure EquadiffClick(Sender: TObject);
    procedure SurfaceClick(Sender: TObject);

    procedure CommentairesClick(Sender: TObject);

    procedure ToolSelectZoom(Sender: TObject);
    procedure ToolZoomOutClick(Sender: TObject);
    procedure ToolRecalculer(Sender: TObject);
    procedure ToolThetaPhi(Sender: TObject);
    procedure ToolFlecheGauche(Sender: TObject);
    procedure ToolFlecheDroite(Sender: TObject);
    procedure ToolFlecheHaut(Sender: TObject);
    procedure ToolFlecheBas(Sender: TObject);

    procedure ComboBox2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ToolApercu(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PaintBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure optionCameraClick(Sender: TObject);
    procedure projCentraleClick(Sender: TObject);
    procedure projOrthoClick(Sender: TObject);
    procedure snapshotClick(Sender: TObject);
    procedure RightColumnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ToolMouse(Sender: TObject);
    procedure ToolParallele(Sender: TObject);
    procedure ToolPerpendiculaire(Sender: TObject);
    procedure ToolMediatrice(Sender: TObject);
    procedure ToolBissectrice(Sender: TObject);
    procedure ToolLabelDot2D(Sender: TObject);
    procedure ToolParallelogramme(Sender: TObject);
    procedure ToolRectangle(Sender: TObject);
    procedure ToolCarre(Sender: TObject);
    procedure ToolPolygoneReg(Sender: TObject);
    procedure ToolAngleDroit(Sender: TObject);
    procedure ToolGradDroite(Sender: TObject);
    procedure ToolMarkSeg(Sender: TObject);
    procedure ToolMarkAngle(Sender: TObject);
    procedure ToolDdroite(Sender: TObject);
    procedure ToolAxes3d(Sender: TObject);
    procedure ToolCourbe3d(Sender: TObject);
    procedure ToolCone(Sender: TObject);
    procedure ToolCylindre(Sender: TObject);
    procedure ToolSphere(Sender: TObject);
    procedure ToolParallelep(Sender: TObject);
    procedure ToolTetra(Sender: TObject);
    procedure ToolReLoad(Sender: TObject);
    procedure ToolDroite3D(Sender: TObject);
    procedure ToolLigne3D(Sender: TObject);
    procedure ToolPlan3d(Sender: TObject);
    procedure ToolPyramide(Sender: TObject);
    procedure ToolPrisme(Sender: TObject);
    procedure ToolCercle3D(Sender: TObject);
    procedure ToolArc3D(Sender: TObject);
    procedure ToolDeplacer(Sender: TObject);
    procedure ToolMove3D(Sender: TObject);
    procedure ExporterenSvgClick(Sender: TObject);
    procedure ExporterenEpscClick(Sender: TObject);
    procedure ExporterenPdfcClick(Sender: TObject);
    procedure CheminClick(Sender: TObject);
    procedure Exporterentikz1Click(Sender: TObject);
    procedure ChangerRepereClick(Sender: TObject);
  private
    { Déclarations privées }
      //fileChanged:boolean;
      moveListBox1 : Boolean;
      ComboBox2Active: Boolean;
      OldItem : Integer;
      //ZoomAv,
      beginZoom:boolean;
      x1,y1,x2,y2:real; //pour les zooms
      //DeplaceGraphique,
      BeginDeplace: boolean; //déplacer le graphique à la souris
      pixX1, pixY1, pixX2, pixY2: integer; //dépacement du graphique
      //TournerGraphique,
      BeginTourner: boolean; //faire touner (3D) à la souris
      deplaceElemGraph: boolean; //deplacement d'un élément graphique dans la liste
      scale_scr:real; //echelle écran

      procedure AfficherTaille;
      procedure Sauvegarder(sous:boolean);
      procedure Clean; //à chaque nouveau fichier;
      procedure NewAction(thetype, theowner:byte; theinfo:tlist);
      procedure execMacro(const nom:string; x,y:integer);
      function execCommande(const commande:string): boolean;
      procedure AddMacroGraph;
      procedure load;
      function unload:boolean;
      procedure detruireItemBoutons;
      procedure AjouterModifierVarGlob(p:PVarGlob);
      procedure AjouterModifierMacro(p:Pmacros);
      procedure ChargerGraph;
      procedure ChargerVarG;
      procedure ChargerMac;
      procedure ModifierGraph(index:integer);
      procedure TranslateVisual;
  public
    sourisDown:boolean;
    { Déclarations publiques }
    procedure AddRecentFile;
    procedure CleanRecentFile(const nom:string);
    procedure AfficherModifie;
    function lire_fichier(Const fichier: string):boolean;
    function GestionAttributs(const objet:string):boolean;
    procedure ReCalculer(tous: boolean); //encapsule la procédure recalculer de l'unité command10 dans un thread
    procedure MiseAjour;
    procedure AfficherVarGlob;
    function MyInputQuery(const Acaption,Aprompt:string; var chaine:String):boolean;
    function GetOpenFile( const Titre, Filtre, Ext:string; var Nom: TFileName):boolean;
    function GetSaveFile( const Titre, Filtre, Ext:string; var Nom: TFileName):boolean;
    procedure Loadfond;
    procedure exporter(mode:byte;const fichier:string);
    procedure dessiner;
    procedure AjouterModifierElement(p: Pelement; const DefaultName, DefaultCommand :string);
    procedure ValiderSaisieMacro(nouveau:boolean);
    procedure ValiderSaisieGraph(nouveau:boolean);
    procedure AfficherMessage(const titre, chaine:string);
    procedure aide_pdf(dossier:string);
  end;

 TMyItem= Class(Tobject)
                 macro: string;
                 statut:byte;

                Constructor Create(Amacro: string);
                procedure execMacro;virtual;
                destructor Destroy;override;
                end;

 PMyBouton=^TMyBouton;
 TMyBouton= object(TCellule)

               macro: string;
               statut:byte;
               Bouton:TButton;

                Constructor Init(Aparent: TWinControl; AnId:integer;
                            Atext, Amacro: string; posX,posY,long,haut:integer; const AHint: string);
                procedure execMacro;virtual;
                destructor detruire;virtual;
                end;

 PMyTrackBar=^TMyTrackBar;
 TMyTrackBar= object(TCellule)

               variable: string;
               statut:byte;
               TrackBar:TTrackBar;

                Constructor Init(Aparent: TWinControl; AnId:integer;
                            Avar: string; posX,posY,long,haut:integer; min,max:longint; const AHint: string);
                procedure changeVar;virtual;
                destructor detruire;virtual;
                end;

 PMyLabel=^TMyLabel;
 TMyLabel= object(TCellule)

               statut:byte;
               Alabel:TLabel;

                Constructor Init(Aparent: TWinControl; const Atext:string; posX,posY:integer);
                destructor detruire;virtual;
                end;
                
 LAction=record
           Atype:byte; //1=création 2=suppression
           AOwner: byte; //1=graph 2=var 3=mac
           Canceled:boolean; //true=annulé false=non annulé
           donnees: Tlist;
         end;
 Taction=^Laction;
 
function AskSave:boolean;
procedure LoadFile;

var
  MainForm: TMainForm;
  CurrentGraph:Pelement;
  CurrentVarGlob:PVarGlob;
  CurrentName:Tnom;
  CurrentMac:Pmacros;
  CurrentCat:integer;
  CurrentDir,CurrentFile: string;
  ListeBoutons, ListeLabels, ListeTRackBar:Pliste;
  PAngleStep: Pconstante;
  UserAction: Tlist;
  
  Canevas:Tcanvas;
  ComptMouse:word;
  DefaultFont:TFont;//fonte système par défaut
  EditDefaultFont:TFont;//fonte par défaut pour les fenêtres de saisies
  VisibleGraph: boolean;

implementation

uses
     //BGRAbitmaptypes,BGRABitmap,
     Fenetre, Marges, Editeur, Attributs,
     SnapShot,
     Input, Apropos, PressePap, ClipBrd, camera, strutils, config, message, update13;
Type
  TMyThread = class(TThread)
  protected
    procedure Execute; override;
  public
    proc : procedure;
    Constructor Create(CreateSuspended : boolean);
    procedure myrep;
  end;

var CalculAll, CalculusDone :boolean;

constructor TMyThread.Create(CreateSuspended : boolean);
begin
      FreeOnTerminate := True;
      inherited Create(CreateSuspended);
end;

procedure TMyThread.Myrep;
begin
      CalculusDone:=true
end;

procedure TMyThread.Execute;
begin
   proc; //exécute la procédure
   Synchronize(Myrep)
end;

{=========================================================}
function modulo2Pi(x:real):real;
begin
      Result:=x;
      while result>pi do result:=result-2*pi;
      while result<=-pi do result:=result+2*pi;
end;
{=============================== TMyItem =================}
procedure TMainForm.ComboBox1Change(Sender: TObject);
var index:integer;
begin
     index:= ComboBox1.ItemIndex;
     if index>-1 then
        TMyItem(Combobox1.Items.Objects[index]).ExecMacro;
end;
{=============================}
constructor TMyItem.Create;
begin
     inherited Create;
     statut:=MacroStatut;
     macro:=Amacro
end;
{=============================}
procedure TMyItem.execMacro;
var f:Pexpression;
    res:Presult;
begin
     New(f,init);
     if f^.definir(macro)
      then begin
           //FoncSpeciales:=true;
           res:=f^.evaluer;
           if res<>nil then listes2.Kill(Pcellule(res));
           //FoncSpeciales:=false;
           end;
      dispose(f,detruire);
end;
{===========================}
destructor TMyItem.Destroy;
begin
      inherited Destroy;
end;
{=========================== gestion des boutons =============================}
procedure TMainForm.gererBoutons(Sender: TObject);
var aux:PMyBouton;
begin
          aux:=PMyBouton(ListeBoutons^.tete);
          while (aux<>nil) and (aux^.bouton.Name<>TButton(Sender).Name) do
          aux:=PMybouton(aux^.suivant);
          if aux<>nil then aux^.ExecMacro;
end;
{======================}
constructor TMyBouton.Init(Aparent: TWinControl; AnId:integer;
                            Atext, Amacro: string; posX,posY,long,haut:integer; const AHint: string);
begin
     Tcellule.init;
     statut:=MacroStatut;
     bouton:=TButton.Create(Aparent);
     //MainForm.Panel1.InsertControl(bouton);
     bouton.ParentFont:=true;
     bouton.name:='MyButton'+IntToStr(AnId);
     bouton.Parent:=AParent;
     bouton.Caption:=AText;
     //bouton.Color:=clbutton;
     bouton.Left:=PosX;
     bouton.Top:=PosY;//+Mainform.ToolBar1.Height+4;
     bouton.Width:=long;
     bouton.Height:=haut;
     bouton.visible:=true;
     bouton.OnClick:= MainForm.gererBoutons;
     bouton.Hint:=AHint;
     macro:=Amacro
end;
{=============================}
procedure TMybouton.execMacro;
var f:Pexpression;
    res:Presult;
begin
     New(f,init);
     if f^.definir(macro)
      then begin
           //FoncSpeciales:=true;
           res:=f^.evaluer;
           if res<>nil then listes2.Kill(Pcellule(res));
           //FoncSpeciales:=false;
           end;
      dispose(f,detruire);
      MainForm.MiseaJour
end;
{===========================}
Destructor TMyBouton.detruire;
begin
      //MainForm.Panel1.RemoveControl(bouton);
      bouton.Parent:=nil;
      Bouton.free;
end;
{=========================== gestion TrackBar =============================}
procedure TMainForm.gererTrackBar(Sender: TObject);
var aux:PMyTrackBar;
begin
          aux:=PMyTrackBar(ListeTRackBar^.tete);
          while (aux<>nil) and (aux^.TRackBar.Name<>TTRackBar(Sender).Name) do
          aux:=PMyTRackBar(aux^.suivant);
          if aux<>nil then aux^.changeVar;
end;
{======================}
constructor TMyTrackBar.Init(Aparent: TWinControl; AnId:integer;
                            Avar: string; posX,posY,long,haut:integer; min,max:longint; const AHint: string);
begin
     Tcellule.init;
     TrackBar:=TTrackBar.Create(Aparent);
     statut:=MacroStatut;
     //TrackBar.ParentFont:=true;
     TrackBar.name:='MyTrackBar'+IntToStr(AnId);
     TrackBar.Parent:=AParent;
     TrackBar.min:=min; TrackBar.max:=max;
     TrackBar.position:=min;
     TrackBar.Caption:=Avar;
     TrackBar.Left:=PosX;
     TrackBar.Top:=PosY;//+Mainform.ToolBar1.Height+4;
     TrackBar.Width:=long;
     TrackBar.Height:=haut;
     TrackBar.visible:=true;
     TrackBar.OnChange:= MainForm.gererTrackBar;
     TrackBar.Hint:=AHint;
     variable:=Avar
end;
{=============================}
procedure TMyTrackBar.changeVar;
var f:Pexpression;
    res:Presult;
begin
     New(f,init);
     if f^.definir('['+variable+':='+FloatToStr(TrackBar.position)+',ReCalc()]')
      then begin
           //FoncSpeciales:=true;
           res:=f^.evaluer;
           if res<>nil then listes2.Kill(Pcellule(res));
           //FoncSpeciales:=false;
           end;
      dispose(f,detruire);
      MainForm.MiseaJour
end;
{===========================}
Destructor TMyTrackBar.detruire;
begin
      //MainForm.Panel1.RemoveControl(bouton);
      TrackBar.Parent:=nil;
      TrackBar.free;
end;

{===================== gestions labels colonne gauche  =====================}
constructor TMyLabel.Init(Aparent: TWinControl; const  Atext: string; posX,posY:integer);
begin
     Tcellule.init;
     statut:=MacroStatut;
     Alabel:=TLabel.Create(Aparent);
     Alabel.ParentFont:=true;
     Alabel.Parent:=AParent;
     Alabel.Caption:=AText;
     Alabel.Left:=PosX;
     Alabel.Top:=PosY;
end;
{===========================}
Destructor TMyLabel.detruire;
begin
      Alabel.Parent:=nil;
      Alabel.free;
end;
{============================= gestion status Bar ==============================}
procedure TMainForm.AfficherTaille;
begin
     StatusBar1.Panels[2].Text:=TgLargeur+Streel(Round(100*((Xmax-Xmin)*Xscale+margeG+margeD))/100)+' cm';
     StatusBar1.Panels[3].Text:=TgHauteur+Streel(Round(100*((Ymax-Ymin)*Yscale+margeH+margeB))/100)+' cm';
end;

procedure TMainForm.AfficherModifie;
begin
     If FileChanged then begin
                              StatusBar1.Panels[4].Text:=TgModified;
                          end
                    else begin
                              StatusBar1.Panels[4].Text:='';
                         end;
end;
{============================= Gestion des fichiers ==============}
function TMainForm.lire_fichier(Const fichier: string):boolean;
begin
     result:=LireFichier(fichier);
     if not result then exit;
     AddMacroGraph; ChargerGraph; ChargerVarG; ChargerMac;
 end;
 {=====================}
function TMainForm.GetOpenFile( const Titre, Filtre, Ext:string; var Nom: TFileName):boolean;
begin
     OpenDialog1.Title:=Titre;
     OpenDialog1.DefaultExt:=Ext;
     OpenDialog1.Options:=OpenDialog1.Options+[ofFileMustExist];
     OpenDialog1.Filter := Filtre+'|'+Ext;
     OpenDialog1.FileName:=ExtractFileName(Nom);
     OpenDialog1.InitialDir:=ExtractFilePath(Nom);
     if OpenDialog1.Execute
        then begin
                        GetOpenFile:=true;
                        Nom:=OpenDialog1.FileName;
             end
        else GetOpenFile:=false;
end;
{===============}
function TMainForm.GetSaveFile( const Titre, Filtre, Ext:string; var Nom: TFileName):boolean;
begin
     SaveDialog1.Title:=Titre;
     SaveDialog1.DefaultExt:=Ext;
     SaveDialog1.Filter := Filtre+' (*.'+Ext+')|*.'+Ext;
     SaveDialog1.FileName:=ExtractFileName(Nom);
     SaveDialog1.InitialDir:=ExtractFilePath(Nom);
     SaveDialog1.Options:=SaveDialog1.Options+[ofOverwritePrompt];
     if SaveDialog1.Execute
        then begin GetSaveFile:=true; Nom:=SaveDialog1.FileName end
        else GetSaveFile:=false;
end;
{===============}
procedure TMainForm.Sauvegarder(sous: boolean);
var fichier:file;
    taille: int64;
begin
     if (FileName='') or sous
        then if GetSaveFile(TgSaveAs,TgSourceFile,'teg',fileName)
                then Caption:='TeXgraph '+calculs1.version+' - '+FileName;
        if FileName<>'' then
        begin
        //assignFile(f,FileName);
        CleanRecentfile(FileName);
        CurrentDir:=ExtractFilePath(fileName);
        chdir(Currentdir);
        if FileExists(fileName) then
           begin
               assignfile(fichier,filename);
               reset(fichier); taille:= filesize(fichier);
               closefile(fichier);
               if taille>0 then
                  RenameFile(filename, changeFileExt(filename,'.bak'))
           end;
        //Cursor:=crHourGlass;
        enregistrer_elements(teg,false,FileName);
        //Cursor:=crdefault;
        filechanged:=false;
        AfficherModifie
        end
end;
{=======================}
procedure TMainForm.MisesAjourModelesClick(Sender: TObject);
begin
     if not AskSave then exit;
     AddRecentFile; FileName:='';
     Caption:='TeXgraph '+calculs1.version+' - *.teg';
     Filechanged:=false; Yafond:=false; YaDrawBitmap:=false;
     Clean;
     ExecCommande('InputMac("update.mac")');
     dessiner
end;

procedure TMainForm.aide_pdf(dossier:string);
var Nom:TfileName;
    Nom2:string;
begin
    Nom:=dossier+'*.pdf';
    if GetOpenFile('Documentation',TgPdfFile,'*.pdf',Nom)
    and (Nom<>'') then
        begin
             Nom2 := ExtractFileName(Nom);
             Nom2 := Copy(Nom2, 1,length(Nom2)-length(ExtractFileExt(Nom)));
             ExecCommande('help('+Nom2+')'); //macro help d'Interface.mac
        end;
end;

procedure TMainForm.TeXgraph_DocClick(Sender: TObject);
var Nom:TfileName;
begin
    ExecCommande('help(TeXgraph-fr)');
end;

procedure TMainForm.Mouse_DocClick(Sender: TObject);
begin
     ExecCommande('help(Mouse)');
end;

procedure TMainForm.Models_DocClick(Sender: TObject);
var Nom:TfileName;
    Nom2:string;
begin
    aide_pdf(UserMacPath)
end;

procedure TMainForm.MisesAJourLogicielClick(Sender: TObject);
begin
     if not AskSave then exit;
     AddRecentFile; FileName:='';
     Caption:='TeXgraph '+calculs1.version+' - *.teg';
     Filechanged:=false; Yafond:=false; YaDrawBitmap:=false;
     Clean;
     ExecCommande('[InputMac("updateTeXgraph.mac"),updateTeXgraph()]');
     dessiner
end;
{=======================}
procedure TMainForm.fichierconfigClick(Sender: TObject);
begin
     ConfigFile:=TconfigFile.create(self);
     ConfigFile.showModal;
     ConfigFile.free
end;
{=======================}
procedure TMainForm.AddRecentFile;//ajoute le fichier courant à l'historique
var item: TmenuItem;
begin
      if FileName='' then exit;
      with MainMenu1.Items[0].Items[2] do
        begin
            item:=TmenuItem.Create(self);
            item.Caption:=FileName;
            item.OnClick:=ClicReCentFile;
            Insert(0,item);
            if Count>10 then delete(9);
        end;
end;
{=======================}
procedure TMainForm.CleanRecentFile(const nom:string);//efface le nom de l'historique
var i:integer;
    aux:string;
begin
        with MainMenu1.Items[0].Items[2] do
                  begin
                       i:=0;
                       while i<Count do
                        begin
                                aux:=Items[i].Caption;
                                system.delete(aux,pos('&',aux),1);
                                if nom=aux then Delete(i) else inc(i)
                        end;
                  end;
end;
{=======================}
procedure TMainForm.AddMacroGraph;
var item: TmenuItem;
     numItem:byte;
     k:integer;
begin

      for k:=0 to mac2d.Count-1 do
         begin
              numitem:=1;
              with MainMenu1.Items[3].Items[numitem] do
              begin
                   item:=TmenuItem.Create(self);
                   item.Caption:=mac2d.Strings[k];
                   item.OnClick:=ClicMacroGraph;
                   Insert(Count,item);
              end;
         end;

      for k:=0 to mac3d.Count-1 do
         begin
              numitem:=2;
              with MainMenu1.Items[3].Items[numitem] do
              begin
                   item:=TmenuItem.Create(self);
                   item.Caption:=mac3d.Strings[k];
                   item.OnClick:=ClicMacroGraph;
                   Insert(Count,item);
              end;
         end;

      mac2d.clear; mac3d.clear
end;
{=====================}
procedure TMainForm.ClicMacroGraph(Sender: TObject);
var nom:string;
begin
  with Sender as Tmenuitem do
        begin
                Nom:=Caption;
                system.delete(nom,pos('&',nom),1);
                DefaultSettings;
                execCommande('\'+Copy(nom,1,pos(' ',nom)-1) )
        end;
end;


procedure TMainForm.ComboBox2Enter(Sender: TObject);
begin
  ComboBox2Active:=True;
  //ShowMessage('active!')
end;

procedure TMainForm.ComboBox2Exit(Sender: TObject);
begin
    ComboBox2Active:=False;
    //ShowMessage('désactive!')
end;

{=====================}
function AskSave:boolean;
var reply:integer;
begin
        result:=true;
        With MainForm do
        if fileChanged then
               begin
                     reply:=MessageDlg(TgAskSaveFile+' '+FileName+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
                     if reply=mrYes then  sauvegarder(false)
                                    else if reply=mrCancel then result:=false;
               end;
end;
{==================}
procedure LoadFile;
var oldcurs:Tcursor;
begin
        With MainForm do
             begin
                 Clean;
                 oldcurs:=PaintBox1.Cursor;
                 PaintBox1.Cursor:=crHourGlass;
                 dessiner;
                 if not lire_fichier(FileName)
                      then MessageDlg(TgDataError+' '+FileName,mtWarning,[mbOk],0);
                 Caption:='TeXgraph '+calculs1.version+' - '+ filename;
                 opbordure.checked:=cadre;
                 opCouleurs.checked:= gestion_couleur;
                 if centrale then
                    begin
                         projortho.checked:=false;
                         projCentrale.checked:=true;
                         optionCamera.Enabled:=true;
                    end
                    else
                    begin
                         projOrtho.checked:=true;
                         projCentrale.checked:=false;
                         optionCamera.Enabled:=false;
                    end;
                 FileChanged:=false;
                 dessiner;
                 PaintBox1.Cursor:=oldcurs;
             end;
end;
{=========================}
procedure TMainForm.NewAction(thetype, theowner:byte; theinfo:tlist);
var action: Taction;
begin
     //theinfo.free; exit;
     Action:=New(Taction);
     action.Atype:=thetype;
     action.AOwner:=theowner;
     action.Canceled:=false;
     action.donnees:=theinfo;
     UserAction.Insert(0,action)
end;
{=========================}
procedure TMainForm.Clean;
var i,j:integer;
    action:Taction;
begin

     for i:=0 to UserAction.Count-1 do
         begin
              action:=UserAction.Items[i];
              for j:=0 to action.donnees.Count-1 do
                 case action.AOwner of
                 2: if  varglob(Pvarglob(action.donnees.Items[j])^.variable^.nom)=nil
                    then
                     begin
                          dispose(Pvarglob(action.donnees.Items[j])^.variable,detruire);
                          dispose(action.donnees.Items[j])
                     end;
                     
                 1: if Trouver(Pelement(action.donnees.Items[j])^.nom,@liste_element)=nil
                       then dispose(Pcellule(action.donnees.Items[j]),detruire);
                       
                 3: if Macros(Pmacros(action.donnees.Items[j])^.nom)=nil
                       then dispose(Pcellule(action.donnees.Items[j]),detruire);
                 end;
              action.donnees.free;
              dispose(action);
         end;
     UserAction.Clear;
     detruireItemBoutons;            // boutons et textes
     finalisation //dans command10
end;
{=========================}
procedure TMainForm.ToolReLoad(Sender: TObject); //recharger le fichier
begin
      FileChanged:=true;
      if AskSave and (FileName<>'') then LoadFile;
end;
{=====================}
procedure TMainForm.OuvrirClick(Sender: TObject);
var nom:TfileName;
begin
     {$IFDEF Unix}
     nom:=CurrentDir;//+'/*.teg';
     if nom[length(nom)]<>'/' then nom:=nom+'/';
     {$ENDIF}
     {$IFDEF windows}
     nom:=CurrentDir;//+'\*.teg';
     if nom[length(nom)]<>'\' then nom:=nom+'\';
     {$ENDIF}
     if AskSave and GetOpenFile(TgOpenAFile,TgSourceFile+' (*.teg)','*.teg',nom)
        then begin
                AddRecentFile;
                FileName:=nom;
                CleanRecentFile(nom);
                CurrentDir:=ExtractFilePath(nom);
                ChDir(CurrentDir);
                LoadFile
             end;
end;
{=======================}
procedure TMainForm.EnregistrerClick(Sender: TObject);
begin
     Sauvegarder(false)
end;
{========================}
procedure TMainForm.EnregistrerSousClick(Sender: TObject);
begin
     Sauvegarder(true)
end;
{=====================}
procedure TMainForm.Nouveau1Click(Sender: TObject);
begin
      if not AskSave then exit;
      AddRecentFile;
      FileName:='';
      Caption:='TeXgraph '+calculs1.version+' - *.teg';
      Filechanged:=false;
      Yafond:=false; YaDrawBitmap:=false;
      Clean;
      graph1_6.fenetre(-5,-5,5,5,1,1);
      graph1_6.marges(0.5,0.5,0.5,0.5);
      Dispose(Matrix3d); Matrix3d:=Nil;
      CurrentMatrix:=DefaultMatrix;
      DefaultSettings;
      //AfficherTaille;
      ChangeGraph:=true;ChangeVarG:=true;ChangeMac:=true;
      dessiner;
end;
{==========================}
procedure TMainForm.Loadfond;
var longX, longY, ratio: real;
     OkLoad:boolean;
begin
      Try
         fond.picture.LoadFromFile(FondName);
         OKLoad:=true;
      Except
          ShowMessage(TgErrorWhileReading+' '+Fondname);
          okload:=false;
      end;
      if okload then
      begin
           ratio:=fond.picture.Width/fond.picture.Height;
           longX:=Xmax-Xmin; longY:=Ymax-Ymin;
           if ratio>1 then longY:=longX/ratio else longX:=longY*ratio;
           graph1_6.Fenetre(Xmin,Ymin, Xmin+longX,Ymin+longY,Xscale,Yscale);
           FondLarge:=Xmax-Xmin; fondHaut:=Ymax-Ymin;
           fondOrigX:=Xmin; fondOrigY:=Ymax;
           YaFond:=true;
           fileChanged:=true;
           dessiner;
      end;
end;
{==========================}
procedure TMainForm.Chargerunfond1Click(Sender: TObject);
begin
      if GetOpenFile(TgOpenBackground,TgPictureFile+' (jpeg, bmp, png)','*.jpg;*.bmp;*.png',FondName)
        then LoadFond;
end;
{==========================}
procedure TMainForm.Supprimerlefond1Click(Sender: TObject);
begin
      if Yafond then
        begin
                Yafond:=false;
                fileChanged:=true;
                dessiner;
        end;
end;
{==========================}
procedure TMainForm.exporter(mode:byte; const fichier:string);
var  chemin, aux, titre,filtre,ext,oldDir:string;
     mac: Pmacros;
     ok:boolean;
begin
     ExportName:=fichier;
     if fichier='' then
     begin
        aux:=Filename;
        if aux='' then aux:='*.' else delete(aux,Length(aux)-2,3);
        case mode of
        1:  begin aux:=aux+'tex'; Titre:=TgExportLaTeXTitle; filtre:=TgExportLatexFilter; Ext:='tex' end;
        2:  begin aux:=aux+'pst'; Titre:=TgExportPstTitle;Filtre:=TgExportPstFilter; Ext:='pst' end;
        4:  begin aux:=aux+'eps';Titre:=TgExportEpsTitle;Filtre:=TgExportEpsFilter;Ext:='eps' end;
       11:  begin aux:=aux+'psf';Titre:=TgExportPsfTitle;Filtre:=TgExportPsfFilter;Ext:='psf' end;
        5:  begin aux:=aux+'pgf';Titre:=TgExportPgfTitle;Filtre:=TgExportPgfFilter;Ext:='pgf' end;
        6:  begin aux:=aux+'pdf';Titre:=TgExportPdfTitle;Filtre:=TgExportPdfFilter;Ext:='pdf' end;
        7:  begin aux:=aux+'tkz';Titre:=TgExportTkzTitle;Filtre:=TgExportTkzFilter;Ext:='tkz' end;
        8:  begin aux:=aux+'eps';Titre:=TgExportEpscTitle;Filtre:=TgExportEpsFilter;Ext:='eps' end;
       10:  begin aux:=aux+'pdf';Titre:=TgExportPdfcTitle;Filtre:=TgExportPdfFilter;Ext:='pdf' end;
        9:  begin aux:=aux+'svg';Titre:=TgExportSvgTitle;Filtre:=TgExportSvgFilter;Ext:='svg' end;
      obj:  begin aux:=aux+'obj';Titre:=TgExportObjTitle;Filtre:=TgExportObjFilter;Ext:='obj' end;
     geom:  begin aux:=aux+'geom';Titre:=TgExportGeomTitle;Filtre:=TgExportGeomFilter;Ext:='geom' end;
     jvx:  begin aux:=aux+'jvx';Titre:=TgExportJvxTitle;Filtre:=TgExportJvxFilter;Ext:='jvx' end;
     js:  begin aux:=aux+'js';Titre:=TgExportJsTitle;Filtre:=TgExportJsFilter;Ext:='js' end;
     texsrc:  begin aux:=aux+'src';Titre:=TgExportSrcTitle;Filtre:=TgExportSrcFilter;Ext:='src' end;
        end;
        ExportName:=aux;
        ok:= ((mode=texsrc) or (liste_element.tete<>nil))
             and  GetSaveFile(Titre,Filtre,Ext,ExportName);
     end
     else ok:=true;
     if ok  then GraphExport(mode)
end;
{===================================}
procedure TMainForm.ToolCopierColler(Sender: TObject);// bouton Copier
var SelectionCopy:integer;
    T:TStringList;
begin
     //if liste_element.tete=nil then exit;
     PressePapier:=Tpressepapier.create(self);
     if PressePapier.ShowModal=mrOk
        then
        begin
             SelectionCopy:= PressePapier.RadioGroup1.ItemIndex;
             ExportName:= TmpPath+'clipboard.txt';
             case SelectionCopy of
                        0: enregistrer_elements(latex,cadre,ExportName);
                        1: enregistrer_elements(pstricks,cadre,ExportName);
                        2: enregistrer_elements(pgf,cadre,ExportName);
                        3: enregistrer_elements(teg,cadre,ExportName);
                        4: enregistrer_elements(src4LaTeX,cadre,ExportName);
                        5: GraphExport(texsrc);
             end;
             T:=TstringList.Create;
             T.LoadFromFile(TmpPath+'clipboard.txt');
             ClipBoard.asTeXt:=T.text;
             T.free
        end;
     PressePapier.free
end;
{===================}
procedure TMainForm.ToolApercu(Sender: TObject);  //aperçu
begin
     if liste_element.tete=nil then  exit;
     Apercu:=true;
     ExecCommande('\Apercu');
     Apercu:=false;
end;
{==================}
procedure TMainForm.ExporterenLatexClick(Sender: TObject);
 begin
     exporter(latex,'')
end;
{===================}
procedure TMainForm.ExporterenPgf1Click(Sender: TObject);
begin
    exporter(pgf,'')
end;
{===================}
procedure TMainForm.Exporterentikz1Click(Sender: TObject);
begin
   exporter(tikz,'')
end;
{===================}
procedure TMainForm.ExporterenPsTricksClick(Sender: TObject);
begin
     exporter(pstricks,'')
end;
{===================}
procedure TMainForm.ExporterenEPSClick(Sender: TObject);
begin
     exporter(eps,'')
end;
{=====================}
procedure TMainForm.ExporterenPsfClick(Sender: TObject);
begin
     exporter(psf,'');
end;
{===================}
procedure TMainForm.ExporterenPdfClick(Sender: TObject);
begin
     exporter(pdf,'')
end;
{======================}
procedure TMainForm.ExporterenSvgClick(Sender: TObject);
begin
     exporter(svg,'')
end;
{======================}
procedure TMainForm.ExporterenEpscClick(Sender: TObject);
begin
      exporter(compileEps,'')
end;
{======================}
procedure TMainForm.ExporterenPdfcClick(Sender: TObject);
begin
     exporter(compilePdf,'')
end;
{=====================}
procedure TMainForm.ExporterenObjClick(Sender: TObject);
begin
     exporter(obj,'')
end;
{=====================}
procedure TMainForm.ExporterenGeomClick(Sender: TObject);
begin
    exporter(geom,'')
end;
{=====================}
procedure TMainForm.ExporterenJvxClick(Sender: TObject);
begin
    exporter(jvx,'')
end;
{=====================}
procedure TMainForm.ExporterSrcToTeXClick(Sender: TObject);
begin
   exporter(texsrc,'')
end;
{=====================}
procedure TMainForm.MenushowlabelanchorClick(Sender: TObject);
begin
   Menushowlabelanchor.checked:=not Menushowlabelanchor.checked;
   showlabelanchor:=Menushowlabelanchor.checked;
   dessiner;
end;
{=====================}
procedure TMainForm.N11Click(Sender: TObject);
begin
    exporter(geom,'')
end;
{=====================}
procedure TMainForm.Importerunmodle1Click(Sender: TObject);
var
    Nom:TFileName;
begin
     
     Nom:=UserMacpath+'*.mod';
     
     if  GetOpenFile(TgOpenAFile,TgModelFile+' (*.mod)','*.mod',Nom)
         then
             begin
                  if not lire_fichier(Nom)
                      then MessageDlg(TgDataError+' '+nom,mtWarning,[mbOk],0);
                 opbordure.checked:=cadre;
                 opCouleurs.checked:= gestion_couleur;
                 FileChanged:=true;
                 dessiner

             end;
end;
{=======================}
procedure TMainForm.Chargerdesmacros1Click(Sender: TObject);
var
    Nom:TFileName;
    titre:string;
begin
     Nom:=UserMacPath+'*.mac';
     if  GetOpenFile(TgOpenAFile,TgMacFile,'*.mac',Nom)
         then
             begin
                  Titre:=ExtractFileName(Nom);
                  if ListeFicMac.IndexOf(Titre)=-1
                     then
                         begin
                              MacroStatut:=tempMac;
                              if not lire_fichier(Nom)
                                 then  MessageDlg(TgDataError+' '+nom,mtWarning,[mbOk],0);
                                 ListeFicMac.Add(Titre);
                                 MacroStatut:=userMac;
                                 opbordure.checked:=cadre;
                                 opCouleurs.checked:=gestion_couleur;
                                 ReCalculer(false)
                         end
                     else Messagedlg(Titre+': '+TgFileLoaded,mtWarning,[mbOk],0);
             end;
end;

{============================= gestion PaintBox ===============================}
procedure TMainForm.dessiner;
var rec:Trect;
    x,y:integer;
begin
    if not VisibleGraph then exit; //pas d'affichage ecran
    x:=maxX+GmargeG+GmargeD; y:=maxY+GmargeH+GmargeB;
    if (PaintBox1.width<>x) or (PaintBox1.Height<>y) then
       begin
            PaintBox1.width:=x;
            PaintBox1.Height:=y;
       end;
    MyBitmap.setsize(x,y);
    MyBitmap.FillRect(0,0,x,y,clwhite,dmSet);
    MyBitmap.Canvas2D.Unclip;
    if Yafond then
            begin
                rec:=rect(Xentier(fondOrigX),Yentier(fondOrigY),Xentier(FondLarge+fondOrigX),Yentier(FondOrigY-fondHaut));
                MyBitmap.Canvas.StretchDraw(rec,fond.Picture.bitmap);
            end
    else if YaDrawBitmap then MyBitmap.CanvasBGRA.Draw(0,0,DrawBitmap);
    Dessiner_elements;
    if Afficherlesvariableslcran.checked then AfficherVarGlob;
    PaintBox1.Invalidate;
    MiseAjour;
end;
{============}
procedure TMainForm.CursNormalClick(Sender: TObject);
begin
      ActiveCurs.Down:=false;
      ActiveCurs:=ToolCursNormal;
      ActiveCurs.Down:=true;
      PaintBox1.Cursor:=crCross;
      FileChanged:=true;
end;
{==============}
procedure TMainForm.ToolSelectZoom(Sender: TObject); //zoom in
begin
      ActiveCurs.Down:=false;
      ActiveCurs:=ToolCursSelect;
      ActiveCurs.Down:=true;
      PaintBox1.Cursor:=crDrag;
      beginZoom:=false;
      FileChanged:=true;
end;
{============}
procedure TMainForm.ToolDeplacer(Sender: TObject); //deplacer le graphique
begin
      ActiveCurs.Down:=false;
      ActiveCurs:=ToolCursDeplace;
      ActiveCurs.Down:=true;
      PaintBox1.Cursor:=crHandPoint;
      beginDeplace:=false;
      FileChanged:=true;
end;
{============}
procedure TMainForm.ToolAnnuleZoomDeplace(Sender: TObject);
begin
     Filechanged:=true;
     execCommande('Si(nil(ZoomList)=0,[Fenetre(Copy(ZoomList,1,1), Copy(ZoomList,2,1),'+
                  'Copy(ZoomList,3,1)),  Del(ZoomList,1,3), ReCalc()])');
end;
{============}
procedure TMainForm.ToolMove3D(Sender: TObject); //faire tourner à la souris
begin
      ComptMouse:=0;
      ActiveCurs.Down:=false;
      ActiveCurs:=ToolCursTourne;
      ActiveCurs.Down:=true;
      beginTourner:=false;
      PaintBox1.Cursor:=crSizeAll;
      FileChanged:=true;
end;
{============}
procedure TMainForm.ToolZoomInClick(Sender: TObject);
begin
     FileChanged:=true;
     execCommande('MouseZoom(1)')
end;
{==============}
procedure TMainForm.ToolZoomOutClick(Sender: TObject);
begin
     FileChanged:=true;
     execCommande('MouseZoom(-1)')
end;
{==============}
procedure TMainForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     SetCaptureControl(PaintBox1);
     sourisDown:=true;
     ComptMouse:=0;
     if Button=mbLeft then
           if PaintBox1.Cursor=crDrag {ZoomAv} then
                          begin x1:=Xreel(X); y1:=Yreel(Y);x2:=x1;y2:=y1;
                                 if (Xmin<=x1) and (x1<=Xmax) and (Ymin<=y1) and (y1<=Ymax)
                                    then
                                        begin
                                             beginZoom:=true;
                                             PaintBox1.Canvas.Pen.mode:= pmNotXor;
                                             PaintBox1.Canvas.Pen.Color:=clBlack;
                                             PaintBox1.Canvas.Pen.Width:=1;
                                             PaintBox1.Canvas.Pen.Style:=psDash;
                                             PaintBox1.Canvas.Brush.style:=bsclear;
                                             PaintBox1.Canvas.rectangle(Xentier(x1),Yentier(y1),Xentier(x2),Yentier(y2));
                                        end;
                           end
                     else
           if PaintBox1.Cursor=crHandPoint {deplacer graphique}
                     then
                         begin
                               BeginDeplace:=true;
                               execCommande('Insert(ZoomList,[Xmin+i*Ymax,Xmax+i*Ymin,Xscale+i*Yscale],1)');
                               pixX2:=X; pixY2:=Y; pixX1:=GmargeG; pixY1:=GmargeH;
                               x1:=Xreel(X); y1:=Yreel(Y);
                               PaintBox1.Canvas.Pen.mode:= pmNotXor;
                               PaintBox1.Canvas.Pen.Color:=clBlack;
                               PaintBox1.Canvas.Pen.Width:=1;
                               PaintBox1.Canvas.Pen.Style:=psDash;
                               PaintBox1.Canvas.Brush.style:=bsclear;
                               PaintBox1.Canvas.rectangle(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                               PaintBox1.Canvas.line(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                               PaintBox1.Canvas.line(pixX1,maxY+pixY1,maxX+pixX1,pixY1);
                         end
                     else
           if PaintBox1.Cursor=crSizeAll
                     then
                         begin
                               BeginTourner:=true;
                               x1:=Xreel(X); y1:=Yreel(Y);
                               execCommande('[SaveWin3d(), IdMatrix3D(), view3D(-2,2,-2,2,-2,2), '+
                                            'NewGraph("cube3d__", "[Arrows:=1, Ligne3D([Xinf,0,Xsup,0,jump,i*Yinf,0,i*Ysup,0,jump,0,Zinf,0,Zsup],0)]"), {NotXor(cube3d__),} ReDraw()]')
                         end
                     else
           if (ssCtrl in shift)
                     then execMacro('CtrlClicG',X,Y)
                     else execMacro('ClicG',X,Y)

        else //pas le bouton de gauche
     if (Button=mbRight) and (PaintBox1.Cursor=crCross) then
            if (ssCtrl in shift) then execMacro('CtrlClicD',X,Y)
                       else
            if Macros('ClicD')=nil
                then execMacro('VarGlob',X,Y)
                else execMacro('ClicD',X,Y);
end;
{============}
procedure TMainForm.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var aux:double;
      u,v:real;
begin
     sourisDown:=false;
     ReleaseCapture;
     
     if Button=mbLeft then
              if beginZoom then begin
                                   beginZoom:=false;
                                   if x2<x1 then begin aux:=x2;x2:=x1;x1:=aux; end;
                                   if y2>y1 then begin aux:=y2;y2:=y1;y1:=aux; end;
                                   PaintBox1.Canvas.rectangle(Xentier(x1),Yentier(y1),Xentier(x2),Yentier(y2));
                                   PaintBox1.Canvas.Pen.mode:=pmCopy;
                                   execCommande('[Set($a,'+Streel(x1)+'+i*('+Streel(y1)+')),'+
                                                'Set($b,'+Streel(x2)+'+i*('+Streel(y2)+')),'+
                                                'Set($u,10/Re(b-a)), Set($v,10/Im(a-b)),$w:=Xscale/Yscale, if u>w*v then u:=v*w else v:=u/w fi,'+
                                                'Insert(ZoomList,[Xmin+i*Ymax,Xmax+i*Ymin,Xscale+i*Yscale],1),'+
						'Fenetre(a,b,u+v*i),ReCalc()]');
                                   ToolZoomOut.Enabled:= constante('ZoomList')^.affixe<>nil;
                             end
                        else
               if BeginDeplace then
                               begin BeginDeplace:=false;
                                    PaintBox1.Canvas.rectangle(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                                    PaintBox1.Canvas.line(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                                    PaintBox1.Canvas.line(pixX1,maxY+pixY1,maxX+pixX1,pixY1);
                                    PaintBox1.Canvas.Pen.mode:=pmCopy;
                                    u:=Xreel(X); v:=Yreel(Y);
                                    graph1_6.Fenetre(Xmin-u+x1, Ymin-v+y1, Xmax-u+x1, Ymax-v+y1,Xscale,Yscale);
                                    ReCalculer(false);
                               end
                        else
               if BeginTourner then
                  begin
                       BeginTourner:=false;
                       execCommande('[DelGraph("cube3d__"),RestoreWin3d(), ReCalc()]')
                  end
                 else execMacro('LButtonUp',X,Y)
        else //pas le bouton de gauche
     if (Button=mbRight) and (PaintBox1.Cursor=crCross) then execMacro('RButtonUp',X,Y);
     MiseAjour
end;
{============}
procedure TMainForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var u,v:real;
begin
 StatusBar1.Panels[0].Text:='x='+Streel(Xreel(X));
 StatusBar1.Panels[1].Text:='y='+Streel(Yreel(Y));
 Inc(comptMouse);
 if beginZoom then
    begin
         u:=Xreel(X); v:=Yreel(Y);
         if (Xmin<=u) and (u<=Xmax) and (Ymin<=v) and (v<=Ymax)
            then
                begin
                     PaintBox1.Canvas.rectangle(Xentier(x1),Yentier(y1),Xentier(x2),Yentier(y2));
                     x2:=u; y2:=v;
                     PaintBox1.Canvas.rectangle(Xentier(x1),Yentier(y1),Xentier(x2),Yentier(y2));
                end;
    end
    else
  if BeginDeplace
        then
                     begin
                     PaintBox1.Canvas.rectangle(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                     PaintBox1.Canvas.line(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                     PaintBox1.Canvas.line(pixX1,maxY+pixY1,maxX+pixX1,pixY1);
                     pixX1:=pixX1+(X-pixX2); pixY1:=pixY1+(Y-pixY2);
                     pixX2:=X; pixY2:=Y;
                     PaintBox1.Canvas.rectangle(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                     PaintBox1.Canvas.line(pixX1,pixY1,maxX+pixX1,maxY+pixY1);
                     PaintBox1.Canvas.line(pixX1,maxY+pixY1,maxX+pixX1,pixY1);
                     end
        else
  if BeginTourner
        then
                 if comptMouse>4 then
                 begin
                      u:=Xreel(X); v:=Yreel(Y);
                      Ptheta^.affixe^.setx(modulo2pi(Ptheta^.affixe^.getx-(U-x1)*2*pi/(Xmax-Xmin)));
                      Pphi^.affixe^.setx(modulo2pi( Pphi^.affixe^.getx+(V-y1)*2*pi/(Ymax-Ymin)));
                      x1:=U; y1:=V; ComptMouse:=0;
                      execCommande('ReCalc(cube3d__)');
                 end else
        else
 if (comptMouse>4) then
            //if (Macros1('MouseMove')<>nil) then
               begin
                    execMacro('MouseMove',X,Y);
                    ComptMouse:=0;
               end
              // else ComptMouse:=0;
end;
{============}
procedure TMainForm.PaintBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var R:Trect;
begin
     if Macros('MouseWheel')<>nil then
     begin
        execcommande('MouseWheel('+Streel(WheelDelta)+')');
        handled:=true;
     end
     else
     begin
        ExecCommande('MouseZoom('+Streel(WheelDelta)+')');
        handled:=true;
     end;
end;

procedure TMainForm.optionCameraClick(Sender: TObject);
begin
    CameraForm:=TCameraForm.create(self);
    if CameraForm.showModal=mrOK
       then recalculer(true);
    CameraForm.free
end;

{============}
procedure TMainForm.projCentraleClick(Sender: TObject);
begin
  if not centrale then  //on passe en centrale
   begin
        centrale:=true;
        optionCamera.enabled:=true;
        projCentrale.checked:=true;

        projOrtho.checked:= false;

        recalculer(true);
        FileChanged:=true;
        AfficherModifie;
     end;
end;
{============}
procedure TMainForm.projOrthoClick(Sender: TObject);
begin
  if centrale then //on passe en ortho
     begin
          centrale:=false;
          projOrtho.checked:=true;

          projCentrale.checked:= false;
          optionCamera.enabled:=false;

          FileChanged:=true;
          AfficherModifie;
          recalculer(true)
     end
end;
{============}
procedure TMainForm.snapshotClick(Sender: TObject);
begin
     if liste_element.tete=nil then  exit;
     SnapShotForm:=TSnapShot.Create(self);
     if SnapShotForm.ShowModal=mrOk
        then begin
             if ExportJpeg then dessiner;//pour enlever les pointillés montrant les marges avant l'export
             Executer(snapCommande);
             if ExportJpeg then begin ExportJpeg:=false; dessiner end;
             end;
     SnapShotForm.free;
end;

{============}
procedure TMainForm.AfficherVarGlob;
var aux:PVarGlob;
    affixe:Paffixe;
     chaine:string;
     haut,large:real;
begin
    haut:=0.1/Yscale;large:=0.1/Xscale;
    aux:=PVarGlob(VariablesGlobales^.tete);
    if aux=nil then exit;
    MyBitmap.CanvasBGRA.Pen.Color:=$808080;
    MyBitmap.CanvasBGRA.Pen.style:=psSolid;
    MyBitmap.CanvasBGRA.Pen.Width:=1;
    MyBitmap.CanvasBGRA.Font.Color:=$808080;
    MyBitmap.CanvasBGRA.Brush.style:=bsClear;
    while aux<>nil do
          begin
          if aux^.statut=0 then
             begin
               affixe:=Paffixe(constante(aux^.variable^.nom)^.affixe);
               if (affixe<>nil)
               and (affixe^.x>=Xmin) and (affixe^.x<=Xmax) and
               (affixe^.y>=Ymin) and (affixe^.y<=Ymax) then
                with MyBitmap.CanvasBGRA do
               begin
               chaine:=String(aux^.variable^.nom);
               MoveTo(Xentier(affixe^.x-large),Yentier(affixe^.y));
               LineTo(Xentier(affixe^.x+large),Yentier(affixe^.y));
               MoveTo(Xentier(affixe^.x),Yentier(affixe^.y-haut));
               LineTo(Xentier(affixe^.x),Yentier(affixe^.y+haut));
               Textout(Xentier(affixe^.x+2*large),Yentier(affixe^.y+3*haut),chaine);
               end;
             end;
             aux:=PVarGlob(aux^.suivant);
          end;
end;
{================= gestion MainForm==============================}
procedure TMainForm.PaintBox1Paint(Sender: TObject);
begin
     MyBitmap.Draw(Canevas,0,0); // PaintBox Canvas
end;

{=========================}
procedure TMainForm.ClicReCentFile(Sender: TObject);
var I:integer;
    nom:string;
    source:TextFile;
begin
  with Sender as Tmenuitem do
        begin
                if not AskSave then exit;
                Nom:=Caption;
                I:=MenuIndex;
                system.delete(nom,pos('&',nom),1);
                AssignFile(source,nom);
                {$I-} system.reset(source); {$I+}
                if IOResult<>0 then  MessageDlg(TgDataError+Nom,mtWarning,[mbOk],0)
                        else begin
                                CloseFile(source);
                                MainMenu1.Items[0].Items[2].Delete(I);
                                AddRecentFile;
                                Filename:=nom;
                                CurrentDir:=ExtractFilePath(filename);
                                chDir(CurrentDir);
                                LoadFile;
                             end;
        end;
end;
{=====================}
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var mac:Pmacros;
begin
      //Inherited;
      if ssCtrl in shift
      then
           if ssShift in shift
                then      {Ctrl+shift}
                  if chr(Key) in ['A'..'Z'] then
                   begin
                        mac:=Macros('OnKey');
                        if mac<>nil then
                                ExecCommande('OnKey("'+chr(Key)+'")');
                        Key:=0
                   end
                   else

            else   {Ctrl+lettre}
              if not ComboBox2active then
                 begin
                       case key of
                       Vk_A:  Begin AxesClick(Sender); Key:=0 end;
                       //ord('G'):  Begin GrilleClick(Sender); Key:=0 end;
                       //ord('D'):  Begin DroiteClick(Sender); Key:=0 end;
                       //ord('H'):  Begin Chemin1Click(Sender); Key:=0 end;
                       //ord('L'):  Begin LignepolygonaleClick(Sender); Key:=0 end;
                       Vk_C:  Begin EllipseClick(Sender); Key:=0 end;
                       Vk_N:  Begin Nouveau1Click(Sender); Key:=0 end;
                       //ord('U'):  Begin UtilisateurClick(Sender); Key:=0 end;
                       //ord('R'):  Begin CartesienneClick(Sender); Key:=0 end;
                       //ord('P'):  Begin ParametreClick(Sender); Key:=0 end;
                       //ord('O'):  Begin PolaireClick(Sender); Key:=0 end;
                       //ord('E'):  Begin EquadiffClick(Sender); Key:=0 end;
                      // ord('I'):  Begin ImpliciteClick(Sender); Key:=0 end;
                       //ord('B'):  Begin BezierClick(Sender); Key:=0 end;
                       VK_Left :  begin ToolFlecheGauche(Nil); Key:=0 end;
                       VK_Right  :  begin ToolFlecheDroite(Nil); Key:=0 end;
                       VK_Up  :  begin ToolFlecheHaut(Nil); Key:=0 end;
                       VK_Down :  begin ToolFlecheBas(Nil); Key:=0 end;
                       end
                 end
              else key:=0
      else {pas de Ctrl}
      if ssAlt in shift
                then
                if ssShift in shift
                   then
                   begin   {Alt+Maj(?)+lettre}
                        case key of
                        //Vk_F9:  Begin VoirListeClick(Sender); Key:=0 end;
                        Vk_L: Begin label2Click(Sender); Key:=0 end;
                        Vk_P: Begin PointsClick(Sender); Key:=0 end;
                        Vk_A: Begin EllipseArcClick(Sender); Key:=0 end;
                        Vk_O:  Begin PolaireClick(Sender); Key:=0 end;
                        Vk_S: Begin SplinecubiqueClick(Sender); Key:=0 end;
                        Vk_V: Begin ToolApercu(Sender); Key:=0 end;//apercu
                        end
                     end
                  else
                     begin
                        case key of
                          Vk_A: Begin ArcClick(Sender); Key:=0 end;
                        end;
                     end
                else {shift+lettre}
      if ssShift in shift
        then      if key=VK_ADD then begin execcommande('MouseZoom(1)'); key:=0 end
        else      if key=VK_SUBTRACT then  begin execcommande('MouseZoom(-1)'); key:=0 end;

      if not (ssShift in shift)

         then if (key=VK_F10) then  begin ReCalculer(true); Key:=0 end;
end;


procedure TMainForm.ComboBox3Change(Sender: TObject);
begin
      scale_scr:=(50+ComboBox3.ItemIndex*25)/100;
      Unite_graphique(PixelsPerInch,scale_scr);
      ScrollBox1.VertScrollBar.position:=0;//bug lazarus 0.9.29 linux
      ScrollBox1.HorzScrollBar.position:=0;//bug lazarus 0.9.29 linux
      Panel1.top:=0; Panel1.left:=0;
      dessiner
end;
{========================}
procedure TMainForm.load;
var f:TextFile;
    I,fontheight: integer;
    fichier,mot1,mot2, Lang,FallBackLang, PoFile:string;
    Item:TmenuItem;
    posx,posy,haut,large,erreur:integer;
    m:Pconstante;
    lecturehistorique:boolean;
    
    procedure split(const s:string; var left,right:string);
    var pos:integer;
    begin
         pos:=1;
         left:=ExtractSubstr(s,pos,['=']);
         right:=ExtractSubstr(s,pos,['=']);
    end;
    
begin
     MyBitmap:=TBGRAbitmap.Create(100,100,clwhite);
     MyBitmap.fontantialias:=true;
     MyBitmap.CanvasBGRA.AntialiasingMode:=amon;
     MyBitmap.Canvas2D.strokestyle(BGRABlack);
     DrawBitmap:=TBGRAbitmap.Create;
     MainForm.font.quality:=fqAntialiased;
     MyBitmap.CanvasBGRA.font.Assign(MainForm.font);
     Canevas:=PaintBox1.Canvas;
     GetLanguageIDs(Lang,FallbackLang);

     Initialisation;
     Yafond:=false;
     Caption:='TeXgraph '+calculs1.version+' - *.teg';

     ListeBoutons:=New(Pliste,init);
     ListeLabels:=New(Pliste,init);
     ListeTRackBar:=New(Pliste,init);
     UserAction:=Tlist.Create;
     lecturehistorique:=false;
     workdir:=GetCurrentDir;
     webLoad:='wget --no-check-certificate';
     {$IFDEF Unix}
     pdfreader:='xpdf'; imageviewer:='display';//lecteur d'imageMagick
     PoFile:=InitialPath+'src/languages/TeXgraph.'+Lang+'.po';
     if not FileExists(PoFile) then
             PoFile:=InitialPath+'src/languages/TeXgraph.'+FallBackLang+'.po';
     {$ENDIF};
     {$IFDEF windows}
     pdfreader:='c:\program files\adobe\Reader 9.0\Reader\AcroRd32.exe';
     imageviewer:='IMdisplay'; //lecteur d'imageMagick
     PoFile:=InitialPath+'src\languages\TeXgraph.'+Lang+'.po';
     if not FileExists(PoFile) then
             PoFile:=InitialPath+'src\languages\TeXgraph.'+FallBackLang+'.po';
     {$ENDIF};
     If FileExists(PoFile) then TranslateResourceStrings(PoFile)//traduction des ressources
     else AfficheMessage('File '+PoFile+' not found.');
     TranslateVisual; //affectation des ressousces
     If FileExists(TmpPath+'TeXgraph.cfg') then
     begin
          assignFile(f,TmpPath+'TeXgraph.cfg');
          system.reset(f);
          while not eof(f) do
          begin
               readln(f,fichier);
               if not lecturehistorique then  {données à lire avant l'historique}
                  begin
                       split(fichier,mot1,mot2);
                       if mot1='posx' then  begin val(mot2,posx,erreur);
                                                  if (erreur=0) then left:=posx;
                                            end
                                      else
                       if mot1='posy' then  begin val(mot2,posy,erreur);
                                                  if (erreur=0) then top:=posy;
                                            end
                                      else
                       if mot1='width' then  begin val(mot2,large,erreur);
                                                   if (erreur=0) then Width:=large;
                                            end
                                      else
                       if mot1='height' then  begin val(mot2,haut,erreur);
                                                    if (erreur=0) then Height:=haut;
                                            end
                                      else
                      if mot1='fontname' then  DefaultFont.name:=mot2  //fonte interface
                                     else
                       if mot1='fontheight' then  begin val(mot2,fontheight,erreur);
                                                      if (erreur=0) then DefaultFont.height:=fontheight;
                                                  end
                                      else
                       if mot1='editfontname' then  EditDefaultFont.name:=mot2  //fonte édition
                                      else
                       if mot1='editfontheight' then  begin val(mot2,fontheight,erreur);
                                                      if (erreur=0) then EditDefaultFont.height:=fontheight;
                                           end
                                      else
                       if mot1='workdir' then  workdir:=mot2
                                      else
                       if mot1='pdfreader' then  pdfreader:=mot2
                                     else
                       if mot1='imageviewer' then  imageviewer:=mot2
                                     else
                       if mot1='javaviewdir' then  javaviewdir:=mot2
                                      else
                       if mot1='webloader' then  webload:=mot2
                                      else
                       if (mot1='historique') or (mot1='recent') then lecturehistorique:=true;
                  end
               else   //lecture de l'historique
               if fichier<>'' then
                   begin
                   Item:=TmenuItem.Create(self);
                   Item.Caption:=fichier;
                   Item.OnClick:=ClicRecentFile;
                   MainMenu1.Items[0].Items[2].add(Item)
                   end;
          end;
          closeFile(f);
          if (workdir='') or (not DirectoryExists(workdir)) then
           workdir:={$IFDEF UNIX}GetEnvironmentVariable('HOME'){$ELSE}GetCurrentDir{$ENDIF};
          chdir(workdir);
          CurrentDir:= workdir;
      end;
      m:=constante('PdfReader'); Pchaine(m^.affixe)^.chaine:= pdfreader;
      m:=constante('ImageViewer'); Pchaine(m^.affixe)^.chaine:= ImageViewer;
      m:=constante('JavaviewPath');
      if (javaviewdir='') or (javaviewdir[length(javaviewdir)]=sep) then Pchaine(m^.affixe)^.chaine:= javaviewdir
         else Pchaine(m^.affixe)^.chaine:= javaviewdir+sep;
      m:=constante('WebLoad'); Pchaine(m^.affixe)^.chaine:= webload;
     With ComboBox3.Items do
        begin
        Add('50%');Add('75%');Add('100%');
        Add('125%');Add('150%');Add('175%');Add('200%');
        Add('225%');Add('250%');Add('275%');Add('300%');
        Add('325%');Add('350%');Add('375%');Add('400%');
        ComboBox3.ItemIndex:=2;
        scale_scr:=1;
        end;

     Unite_graphique(PixelsPerInch,scale_scr);
     macroStatut:=predefMac; //macro permanente

     If not FileExists(MacPath+'Interface.mac') then
          AfficheMessage('Interface.mac'+TgNotInDir+MacPath)
     else
          lire_fichier(MacPath+'Interface.mac'); //ListeFicMac.Add('TeXgraph.mac')

     ActiveCurs:=ToolCursNormal;
     ActiveCurs.Down:=true;
     ToolCursSelect.down:=false;
     ToolCursDeplace.down:=false;
     macroStatut:=userMac;
     ChangeVarG:=false; ChangeMac:=false; ChangeGraph:=false;
     deplaceElemGraph:=false;
     SourisDown:=false;
     fileChanged:=false;
     FileName:='';
     Canevas.CopyMode:=CmSrcCopy;
     //dessiner;
end;
{========================}
procedure TMainForm.FormShow(Sender: TObject);
begin
     dessiner
end;

{========================}
procedure TMainForm.TranslateVisual;
begin
//menu
  with MainMenu1 do
  begin
       type_element[14]:=' ('+TgUser+')';
       Fichier1.Caption:=TgFile;
       with Fichier1 do
       begin
            Nouveau1.Caption:=TgNew;
            Ouvrir.Caption:=TgOpen;
            Rouvrir1.Caption:=TgRecent;
            Enregistrer.Caption:=TgSave;
            EnregistrerSous.Caption:=TgSaveAs;
            Chargerdesmacros1.Caption:=TgLoadMac;
            Importerunmodle1.Caption:=TgLoadMod;
            Chargerunfond1.Caption:=TgLoadPicture;
            Supprimerlefond1.CAption:=TgDelPicture;
            ExporterenLatex.Caption:=TgExportToEepic;
            ExporterenPsTricks.CAption:=TgExportToPstricks;
            ExporterenPgf1.Caption:=TgExportToPgf;
            ExporterenTikz1.Caption:=TgExportToTikz;
            ExporterenEPS.Caption:=TgExportToEps;
            ExporterenPsf.Caption:=TgExportToPsf;
            ExporterenEpsc.Caption:=TgExportToEpsc;
            ExporterenPdf.Caption:=TgExportToPdf;
            ExporterenPdfc.Caption:=TgExportToPdfc;
            ExporterenSvg.CAption:=TgExportToSvg;
            ExporterSrcToTeX.Caption:=TgExportSrcToTeX;
            ExporterenObj.CAption:=TgExportToObj;
            ExporterenGeom.Caption:=TgExportToGeom;
            ExporterenJvx.Caption:=TgExportToJvx;
            ExporterenJs.Caption:=TgExportToJs;
            Quitter.Caption:=TgExit;
        end;
       Edition.Caption:=TgEdit;
       with Edition do
       begin
           Annuler.Caption:=TgUndo;
           Refaire.Caption:=TgRedo;
           Editer.Caption:=TgEditWindow;
       end;
       Parametres.Caption:=TgParameter;
       with Parametres do
       begin
           Fenetre.Caption:=TgView;
           Marge.Caption:=TgMargin;
           opBordure.Caption:=TgBorder;
           opCouleurs.Caption:=TgColor;
           Commentaires.Caption:=TgComment;
           ChangerRepere.Caption:=TgChangeUnit;
           projOrtho.Caption:=TgOrthoProj;
           projCentrale.Caption:=TgCentralProj;
           optionCamera.Caption:=TgCamera;
           Afficherlesvariableslcran.Caption:=TgShowVarScreen;
           Menushowlabelanchor.Caption:=TgShowLabelAnchor;
           RightColumn.Caption:=TgShowRightColumn;
           LeftColumn.Caption:=TgShowLeftColumn;
           fichierconfig.Caption:=TgConfigFile;
       end;
       Creer.Caption:=TgCreate;
       with Creer do
       begin
          Elementsgraphiques.Caption:=TgGraphicObjects;
          with Elementsgraphiques do
          begin
               Grille.CAption:=TgGrid;
               Axes.Caption:=TgAxes;
               Courbes.Caption:=TgCurves;
               with courbes do
               begin
                  Cartesienne.Caption:=TgCartesian;
                  Parametrique.Caption:=TgParametric;
                  Polaire.Caption:=TgPolar;
                  Equadiff.Caption:=TgOdeSolution;
                  Implicite.Caption:=TgImplicit;
                  Bezier.Caption:=TgBezier;
                  Splinecubique.Caption:=TgCubicSpline;
               end;
          Droite.Caption:=TgDroite;
          Points.Caption:=TgPoints;
          Lignepolygonale.Caption:=TgPolyLine;
          Chemin.Caption:=TgChemin;
          EllipseCercle.Caption:=TgEllipseCercle;
          CircleArc.Caption:=TgCircleArc;
          EllipticArc.Caption:=TgEllipticArc;
          Label2.Caption:=TgLabel;
          Surface.Caption:=TgSurface;
          Utilisateur.Caption:=TgUserObject;
          end;
       AutresElements2D.Caption:=TgOther2D;
       AutresElements3D.Caption:=TgOther3D;
       Varglobs.Caption:=TgVarglobs;
       Macros1.Caption:=TgMacros;
       end;
  Aide1.Caption:=TgAide;
  with Aide1 do
       begin
         OuvrirForum.Caption:=TgOuvrirForum;
         docpdf.Caption:=Tgdocpdf;
         with docPdf do
         begin
              TeXgraph_Doc.Caption:=TgTeXgraph_Docpdf;
              Mouse_Doc.Caption:=TgMouse_Docpdf;
              Models_Doc.Caption:=TgModels_Docpdf;
         end;
         MisesAjourModelesLogiciel.Caption:=TgMisesAjourModelesLogiciel;
         with MisesAjourModelesLogiciel do
              begin
                MisesAJourModeles.Caption:=TgMisesAJourModeles;
                MisesAJourLogiciel.Caption:=TgMisesAJourLogiciel;
              end;
         Apropos1.Caption:=TgApropos;
       end;
  end;//end menu
//droit et bas
     Label1.Caption:=TgCommandLine;
     GroupBox1.Caption:=TgGraphicObjects;
     GroupBox2.Caption:=TgVarGLob;
     GroupBox3.Caption:=TgMacrosBox;
     Button1.caption:=TgNew; Button1.Hint:=TgUserObject; Button10.Hint:=TgAttributesHint; //elements graphiques

     Button2.caption:=TgDelete; Button4.caption:=TgDelete;  Button7.caption:=TgDelete;
     Button2.Hint:=TgDeleteHint; Button4.Hint:=TgDeleteHint;  Button7.Hint:=TgDeleteHint;

     Button3.caption:=TgNew; Button6.caption:=TgNew;
     Button3.Hint:=TgNewGlobVarHint; Button6.Hint:=TgNewMacroHint;

     Button5.caption:=TgAll;  Button8.caption:=TgAll;
     Button5.Hint:=TgAllHint;  Button8.Hint:=TgAllHint;
//barre d'outils
     TabSheet1.Caption:=TgTabSheet1;
     ToolButton36.Hint:=TgToolButton36;
     ToolButton1.Hint:=TgToolButton1;
     ToolButton39.Hint:=TgToolButton39;
     ToolButton3.Hint:=TgToolButton3;
     ToolSnapshot.Hint:=TgToolSnapshot;
     ToolButton5.Hint:=TgToolButton5;
     ToolButton6.Hint:=TgToolButton6;
     ToolButton11.Hint:=TgToolButton11;
     ToolButton12.Hint:=TgToolButton12;
     ToolButton13.Hint:=TgToolButton13;
     ToolButton14.Hint:=TgToolButton14;
     ToolButton15.Hint:=TgToolButton15;
     ToolButton16.Hint:=TgToolButton16;
     ToolButton17.Hint:=TgToolButton17;
     ToolButton18.Hint:=TgToolButton18;
     ToolButton19.Hint:=TgToolButton19;
     ToolButton20.Hint:=TgToolButton20;
     ToolButton22.Hint:=TgToolButton22;
     ToolButton25.Hint:=TgToolButton25;
     ToolButton34.Hint:=TgToolButton34;
     Ellipse.Hint:=TgEllipse;
     Arc.Hint:=TgArcButton;
     EllipseArc.Hint:=TgEllipseArc;
     ToolButton76.Hint:=TgToolButton76;
     ToolButton27.Hint:=TgToolButton27;
     ToolZoomOut.Hint:=TgToolZoomOut;
     ToolButton49.Hint:=TgUndo;
     ToolReCalc.Hint:=TgToolReCalc;
     ToolLoadMouse.Hint:=TgToolLoadMouse;
     ToolZoomIn.Hint:=TgToolZoomIn;
     ToolCursNormal.Hint:=TgToolCursNormal;
     ToolCursSelect.Hint:=TgToolCursSelect;
     ToolCursDeplace.Hint:=TgToolCursDeplace;
     ToolCursTourne.Hint:=TgToolCursTourne;
     ComboBox3.Hint:=TgComboBox3;

     TabSheet2.Caption:=TgTabSheet2;
     ToolButton41.Hint:=TgToolButton41;
     ToolButton35.Hint:=TgToolButton35;
     ToolButton42.Hint:=TgToolButton42;
     ToolButton43.Hint:=TgToolButton43;
     ToolButton44.Hint:=TgToolButton44;
     ToolButton45.Hint:=TgToolButton45;
     ToolButton46.Hint:=TgToolButton46;
     ToolButton48.Hint:=TgToolButton48;
     ToolButton50.Hint:=TgToolButton50;
     ToolButton51.Hint:=TgToolButton51;
     ToolButton52.Hint:=TgToolButton52;
     ToolButton53.Hint:=TgToolButton53;
     ToolButton54.Hint:=TgToolButton54;
     ToolButton47.Hint:=TgToolButton47;
     Intersection.Hint:=TgToolIntersection;
     Cercle.Hint:=TgToolCercle;

     TabSheet3.Caption:=TgTabSheet3;
     ToolButton28.Hint:=TgToolButton28;
     ToolButton29.Hint:=TgToolButton29;
     ToolButton32.Hint:=TgToolButton32;
     ToolButton31.Hint:=TgToolButton31;
     ToolButton30.Hint:=TgToolButton30;
     ToolButton21.Hint:=TgToolButton21;
     ToolButton55.Hint:=TgToolButton55;
     ToolButton56.Hint:=TgToolButton56;
     ToolButton57.Hint:=TgToolButton57;
     ToolButton58.Hint:=TgToolButton58;
     ToolButton59.Hint:=TgToolButton59;
     ToolButton60.Hint:=TgToolButton60;
     ToolButton61.Hint:=TgToolButton61;
     ToolButton67.Hint:=TgToolButton67;
     ToolButton68.Hint:=TgToolButton68;
     ToolButton64.Hint:=TgToolButton64;
     ToolButton66.Hint:=TgToolButton66;
     ToolButton65.Hint:=TgToolButton65;
     ToolButton70.Hint:=TgToolButton70;
     ToolButton69.Hint:=TgToolButton69;
     ToolButton62.Hint:=TgToolButton62;
     ToolJavaView.Hint:=TgToolJavaView;
     ToolGeomView.Hint:=TgToolGeomView;
     ToolWebGL.Hint:=TgToolWebGL;

end;
{========================}
procedure TMainForm.FormCreate(Sender: TObject);
begin
      load;
      Font:=DefaultFont;
      moveListBox1:=false;
      SynAnySyn1.KeyWords.Assign(keywordList);
      MisesAjourModelesLogiciel.enabled:=(usermacpath<>'')
end;
{========================}
function TMainForm.unload: boolean;
var index:integer;
    f:TextFile;
    fichier,oldDir:string;
begin
     UnLoad:=false;
     if not AskSave then exit;
     AddRecentFile;
     GetDir(0,oldDir);
     ChDir(TmpPath);

     {$IFDEF UNIX}
     SystemExec('bash -c "rm -f *.log *.dvi *.pdf *.aux *.pgf *.eps *.pst *.bmp *.png *.jpg *.txt"',true,false);
     {$ENDIF}
     {$IFDEF MSWINDOWS}
     SystemExec('cmd /C del *.log *.dvi *.pdf *.aux *.pgf *.eps *.pst *.bmp *.png *.jpg *.txt', true,false);
     {$ENDIF}

     {$I-}
     assignFile(f,'TeXgraph.cfg');
     rewrite(f);
     {$I+}
     if IOresult<>0 then //erreur
      else
      begin
        writeln(f,'posx=',left);
        writeln(f,'posy=',top);
        writeln(f,'width=',width);
        writeln(f,'height=',height);
        writeln(f,'fontname=',DefaultFont.name);
        writeln(f,'fontheight=',DefaultFont.height);
        writeln(f,'pdfreader=',pdfreader);
        writeln(f,'imageviewer=',imageviewer);
        writeln(f,'editfontname=',EditDefaultFont.name);
        writeln(f,'editfontheight=',EditDefaultFont.height);

        writeln(f,'workdir=',workdir);
        writeln(f,'javaviewdir=',javaviewdir);
        writeln(f,'webloader=',webload);
        writeln(f,'recent=');
        with MainMenu1.Items[0].Items[2] do
        for index:=0 to Count-1 do
           begin
                fichier:= Items[Index].Caption;
                system.delete(fichier,pos('&',fichier),1);
                writeln(f,fichier);
          end;
        closeFile(f);
      end;
     ChDir(oldDir);
     Clean;
     Dispose(ListeBoutons,detruire);
     Dispose(ListeLabels,detruire);
     Dispose(ListeTrackBar,detruire);
     ComboBox1.Items.Clear;
     dispose(TimerMac,detruire);
     MyBitmap.free;
     DrawBitmap.free;
     UserAction.free;
     UnLoad:=true;
end;
{========================}
procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     CanClose:=UnLoad
end;
{========================}
procedure TMainForm.detruireItemBoutons;
var p:PMyBouton;
    q:TMyItem;
    r:PMyLabel;
    t:PMyTrackBar;
    index:integer;
begin
      p:=PMyBouton(ListeBoutons^.tete);
      while p<>nil do
            if p^.statut<2
               then ListeBoutons^.supprimer(Pcellule(p))
               else p:=PMyBouton(p^.suivant);
      r:=PMyLabel(ListeLabels^.tete);
      while r<>nil do
            if r^.statut<2
               then ListeLabels^.supprimer(Pcellule(r))
               else r:=PMyLabel(r^.suivant);
      t:=PMyTrackBar(ListeTrackBar^.tete);
      while t<>nil do
            if t^.statut<2
               then ListeTrackBar^.supprimer(Pcellule(t))
               else t:=PMyTrackBar(t^.suivant);
      index:=0;
      while index<= (ComboBox1.Items.Count-1) do
            begin
                 q:=TMyItem(ComboBox1.Items.Objects[index]);
                 if q.statut<2 then
                    begin
                         q.free;
                         ComboBox1.Items.delete(index);
                    end
                 else inc(index);
            end;
      ComboBox1.ItemIndex:=0;
end;
{========================}
procedure TMainForm.FormResize(Sender: TObject);
var haut,large:integer;
 begin
    Haut:=Splitter2.Height div 3;// des GroupBox
    GroupBox1.Height:=Haut;
    GroupBox2.Height:=Haut;
end;
{======================}
procedure TMainForm.ComboBox2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var TheChaine,aux:string;
    indice:integer;
    f: Pexpression;
    res:Presult;
begin
     if key=VK_Delete then
      begin {suppr}
          Thechaine:=ComboBox2.text;
          if ComboBox2.SelText=TheChaine
             then begin
                  indice:=ComboBox2.Items.IndexOf(Thechaine);
                  if indice>-1 then ComboBox2.Items.delete(indice);
                  ComboBox2.ItemIndex:=0;
                  end;
     end
     else
     if Key=VK_return then
     begin
     key:=0;
     New(f,init);
     Thechaine:=ComboBox2.text;
     if f^.definir(Thechaine)
        then
            begin
                 indice:=ComboBox2.Items.IndexOf(Thechaine);
                 if indice>-1 then ComboBox2.Items.delete(indice);
                 //FoncSpeciales:=true;
                 res:=f^.evaluer;
                 //FoncSpeciales:=false;
                 if checkBox1.checked then   //afficher la sortie
                   begin
                    if res<>nil then aux:=res^.en_chaine else aux:='Nil';
                    AfficherMessage(TgResultOf+': '+Thechaine, aux);
                   end;
                 listes2.Kill(Pcellule(res));
                 if ChangeGraph or ChangeVarG or ChangeMac then  ReCalculer(true);
                 dessiner;
                 ComboBox2.Items.Insert(0,TheChaine);
                 ComboBox2.ItemIndex:=0;
                 ComboBox2.SetFocus
            end
        else begin
                  Messagedlg(ErrorMessage, mtWarning,[mbok],0);
                  ComboBox2.Selstart:=Errorpos-1;Combobox2.SelLength:=1;

             end;
        dispose(f,detruire);
        end;
end;
{====================}
procedure TMainForm.QuitterClick(Sender: TObject);
begin
     close
end;

procedure TMainForm.ScrollBox1Click(Sender: TObject);
begin

end;

{====================}
procedure TMainForm.ScrollBox1Resize(Sender: TObject);
begin
    //Panel1.top:=0; Panel1.left:=0;
    ScrollBox1.VertScrollBar.position:=0;//bug lazarus 0.9.29 linux
    ScrollBox1.HorzScrollBar.position:=0;//bug lazarus 0.9.29 linux
    ScrollBox1.invalidate;
    ScrollBox1.Repaint
end;
{====================}
procedure TMainForm.StopButtonClick(Sender: TObject);
begin
  StopAll:=true;
  ExitBloc:=true;
  CalculusDone:=true;
  ShowMessage(TgMessageInterrupted);
end;

{========================}
procedure TMainForm.FenetreClick(Sender: TObject);
begin
     FenetreForm:=TfenetreForm.Create(self);
     if FenetreForm.ShowModal=mrOk
        then
            begin
                 fileChanged:=true;
                 Recalculer(false) {pas tous};
            end;
     FenetreForm.free
end;
{========================}
procedure TMainForm.MargeClick(Sender: TObject);
begin
     MargesForm:=TMargesForm.Create(self);
     if MargesForm.ShowModal=mrOk
        then
            begin
                 fileChanged:=true;
                 dessiner;
            end;
     MargesForm.free
end;
{========================}
procedure TMainForm.opBordureClick(Sender: TObject);
begin
     opBordure.checked:=not opBordure.Checked;
     cadre:=opBordure.checked;
     Filechanged:=true;
     AfficherModifie
end;
{========================}
procedure TMainForm.CommentairesClick(Sender: TObject);
begin
     Commentaires.checked:=not Commentaires.Checked;
     inclure_commentaires:=Commentaires.checked;
     Filechanged:=true;
     AfficherModifie
end;
{=========================}
procedure TMainForm.opCouleursClick(Sender: TObject);
begin
          opCouleurs.checked:=not opCouleurs.Checked;
          gestion_couleur:=opCouleurs.checked;
          dessiner;
          Filechanged:=true;
          AfficherModifie
end;
{========================}
procedure TMainForm.ChangerRepereClick(Sender: TObject);
begin
    ChangerRepere.checked:=not(ChangerRepere.checked);
    OriginalCoord:=not(ChangerRepere.checked);
    Filechanged:=true;
    AfficherModifie
end;
{========================}
procedure TMainForm.AfficherlesvariableslcranClick(Sender: TObject);
begin
         Afficherlesvariableslcran.checked:=not Afficherlesvariableslcran.checked;
         dessiner;
end;
{========================}
procedure TMainForm.RightColumnClick(Sender: TObject);
begin
        RightColumn.checked:=not(RightColumn.checked);
        if RightColumn.checked then
                begin
                     Splitter2.Left:= groupBox1.left-Splitter2.width;
                     groupBox1.visible:=true;
                     groupBox2.visible:=true;
                     groupBox3.visible:=true;
                end
        else begin
                     groupBox1.visible:=false;
                     groupBox2.visible:=false;
                     groupBox3.visible:=false;
                     Splitter2.Left:= ClientWidth;
             end;
end;
{===========================}
procedure TMainForm.LeftColumnClick(Sender: TObject);
begin
     begin
        LeftColumn.checked:=not(LeftColumn.checked);
        if LeftColumn.checked then
                begin
                     Splitter1.visible:=true;
                     Button9.visible:=true;
                     ComboBox1.visible:=true;
                     Panel1.visible:=true;
                end
        else begin
                     Button9.visible:=false;
                     ComboBox1.visible:=false;
                     Panel1.visible:=false;
                     Splitter1.visible:=false;
                     ScrollBox1.left:=0;
             end;
end;

end;
{===========================}
procedure TMainForm.AjouterModifierVarGlob(p: PVarGlob);
var ok:boolean;
    EditForm:TEditForm;
begin
     CurrentVarGlob:=p;
     CurrentCat:=cat_VarGlob;
     EditForm:=TEditForm.Create(MainForm);
     EditForm.Memo1.Highlighter:=MainForm.SynAnySyn1;
     EditForm.Visible:=False;
     EditForm.modal:=true;
     EditForm.Caption:=TgGlobalVar;
     ok:=(EditForm.ShowModal=mrOk);
     EditForm.free;
     if ok then
            begin
                 filechanged:=true;
                 changeVarG:=true;
                 Recalculer(false);
            end;
     ScrollBox1.SetFocus;
end;
{========================}
procedure TMainForm.VarglobsClick(Sender: TObject);
begin
     ajouterModifierVarGlob(nil);
end;
{========================}
procedure TMainForm.EditerClick(Sender: TObject);
var EditForm:TeditForm;
begin
     CurrentCat:=-1; //valeur -1 pour édition
     EditForm:=TEditForm.Create(self);
     EditForm.Memo1.Highlighter:=SynAnySyn1;
     EditForm.Caption:=TgEditAText;
     EditForm.Show;
end;


{========================}
procedure TMainForm.AfficherMessage(const titre,chaine:string);
begin
     MessageForm:=TMessageForm.Create(self);
     MessageForm.Caption:=titre;
     //MessageForm.Memo1.Highlighter:=SynAnySyn1;
     MessageForm.memo1.text:=FormatString(chaine,60);
     MessageForm.ShowModal;
end;
{========================}
procedure TMainForm.ValiderSaisieMacro(nouveau:boolean);
begin
     ChangeMac:=true;
     filechanged:=true;
     Recalculer(false);
     //ScrollBox1.SetFocus;
     MainForm.ListBox3.SetFocus
end;
{========================}
procedure TMainForm.AjouterModifierMacro(p:Pmacros);
var EditForm:TeditForm;
begin
     CurrentCat:=cat_macro;
     CurrentMac:=p;
     EditForm:=TEditForm.Create(self);
     EditForm.Memo1.Highlighter:=SynAnySyn1;
     if p=nil then
        EditForm.Caption:=TgNewMacro
     else
        EditForm.Caption:='Macro '+p^.nom;
     EditForm.Show
end;
{========================}
procedure TMainForm.Macros1Click(Sender: TObject);
begin
     ajouterModifierMacro(nil);
end;
{========================}
procedure TMainForm.ValiderSaisieGraph(nouveau:boolean);
var InfoAction:Tlist;
begin
     DeplaceElemGraph:=not nouveau;
     if nouveau then
        begin
             //InfoAction:=Tlist.Create;                 // nouvelle action
             //InfoAction.Add(liste_element.queue);     // création du dernier
            // NewAction(1,1,InfoAction);                // ajout au sommet de la pile
        end;
     ChangeGraph:=true;
     filechanged:=true;
     dessiner;
     DefaultSettings;
     ScrollBox1.Setfocus;
end;
{========================}
procedure TMainForm.AjouterModifierElement(p: Pelement; const defaultName, defaultCommand:string);

var nouveau :boolean;
    EditForm:TeditForm;
begin
     CurrentCat:=cat_utilisateur; CurrentGraph:=p; nouveau:=(p=nil);
     if nouveau
        then
             begin {nom par défaut}
                  PcomptGraph^.affixe^.setx(PcomptGraph^.affixe^.getx+1);
                  CurrentName:=defaultName+'_'+Streel(PcomptGraph^.affixe^.getx)
             end
        else CurrentName:=CurrentGraph^.nom;
        EditForm:=TEditForm.Create(self);
        EditForm.Memo1.Highlighter:=SynAnySyn1;
        if nouveau then
                begin
                  EditForm.Caption:=TgGraphElement+'-';
                  EditForm.Memo1.text:=DefaultCommand;
                end
        else EditForm.Caption:=TgGraphElement+'-'+p^.nom;
     EditForm.Show;
end;
{========================}
procedure TMainForm.GrilleClick(Sender: TObject);
begin
   AjouterModifierElement(nil,'grid', TgGridHelp);
   //ExecCommande('grid''()');
end;
{====================}
procedure TMainForm.AxesClick(Sender: TObject);
begin
     AjouterModifierElement(nil,'axes',TgAxesHelp);
     //ExecCommande('axes''()');
end;
{===================}
procedure TMainForm.ParametriqueClick(Sender: TObject);
begin
      AjouterModifierElement(nil,'parametric',TgParametricHelp);
      //ExecCommande('parametric''()');
end;
{=========================}
procedure TMainForm.CartesienneClick(Sender: TObject);
begin
      AjouterModifierElement(nil, 'cartesian',TgCartesianHelp);
      //ExecCommande('cartesian''()');
end;
{=========================}
procedure TMainForm.PolaireClick(Sender: TObject);
begin
      AjouterModifierElement(nil,'polar',TgPolarHelp);
      //ExecCommande('polar''()');
end;
{=========================}

procedure TMainForm.UtilisateurClick(Sender: TObject);
begin
      AjouterModifierElement(nil,'user','[//command'+LF+LF+']')
end;
{=====================}
procedure TMainForm.EquadiffClick(Sender: TObject);
begin
      AjouterModifierElement(nil, 'odeint',TgEquaDiffHelp)
      //ExecCommande('odeint''()');
end;
{=====================}
procedure TMainForm.PointsClick(Sender: TObject);
begin
    AjouterModifierElement(nil,'dot',tgcat_dotHelp);
    //ExecCommande('dot''()');
end;
{====================}
procedure TMainForm.DroiteClick(Sender: TObject);
begin
    AjouterModifierElement(nil,'straightL',TgDroiteHelp);
    //ExecCommande('straightL''()');
end;
{====================}
procedure TMainForm.EllipseClick(Sender: TObject);
begin
     AjouterModifierElement(nil,'ellipse',tgellipsehelp);
     //ExecCommande('ellipse''()');
end;

procedure TMainForm.ExporterenJsClick(Sender: TObject);
begin
     exporter(js,'')
end;

{====================}
procedure TMainForm.SplinecubiqueClick(Sender: TObject);
begin
     AjouterModifierElement(nil,'spline',TgSplineHelp);
    //ExecCommande('spline''()');
end;
{====================}
procedure TMainForm.BezierClick(Sender: TObject);
begin
     AjouterModifierElement(nil, 'bezier', TgBezierHelp);
     //ExecCommande('bezier''()');
end;
{====================}
procedure TMainForm.ImpliciteClick(Sender: TObject);
begin
      AjouterModifierElement(nil,'implicit',TgImplicitHelp);
      //ExecCommande('implicit''()');
end;
{====================}
procedure TMainForm.Label2Click(Sender: TObject);
begin
     AjouterModifierElement(nil,'label',tglabelhelp);
     //ExecCommande('label''()');
end;
{====================}
procedure TMainForm.LignepolygonaleClick(Sender: TObject);
begin
     AjouterModifierElement(nil,'line',tgpolylineHelp);
     //ExecCommande('line''()');
end;

{====================}
procedure TMainForm.CheminClick(Sender: TObject);
begin
    AjouterModifierElement(nil, 'path',TgPathHelp);
    //ExecCommande('path''()');
end;
{====================}
procedure TMainForm.EllipseArcClick(Sender: TObject);
begin
     AjouterModifierElement(nil, 'ellipticArc',TgEllipticArcHelp);
     //ExecCommande('ellipticArc''()');
end;
{====================}
procedure TMainForm.SurfaceClick(Sender: TObject);
begin
    AjouterModifierElement(nil, 'Dsurface',TgDsurfaceHelp);
end;
{====================}
procedure TMainForm.ToolRecalculer(Sender: TObject);
begin
      ReCalculer(true);
end;
{====================}
procedure TMainForm.ToolThetaPhi(Sender: TObject);//theta phi
begin
     execCommande('Si(Input("'+TgGiveThetaPhi+'","theta, phi",[Ent(theta*180/pi),",",Ent(phi*180/pi)]),'+
                  '[Set($x, pi*Eval(["[",chaine(),"]"])/180), Si(nil(x)=0,'+
                  '[Set(theta,Copy(x,1,1)), Set(phi,Copy(x,2,1)),ReCalc()])])')
end;
{==================}
procedure TMainForm.ToolFlecheGauche(Sender: TObject);// fleche gauche
begin
      Ptheta^.affixe^.setx(modulo2pi(Ptheta^.affixe^.getx+Panglestep^.affixe^.getx));
      command10.recalculer(true); dessiner
end;
{=================}
procedure TMainForm.ToolFlecheDroite(Sender: TObject);// Flèche droite
begin
      Ptheta^.affixe^.setx(modulo2pi(Ptheta^.affixe^.getx-Panglestep^.affixe^.getx));
      command10.recalculer(true); dessiner
end;
{=================}
procedure TMainForm.ToolFlecheHaut(Sender: TObject);// Flèche haut
//var x:real;
begin
      Pphi^.affixe^.setx(modulo2pi(Pphi^.affixe^.getx+Panglestep^.affixe^.getx));
      command10.recalculer(true); dessiner
end;
{=================}
procedure TMainForm.ToolFlecheBas(Sender: TObject);// Flèche bas
begin
     Pphi^.affixe^.setx(modulo2pi(Pphi^.affixe^.getx-Panglestep^.affixe^.getx));
     command10.recalculer(true); dessiner
end;
{=================}
function TMainForm.GestionAttributs(const objet: string):boolean;
begin
     try
        AttributsForm:=TAttributsForm.Create(self);
        AttributsForm.Caption:=TgAttributesWin+objet;
        GestionAttributs:= (AttributsForm.ShowModal=mrOk);
        AttributsForm.free;
     except GestionAttributs:= false
     end
end;
{========================}
function TMainForm.MyInputQuery(const Acaption,Aprompt:string; var chaine:String):boolean;
begin
      InputForm:=TInputForm.Create(self);
      with InputForm do
      begin
        Caption:=ACaption;
        Icon:=MainForm.Icon;
        Label1.Caption:=Aprompt;
        Edit1.text:=chaine;
        if ShowModal=mrOk
         then
             begin
                  MyInputQuery:=true;
                  chaine:=Edit1.text
             end else MyInputQuery:=false;
        free
      end;
end;
{=======================}
procedure TMainForm.ReCalculer(tous: boolean); {celui-ci entraîne le réaffichage }
var MyThread:TMyThread;
          procedure MyProc;
          begin
               command10.recalculer(calculAll)
          end;
begin
     ScrollBox1.Cursor:=crHourGlass; CalculusDone:=false;
     StopAll:=false;calculAll:=tous; CurrentFile:=name;
     {InThread:=True; DifferedMessage:='';
     MyThread := TMyThread.Create(True);
     MyThread.proc:=@MyProc;
     StopButton.enabled:=true;
     MyThread.start;
     repeat Application.ProcessMessages; Sleep(100) until CalculusDone;
     StopButton.enabled:=false; InThread:=False;}
     MyProc();
     if DifferedMessage<>'' then AfficherMessage('Message',DifferedMessage);
     if not StopAll then dessiner else
        begin
          StopAll:=False;
          MiseAjour;
        end;
     ScrollBox1.Cursor:=crdefault;
end;
{========================}
function TMainForm.execCommande(const commande:string): boolean;
var f:Pexpression;
    T:Presult;
begin
     ExecCommande:=false;
     new(f,init);
     if f^.definir(commande) then
        begin
             T:=f^.evaluer;
             Kill(Pcellule(T));
             ExecCommande:=true;
        end;
     dispose(f,detruire);
end;
{=======================}
procedure TMainForm.execMacro(const nom:string; x,y:integer);
var chaine:string;
    x1,y1:real;
begin
     x1:=Xreel(x);
     y1:=Yreel(y);
     chaine:=nom+'('+Streels(x1)+'+i*('+Streels(y1)+'))';
     ExecCommande(chaine);
end;
{========================}
procedure TMainForm.OuvrirForumClick(Sender: TObject);
begin
     HtmlHelpDataBase1.BaseURL:='https://texgraph.tuxfamily.org/forum';
     ShowHelpOrErrorForKeyword('','HTML/index.php');
end;
{========================}
procedure TMainForm.Apropos1Click(Sender: TObject);
begin
      AproposForm:=TAproposForm.Create(self);
      If AproposForm.ShowModal=mrOk then;
      AproposForm.Free;
end;
{===================================== gestion des trois listes =========================================}
procedure TMainForm.ModifierGraph(index:integer);
var p: Pelement;
begin
     p:=Pelement(liste_element.chercher_element(index+1));
     if p=nil then exit;
     AjouterModifierElement(p,'','')
end;
{===================}
procedure TMainForm.Button1Click(Sender: TObject);// Creer un élément graphique
begin
     AjouterModifierElement(nil,'user','[//command'+LF+LF+']')
end;
{===================}
procedure TMainForm.Button10Click(Sender: TObject);//attributs des éléments sélectionnés
var p:Pelement;
    i:longint;
begin
     if ListBox1.Items.Count=0 then exit;
     multiselection:= ListBox1.selcount>1;
     p:=Pelement(liste_element.chercher_element(ListBox1.ItemIndex+1));
     if p<>nil then p^.lireAttributs;
    try
     AttributsForm:=TAttributsForm.Create(self);
     AttributsForm.caption:=TgAttributesSelection;
     with AttributsForm do
     if ShowModal=mrOk then
     begin
        p:=Pelement(liste_element.tete);
        for i:=0 to ListBox1.Items.Count-1 do
            begin
                if ListBox1.selected[i] then
                            begin
                                if multiselection then
                                        begin
                                           p^.lireAttributs;
                                           valider; SetAttributs;
                                        end;
                                p^.fixeAttributs;
                                p^.recalculer;
                            end;
                p:=Pelement(p^.suivant);
            end;
        filechanged:=true;
        dessiner;
    end
   finally
     AttributsForm.free;
     multiselection:=false;
     end;
end;
{=======================}
procedure TMainForm.Button2Click(Sender: TObject); //suppression des éléments sélectionnés
var i:longint;
    p,aux:Pelement;
    theinfo:tlist;
begin
      if ListBox1.Items.Count=0 then exit;
      if  MessageDlg(TgSupprimer,mtConfirmation,[mbYes,mbNo],0)=MrYes then
         begin
              theinfo:=Tlist.Create;
              p:=Pelement(liste_element.tete);
              for i:=0 to ListBox1.Items.Count-1 do
                     if ListBox1.selected[i] then    // les éléments sélectionnés seront dans la
                       begin                         // liste des actions
                        p^.Liste_points^.detruire;   // on détruit les données inutiles
                        Kill(Pcellule(p^.donnees));
                        aux:=Pelement(p^.suivant);
                        Liste_element.retirer(Pcellule(p)); // retrait de l'élément
                        theinfo.add(p);                     // sauvegarde
                        p:=aux;
                       end
                     else p:=Pelement(p^.suivant);
              NewAction(2,1,theinfo);                      // enregistrement de l'action
              ChangeGraph:=true;
              filechanged:=true;
              dessiner;
         end;

end;
{====================
procedure TMainForm.Button10Click(Sender: TObject);//suppr tt element graph
var theinfo:tlist;
    p,aux:Pelement;
begin
      if  (liste_element.tete<>nil) and (MessageDlg(TgSupprimerTout,mtConfirmation,[mbYes,mbNo],0)=MrYes)
      then
          begin
               theinfo:=Tlist.Create;
               repeat
                     p:=Pelement(liste_element.tete);
                     Liste_element.retirer(Pcellule(p));
                     p^.Liste_points^.detruire;
                     Kill(Pcellule(p^.donnees));
                     theinfo.add(p);
               until (liste_element.tete=nil);
               NewAction(2,1,theinfo);
               filechanged:=true;
               ChangeGraph:=true;
               dessiner;
          end;
end;
====================}
procedure TMainForm.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (Key=VK_Delete) then Button2Click(sender);
end;
{====================}
procedure TMainForm.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
      if (Key=chr(VK_return)) and (ListBox1.ItemIndex>-1) then
        ModifierGraph(ListBox1.ItemIndex);
end;
{====================}
const DoubleClick:boolean=false;

procedure TMainForm.ListBox1DblClick(Sender: TObject);
begin
      DoubleClick:=true;
end;
{====================}
procedure TMainForm.ListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var P: Pelement;
    index:longint;
begin
     if (Button=mbLeft) And not( (ssShift in shift) or (ssCtrl in shift))
        then
            begin
                 olditem:=ListBox1.ItemAtPos(Point(X,Y),false);
                 moveListBox1:=true;
            end else
      if (Button=mbRight) And not( (ssShift in shift) or (ssCtrl in shift))
         then
             begin
               index:=ListBox1.ItemAtPos(Point(X,Y),false);
               P:=Pelement(liste_element.chercher_element(Index+1));
               if P<>nil then
                  begin
                       P.visible:=not P.visible;
                       dessiner;
                  end;
               ChargerGraph;
             end;
end;
{====================}
procedure TMainForm.ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var mac:Pmacros;
    code,NumIndex:integer;
begin
     if DoubleClick then
        begin ModifierGraph(olditem);
              DoubleClick:=false;
        end;
     NumIndex:=listBox1.ItemAtPos(Point(X,Y),true);
     if (Button=mbLeft)
        then
             if moveListBox1
                then
                        begin
                                if(olditem<>NumIndex)then
                                    begin
                                        liste_element.deplacer(olditem+1, NumIndex+1);
                                        listBox1.ItemIndex:=NumIndex;
                                        filechanged:=true;
                                        ChangeGraph:=true;
                                        DeplaceElemGraph:=true;
                                        dessiner;
                                        moveListBox1:=false;
                                    end
                                    else
                                if NumIndex>-1 then
                                    begin
                                        mac:=Macros('ClicGraph');
                                        if mac<>nil
                                                then begin
                                                code:=Pelement(liste_element.chercher_element(NumIndex+1)).id;
                                                ExecCommande('ClicGraph('+Streel(code)+')')
                                                end;
                                    end;
                                moveListBox1:=false;
                        end
end;
{====================}
procedure TMainForm.ChargerGraph;
var aux:Pelement;
    indice:integer;
    car:char;
begin
     indice:=ListBox1.ItemIndex;
     ListBox1.Clear;
     ListBox1.MultiSelect:=false;
     aux:=Pelement(liste_element.tete);
     while aux<>nil do
        begin
             if aux^.visible then car:='x' else car:=' ';
             ListBox1.Items.Add('['+car+'] '+String(aux^.nom));//+type_element[aux^.cat]);
             aux:=Pelement(aux^.suivant)
       end;
     if indice < ListBox1.Items.Count
     then ListBox1.ItemIndex:=indice
     else ListBox1.ItemIndex:=ListBox1.Items.Count-1;
     if deplaceElemGraph then deplaceElemGraph:=false;
     ListBox1.MultiSelect:=true;
end;
{====================}
procedure TMainForm.Button3Click(Sender: TObject); //Nouv VarG
begin
      AjouterModifierVarGlob(nil);
end;
{=======================}
procedure TMainForm.Button4Click(Sender: TObject);//Suppr VarG
var i,j:longint;
    p:PVarGlob;
    aux:Pmacros;
    Anom:string;
    ActionInfo:Tlist;
begin
     if ListBox2.ItemIndex=-1 then exit;
     if  MessageDlg(TgSupprimer,mtConfirmation,[mbYes,mbNo],0)=MrYes then
         begin
                ActionInfo:=Tlist.create;
                for j:=0 to listBox2.Items.Count-1 do
                   if listBox2.selected[j] then
                        begin
                                Anom:= ListBox2.Items.strings[j];
                                i:=1; while Anom[i]<>' ' do inc(i);
                                SetLength(Anom,i-1);
                                p:=VarGlob(Anom);
                                if p<>nil then
                                  begin
                                       VariablesGlobales^.retirer(Pcellule(p));
                                       //LesConstantes^.retirer(Pcellule(p^.variable));
                                       LesConstantes.remove(Anom);
                                       ActionInfo.Add(p);
                                  end;
                        end;
                NewAction(2,2,ActionInfo);
                ChangeVarG:=true;
                filechanged:=true;
                ReCalculer(false)
         end;
end;
{=======================}
procedure TMainForm.Button5Click(Sender: TObject);//Tt suppr VarG
var p,aux:PVarGlob;
    ActionInfo:Tlist;
begin
      if  (VariablesGlobales^.tete<>nil) and
      (MessageDlg(TgSupprimerTout,mtConfirmation,[mbYes,mbNo],0)=MrYes)
      then
          begin
               ActionInfo:=Tlist.create;
               p:=PVarGlob(VariablesGlobales^.tete);
               while p<>nil do
                          if p^.statut=0 then
                           begin
                                aux:=Pvarglob(p^.suivant);
                                VariablesGlobales^.retirer(Pcellule(p));
                                //LesConstantes^.retirer(Pcellule(p^.variable));
                                LesConstantes.Remove(p^.variable^.nom);
                                ActionInfo.Add(p);
                                p:=aux
                           end
                           else p:=PVarGlob(p^.suivant);
               NewAction(2,2,ActionInfo);
               ChangeVarG:=true;
               filechanged:=true;
               ReCalculer(false);
          end;
end;
{================================ LisBox2 ==================================}

procedure TMainForm.ListBox2DblClick(Sender: TObject);// double click VarG
begin
     DoubleClick:=true;
end;
{======================}
procedure TMainForm.ListBox2MouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if (Button=mbLeft) And not( (ssShift in shift) or (ssCtrl in shift))
        then olditem:=ListBox2.ItemAtPos(Point(X,Y),false);
end;
{======================}
procedure TMainForm.ListBox2MouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p:PVarGlob;
    Anom: string;
    i:integer;
begin
     if DoubleClick and (olditem>-1) then
        begin
             Anom:=ListBox2.Items.strings[olditem];
             i:=1; while Anom[i]<>' ' do inc(i);
             SetLength(Anom,i-1);
             p:=VarGlob(Anom);
             if p=nil then exit;
             AjouterModifierVarGlob(p);
             DoubleClick:=false;
        end;
end;

{======================}
procedure TMainForm.ListBox2KeyPress(Sender: TObject; var Key: Char);
begin
     if (Key=chr(VK_return)) then
      begin
        DoubleClick:=true; olditem:=ListBox2.ItemIndex;
        ListBox2MouseUp(Sender, mbLeft,[],0,0)
      end;
end;
{======================}
procedure TMainForm.ListBox2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (Key=VK_Delete) then Button4Click(Sender);
end;
{======================}
function StrAffixe(x,y:real):string;
var  r:string;                  {cette chaine contiendra le résultat final, par ex: [0, 1+i, -2*i] }
     Stx,Sty:string;
     signe:string[1];
 begin

        if (x=Jump^.x) {and (y=Jump^.y)} then r:=r+'jump'
               else
               begin
            Stx:=Streel(abs(x)); Sty:=Streel(abs(y));
            if (Stx='0') and (Sty='0')                    {on traite le problème des signes et de la valeur 0}
               then r:=r+'0'
               else
                   begin
                        if (Stx<>'0') then
                                          begin
                                               r:=r+Streel(x);
                                               signe:='+'
                                          end
                                      else signe:='';
                        if (Sty<>'0') then
                                           if y>0 then
                                                      if Sty<>'1' then
                                                                           r:=r+signe+Streel(y)+'*i'
                                                                  else
                                                                           r:=r+signe+'i'
                                                  else
                                                     if Sty<>'1' then
                                                                          r:=r+Streel(y)+'*i'
                                                                 else
                                                                          r:=r+'-i';
                   end;
               end;
      StrAffixe:=r;
 end;
{=================}
procedure TMainForm.ChargerVarG;
var aux:PVarGlob;
    Anom:string;
    val:Presult;
    olddigits:byte;
    index:integer;
begin
     olddigits:=digits;
     digits:=4;
     index:=listBox2.ItemIndex;
     ListBox2.Clear;
     ListBox2.MultiSelect:=false;
     aux:=PVarGloB(VariablesGlobales^.tete);
     while aux<>nil do
        begin
             if aux^.statut=0 then
                begin
                     if aux^.variable^.affixe=nil
                        then Anom:=' = NIL'
                        else  begin
                              val:=aux^.variable^.affixe;
                              if val^.cat=0 then
                                if val^.suivant<>nil then
                                       Anom:= ' = ['+StrAffixe(Paffixe(val)^.x,Paffixe(val)^.y)+',...]'
                                else Anom:= ' = '+StrAffixe(Paffixe(val)^.x,Paffixe(val)^.y)
                              else
                              if val^.cat=1 then
                                if val^.suivant<>nil then
                                       Anom:= ' = ['+Pchaine(val)^.texgraphChaine+',...]'
                                else Anom:= ' = '+Pchaine(val)^.texgraphChaine;
                              end;
                     if length(Anom)>25 then Anom:=Copy(Anom,1,25)+'...';
                     Anom:=aux^.variable^.nom+Anom;
                     ListBox2.Items.Add(Anom);
                end;
             aux:=PVarGlob(aux^.suivant)
       end;
       digits:=olddigits;
       if index>ListBox2.Items.Count-1 then index:=ListBox2.Items.Count-1;
       listBox2.ItemIndex:=index;
       ListBox2.MultiSelect:=true;
end;
{============================ ListBox3 ==========================}
procedure TMainForm.Button6Click(Sender: TObject);  //Nouv Mac
begin
       AjouterModifierMacro(nil)
end;
{=======================}
procedure TMainForm.Button7Click(Sender: TObject); //Suppr Mac
var i:longint;
    p:Pmacros;
    ActionInfo:Tlist;
begin
      if (ListBox3.ItemIndex=-1) or
      (MessageDlg(TgSupprimer,
                      mtConfirmation,[mbYes,mbNo],0)=MrNo) then  exit;
        ActionInfo:=Tlist.create;
        for i:=0 to listBox3.Items.Count-1 do
            if ListBox3.Selected[i] then
                begin
                        p:=Macros(ListBox3.Items.strings[i]);
                        if p<>nil then
                           begin
                                       LesMacros.remove(p^.nom);
                                       ActionInfo.Add(p);
                           end;
                end;
        ChangeMac:=true;
        filechanged:=true;
        NewAction(2,3,ActionInfo);
        ReCalculer(false);
end;
{=======================}
procedure TMainForm.Button8Click(Sender: TObject); // tt suppr Mac
var i:longint;
    p:Pmacros;
    ActionInfo:Tlist;
begin
     if  (LesMacros.Count>0) and
      (MessageDlg(TgSupprimerTout,mtConfirmation,[mbYes,mbNo],0)=MrYes)
      then
          begin
               ActionInfo:=Tlist.create;
               for i:=0 to listBox3.Items.Count-1 do
                begin
                        p:=Macros(ListBox3.Items.strings[i]);
                        if p<>nil then
                           begin
                                       LesMacros.remove(p^.nom);
                                       ActionInfo.Add(p);
                           end;
                end;
               NewAction(2,3,ActionInfo);
               ChangeMac:=true;
               filechanged:=true;
               ReCalculer(false);
          end;
end;
{=======================}
procedure TMainForm.ListBox3DblClick(Sender: TObject);// double clic sur une macro
begin
     DoubleClick:=true;
end;
{======================}
procedure TMainForm.ListBox3MouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if (Button=mbLeft) And not( (ssShift in shift) or (ssCtrl in shift))
        then olditem:=ListBox3.ItemAtPos(Point(X,Y),false);
end;
{======================}
procedure TMainForm.ListBox3MouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var key:char;
begin
     if DoubleClick and (olditem>-1) then
        begin
             key:=chr(VK_return);
             ListBox3KeyPress(Sender,key);
             DoubleClick:=false;
        end;
end;
{======================}
procedure TMainForm.MenuDefaireClick(Sender: TObject); // Ctrl+Z
var i,j:integer;
    ok:boolean;
    action:Taction;
    p:Pelement;
    v:Pvarglob;
    m:Pmacros;
begin
     if UserAction.Count=0 then exit;
     ok:=false; i:=-1;
     while (not ok) and (i<UserAction.Count-1) do
           begin
                inc(i);
                ok:=not Taction(UserAction.Items[i]).Canceled; //dernière action non anulée
           end;
     if ok then
        begin
             action:=UserAction.Items[i];
             action.Canceled:=true;
             if action.Atype=1 then //on annule une création
                begin
                     Case action.AOwner of
                     1: if action.donnees.Count>-1 then
                        begin
                           p:=Pelement(action.donnees.Items[0]);
                           if Trouver(p^.nom,@liste_element)<>nil then
                           begin
                                p^.Liste_points^.detruire;
                                Kill(Pcellule(p^.donnees));
                                Liste_element.retirer(Pcellule(p));
                           end;
                           ChangeGraph:=true;
                        end;
                     2: if action.donnees.Count>-1 then
                        begin
                           v:=PvarGlob(action.donnees.Items[0]);
                           if VarGlob(v^.variable^.nom)<>nil then
                           begin
                                VariablesGlobales^.retirer(Pcellule(v));
                                //LesConstantes^.retirer(Pcellule(v^.variable));
                                LesConstantes.remove(v^.variable^.nom);
                           end;
                           ChangeVarG:=true;
                        end;
                     3: if action.donnees.Count>-1 then
                        begin
                           m:=Pmacros(action.donnees.Items[0]);
                           if Macros(m^.nom)<>nil then
                              LesMacros.remove(m^.nom);
                           ChangeMac:=true;
                        end;
                     end
                end
             else                  //on annule une suppression
              begin
                 case action.AOwner of
                 1: begin
                         for j:=0 to action.donnees.Count-1 do
                         if Trouver(Pelement(action.donnees.Items[j])^.nom,
                             @liste_element)=nil then
                           Liste_element.ajouter_fin(action.donnees.Items[j]);
                         ChangeGraph:=true;
                    end;
                 2: begin
                         for j:=0 to action.donnees.Count-1 do
                          if VarGlob(PVarGlob(action.donnees.Items[j])^.variable^.nom)=nil then
                           begin
                         VariablesGlobales^.ajouter_fin(action.donnees.Items[j]);
                         LesConstantes.ajouter_fin(Pvarglob(action.donnees.Items[j])^.variable);
                           end;
                         ChangeVarG:=true;
                    end;
                 3: begin
                         for j:=0 to action.donnees.Count-1 do
                          if Macros(Pmacros(action.donnees.Items[j])^.nom)=nil then
                           begin
                           LesMacros.ajouter_fin(action.donnees.Items[j]);
                           end;
                         ChangeMac:=true;
                    end;
                 end;
              end;
              if i<>0 then //on met l'action modifiée au sommet de la pile
                 UserAction.Move(i,0);
              FileChanged:=true; ReCalculer(false);
        end;
end;

{======================}
procedure TMainForm.MenuRefaireClick(Sender: TObject);  //Ctrl+Y
var i,j:integer;
    ok:boolean;
    action:Taction;
    p:Pelement;
    v:Pvarglob;
    m:Pmacros;
begin
     if UserAction.Count=0 then exit;
     ok:=false; i:=-1;
     while (not ok) and (i<UserAction.Count-1) do
           begin
                inc(i);
                ok:=Taction(UserAction.Items[i]).Canceled;
           end;
     if ok then  //on a une action annulée
        begin
             action:=UserAction.Items[i];
             action.Canceled:=false;
             if action.Atype=1 then //on refait une création
                begin
                     Case action.AOwner of
                     1: if action.donnees.Count>-1 then
                        begin
                           p:=Pelement(action.donnees.Items[0]);
                           if Trouver(p^.nom,@liste_element)=nil then
                              Liste_element.ajouter_fin(Pcellule(p));
                           ChangeGraph:=true;
                        end;
                     2: if action.donnees.Count>-1 then
                        begin
                           v:=PvarGlob(action.donnees.Items[0]);
                           if VarGlob(v^.variable^.nom)=nil then
                           begin
                                VariablesGlobales^.ajouter_fin(Pcellule(v));
                                LesConstantes.ajouter_fin(v^.variable);
                           end;
                           ChangeVarG:=true;
                        end;
                     3: if action.donnees.Count>-1 then
                        begin
                           m:=Pmacros(action.donnees.Items[0]);
                           if Macros(m^.nom)=nil then
                           LesMacros.ajouter_fin(m);
                           ChangeMac:=true;
                        end;
                     end
                end
             else                  //on refait une suppression
              begin
                 case action.AOwner of
                 1: begin
                         for j:=0 to action.donnees.Count-1 do
                          begin
                               p:=Pelement(action.donnees.Items[j]);
                               if Trouver(p^.nom,@liste_element)<>nil then
                               begin
                                    p^.Liste_points^.detruire;
                                    Kill(Pcellule(p^.donnees));
                                    Liste_element.retirer(Pcellule(p));
                               end;
                          end;
                         ChangeGraph:=true;

                    end;
                 2: begin
                         for j:=0 to action.donnees.Count-1 do
                         begin
                              v:=Pvarglob(action.donnees.Items[j]);
                              if VarGlob(v^.variable^.nom)<>nil then
                           begin
                              VariablesGlobales^.retirer(Pcellule(v));
                              //LesConstantes^.retirer(Pcellule(v^.variable));
                              LesConstantes.remove(v^.variable^.nom)
                           end;
                         end;
                         ChangeVarG:=true;
                    end;
                 3: begin
                         for j:=0 to action.donnees.Count-1 do
                         begin
                              m:=Pmacros(action.donnees.Items[j]);
                              if Macros(m^.nom)<>nil then
                              LesMacros.remove(m^.nom);
                         end;
                         ChangeMac:=true;
                    end;
                 end;
              end;
              if i<>0 then //on met l'action modifiée au sommet de la pile
                 UserAction.Move(i,0);
              FileChanged:=true; ReCalculer(false)
        end;
end;
{======================}
procedure TMainForm.ListBox3KeyPress(Sender: TObject; var Key: Char); // touche entrée mac
var p:PMacros;
begin
    if (Key=chr(VK_return))then
       begin
             p:=Macros(string(ListBox3.Items.strings[ListBox3.ItemIndex]));
             if p=nil then exit;
             AjouterModifierMacro(p);
        end;
end;
{=======================}
 procedure TMainForm.ListBox3KeyDown(Sender: TObject; var Key: Word; //touche suppr mac
  Shift: TShiftState);
begin
    if (Key=VK_Delete) then  Button7Click(Sender);
end;
{=======================}
procedure TMainForm.ChargerMac;
var aux:PMacros;
    I,index:longint;
begin
     index:=listBox3.ItemIndex;
     ListBox3.Clear;
     ListBox3.MultiSelect:=false;

     with LesMacros do
          for I:=0 to Count-1 do
              begin
                    aux:=PMacros(List[I]^.data);
                    if (Pmacros(aux)^.statut=0) then ListBox3.Items.Add(String(aux^.nom));
              end;
     if index>ListBox3.Items.Count-1 then index:=ListBox3.Items.Count-1;
     ListBox3.ItemIndex:=index;
     ListBox3.MultiSelect:=true;
end;
{==================}
procedure TMainForm.MiseAjour;
begin
     If sourisDown then exit ;
     if ChangeGraph then begin  ChargerGraph;  changegraph:=false; end;
     if ChangeVarG then begin  ChargerVarG;  changeVarG:=false;   end;
     if ChangeMac then begin  ChargerMac;  changeMac:=false;  end;
     if ChangeFen then begin  AfficherTaille; ChangeFen:=false;  end;
     AfficherModifie;
     ScrollBox1.SetFocus
end;
{==================}
procedure TMainForm.Timer1Timer(Sender: TObject);
var res:Presult;
begin
        res:=TimerMac^.evaluer;
        listes2.Kill(Pcellule(res))
end;

{Boutons 2D et souris}
procedure TMainForm.ToolMouse(Sender: TObject);  //souris
begin
       lire_fichier(MacPath+'Mouse.mod');
       dessiner
end;

procedure TMainForm.ToolParallele(Sender: TObject); //parallel
begin
      AjouterModifierElement(nil,'Dparallel',TgDparallelHelp)
end;

procedure TMainForm.ToolPerpendiculaire(Sender: TObject); //prependiculaire
begin
      AjouterModifierElement(nil,'Dperp',TgDperpHelp)
end;

procedure TMainForm.ToolMediatrice(Sender: TObject); //mediatrice
begin
       AjouterModifierElement(nil,'Dmed',TgDmedpHelp)
end;

procedure TMainForm.ToolBissectrice(Sender: TObject); //bissectrice
begin
   AjouterModifierElement(nil,'Dbissec',TgDbissecpHelp)end;

procedure TMainForm.ToolLabelDot2D(Sender: TObject);  //ShowDot
begin
     DefaultSettings;
     ExecCommande('NewLabelDot''()');
end;

procedure TMainForm.ToolParallelogramme(Sender: TObject);  //parallelo
begin
        AjouterModifierElement(nil,'Dparallelo',TgDparalleloHelp)
end;

procedure TMainForm.ToolRectangle(Sender: TObject);  //rectangle
begin
   AjouterModifierElement(nil,'Drectangle',TgDrectangleHelp)
end;

procedure TMainForm.ToolCarre(Sender: TObject);  //carre
begin
   AjouterModifierElement(nil,'Dcarre',TgDcarreHelp)
end;

procedure TMainForm.ToolPolygoneReg(Sender: TObject);    //polyreg
begin
   AjouterModifierElement(nil,'Dpolyreg',TgDpolyregHelp)
end;

procedure TMainForm.ToolAngleDroit(Sender: TObject);     //angle droit
begin
        AjouterModifierElement(nil,'angleD',TgangleDHelp)
end;

procedure TMainForm.ToolMarkSeg(Sender: TObject);   //markseg
begin
        AjouterModifierElement(nil,'markseg',TgmarksegHelp)
end;

procedure TMainForm.ToolMarkAngle(Sender: TObject); //markangle
begin
        AjouterModifierElement(nil,'markseg',TgmarkangleHelp)
end;

procedure TMainForm.ToolDdroite(Sender: TObject); //ddroite
begin
        AjouterModifierElement(nil,'Ddroite',TgDdroiteHelp)
end;

procedure TMainForm.ToolGradDroite(Sender: TObject);  //Graddroite
begin
     AjouterModifierElement(nil,'GradDroite',TgGradDroiteHelp)
end;

procedure TMainForm.IntersectionClick(Sender: TObject);//Intersection
begin
     AjouterModifierElement(nil,'Intersec',TgIntersecHelp)
end;

procedure TMainForm.ToolgeomviewClick(Sender: TObject);
begin
     DefaultSettings;
     ExecCommande('geomview()');
end;

procedure TMainForm.ToolJavaviewClick(Sender: TObject);  //voir javaview
begin
     DefaultSettings;
     ExecCommande('javaview()');
end;

procedure TMainForm.ToolWebGLClick(Sender: TObject);
begin
     DefaultSettings;
     ExecCommande('WebGL()');
end;


procedure TMainForm.CercleClick(Sender: TObject);  //Cercle
begin
     AjouterModifierElement(nil, 'circle',TgCircleHelp);
end;

procedure TMainForm.ArcClick(Sender: TObject); //Arc d'ellipse
begin
     AjouterModifierElement(nil, 'arc',TgArcHelp);
end;


procedure TMainForm.ToolAxes3d(Sender: TObject);   //Axes3D
begin
     AjouterModifierElement(nil, 'BoxAxes3D',TgBoxAxes3DHelp);
end;

procedure TMainForm.ToolCourbe3d(Sender: TObject); //courbe3D
begin
     AjouterModifierElement(nil, 'Courbe3D',TgCourbe3DHelp);
end;

procedure TMainForm.ToolCone(Sender: TObject);   //cone
begin
     AjouterModifierElement(nil, 'Dcone',TgDconeHelp);
end;

procedure TMainForm.ToolCylindre(Sender: TObject); //cylindre
begin
     AjouterModifierElement(nil, 'Dcylindre',TgDcylindreHelp);
end;

procedure TMainForm.ToolSphere(Sender: TObject);  //sphere
begin
     AjouterModifierElement(nil, 'Dsphere',TgDsphereHelp);
end;

procedure TMainForm.ToolParallelep(Sender: TObject); //parallelep
begin
     AjouterModifierElement(nil, 'Dparallelep', TgDparallelepHelp);
end;

procedure TMainForm.ToolTetra(Sender: TObject);  //tetraedre
begin
     AjouterModifierElement(nil, 'Dtetraedre', TgDtetraedreHelp);
end;

procedure TMainForm.ToolPrisme(Sender: TObject);  //Prisme
begin
     AjouterModifierElement(nil, 'Dprisme',TgDprismeHelp);
end;

procedure TMainForm.ToolPyramide(Sender: TObject); //Pyramide
begin
     AjouterModifierElement(nil, 'Dpyramide',TgDpyramideHelp);
end;

procedure TMainForm.ToolLabelDot3D(Sender: TObject); //showdot3D
begin
     DefaultSettings;
     ExecCommande('NewLabelDot3D''()');
end;


procedure TMainForm.ToolDroite3D(Sender: TObject);    //droite3D
begin
     AjouterModifierElement(nil, 'DrawDroite', TgDrawDroiteHelp);
end;

procedure TMainForm.ToolLigne3D(Sender: TObject);   //ligne3D
begin
     AjouterModifierElement(nil, 'Ligne3D', TgLigne3DHelp);
end;

procedure TMainForm.ToolPlan3d(Sender: TObject);  //Plan3D
begin
     AjouterModifierElement(nil, 'DrawPlan', TgDrawPlanHelp);
end;

procedure TMainForm.ToolCercle3D(Sender: TObject);  //cercle3d
begin
    AjouterModifierElement(nil, 'Cercle3D', TgCercle3DHelp);
end;

procedure TMainForm.ToolArc3D(Sender: TObject); //arc3d
begin
    AjouterModifierElement(nil, 'Arc3D', TgArc3DHelp);
end;

Initialization
    {$i Unit1.lrs}
     LesConstantes.ajouter_fin(new(Pconstante,init('ZoomList',nil,false)));
     PangleStep:=new(Pconstante,init('AngleStep',new(Paffixe,init(pi/36,0)),false));
     LesConstantes.ajouter_fin(PangleStep);
     DefaultFont:=TFont.Create;
     EditDefaultFont:=TFont.Create;
     DefaultFont.Color := clwindowtext;
     EditDefaultFont.Color := clwindowtext;
     {$IFDEF Unix}
     DefaultFont.CharSet:= DEFAULT_CHARSET;
     DefaultFont.Height := 0;
     DefaultFont.Size := 0;
     DefaultFont.Name := 'default';
     DefaultFont.Pitch := fpDefault;

     EditDefaultFont.charset:=DEFAULT_CHARSET;
     EditDefaultFont.height:=-15;
     EditDefaultFont.name:= 'Monospace';
     EditDefaultFont.pitch:=fpdefault;
     {$ENDIF}
     {$IFDEF WINDOWS}
     DefaultFont.CharSet:= DEFAULT_CHARSET;
     DefaultFont.Height := -11;
     DefaultFont.Name := 'Ms Sans Serif';
     DefaultFont.Pitch := fpvariable;

     EditDefaultFont.charset:=default_charset;
     EditDefaultFont.height:=-15;
     EditDefaultFont.name:= 'Courier New';
     EditDefaultFont.pitch:=fpfixed;
     {$ENDIF}
     VisibleGraph:=true;

Finalization
     DefaultFont.free;
     EditDefaultFont.free
END.


