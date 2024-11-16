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

unit command5;

{$MODE Delphi}

 { définition des opérations, des commandes, des constantes }
INTERFACE
USES
  {$IFDEF GUI}
  BGRAbitmaptypes,BGRABitmap,
  {$ENDIF}
  Sysutils,calculs1{calculs},Classes, listes2,complex3, analyse4 {, dialogs};

Const
    CRLF = LineEnding;
    gestion_couleur:boolean=true;
    breakLoop:boolean=False;       {indique si une boucle doit être interrompue}

Type Tcolor=longint;

FUNCTION solve(f,df:Pexpression;const v:string;a,b,precision:real;nb:longint):Paffixe;
FUNCTION definir_reel(Const chaine:String; var x:real):boolean;
function IdentifierOk(Nom:Tnom):boolean;
FUNCTION MakeSpeciale(Const S:string): string; //code texgraph à remplacer dans une chaine
                                               //délimiteurs \[ et \]
function convColor(CONST couleur: Tcolor; opacity:byte=255): {$IFDEF GUI} TBGRAPixel {$ELSE} TColor {$ENDIF};
function greyscale(CONST r,g,b:  BYTE):  TColor;
FUNCTION Rgb(CONST r,g,b:  BYTE):  TColor;
FUNCTION GetRvalue(Const C: TColor):byte;
FUNCTION GetGvalue(Const C: TColor):byte;
FUNCTION GetBvalue(Const C: TColor):byte;

FUNCTION Break():boolean; // renvoie true si une sortie de boucle ou de bloc est demandée
FUNCTION Executer(const commande: string): boolean;
procedure restoreVarG(const nom:string;valeur:Presult);
FUNCTION Merge(entree:Paffixe): Paffixe; //entree=ligne polygonale par morceau (avec jump) en sortie ligne
// polygonale par composante connexe
function stringinverser(const c: string): string;

VAR     
        ChangeMac:boolean;       {indique si une macro a été créée/modifiée}

        PXmin, PXmax, PYmin, PYmax, PXscale, PYscale: Pconstante; {pointe sur les coins de la fenetre}
        PDraw, PData :Pconstante; // pointe sur la liste des points dessinés d'un élément graphique et
                                  // sur la liste des données
        PExportMode: Pconstante; //type d'exportation= tex, pst, teg, eps, pgf, epsc, pdfc, svg, myExport

        Ptheta, Pphi: Pconstante; //angles pour la 3D
        {$IFDEF GUI}
        MyBitmap : TBGRAbitmap; // pour faire le dessin dans l'interface graphique
        {$ENDIF}
IMPLEMENTATION

const
         priorite_affectation=-4;
         priorite_or=-2;
         priorite_and=-1;
         priorite_inferieur=0;       {priorités des opérations}
         priorite_superieur=0;
         priorite_egal=0;
         priorite_addition=1;
         priorite_soustraction=2;
         priorite_multiplication=3;
         priorite_division=4;
         priorite_puissance=5;
         priorite_fonction=6;
         priorite_copy=7;

type
         tRec=record Xinf,Yinf,Xsup,Ysup: real end;

         PCmListe= ^TCmListe;
         TCmListe= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               //function StrEval(arg:PListe):string;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;
               
         PM= ^TM;
         TM= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         PCopy= ^TCopy;
         TCopy= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               end;

         PSolve=^TSolve;
         TSolve= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PBreak=^TBreak;
         TBreak= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PExit=^TExit;
         TExit= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PSeq=^TSeq;
         TSeq= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:PListe):string;virtual;
                     end;
         PRange=^TRange;
         TRange= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:PListe):string;virtual;
                     end;

         Pmap= ^Tmap;
         Tmap= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:PListe):string;virtual;
                     end;

         PFor= ^TFor;            //usage interne boucle for
         TFor= object(Tmap)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:PListe):string;virtual;
                     end;

         PSi= ^TSi;
         TSi= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     function deriver(arg:Pliste;variable:string):Pcorps;virtual;
                     //function StrEval(arg:PListe):string;virtual;
                     end;

         PSetVar= ^TSetVar;
         TSetVar= object(Tcommande)
                  function executer(arg:PListe):Presult;virtual;
                  end;

         PIsString= ^TIsString;
         TIsString= object(Tcommande)
                  function executer(arg:PListe):Presult;virtual;
                  end;

         PScientificF= ^TScientificF;
         TScientificF= object(Tcommande)
                  function executer(arg:PListe):Presult;virtual;
                  end;

         PDel= ^TDel;
         TDel= object(Tcommande)
                  function executer(arg:PListe):Presult;virtual;
               end;

         PSubs= ^TSubs;
         TSubs= object(Tcommande)
                       function executer(arg:PListe):Presult;virtual;
                   end;

         PAppend=^Tappend;
         TAppend= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                end;

         PInc=^TInc;
         TInc= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

         PEchange=^TEchange;
         TEchange= object(Tcommande)
                   function executer(arg:PListe):Presult;virtual;
              end;

         PEgal= ^TEgal;
         TEgal= object(Tcommande)
                function executer(arg:PListe):Presult;virtual;
               end;

         PNEgal= ^TNEgal;
         TNEgal= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
               end;

         POr= ^TOr;
         TOr= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               end;

         PAnd= ^TAnd;
         TAnd= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
               end;

         PLoop= ^TLoop;
         TLoop= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):string;virtual;
                     end;
                     
         PWhile= ^TWhile;      //usage interne boucle while
         TWhile= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):string;virtual;
                     end;

         PAssign= ^TAssign;
         TAssign= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PNops=^TNops;
         TNops=object(Tcommande)
                   function executer(arg:PListe):Presult;virtual;
                     end;
                     
         PNargs=^TNargs;
         TNargs=object(Tcommande)
                   function executer(arg:PListe):Presult;virtual;
                     end;

         PArgs=^TArgs;
         TArgs=object(Tcommande)
                   function executer(arg:PListe):Presult;virtual;
                   //function StrEval(arg:Pliste):string;virtual;
                     end;
                     
         PStrArgs=^TStrArgs;
         TStrArgs=object(Tcommande)
                   function executer(arg:PListe):Presult;virtual;
                   //function StrEval(arg:Pliste):string;virtual;
                  end;

         PDiff= ^TDiff;
         TDiff= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         PInt= ^TInt;
         TInt= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     function deriver(arg:Pliste;variable:string):Pcorps;virtual;
                     end;

         PMix= ^TMix;
         TMix= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

         Pplus=^Tplus;
         Tplus= object(Toperation)
                     function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
                     function deriver(arg:Pliste;const variable:string):Pcorps;virtual;
                     function simplifier(arg:Pliste):Pcorps;virtual;
                     end;

         Pfois=^Tfois;
         Tfois= object(Toperation)
                     function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
                     function deriver(arg:Pliste;const variable:string):Pcorps;virtual;
                     function simplifier(arg:Pliste):Pcorps;virtual;
                     end;

         Pmoins=^Tmoins;
         Tmoins= object(Toperation)
                     function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
                     function deriver(arg:Pliste;const variable:string):Pcorps;virtual;
                     function simplifier(arg:Pliste):Pcorps;virtual;
                     end;

         Pdiv=^Tdiv;
         Tdiv= object(Toperation)
                     function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
                     function deriver(arg:Pliste;const variable:string):Pcorps;virtual;
                     function simplifier(arg:Pliste):Pcorps;virtual;
                     end;

         Pexpo=^Texpo;
         Texpo= object(Toperation)
                     function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
                     function deriver(arg:Pliste;const variable:string):Pcorps;virtual;
                     function simplifier(arg:Pliste):Pcorps;virtual;
                     end;

         PCapD= ^TCapD;
         TCapD= object(Toperation)
               function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PCutB= ^TCutB;
         TCutB= object(Toperation)
                  function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PCutA= ^TCutA;
         TCutA= object(Toperation)
               function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PCapL= ^TCapL;
         TCapL= object(Toperation)
                function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PSup= ^TSup;
         TSup= object(Toperation)
               function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PSupOuE= ^TSupOuE;
         TSupOuE= object(Toperation)
               function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PInf= ^TInf;
         TInf= object(Toperation)
               function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PInfOuE= ^TInfOuE;
         TInfOuE= object(Toperation)
               function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
               end;

         PInside=^TInside;
         TInside= object(Toperation)
                     function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
                     end;

         Psqr= ^Tsqr;
         Tsqr= object(Tfonction)
                function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Popp= ^Topp;
         Topp= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Psin= ^Tsin;
         Tsin= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pcos= ^Tcos;
         Tcos= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Ptan= ^Ttan;
         Ttan= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;
               
{contribution de Patrick BESSE 29/03/08}
               
         Pcot= ^Tcot;
         Tcot= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;
               
         Parccot= ^Tarccot;
         Tarccot= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;
               
         Pcth= ^Tcth;
         Tcth= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pargcth= ^Targcth;
         Targcth= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;
{=====================================}
         Parcsin= ^Tarcsin;
         Tarcsin= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Parccos= ^Tarccos;
         Tarccos= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Parctan= ^Tarctan;
         Tarctan= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pargsh= ^Targsh;
         Targsh= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pargch= ^Targch;
         Targch= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pargth= ^Targth;
         Targth= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pexp= ^Texp;
         Texp= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pln= ^Tln;
         Tln= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Psqrt= ^Tsqrt;
         Tsqrt= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pbar= ^Tbar;
         Tbar= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Psh= ^Tsh;
         Tsh= object(Tfonction)

               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pch= ^Tch;
         Tch= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pth= ^Tth;
         Tth= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         Pabs= ^Tabs;
         Tabs= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         PArg= ^TArg;
         TArg= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               end;

         PEnt= ^TEnt;
         TEnt= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               function deriver(arg:Pliste;variable:string):Pcorps;virtual;
               end;

         PRand= ^TRand;
         TRand= object(Tfonction)
               function evaluer(arg:Paffixe):Paffixe;virtual;
               end;

         PRe= ^TRe;
         TRe= object(Tfonction)
                     function evaluer(arg:Paffixe):Paffixe;virtual;
                     function deriver(arg:Pliste;variable:string):Pcorps;virtual;
                     end;

         PIm= ^TIm;
         TIm= object(Tfonction)
                     function evaluer(arg:Paffixe):Paffixe;virtual;
                     function deriver(arg:Pliste;variable:string):Pcorps;virtual;
                     end;
{==============================}
         PRgb= ^TRgb;
         TRgb= object(Tcommande)
                function executer(arg:PListe):Presult;virtual;
               end;
               
         PHexacolor= ^THexacolor;
         THexacolor= object(Tcommande)
                function executer(arg:PListe):Presult;virtual;
               end;

         PPermuteWith=^TPermuteWith;
         TPermuteWith= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               end;

         PSort=^Tsort;
         Tsort= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               end;

         PReverse=^TReverse;
         TReverse= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               end;

         PMerge=^TMerge;
         TMerge= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               end;

         PClip2D = ^TClip2D;
         TClip2D= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               end;
               
         PRound=^TRound;
         TRound= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
               //function StrEval(arg:PListe):string;virtual;
               end;

          PStrComp= ^TStrComp;
          TStrComp= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;
          PStrPos= ^TStrPos;
          TStrPos= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

          PStrReplace= ^TStrReplace;
          TStrReplace= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):string;virtual;
                     end;

          PStrDel= ^TStrDel;
          TStrDel= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):string;virtual;
                     end;

          PStrInsert= ^TStrInsert;
          TStrInsert= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):string;virtual;
                     end;

          PGetStr= ^TGetStr;
          TGetStr= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

          PString= ^TString;
          TString= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

          PUpperCase= ^TUpperCase;
          TUpperCase= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

          PLowerCase= ^TLowerCase;
          TLowerCase= object(Tcommande)
                      function executer(arg:PListe):Presult;virtual;
                      end;

          PStr= ^TStr;
          TStr= object(Tcommande)
                      function executer(arg:PListe):Presult;virtual;
                      end;

          PStrLength= ^TStrLength;
          TStrLength= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

          PStrCopy= ^TStrCopy;
          TStrCopy= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):string;virtual;
                     end;

          PStr2List= ^TStr2List;
          TStr2List= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):string;virtual;
                     end;

          PString2Teg= ^TString2Teg;
          TString2Teg= object(Tcommande)
                       function executer(arg:PListe):Presult;virtual;
                       end;

          PConcat= ^TConcat;
          TConcat= object(Tcommande)
                      function executer(arg:PListe):Presult;virtual;
                      end;

          PFree=^TFree;
          TFree= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
                     end;

{=======================================}
Function Break():boolean;
begin
     result:=BreakLoop or ExitBloc;
end;
{=======================================}
function greyscale(CONST r,g,b:  BYTE):  TColor;
var gris:byte;
begin
     gris:=Round(r*0.299+g*0.587+b*0.114);
     RESULT := (gris OR (gris SHL 8) OR (gris SHL 16))
end;
{=======================================}
{$IFDEF GUI}
function convColor(CONST couleur: Tcolor; opacity:byte=255):  TBGRAPixel;
begin
     if gestion_couleur
        then result.FromColor(couleur,opacity)
        else result.FromColor(greyscale(GetRvalue(couleur),GetGvalue(couleur),GetBvalue(couleur)),opacity)
end;
{$ELSE}
function convColor(CONST couleur: Tcolor; opacity:byte=255):  TColor;
begin
     if gestion_couleur
        then result:=couleur
        else result:=greyscale(GetRvalue(couleur),GetGvalue(couleur),GetBvalue(couleur))
end;
{$ENDIF}
{=======================================}
FUNCTION RGB(CONST r,g,b:  BYTE):  TColor;
  BEGIN
    if gestion_couleur then
       RESULT := (r OR (g SHL 8) OR (b SHL 16))
    else RESULT := greyscale(r,g,b)
  END {RGB};
{=======================================}
FUNCTION GetRvalue(CONST C:  TColor):byte;
  BEGIN
    RESULT := C and $FF;
   END {RGB};
{=======================================}
FUNCTION GetGvalue(CONST C:  TColor):byte;
  BEGIN
    RESULT := (C shr 8) and $FF;
   END {RGB};
{=======================================}
FUNCTION GetBvalue(CONST C:  TColor):byte;
  BEGIN
    RESULT := (C shr 16) and $FF;
   END {RGB};
{=========== identifierOk ===============}
function IdentifierOk(Nom:Tnom):boolean;
var ok:boolean;
    i,k:longint;
begin
      result:=false;
      k:=length(Nom); if k=0 then exit;
      i:=1;
      if MacroStatut=usermac
        then initial_car:=initial_car1
        else initial_car := initial_car2; //initial identificateur
      ok:=Nom[i] in initial_car;
      while (i<=k) and (Nom[i] in Set_nom) do inc(i);
      ok:=ok and (i>k);
      result:=ok
end;
{=======================================}
function TGetStr.executer(arg:PListe):Presult;
var f:Pcorps;
    aux:string;
    c:Pmacros;
    d:Pconstante;
    T:Presult;
begin
     executer:=Nil;
     if arg=Nil then exit;
     f:=Pcorps(arg^.tete);
     if f=nil then exit;
     if f^.categorie=cat_constante
           then aux:=Pconstante(f^.contenu)^.nom
           else
     if f^.categorie=cat_macro
                then aux:=Pmacros(f^.contenu)^.nom
                else aux:=MakeString(f);
     c:=macros(aux);
     if c<>nil then
        begin
              T:=c^.executer(f^.arguments);
              if T<>Nil then
              begin
                    aux:=T^.StrConcat;
                   Kill(Pcellule(T))
              end
              else aux:=''
        end
     else
          begin
               d:=constante(aux);
               if (d<>nil) and (d^.affixe<>Nil) then aux:=d^.affixe^.StrConcat
               else exit;
          end;
     executer:=New(Pchaine,init(aux))
end;
{================================}
function TBreak.executer(arg:PListe):Presult;
begin
     executer:=Nil;
     BreakLoop:=true;
end;
{================================}
function TExit.executer(arg:PListe):Presult;
begin
     executer:=Nil;
     ExitBloc:=true;  //pour sortir du bloc courant
     //BreakLoop:=true; //pour sortir des éventuelles boucles
end;
{================================}
function TString.executer(arg:PListe):Presult;
var f:Pcorps;
    aux:string;
begin
     executer:=Nil;
     if arg=Nil then exit;
     f:=Pcorps(arg^.tete);
     if f=nil then aux:=''
        else
        if f^.categorie=cat_constante
           then aux:=Pconstante(f^.contenu)^.nom
           else aux:=f^.en_chaine;
     if aux='' then exit;
     executer:=New(Pchaine,init(aux))
end;
{================================}
function TIsString.executer(arg:PListe):Presult;
var f:Pcorps;
    T:Presult;
    rep:boolean;
begin
     executer:=Nil;
     if arg=Nil then rep:=false
        else
     begin
          f:=Pcorps(arg^.tete);
          if f=nil then rep:=false
             else
             begin
                  T:=f^.evaluer;
                  if T=Nil then rep:=false else rep:= (T^.cat=1) and (T^.suivant=Nil);
             end;
     end;
     executer:=New(Paffixe,init(byte(rep),0))
end;
{================================}
function TUpperCase.executer(arg:PListe):Presult;
var f:Pcorps;
    L:type_liste;
    T:Presult;
begin
     executer:=Nil;
     if arg=Nil then exit;
     f:=Pcorps(arg^.tete);
     L.init;
     while f<>nil do
      begin
         T:=f^.evaluer;
        if T<>Nil then L.ajouter_fin(T^.majusculer);
        Kill(Pcellule(T));
        f:=Pcorps(f^.suivant)
      end;
     executer:=Presult(L.tete)
end;
{================================}
function TLowerCase.executer(arg:PListe):Presult;
var f:Pcorps;
    L:type_liste;
    T:Presult;
begin
     executer:=Nil;
     if arg=Nil then exit;
     f:=Pcorps(arg^.tete);
     L.init;
     while f<>nil do
      begin
         T:=f^.evaluer;
        if T<>Nil then L.ajouter_fin(T^.minusculer);
        Kill(Pcellule(T));
        f:=Pcorps(f^.suivant)
      end;
     executer:=Presult(L.tete)
end;
{================================}
function TString2Teg.executer(arg:PListe):Presult;
var f:Pcorps;
    L:type_liste;
    T:string;
    res: Presult;
begin
     executer:=Nil;
     if arg=Nil then exit;
     f:=Pcorps(arg^.tete);
     L.init;
     while f<>nil do
      begin
        res:=f^.evaluer;
        if res=Nil then T:=''
           else
           begin
               T:=res^.en_chaine; //une chaine pour TeXgraph
               Kill(Pcellule(res));
           end;
        if T<>'' then L.ajouter_fin(new(Pchaine,init(T)));
        f:=Pcorps(f^.suivant)
      end;
     executer:=Presult(L.tete)
end;
{================================}
function TScientificF.executer(arg:PListe):Presult;
{NumerifF( reel, deci ): renvoie la liste au format scientifique}
var f,f2:Pcorps;
    T:Paffixe;
    res:String;
    x:real;
    k:longint;
    precision:integer;
begin
     executer:=Nil;
     if arg=Nil then exit;
     f:=Pcorps(arg^.tete);
     if f=Nil then exit;
     f2:=Pcorps(f^.suivant);
     precision:=14;
     if f2<>Nil then
     begin
         T:=f2^.evalnum;
         if T<>Nil then precision:=round(T^.x);
         Kill(Pcellule(T));
         if precision=0 then precision:=14;
     end;
     T:=f^.evalnum;
     if T=Nil then res:=''
     else
         begin
             x:=T^.x; Kill(Pcellule(T));
             res:=FloatToStrF(x,ffExponent,precision+1,0);
             k:=pos('E',res)-1;
             if k=-1 then k:=length(res);
             while res[k]='0' do begin delete(res,k,1); dec(k) end;
             if (k>0) and (res[k]='.') then  delete(res,k,1);
             res:=StringReplace(res,'+','',[rfReplaceAll])
         end;
     executer:=new(Pchaine,init(res))
end;
{================================}
function TStr.executer(arg:PListe):Presult;
// Str(arg1, arg2, ..): renvoie la liste des arguments mis en chaines de caractères,
// chaque argument est évalué et le résultat est tansformé en chaine, si l'argument
// est un nom de macro (sans parenthèses) c'est le corps de la macro qui est renvoyé.
// Si le résultat de l'évaluation est Nil, c'est une chaine vide qui est renvoyée.
var f:Pcorps;
    L:type_liste;
    T:Presult;
    aux : string;
    c: Pmacros;
begin
     executer:=Nil;
     if arg=Nil then exit;
     f:=Pcorps(arg^.tete);
     L.init;
     while f<>nil do
      begin
        T:=f^.evaluer;
        if T<>Nil then
           begin
             //if (T^.cat=1) and (T^.suivant=Nil) then L.ajouter_fin(new(Pchaine,init(T^.getchaine)))
                //else L.ajouter_fin(new(Pchaine,init(T^.en_chaine)));
             L.ajouter_fin(new(Pchaine,init(T^.StrEval)));
             Kill(Pcellule(T))
           end
        else
            begin
              if f^.categorie = cat_constante then // un nom évalué à Nil
                 begin
                       aux:=Pconstante(f^.contenu)^.nom;
                       if aux<>'' then
                          begin
                               c:=macros(aux);  // nom de macro ?
                               if c<>nil then  // oui
                                  begin
                                       aux:=c^.commande;
                                       if (aux='') and (c^.contenu<>nil) and (c^.contenu^.corps<>nil)
                                          then aux:= c^.contenu^.corps^.en_chaine;
                                  end
                               else  // non
                                     aux := ''
                         end;
                       L.ajouter_fin(new(Pchaine,init(aux)));
                 end
              else L.ajouter_fin(new(Pchaine,init('')));;
            end;
        f:=Pcorps(f^.suivant)
      end;
     executer:=Presult(L.tete)
end;
{================================}
function TConcat.executer(arg:PListe):Presult;
var res:string;
    f1:Pcorps;
    T:Presult;
begin
     res:='';
     executer:=Nil;
     if arg<>nil
        then
            begin
                 f1:=Pcorps(arg^.tete);
                 while (f1<>nil) do
                       begin
                            T:=f1^.evaluer;
                            if T<>Nil then res += T^.StrConcat; // on évalue chaque arguments et on concatene
                            Kill(Pcellule(T));
                            f1:=Pcorps(f1^.suivant);
                       end;
            end;
     if res='' then exit;
     executer:=new(Pchaine,init(res))
end;
{============ TPCmListe qui évalue une liste de complexes ===================}
function TCmListe.executer(arg:PListe):Presult;
var resultat:type_liste;
    f1:Pcorps;
begin
     executer:=nil;
     if arg<>nil
        then
            begin
                 resultat.init;
                 f1:=Pcorps(arg^.tete);
                 while (f1<>nil) and (not ExitBloc) do
                       begin
                            resultat.ajouter_fin(PCellule(f1^.evaluer));
                            f1:=Pcorps(f1^.suivant);
                       end;
                 executer:=Paffixe(resultat.tete);
            end;
end;
{=======================
function TCmListe.StrEval(arg:PListe):string;
var res:string;
    f1:Pcorps;
begin
     res:='';
     if arg<>nil
        then
            begin
                 f1:=Pcorps(arg^.tete);
                 while (f1<>nil) and (not ExitBloc) do
                       begin
                            res += f1^.StrEval;
                            f1:=Pcorps(f1^.suivant);
                       end;
            end;
     result:=res
end;
=======================}
function TCmListe.deriver(arg:Pliste;variable:string):Pcorps;
var p,aux,f1:Pcorps;
    q:Pcommande;
    error:boolean;
begin
     deriver:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     
     q:=commande('Liste');
     p:=new(Pcorps,init(cat_commande,q));  {p va contenir l'expression dérivée, c'est une commande Liste}
     error:=false;
     repeat
           aux:=f1^.deriver(variable);
           if aux=nil
              then error:=true
              else p^.ajouter_arg(aux);
                       
           f1:=Pcorps(f1^.suivant);
     until (f1=nil) or  error;
     if error then begin dispose(p,detruire); p:=nil end;
     deriver:=p;
end;
{============ TM qui évalue un point du plan ou de l'espace M(a,b) ou M(a,b,c) ===================}
function TM.executer(arg:PListe):Presult;
var resultat:type_liste;
    op:Pcorps;
    compt:byte;
    error:boolean;
    x,y:real;
    T:Paffixe;
begin
     executer:=nil;
     compt:=0; error:=false;
     if arg<>nil
        then
            begin
                 resultat.init;
                 op:=Pcorps(arg^.tete);
                 while (not error) and (op<>nil) and (compt<4) do
                       begin
                            T:=Paffixe(op^.evaluer);
                            error:=(T=nil) or (T^.cat<>0) or (T^.y<>0);
                            if not error then
                               begin
                                    inc(compt);
                                    if compt=1 then x:=T^.x
                                               else
                                    if compt=2 then y:=T^.x
                                               else
                                               begin
                                                    x:=T^.x;
                                                    y:=0
                                               end;
                                    if compt>1 then resultat.ajouter_fin(new(Paffixe,init(x,y)));
                                    op:=Pcorps(op^.suivant);
                               end;

                       end;
                 if error then resultat.detruire;
                 executer:=Paffixe(resultat.tete);
            end;
end;
{=======================}
function TM.deriver(arg:Pliste;variable:string):Pcorps;
var p,aux,f1:Pcorps;
    q:Pcommande;
    error:boolean;
begin
     deriver:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;

     q:=commande('M');
     p:=new(Pcorps,init(cat_commande,q));  {p va contenir l'expression dérivée, c'est une commande M}
     error:=false;
     repeat
           aux:=f1^.deriver(variable);
           if aux=nil
              then error:=true
              else p^.ajouter_arg(aux);

           f1:=Pcorps(f1^.suivant);
     until (f1=nil) or  error;
     if error then begin dispose(p,detruire); p:=nil end;
     deriver:=p;
end;

{=============== Commande TSeq =========================================}
function Seq(f1:Pcorps;variable:Pconstante;debut,fin,pas:real):Paffixe;
var r,old:Presult;
    i:real;
    l:type_liste;
    index:Paffixe;
    {=============}
    function fini:boolean;
    begin
         if pas>0
            then fini:=i>fin
            else fini:=i<fin
    end;
    {=============}
begin
     Seq:=nil;
     BreakLoop:=False;
     if (variable^.predefinie) or (pas=0)
         or ((fin>debut) and (pas<0))
         or ((fin<debut) and (pas>0))
         then exit;
     old:=variable^.affixe;
     index:=new(Paffixe,init(debut,0));
     variable^.affixe:=index;
     l.init; i:=debut;
     while (not fini) and (not Break()) do
         begin
              index.x:=i;
              r:=f1^.evaluer;
              if index<>nil
                 then
                     begin
                          i:=index.x;
                          l.ajouter_fin(PCellule(r));
                          i += pas
                     end
                 else BreakLoop:=true;
         end;
     Kill(Pcellule(index));
     variable^.affixe:=old;
     BreakLoop:=False;
     Seq:=Paffixe(l.tete);
end;
{==============================================}
function StrSeq(f1:Pcorps;variable:Pconstante;debut,fin,pas:real):string;
var old:Presult;
    i:real;
    l,aux:string;
    index:Paffixe;
    {=============}
    function fini:boolean;
    begin
         if pas>0
            then fini:=i>fin
            else fini:=i<fin
    end;
    {=============}
begin
     StrSeq:=''; BreakLoop:=False;
     if (variable^.predefinie) or (pas=0)
         or ((fin>debut) and (pas<0))
         or ((fin<debut) and (pas>0))
         or (variable^.affixe^.cat<>0)
         then exit;
     old:=variable^.affixe;
     index:=new(Paffixe,init(debut,0));
     variable^.affixe:=index;
     l:=''; i:=debut;
     while (not fini) and (not Break()) do
         begin
              index.x:=i;
              aux:=MakeString(f1);
              if index<>nil
                 then
                     begin
                          i:=index.x;
                          l += aux;
                          i += pas
                     end
                 else BreakLoop:=true;
         end;
     Kill(Pcellule(index));
     variable^.affixe:=old;
     BreakLoop:=False;
     StrSeq:=l;
end;
{==================================================}
function TSeq.executer(arg:PListe):Presult;
var f1,f2,f3,f4,f5:Pcorps;
    debut,fin,pas:real;
    T:Paffixe;
    error:boolean;
begin
     executer:=nil;            {f1=expression, f2=compteur, f3=valeur dep, f4= valeur fin, f5=pas}
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     f4:=Pcorps(f3^.suivant);
     if f4=nil then exit;
     f5:=Pcorps(f4^.suivant);
     if f2^.categorie<>cat_constante then exit;
     T:=f3^.evalNum;
     error:=false;
     pas:=1; debut:=0; fin:=0;
     if (T<>nil) and (T^.cat=0)
        then
            begin
                  if T^.y<>0
                     then error:=true
                     else debut:=T^.x;
                  Kill(Pcellule(T))
            end
        else begin Kill(Pcellule(T)); exit end;
     T:=f4^.evalNum;
     if (T<>nil) and (T^.cat=0)
        then
            begin
                 if T^.y<>0
                    then error:=true
                    else fin:=T^.x;
                 Kill(Pcellule(T))
            end
        else begin Kill(Pcellule(T)); exit end;
     if f5<>nil
        then
            begin
                 T:=f5^.evalNum;
                 if (T<>nil) and (T^.cat=0)
                    then
                        begin
                             if T^.y<>0
                                then error:=true
                                else pas:=T^.x;
                             Kill(Pcellule(T))
                        end
                    else begin Kill(Pcellule(T)); exit end;
            end
        else pas:=1;
     if not error
        then
            executer:=Seq(f1,Pconstante(f2^.contenu),debut,fin,pas)
end;
{==================================================
function TSeq.StrEval(arg:PListe):string;
var f1,f2,f3,f4,f5:Pcorps;
    debut,fin,pas:real;
    T:Paffixe;
    error:boolean;
begin
     StrEval:='';            //f1=expression, f2=compteur, f3=valeur dep, f4= valeur fin, f5=pas
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     f4:=Pcorps(f3^.suivant);
     if f4=nil then exit;
     f5:=Pcorps(f4^.suivant);
     if f2^.categorie<>cat_constante then exit;
     T:=Paffixe(f3^.evaluer);
     error:=false;
     pas:=1; debut:=0; fin:=0;
     if (T<>nil) and (T^.cat=0)
        then
            begin
                  if T^.y<>0
                     then error:=true
                     else debut:=T^.x;
                  Kill(Pcellule(T))
            end
        else begin Kill(Pcellule(T)); exit end;
     T:=Paffixe(f4^.evaluer);
     if (T<>nil) and (T^.cat=0)
        then
            begin
                 if T^.y<>0
                    then error:=true
                    else fin:=T^.x;
                 Kill(Pcellule(T))
            end
        else begin Kill(Pcellule(T)); exit end;
     if f5<>nil
        then
            begin
                 T:=Paffixe(f5^.evaluer);
                 if (T<>nil) and (T^.cat=0)
                    then
                        begin
                             if T^.y<>0
                                then error:=true
                                else pas:=T^.x;
                             Kill(Pcellule(T))
                        end
                    else begin Kill(Pcellule(T)); exit end;
            end
        else pas:=1;
     if not error
        then
            StrEval:=StrSeq(f1,Pconstante(f2^.contenu),debut,fin,pas)
end;
=============== commande TRange =================================}
// Range(depart, fin (incluse) [, pas]) : renvoie la liste des nombres de <départ> à
// <fin> avec un pas de <pas> (1 par défaut), le pas peut être négatif.
function TRange.executer(arg: Pliste): Presult;
var f1,f2,f3:Pcorps;
    i,debut,fin,pas:real;
    T, r: Paffixe;
    l: type_liste;
    {=============}
    function fini:boolean;
    begin
         if pas>0
            then fini:=i>fin
            else fini:=i<fin
    end;
    {=============}
begin
     executer:=nil;            {f1=depart, f2=arrivee, f3=pas}
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2 = Nil then // on a Range(fin), donc depart=1 et pas=1
         begin
              debut := 1; pas := 1;
              T := f1^.evalNum;
              if T = Nil then exit
              else begin fin:=T^.x; Kill(Pcellule(T)) end
         end
     else // on a range(depart,fin,..)
         begin
              T := f1^.evalNum;
              if T = Nil then exit
              else begin debut:=T^.x; Kill(Pcellule(T)) end;
              T := f2^.evalNum;
              if T = Nil then exit
              else begin fin:=T^.x; Kill(Pcellule(T)) end;
              f3 := Pcorps(f2^.suivant);
              if f3 = Nil then pas := 1
              else
                  begin
                       T := f3^.evalNum;
                       if T = Nil then exit
                       else begin pas:=T^.x; Kill(Pcellule(T)) end
                  end
         end;
     //maintenant on a depart, arrivee et pas
     BreakLoop:=False;
     if (pas=0)
         or ((fin>debut) and (pas<0))
         or ((fin<debut) and (pas>0))
     then exit;
     l.init; i:=debut;
     while (not fini) and (not Break()) do
         begin
              r:=New(Paffixe,init(i,0));
              if r<>Nil then
                  begin
                       l.ajouter_fin(PCellule(r));
                       i += pas
                  end
                 else BreakLoop:=true;
         end;
     BreakLoop:=False;
     executer:=Paffixe(l.tete);
end;
{==============================================
function TRange.StrEval(arg: Pliste): string;
var f1,f2,f3:Pcorps;
    i,debut,fin,pas:real;
    T: Paffixe;
    l: string;

    function fini:boolean;
    begin
         if pas>0
            then fini:=i>fin
            else fini:=i<fin
    end;

begin
     StrEval := '';            //f1=depart, f2=arrivee, f3=pas
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2 = Nil then // on a Range(fin), donc depart=1 et pas=1
         begin
              debut := 1; pas := 1;
              T := f1^.evalNum;
              if T = Nil then exit
              else begin fin:=T^.x; Kill(Pcellule(T)) end
         end
     else // on a range(depart,fin,..)
         begin
              T := f1^.evalNum;
              if T = Nil then exit
              else begin debut:=T^.x; Kill(Pcellule(T)) end;
              T := f2^.evalNum;
              if T = Nil then exit
              else begin fin:=T^.x; Kill(Pcellule(T)) end;
              f3 := Pcorps(f2^.suivant);
              if f3 = Nil then pas := 1
              else
                  begin
                       T := f3^.evalNum;
                       if T = Nil then exit
                       else begin pas:=T^.x; Kill(Pcellule(T)) end
                  end
         end;
     //maintenant on a depart, arrivee et pas
     BreakLoop:=False;
     if (pas=0)
         or ((fin>debut) and (pas<0))
         or ((fin<debut) and (pas>0))
     then exit;
     l := ''; i:=debut;
     while (not fini) and (not Break()) do
         begin
              l += floatToStr(i);
              i += pas
         end;
     BreakLoop:=False;
     StrEval := l;
end;
=============== commande Tmap =================================}
function TMap.executer(arg:Pliste):Presult;  //Map( expression, variable, liste <,pas ou paquet>) paquet=i+entier
var f1,f2,f3,f4:Pcorps;
    T,index,old:Presult;
    l:type_liste;
    del:boolean;
    variable:Pconstante;
    pas,by,i: longint;
    returnjump:boolean;

    procedure mapby;
    var aux:type_liste;
    begin
          i:=0; aux.init;
          repeat
                Inc(i);
                if Isjump(index) then
                   begin
                        sep^.y:=Paffixe(index)^.y;
                        if by<0 then //correspond a l'option "by/By jump"
                         begin
                              variable^.affixe:=Presult(aux.tete);
                              l.ajouter_fin(PCellule(f1^.evaluer));
                         end;
                        if returnjump then l.ajouter_fin(new(Paffixe,init(Paffixe(index)^.x, Paffixe(index)^.y))); //on renvoie le jump dans la liste
                        Kill(Pcellule(variable^.affixe));
                        aux.init; i:=0
                   end
                   else
                   begin
                        aux.ajouter_fin(index^.dup);
                        if i=by then
                           begin
                                variable^.affixe:=Presult(aux.tete);
                                l.ajouter_fin(PCellule(f1^.evaluer));
                                Kill(Pcellule(variable^.affixe));
                                aux.init;
                                i:=0
                           end;
                   end;
                index:=Paffixe(index^.suivant);
          until (index=nil) or Break();
          if ((by=-1) and (aux.tete<>nil) and (not Break()))// correspond a l'option "by jump", on traite la dernière partie si elle n'est pas vide,
              or (by=-2) // by=-2: traitement par composante, la dernière est traitée même si elle est vide (by comp).
             then
             begin
                  variable^.affixe:=Presult(aux.tete);
                  l.ajouter_fin(PCellule(f1^.evaluer));
                  Kill(Pcellule(variable^.affixe));
                  aux.init;
             end;
          aux.detruire;
     end;
     
begin
     executer:=nil;                {f1=expression, f2=variable, f3=liste, f4=pas}
     BreakLoop:=False;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     if f2^.categorie<>cat_constante then exit;
     if f3^.categorie=cat_constante
        then
            begin
                 del:=false;       {si f3 est une constante on ne la duplique pas}
                 T:=Pconstante(f3^.contenu)^.affixe;
            end
        else
            begin
                 del:=true;T:=f3^.evaluer;  {f3 est dupliquée}
            end;
     if T=nil then exit;
     f4:=Pcorps(f3^.suivant);
     pas:=1; by:=0; returnjump:=true;
     if f4<>Nil  then
        begin
             old:=f4^.evalNum;
             if old<>Nil then
                if Isjump(old) then begin by:=-1; returnjump:=(Paffixe(old)^.y=1) end
                else
                    if Paffixe(old)^.x=-jump^.x then begin by:=-2;  returnjump:=(Paffixe(old)^.y=1) end // by/By comp
                    else
                        begin pas:=round(Paffixe(old)^.x); by:=round(abs(Paffixe(old)^.y));returnjump:=(Paffixe(old)^.y=1) end;
             if pas=0 then pas:=1;
             if by=1 then by:=pas; // il y a l'option by/By <paquet>
             //if by=1 then by:=0; //paquet de 1
             Kill(Pcellule(old))
        end;
     index:=T; l.init;
     variable:=Pconstante(f2^.contenu);
     old:=variable^.affixe;
     if by<>0 then mapby
     else
     //if (T^.cat=0) or (T^.suivant<>Nil) then // liste de complexes
     begin
          i:=pas;
          repeat
                if i=pas then
                   begin
                     variable^.affixe:=index^.dup;
                     l.ajouter_fin(f1^.evaluer);
                     Kill(Pcellule(variable^.affixe));
                     i:=0
                   end;
                index:=Presult(index^.suivant);Inc(i);
          until (index=nil) or Break();
     end;
     if del then Kill(Pcellule(T));
     executer:=Presult(l.tete);
     variable^.affixe:=old;
     BreakLoop:=False;
end;
{=============== commande TMap =================================
function TMap.strEval(arg:Pliste):string;
var f1,f2,f3,f4:Pcorps;
    T,index,old:Presult;
    l:string;
    del:boolean;
    variable:Pconstante;
    pas,by,i, j, long: longint;
    chaine: string;
    returnjump:boolean;
    
    procedure mapby;
    var aux:type_liste;
    begin
          i:=0; aux.init;
          repeat
                Inc(i);
                if Isjump(index) then
                   begin
                     sep^.y:=Paffixe(index)^.y;
                     if by<0 then //correspond a l'option "by jump"
                         begin
                              variable^.affixe:=Paffixe(aux.tete);
                              l += MakeString(f1);
                         end;
                        if returnjump then l:=l+'jump'; //on renvoie le jump dans la liste
                        aux.detruire;
                        i:=0
                   end
                   else
                   begin
                       aux.ajouter_fin(index^.dup);
                       if i=by then
                          begin
                               variable^.affixe:=Paffixe(aux.tete);
                               l += MakeString(f1);
                               aux.detruire;
                               i:=0
                          end;
                  end;
                index:=Paffixe(index^.suivant);
          until (index=nil) or Break();
          if ((by=-1) and (aux.tete<>nil) and (not Break())) or (by=-2) then //correspond a l'option "by jump", on traite la dernière partie
             begin
                  variable^.affixe:=Paffixe(aux.tete);
                  l += MakeString(f1);
             end;
          aux.detruire;
     end;
    

begin
     strEval:='';                //f1=expression, f2=variable, f3=liste
     BreakLoop:=False;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     if f2^.categorie<>cat_constante  then exit;
     if f3^.categorie=cat_constante
        then
            begin
                 del:=false;       //si f3 est une constante on ne la duplique pas
                 T:=Pconstante(f3^.contenu)^.affixe;
            end
        else
            begin
                 del:=true;T:=f3^.evaluer;   //f3 est dupliquée
            end;
     if T=nil then exit;
     f4:=Pcorps(f3^.suivant);
     pas:=1; by:=0; returnjump:=true;
     if f4<>Nil  then
        begin
             old:=f4^.evaluer; if old<>Nil then old:=old^.evalNum;
             if old<>Nil then
                if Isjump(old) then begin by:=-1; returnjump:=(Paffixe(old)^.y=1) end
                else begin pas:=round(Paffixe(old)^.x); by:=round(Paffixe(old)^.y) end;
             if pas=0 then pas:=1;
             if by=1 then by:=pas; // option by <paquet>
             if by=1 then by:=0; //paquet de 1
             Kill(Pcellule(old))
        end;
     index:=T; l:='';
     variable:=Pconstante(f2^.contenu);
     old:=variable^.affixe;
     if by<>0 then mapby
     else
     if (T^.cat=0) or (T^.suivant<>Nil) then // liste de complexes
        begin
          variable^.affixe:=Nil;
          i:=pas;
          repeat
                if i=pas then
                   begin
                     variable^.affixe:=index^.dup;
                     l:=l+MakeString(f1);
                     Kill(Pcellule(variable^.affixe));
                     i:=0
                   end;
                index:=Paffixe(index^.suivant);Inc(i);
          until (index=nil) or Break();
      end
      else // on doit parcourir une chaîne
       begin
            chaine := T^.getchaine;
            long := length(chaine);
            i:=pas; j := 1;
            variable^.affixe:=new(Pchaine,init(''));
            repeat
                  if i=pas then
                     begin
                       if j<=long then
                          begin
                               variable^.affixe^.setchaine(chaine[j]);
                               l:=l+MakeString(f1);
                               //l.ajouter_fin(f1^.evaluer);
                          end;
                       i:=0
                     end;
                  Inc(i); Inc(j)
            until (j>long) or Break();
            Kill(Pcellule(variable^.affixe));
       end;
     if del then Kill(Pcellule(T));
     variable^.affixe:=old;
     strEval:=l;
     BreakLoop:=False;
end;
==============================================}
function TFor.executer(arg:Pliste):Presult;
var f1,f2,f3,f4:Pcorps;
begin
     executer:=nil;                {f1=variable, f2=liste,f3=by ou expression f4=expression}
     BreakLoop:=False;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     f4:=Pcorps(f3^.suivant);
     if f4=nil then //pas d'option by
        begin
             arg.tete:=f3; f3^.precedent:=nil; f3^.suivant:=f1;
             f1^.precedent:=f3; f2^.suivant:=nil; arg.queue:=f2;
             executer:=Tmap.executer(arg);
             arg.tete:=f1; f1^.precedent:=nil; f2^.suivant:=f3;
             f3^.precedent:=f2; f3^.suivant:=nil; arg.queue:=f3;
        end
     else   //option by
         begin
             arg.tete:=f4; f4^.precedent:=nil;
             f4^.suivant:=f1;f1^.precedent:=f4;
             f2^.suivant:=f3; arg.queue:=f3;
             executer:=Tmap.executer(arg);
             arg.tete:=f1; f1^.precedent:=nil; f2^.suivant:=f3;
             f3^.precedent:=f2; f3^.suivant:=f4;
             f4^.precedent:=f3; f4^.suivant:=nil;
             arg.queue:=f4;
        end;
end;
{========================================
function TFor.strEval(arg:Pliste):string;
var f1,f2,f3,f4:Pcorps;
begin
     strEval:='';                //f1=variable, f1=liste,f3=expression
     BreakLoop:=False;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     f4:=Pcorps(f3^.suivant);
     if f4=nil then
        begin
             arg.tete:=f3; f3^.precedent:=nil; f3^.suivant:=f1;
             f1^.precedent:=f3;f2^.suivant:=nil; arg.queue:=f2;
             strEval:=Tmap.strEval(arg);
             arg.tete:=f1; f1^.precedent:=nil; f2^.suivant:=f3;
             f3^.precedent:=f2;f3^.suivant:=nil; arg.queue:=f3;
        end
     else
         begin
             arg.tete:=f4; f4^.precedent:=nil;
             f4^.suivant:=f1;f1^.precedent:=f4;
             f2^.suivant:=f3; arg.queue:=f3;
             strEval:=Tmap.strEval(arg);
             arg.tete:=f1; f1^.precedent:=nil; f2^.suivant:=f3;
             f3^.precedent:=f2;f3^.suivant:=f4;
             f4^.precedent:=f3;f4^.suivant:=nil;
             arg.queue:=f4;
        end;
        BreakLoop:=False;
end;
=================== commande TSi =========================}
function TSi.executer(arg:Pliste):Presult;
var f1,f2,f3:Pcorps;
    r:Presult;
    T:Paffixe;
    stop:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     r:=nil;
     stop:=false;
     repeat
           T:=f1^.evalNum;
           if T=nil then exit;
           If (T^.x=1) and (T^.y=0)
              then
                  begin
                       r:=f2^.evaluer;
                       stop:=true
                  end
              else
                  if (T^.x=0) and (T^.y=0)
                     then
                         if (f3<>nil) and (f3^.suivant=nil)
                            then
                                begin
                                     r:=f3^.evaluer;
                                     stop:=true
                                end
                            else
                     else stop:=true;
           Kill(Pcellule(T));
           f1:=f3;
           if f1<>nil
              then f2:=Pcorps(f1^.suivant)
              else f2:=nil;
           if f2<>nil then f3:=Pcorps(f2^.suivant);
     until (f2=nil) or stop;
     executer:=r
end;
{===========================
function TSi.StrEval(arg:Pliste):String;
var f1,f2,f3:Pcorps;
    r:string;
    T:Paffixe;
    stop:boolean;
begin
     StrEval:='';
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     r:='';
     stop:=false;
     repeat
           T:=f1^.evalNum;
           if T=nil then exit;
           If (T^.x=1) and (T^.y=0)
              then
                  begin
                       r:=MakeString(f2);
                       stop:=true
                  end
              else
                  if (T^.x=0) and (T^.y=0)
                     then
                         if (f3<>nil) and (f3^.suivant=nil)
                            then
                                begin
                                     r:=MakeString(f3);
                                     stop:=true
                                end
                            else
                     else stop:=true;
           Kill(Pcellule(T));
           f1:=f3;
           if f1<>nil
              then f2:=Pcorps(f1^.suivant)
              else f2:=nil;
           if f2<>nil then f3:=Pcorps(f2^.suivant);
     until (f2=nil) or stop;
     StrEval:=r
end;
===========================}
function TSi.deriver(arg:Pliste;variable:string):Pcorps;
var p,aux,f1,f2,f3:Pcorps;
    q:Pcommande;
    stop,error:boolean;
begin
     deriver:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     q:=commande('Si');
     p:=new(Pcorps,init(cat_commande,q));  {p va contenir l'expression dérivée, c'est une commande Si}
     stop:=false;error:=false;
     repeat
           p^.ajouter_arg(f1^.dupliquer);
           aux:=f2^.deriver(variable);
           if aux=nil
              then error:=true
              else
                  begin
                       p^.ajouter_arg(aux);
                       if (f3<>nil) and (f3^.suivant=nil)
                          then
                              begin
                                   aux:=f3^.deriver(variable);
                                   if aux=nil
                                      then error:=true
                                      else p^.ajouter_arg(aux);
                                   stop:=true
                              end;
                  end;
           f1:=f3;
           if f1<>nil
              then f2:=Pcorps(f1^.suivant)
              else f2:=nil;
           if f2<>nil
              then f3:=Pcorps(f2^.suivant);
     until (f2=nil) or stop or error;
     if error then dispose(p,detruire);
     if f3<>nil then 
     deriver:=p;
end;

{=============== commande TSolve =========================================}
function solve(f,df:Pexpression;const v:string;a,b,precision:real;nb:longint):Paffixe;
var r0,r1,r2,r3,r4 :PAffixe;
    liste:type_liste;
    i,k:longint;
    x,fin,deltaX:real;
    error:boolean;
begin
     liste.init;
     x:=a;
     new(r0,init(x,0));
     f^.assigner(v,r0);
     df^.assigner(v,r0);
     deltaX:=(b-a)/nb;
     r1:=nil;r2:=nil;r3:=nil;r4:=nil;
     {while x+deltaX/2<=b} for k:=1 to nb do
           begin
                r0^.x:=x+deltaX/2;
                fin:=x+deltaX;
                i:=1;
                error:=true;
                while i<=5 do
                    begin
                         r1:=f^.evalNum;
                         if r1<>nil then
                            begin
                                 r2:=df^.evalNum;
                                 if r2<>nil then
                                    begin
                                    r4:=diviserC(r1,r2);
                                    r3:=soustraireC(r0,r4);
                                    error:= (r3=nil);
                                    if (not error) then r0^.x:=r3^.x else i:=5
                                    end else i:=5;
                            end else i:=5;
                         Kill(Pcellule(r1));
                         Kill(Pcellule(r2));
                         Kill(Pcellule(r3));
                         Kill(Pcellule(r4));
                         inc(i)
                    end;
                if not error then
                       if (r0^.x>=x) and (r0^.x<fin) then  //modification de r0^.x<fin
                          begin
                           r1:=f^.evalNum;
                           if (r1<>nil) and (abs(r1^.x)<=precision) then
                           liste.ajouter_fin(new(PAffixe,init(r0^.x,x+deltaX/2)));
                           if r1<>nil then Kill(Pcellule(r1));
                          end;
                 x:=x+deltaX;
           end;
    solve:=Paffixe(liste.tete);
    f^.desassigner(v);df^.desassigner(v);
    Kill(Pcellule(r0));
end;

{commande TSolve }
 function TSolve.executer(arg:Pliste):Presult;
var f1,f2,f3,f4,f5:Pcorps;
    r,aux:Paffixe;
    f,df:Pexpression;
    a,b:real;
    n:word;
    ok,keepvarloc:boolean;
    ChaineAux:string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     f4:=Pcorps(f3^.suivant);
     if f4=nil then exit;
     f5:=Pcorps(f4^.suivant);
     new(f,init);
     keepvarloc:=KeepVarLocName;
     KeepVarLocName:=false;//true;
     ChaineAux:=f1^.en_chaine;
     KeepVarLocName:=keepvarloc;
     ok:=f^.definir(ChaineAux);
     if not ok then begin dispose(f,detruire); exit end;
     df:=f^.deriver(Pconstante(f2^.contenu)^.nom);
     if df=nil then begin dispose(f,detruire); exit end;
     r:=f3^.evalNum;
     if r<>nil then begin a:=r^.x; Kill(Pcellule(r)) end
               else begin dispose(f,detruire); dispose(df,detruire); exit end;
     r:=f4^.evalNum;
     if r<>nil then begin b:=r^.x; Kill(Pcellule(r)) end
               else begin dispose(f,detruire); dispose(df,detruire); exit end;
     if f5<>nil then
        begin
        r:=f5^.evalNum;
        if r<>nil then begin n:=Round(abs(r^.x)); if n=0 then n:=25; Kill(Pcellule(r)) end
                  else begin dispose(f,detruire); dispose(df,detruire); exit end;
        end else n:=25;
     aux:=solve(f,df,Pconstante(f2^.contenu)^.nom,a,b,1.e-5,n);{nil;}
     r:=aux;
     while r<>nil do
           begin
                r^.y:=0;
                r:=Paffixe(r^.suivant);
           end;
     executer:=aux;
     dispose(f,detruire);
     dispose(df,detruire);
end;
{================= commande TCopy ===============}
function stringCopy(const chaine: string; depart, nombre: longint):Presult; //fonction copy appliquée à une chaîne
var
    i :longint;
    res:string;
begin
     stringCopy:=Nil;
     if chaine='' then res:=''
     else
         begin
           i:=length(chaine);
           if depart<0 then //on renvoit les "nombre" derniers
              begin
                   if (nombre=0) or (nombre>=i) then res:=chaine
                   else res:= copy(chaine,i-nombre+1,nombre)
              end
              else   //on renvoit les "nombre" termes partant du n°depart
              begin
                   if nombre=0 then nombre:=i;
                   res:=copy(chaine,depart,nombre)
              end;
         end;
     stringCopy:=new(Pchaine,init(res))
end;

function TCopy.executer(arg:Pliste):Presult; // fonction Copy générale
var f1,f2,f3:Pcorps;
    T,aux:Presult;
    r:Paffixe;
    i,depart,nombre:longint;
    l:type_liste;
    del,all: boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     r:=f2^.evalNum;
     if r=nil then exit;
     depart:=Round(r^.x);
     if depart=0 then depart:=-1;
     //if depart<0 then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then if r^.suivant<>nil then nombre:=Round(Paffixe(r^.suivant)^.x) else nombre:=1
               else begin
                    Kill(Pcellule(r));
                    r:=f3^.evalNum;
                    if r=nil then exit;
                    nombre:=Round(r^.x);
                    end;
     Kill(Pcellule(r));
     if f1^.categorie=cat_constante then
        begin
             del:=false;
             T:=Pconstante(f1^.contenu)^.affixe
        end else begin del:=true;T:=f1^.evaluer; end;
     if T=nil then exit;
     aux:=T;
     {if (T^.cat = 1) and (T^.suivant=Nil) //chaine
        then
            begin
                 executer := stringCopy(T^.getchaine,depart,nombre);
                 if del then Kill(Pcellule(T));
                 exit
            end;}
     if depart<0 then //on renvoit les "nombre" termes partant de -depart dand la liste à l'envers
        begin
             i:=-1;
             while (aux^.suivant)<>nil do aux:=Paffixe(aux^.suivant);//on se place sur le dernier element
             while (aux<>nil) and (i>depart) do begin aux:=Paffixe(aux^.precedent); dec(i) end;
             if aux=nil then begin if del then Kill(Pcellule(T)); exit end;
             i:=0;l.init; all:=nombre=0;
             while (aux<>nil) and (all or (i<nombre)) do
                   begin l.ajouter_debut(PCellule(aux^.dup));
                         inc(i);aux:=Paffixe(aux^.precedent)
                   end;
        end
        else   //on renvoit les "nombre" termes partant du n°depart le la liste
        begin
             i:=1;
             while (aux<>nil) and (i<depart) do begin aux:=Paffixe(aux^.suivant); inc(i) end;
             if aux=nil then begin if del then Kill(Pcellule(T)); exit end;
             i:=0;l.init; all:=nombre=0;
             while (aux<>nil) and (all or (i<nombre)) do
                   begin l.ajouter_fin(PCellule(aux^.dup));
                         inc(i);aux:=Paffixe(aux^.suivant)
                   end;
        end;
     if del then Kill(Pcellule(T));
     executer:=Paffixe(l.tete)
end;
{==========================TLoop ==============}
function TLoop.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    l:type_liste;
    T:Presult;
    r:Paffixe;
    stop:boolean;
begin
     executer:=nil;
     BreakLoop:=False;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     l.init;
     repeat
           T:=f1^.evaluer;
           if T<>nil then l.ajouter_fin(PCellule(T));
           r:=f2^.evalNum;
           stop:=(r=nil) or (r^.x=1) or Break();
           if r<>nil then Kill(Pcellule(r));
     until stop;
     BreakLoop:=False;
     executer:=Paffixe(l.tete)
end;
{===================== StrLoop ===============
function TLoop.StrEval(arg:PListe):string;
var f1,f2:Pcorps;
    aux:string;
    r:Paffixe;
    stop:boolean;
begin
     StrEval:='';
     BreakLoop:=False;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     aux:='';
     repeat
           aux += MakeString(f1);
           r:=f2^.evalNum;
           stop:=(r=nil) or (r^.x=1) or Break();
           Kill(Pcellule(r));
     until stop;
     BreakLoop:=False;
     StrEval:=aux
end;
==========================TWhile ==============}
function Twhile.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    l:type_liste;
    T:Presult;
    r:Paffixe;
    stop:boolean;
begin
     executer:=nil;
     BreakLoop:=False;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);    {f1= condition, f2=action}
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     l.init;
     r:=f1^.evalNum;
     stop:=(r=nil) or (r^.x=0);
     if r<>nil then Kill(Pcellule(r));
     while not stop do
       begin
           T:=f2^.evaluer;
           if T<>nil then l.ajouter_fin(PCellule(T));
           r:=f1^.evalNum;
           stop:=(r=nil) or (r^.x=0) or Break();
           Kill(Pcellule(r));
       end;
     BreakLoop:=False;
     executer:=Paffixe(l.tete)
end;
{===================== Strwhile ===============
function Twhile.StrEval(arg:PListe):string;
var f1,f2:Pcorps;
    aux:string;
    r:Paffixe;
    stop:boolean;
begin
     StrEval:='';
     BreakLoop:=False;
     if arg=nil then exit;    //f1= condition, f2=action
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     aux:='';
     r:=f1^.evalNum;
     stop:=(r=nil) or (r^.x=0);
     Kill(Pcellule(r));
     while not stop do
        begin
           aux += MakeString(f2);
           r:=f1^.evalNum;
           stop:=(r=nil) or (r^.x=0) or Break();
           Kill(Pcellule(r));
        end;
     BreakLoop:=False;
     StrEval:=aux
end;
=====================================}
{TAssign}
function TAssign.executer(arg:PListe):Presult;
var f1,f2,f3:Pcorps;
   T:Presult;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or(f2^.categorie<>cat_constante) then exit;
     f3:=Pcorps(f2^.suivant);
     if (f3=nil) then exit;
     T:=f3^.evaluer;
     if not f1^.assigner(Pconstante(f2^.contenu)^.nom,T) then Kill(Pcellule(T));
end;

{TNops}
function TNops.executer(arg:PListe):Presult;
var f1:Pcorps;
   T,aux:Presult;
   nb:longint;
   DelT:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     nb:=0;
     if f1<>nil then
        begin
             if (f1^.categorie=cat_constante) then begin DelT:=false;T:=Pconstante(f1^.contenu)^.affixe end
                                              else begin DelT:=true;T:=f1^.evaluer end;
             aux:=T;
             if aux<>nil then
                {if (aux^.cat=1) and (aux^.suivant=Nil) then // chaine de caractères
                   nb := length(T^.getchaine)
                else //c'est une liste }
                    while aux<>nil do begin inc(nb);aux:=Paffixe(aux^.suivant) end;
             if delT then Kill(Pcellule(T));
        end;
     executer:=new(Paffixe,init(nb,0))
end;

{TNargs}
function TNargs.executer(arg:PListe):Presult; {renvoie le nombre d'arguments d'une macro}
begin
     executer:=new(Paffixe,init(Nargs,0))
end;

{TArgs}
function TArgs.executer(arg:PListe):Presult; {évalue et renvoie l'argument numero k d'une macro}
var f1:Pcorps;
   T:Presult;
   r:Paffixe;
   all, continue:boolean;
   k,j:longint;
   res:type_liste;
begin
     executer:=nil;
     if Args=nil then exit; //pas d'arguments de macros
     if arg=nil then f1:=nil else f1:=Pcorps(arg^.tete);
     all:=(f1=nil); //parenthèses vides signifient tous les arguments
     if not all then
        begin
             r:=f1^.evalNum;
             if r<>nil then k:=round(r^.x) else k:=0;
             Kill(Pcellule(r));
             if k=0 then exit;
        end;
     res.init;j:=0;
     f1:=Pcorps(Args^.tete);
     continue:=(f1<>nil);
     while continue do
           begin
                Inc(j);
                if all or (j=k) then
                   begin
                        T:=f1^.evaluer;
                        if T<>nil then res.ajouter_fin(T);
                   end;
                f1:=Pcorps(f1^.suivant);
                continue:= (all or (j<>k)) and (f1<>nil);
           end;
     executer:=Paffixe(res.tete)

end;
{=================================
function TArgs.StrEval(arg:Pliste):string;
var f1:Pcorps;
    res:string;
    all,continue:boolean;
    T:Paffixe;
    k,j:longint;
begin
     result:='';
     res:='';
     if Args=nil then exit; //pas d'arguments de macros
     if arg=nil then f1:=nil else f1:=Pcorps(arg^.tete);
     all:=(f1=nil); //parenthèses vides signifient tous les arguments
     if not all then
        begin
             T:=f1^.evalNum;
             if T<>nil then k:=round(T^.x) else k:=0;
             Kill(Pcellule(T));
             if k=0 then exit;
        end;
     j:=0;
     f1:=Pcorps(Args^.tete);
     continue:=(f1<>nil);
     while continue do
           begin
                Inc(j);
                if all or (j=k) then
                   begin
                        res += MakeString(f1);//f1^.en_chaine;
                   end;
                f1:=Pcorps(f1^.suivant);
                continue:= (all or (j<>k)) and (f1<>nil);
           end;
     result:=res;
end;
====================================}
{TStrArgs}
function TStrArgs.executer(arg:PListe):Presult;
var f1:Pcorps;
    res:string;
    all,continue,oldKeep:boolean;
    T:Paffixe;
    k,j:longint;
begin
     executer:=Nil; res:='';
     if Args=nil then exit; //pas d'arguments de macros
     if arg=nil then f1:=nil else f1:=Pcorps(arg^.tete);
     all:=(f1=nil); //parenthèses vides signifient tous les arguments
     if not all then
        begin
             T:=f1^.evalNum;
             if T<>nil then k:=round(T^.x) else k:=0;
             Kill(Pcellule(T));
             if k=0 then exit;
        end;
     j:=0;
     f1:=Pcorps(Args^.tete);
     continue:=(f1<>nil);
     oldKeep:=KeepVarLocName;
     KeepVarLocName:=false;//true;
     while continue do
           begin
                Inc(j);
                if all or (j=k) then
                   begin
                        if all and (j>1) then res:=res+',';
                        res:=res+f1^.en_chaine;
                   end;
                f1:=Pcorps(f1^.suivant);
                continue:= (all or (j<>k)) and (f1<>nil);
           end;
     KeepVarLocName:=oldKeep;
     executer:=New(PChaine,init(res));
end;

{TDiff}
function TDiff.executer(arg:PListe):Presult;
var f1,f2,f3,f4,par:Pcorps;
    r:Pexpression;
    aux:Pconstante;
    aux2:Pliste;
    c:Pmacros;
    num:word;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if (f3=nil) or (f3^.categorie<>cat_constante) or (Pconstante(f3^.contenu)^.predefinie) then exit;
     f4:=Pcorps(f3^.suivant);
     new(r,init);
     aux:=Pconstante(LesVarLoc^.tete);
     while aux<>nil do
           begin
                r^.VarLoc^.ajouter_fin(PCellule(new(Pconstante,init(aux^.nom,Nil,true))));
                aux:=Pconstante(aux^.suivant);
           end;
     r^.corps:=f2^.deriver(Pconstante(f3^.contenu)^.nom);
     if r^.corps=nil then begin dispose(r,detruire); exit end;
     num:=0; 
     while f4<>nil do
      if (f4^.categorie=cat_constante) And (not Pconstante(f4^.contenu)^.predefinie)  then
           begin
                inc(num);
                par:=new(Pcorps,init(cat_parametre,new(Pparametre,init(num))));
                r^.corps^.composer(Pconstante(f4^.contenu)^.nom,par);
                dispose(par,detruire);
                f4:=Pcorps(f4^.suivant)
           end;
     r^.simplifier;
     if r^.corps=nil then begin dispose(r,detruire); exit end;
     aux2:=LesVarLoc;
     LesVarLoc:=r^.VarLoc;
     r^.corps^.brancherLocales;
     LesVarLoc:=aux2;
     c:=new(Pmacros,init(Pconstante(f1^.contenu)^.nom,r));
     c^.commande:=r^.corps^.en_chaine;
     ajouter_macros(c);
     ChangeMac:=true;
end;

{TInt}
function integrale(f:Pcorps; variable:string; a,b:real): Paffixe;
var
   compt,deuxN:word;
   h:real;
   T,S0,S1,M0,M1,U0,U1,V0,V1,aux1,aux2,aux3:Paffixe;
   stop:boolean;

          function Median:Paffixe; (*M_2^{n+1}*)
          var k:word;
              res,aux1,aux2:Paffixe;
          begin
               Median:=nil;
               T^.x:=a+h/2;
               res:=f^.evalNum;
               if res=nil then exit;
               for k:=1 to deuxN-1 do
                   begin
                        T^.x:=T^.x+h;
                        aux1:=f^.evalNum;
                        if aux1=nil then
                           begin
                                Kill(Pcellule(res));
                                exit
                           end;
                        aux2:=ajouterC(res,aux1);
                        if res<>nil then Kill(Pcellule(res));
                        if aux1<>nil then Kill(Pcellule(aux1));
                        res:=aux2;
                   end;
               aux1:=new(Paffixe,init(h,0));
               median:=multiplierC(aux1,res);
               if res<>nil then Kill(Pcellule(res));
               if aux1<>nil then Kill(Pcellule(aux1));
          end;
begin
     {integrale:=nil;}
     h:=(b-a);deuxN:=1;compt:=0;
     T:=new(Paffixe,init(a,0));
     f^.assigner(variable,T);
     T^.x:=a; aux1:=f^.evalNum;
     T^.x:=b; aux3:=f^.evalNum;
     T^.x:=(a+b)/2; aux2:=f^.evalNum;
     S0:=nil;
     M0:=nil;
     M1:=median;
     U0:=nil;U1:=nil;V0:=nil;V1:=nil;S1:=nil;
     if (aux1=nil) or (aux3=nil) or (aux2=nil) or (M1=nil) then
        else
        begin
     S1:=new(Paffixe,init(0,0));
     CalcError:=false;
     S1^.x:=multiplier(h/6,ajouter(aux1^.x,ajouter(aux3^.x,multiplier(4,aux2^.x))));
     S1^.y:=multiplier(h/6,ajouter(aux1^.y,ajouter(aux3^.y,multiplier(4,aux2^.y))));
     stop:=CalcError or (S1=nil) or (M1=nil);
     while (not stop) and (compt<=10)
      do begin
          inc(compt);
          if S0<>nil then Kill(Pcellule(S0));
          if M0<>nil then Kill(Pcellule(M0));
          M0:=M1;
          deuxN:=2*deuxN; h:=h/2;
          M1:=median;
          if (M1<>nil) and (M0<>nil) then
             begin
                  S0:=S1;
                  S1:=new(Paffixe,init(ajouter(S0^.x/2,ajouter(M1^.x*2/3,-M0^.x/6)),
                  ajouter(S0^.y/2,ajouter(M1^.y*2/3,-M0^.y/6))));
                  If U0<>nil then Kill(Pcellule(U0));
                  U0:=U1;
                  U1:=new(Paffixe,init(ajouter(S1^.x*16/15,-S0^.x/15),
                                       ajouter(S1^.y*16/15,-S0^.y/15)));
                  if U0<>nil then
                     begin
                  If V0<>nil then Kill(Pcellule(V0));
                  V0:=V1;
                  V1:=new(Paffixe,init(ajouter(U1^.x*64/63,-U0^.x/63),
                                       ajouter(U1^.y*64/63,-U0^.y/63)));
                     end;
                  if CalcError then Kill(Pcellule(V1));
                  stop:= CalcError or ((compt>=3) and (V0<>nil) and (V1<>nil)
                  and (sqrt(ajouter(sqr(ajouter(V1^.x,-V0^.x)),sqr(ajouter(V1^.y,-V0^.y))))<1e-5));
             end else stop:=true;

     end;
     end;
     integrale:=V1;
     If S0<>nil then Kill(Pcellule(S0));
     If S1<>nil then Kill(Pcellule(S1));
     If U0<>nil then Kill(Pcellule(U0));
     If U1<>nil then Kill(Pcellule(U1));
     If V0<>nil then Kill(Pcellule(V0));
     If M0<>nil then Kill(Pcellule(M0));
     If M1<>nil then Kill(Pcellule(M1));
     if aux1<>nil then Kill(Pcellule(aux1));
     if aux2<>nil then Kill(Pcellule(aux2));
     if aux3<>nil then Kill(Pcellule(aux3));
     if not f^.assigner(variable,nil) then Kill(Pcellule(T));
end;

function TInt.executer(arg:PListe):Presult;
var f1,f2,f3,f4:Pcorps;
    a,b:Paffixe;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) then exit;
     f3:=Pcorps(f2^.suivant);
     if (f3=nil) then exit;
     f4:=Pcorps(f3^.suivant);
     if (f4=nil) then exit;
     a:=f3^.evalNum;
     if a=nil then exit;
     b:=f4^.evalNum;
     if b=nil then begin Kill(Pcellule(a)); exit end;
     executer:=integrale(f1,Pconstante(f2^.contenu)^.nom,a^.x,b^.x);
     Kill(Pcellule(a)); Kill(Pcellule(b));
end;

function TInt.deriver(arg:Pliste;variable:string):Pcorps;
var f1,f2,f3,f4,f5,f6:Pcorps;
    aux1,aux2,aux3,aux4:Pcorps;
    op1,op2,res,res2,res3:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) then exit;
     f3:=Pcorps(f2^.suivant);
     if (f3=nil) then exit;
     f4:=Pcorps(f3^.suivant);
     if (f4=nil) then exit;
     aux1:=f4^.deriver(variable);
     if aux1=nil then exit;
     aux2:=f1^.dupliquer;
     aux2^.composer(Pconstante(f2^.contenu)^.nom,f4);
     if aux2=nil then begin dispose(aux1,detruire); exit end;
     aux3:=f3^.deriver(variable);
     if aux3=nil then begin dispose(aux1,detruire); dispose(aux2,detruire);exit end;
     aux4:=f1^.dupliquer;
     aux4^.composer(Pconstante(f2^.contenu)^.nom,f3);
     if aux4=nil then begin dispose(aux1,detruire); dispose(aux2,detruire);
                            dispose(aux3,detruire);exit end;
     op1:=new(Pcorps,init(cat_operateur,operation('*')));
     op1^.ajouter_arg(aux1);op1^.ajouter_arg(aux2);
     op2:=new(Pcorps,init(cat_operateur,operation('*')));
     op2^.ajouter_arg(aux3);op2^.ajouter_arg(aux4);
     res:=new(Pcorps,init(cat_operateur,operation('-')));
     res^.ajouter_arg(op1);res^.ajouter_arg(op2);
     if not f1^.DependDe(variable) then deriver:=res
        else
        begin
             f5:=f1^.deriver(variable);
             if f5=nil then begin dispose(res,detruire); exit end;
             f6:=f5^.simplifier;
             if f6=nil then begin dispose(res,detruire); dispose(f5,detruire); exit end;
             dispose(f5,detruire);
             res2:=new(Pcorps,init(cat_commande,commande('Int')));
             res2^.ajouter_arg(f6);
             res2^.ajouter_arg(f2^.dupliquer);
             res2^.ajouter_arg(f3^.dupliquer);
             res2^.ajouter_arg(f4^.dupliquer);
             res3:=new(Pcorps,init(cat_operateur,operation('+')));
             res3^.ajouter_arg(res2);res3^.ajouter_arg(res);
             deriver:=res3
        end;
     
end;
{======================================}
{TRgb}
function TRgb.executer(arg:PListe):Presult;
var f1,f2,f3:Pcorps;
    a,b,c:paffixe;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     f3:=Pcorps(f2^.suivant);
     if (f3=nil) then exit;
     a:=f1^.evalNum;
     if a=nil then exit;
     b:=f2^.evalNum;
     if b=nil then begin Kill(Pcellule(a)); exit end;
     c:=f3^.evalNum;
     if c=nil then begin Kill(Pcellule(a)); Kill(Pcellule(b));exit end;
     executer:=new(Paffixe,init(RGB(round(a^.x*255), round(b^.x*255),round(c^.x*255)),0));
     Kill(Pcellule(a)); Kill(Pcellule(b)); Kill(Pcellule(c));

end;
{======================================}
{TRound}
//Round(valeur [, nbdeci])
function TRound.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    a,b:Paffixe;
    aux,aux2:string;
    c,d,error:longint;
    sortiex, sortiey:real;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     a:=f1^.evalNum;
     if a=nil then exit;
     if (f2=nil) then begin b:=Nil; d:=0 end else
     begin
          b:=f2^.evalNum;
          if b=Nil then d:=0 else d:= round(abs(b^.x))
     end;
     if d=0 then
        begin
             sortiex:=round(a^.x);
             sortiey:=round(a^.y)
        end
     else
     begin
          aux:='0.'; for c:=1 to d do aux:=aux+'#';
          aux2:=FormatFloat(aux,a^.x);
          Val(aux2,sortiex,error);
          if error<>0 then sortiex:=a^.x;
          aux2:=FormatFloat(aux,a^.y);
          Val(aux2,sortiey,error);
          if error<>0 then sortiey:=a^.y;
     end;
     executer:=new(Paffixe,init(sortiex,sortiey));
     Kill(Pcellule(a)); Kill(Pcellule(b));
end;
{======================================
function TRound.StrEval(arg:PListe):string;
var f1,f2:Pcorps;
    a,b,res:Paffixe;
    aux,aux2:string;
    c,d,error:longint;
    sortiex, sortiey:real;
begin
     StrEval:='';
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     a:=f1^.evalNum;
     if a=nil then exit;
     if (f2=nil) then begin b:=Nil; d:=0 end else
     begin
          b:=f2^.evalNum;
          if b=Nil then d:=0 else d:= round(abs(b^.x))
     end;
     if d=0 then
        begin
             sortiex:=round(a^.x);
             sortiey:=round(a^.y)
        end
     else
     begin
          aux:='0.'; for c:=1 to d do aux:=aux+'#';
          aux2:=FormatFloat(aux,a^.x);
          Val(aux2,sortiex,error);
          if error<>0 then sortiex:=a^.x;
          aux2:=FormatFloat(aux,a^.y);
          Val(aux2,sortiey,error);
          if error<>0 then sortiey:=a^.y;
     end;
     res:=new(Paffixe,init(sortiex,sortiey));
     StrEval:=res^.en_chaine;
     Kill(Pcellule(a)); Kill(Pcellule(b));Kill(Pcellule(res));
end;
======================================}
{THexaColor}
function THexaColor.executer(arg:PListe):Presult;
var f1:Pcorps;
    a:string;
    b:longint;
    error:integer;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     a:='$'+MakeString(f1);
     if a='' then exit;
     val(a,b,error);
     b:= (b mod 256)*65536+((b shr 8) mod 256)*256+((b shr 16) mod 256);
     if error<>0 then exit;
     executer:=new(Paffixe,init(b,0));
end;

{=========== opérations  ===============}
{Tplus}
function Tplus.evaluer(arg1,arg2:Paffixe):Paffixe;
var r:Presult;
    res:type_liste;
    un_seul, fini, ech: boolean;
    aux: Paffixe;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     res.init;
     un_seul := (arg1^.suivant=Nil) or (arg2^.suivant=Nil);
     if arg2^.suivant=Nil then begin ech:=true; aux:=arg2; arg2:=arg1; arg1:=aux end//échange
     else ech:=False;
     fini := False;
     while not fini do
           begin
           if arg1=nil then r:=Paffixe(arg2^.dup)
                       else
           if arg2=nil then r:=Paffixe(arg1^.dup)
                        {else
           if Isjump(arg2) then r:=Paffixe(arg2^.dup)
                        else
           if Isjump(arg1) then r:=Paffixe(arg1^.dup) }
                        else
           if (arg1^.cat=0) and (arg2^.cat=0) then
              begin
                  r:= ajouterC(Paffixe(arg1),Paffixe(arg2));
                  //Messagedlg('ok',mtWarning,[mbok,mbcancel],0)
              end
                         else
           if (arg1^.cat=1) and (arg2^.cat=1) then
              begin
               if ech then r:=new(Pchaine,init( Pchaine(arg2)^.chaine+Pchaine(arg1)^.chaine))
               else r:=new(Pchaine,init( Pchaine(arg1)^.chaine+Pchaine(arg2)^.chaine));
              end
                         else r:=Nil;
           if r<>nil then res.ajouter_fin(r) else {res.ajouter_fin(jump)};
           if (arg1<>nil) and (not un_seul) then arg1:=Paffixe(arg1^.suivant);
           if arg2<>nil then arg2:=Paffixe(arg2^.suivant);
           fini :=  (arg2=nil) and (un_seul or (arg1=Nil))
           end;
     evaluer:=Paffixe(res.tete);
end;

function Tplus.simplifier(arg:Pliste):Pcorps;
var p,aux1,aux2,aux3,aux4:Pcorps;
    r:Paffixe;
begin
     simplifier:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.simplifier;
     if aux3=nil then exit;
     aux4:=aux2^.simplifier;
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     if (aux3^.categorie=Cat_affixe) and (aux4^.categorie=cat_affixe)
      then begin
               r:=self.evaluer(Paffixe(aux3^.contenu),Paffixe(aux4^.contenu));
               if r<>nil then p:=new(Pcorps,init(cat_affixe,r)) else p:=nil;
               dispose(aux3,detruire); dispose(aux4,detruire);
           end
           else
      if (aux3^.categorie=Cat_affixe) and (Paffixe(aux3^.contenu)^.x=0) and (Paffixe(aux3^.contenu)^.y=0)
       then begin
                 p:=aux4;
                 dispose(aux3,detruire);            
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=0) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=aux3;
                 dispose(aux4,detruire);            
            end else
       begin p:=new(Pcorps,init(cat_operateur,operation(nom)));
             p^.ajouter_arg(aux3);
             p^.ajouter_arg(aux4)
       end;
       simplifier:=p;
end;

function Tplus.deriver(arg:Pliste;const variable:string):Pcorps;
var aux1,aux2,aux3,aux4,p:Pcorps;
    q:Poperation;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.deriver(variable);
     if aux3=nil then exit;
     aux4:=aux2^.deriver(variable);
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     q:=operation('+');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux3);
     p^.ajouter_arg(aux4);
     deriver:=p;
end;

{Tmoins}
function Tmoins.evaluer(arg1,arg2:Paffixe):Paffixe;
var r:Presult;
    res:type_liste;
    un_seul, fini, ech: boolean;
    aux: Paffixe;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     res.init;
     un_seul := (arg1^.suivant=Nil) or (arg2^.suivant=Nil);
     if arg2^.suivant=Nil then begin aux:=arg2; arg2:=arg1; arg1:=aux; ech:=True end//échange
     else ech:=false;
     fini := False;
     while not fini do
           begin
           if arg1=nil then if arg2^.cat=0 then r:=new(Paffixe,init(-Paffixe(arg2)^.x,-Paffixe(arg2)^.y)) else r:=Nil
                       else
           if arg2=nil then r:=arg1^.dup
                        else
           {if Isjump(arg2) then r:=Paffixe(arg2^.dup)
                        else
           if Isjump(arg1) then r:=Paffixe(arg1^.dup)
                        else }
           if (arg1^.cat=0) and (arg2^.cat=0) then
              if ech then r:= soustraireC(Paffixe(arg2),Paffixe(arg1)) else r:= soustraireC(Paffixe(arg1),Paffixe(arg2))
                            else r:=Nil;
           if r<>nil then res.ajouter_fin(r) else {res.ajouter_fin(jump)};
           if (arg1<>nil) and (not un_seul) then arg1:=Paffixe(arg1^.suivant);
           if arg2<>nil then arg2:=Paffixe(arg2^.suivant);
           fini :=  (arg2=nil) and (un_seul or (arg1=Nil))
           end;
     evaluer:=Paffixe(res.tete);
end;

function Tmoins.deriver(arg:Pliste;const variable:string):Pcorps;
var aux1,aux2,aux3,aux4,p:Pcorps;
    q:Poperation;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.deriver(variable);
     if aux3=nil then exit;
     aux4:=aux2^.deriver(variable);
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     q:=operation('-');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux3);
     p^.ajouter_arg(aux4);
     deriver:=p;
end;

function Tmoins.simplifier(arg:Pliste):Pcorps;
var p,aux1,aux2,aux3,aux4:Pcorps;
    r:Paffixe;
begin
     simplifier:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.simplifier;
     if aux3=nil then exit;
     aux4:=aux2^.simplifier;
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     if (aux3^.categorie=Cat_affixe) and (aux4^.categorie=cat_affixe)
      then begin
               r:=self.evaluer(Paffixe(aux3^.contenu),Paffixe(aux4^.contenu));
               if r<>nil then p:=new(Pcorps,init(cat_affixe,r)) else p:=nil;
               dispose(aux3,detruire); dispose(aux4,detruire);
           end
           else
      if (aux3^.categorie=Cat_affixe) and (Paffixe(aux3^.contenu)^.x=0) and (Paffixe(aux3^.contenu)^.y=0)
       then begin
                 p:=new(Pcorps,init(cat_fonction,fonction('opp')));
                 p^.ajouter_arg(aux4);
                 dispose(aux3,detruire);            
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=0) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=aux3;
                 dispose(aux4,detruire);            
            end else
       begin p:=new(Pcorps,init(cat_operateur,operation(nom)));
             p^.ajouter_arg(aux3);
             p^.ajouter_arg(aux4)
       end;
       simplifier:=p;
end;
{=======================================}
function listeFoisListe(arg1,arg2:Paffixe):Paffixe; // produit de deux listes
var r:Presult;
    res:type_liste;
    nb, i : integer;
    str, str2 : string;
begin
     listeFoisListe:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     res.init;
     while (arg1<>nil) or (arg2<>nil) do
           begin
           if arg1=nil then r:=Paffixe(arg2^.dup)
                       else
           if arg2= nil then r:=Paffixe(arg1^.dup)
                        else
           if (arg1^.cat=0) and (arg2^.cat=0) then
              begin
                  r:= multiplierC(Paffixe(arg1),Paffixe(arg2));  // produit de deux complexes
              end
                         else
           if (arg1^.cat=1) and (arg2^.cat=0) then // chaine * nombre
              begin
                        nb := abs(round(Paffixe(arg2).getX));
                        str := Pchaine(arg1)^.chaine;
                        str2 := '';
                        for i:=1 to nb do str2 += str;
                        r:= new(Pchaine,init( str2 ));
              end
           else
               if (arg1^.cat=0) and (arg2^.cat=1) then // nombre * chaine
               begin
                        nb := abs(round(Paffixe(arg1).getX));
                        str := Pchaine(arg2)^.chaine;
                        str2 := '';
                        for i:=1 to nb do str2 += str;
                        r:= new(Pchaine,init( str2 ));
              end
              else r:=Nil;
           if r<>nil then res.ajouter_fin(r) else {res.ajouter_fin(jump)};
           if arg1<>nil then arg1:=Paffixe(arg1^.suivant);
           if arg2<>nil then arg2:=Paffixe(arg2^.suivant)
           end;
     listeFoisListe:=Paffixe(res.tete);
end;
{Tfois}
function Tfois.evaluer(arg1,arg2:Paffixe):Paffixe;
var r:Presult;
    res:type_liste;
    nb, i : integer;
    str, str2 : string;
    aux : Paffixe;
begin
     evaluer:=nil;
     res.init;
     if (arg1=nil) or (arg2=Nil) then exit;
     if (arg1^.suivant <> Nil) and (arg2^.suivant <> Nil)  then   // liste * liste
        begin
             evaluer := listeFoisListe(arg1,arg2);
             exit
        end;
     // un deux au moins est réduit à un seul élément, il faut que ce soit arg1
     if arg2^.suivant = Nil then begin aux:=arg2; arg2:=arg1; arg1:=aux end;
     if Isjump(arg1) then while arg2<>Nil do
          begin
               res.ajouter_fin(arg1^.dup); arg2:=Paffixe(arg2^.suivant)
          end
     else
         while (arg2<>nil) do  // un seul élément * liste
          begin
            if Isjump(arg2) then res.ajouter_fin(arg2^.dup)
            else
               begin
                if (arg1^.cat=0) and (arg2^.cat=0) then r:= multiplierC(Paffixe(arg1),Paffixe(arg2))
                  else
                     if (arg1^.cat=1) and (arg2^.cat=0) then //chaine * nombre
                       begin
                            nb := abs(round(Paffixe(arg2).getX));
                            str := Pchaine(arg1)^.chaine;
                            str2 := '';
                            for i:=1 to nb do str2 += str;
                            r:= new(Pchaine,init( str2 ));
                       end
                     else
                         if (arg1^.cat=0) and (arg2^.cat=1) then // nombre * chaine
                           begin
                                nb := abs(round(Paffixe(arg1).getX));
                                str := Pchaine(arg2)^.chaine;
                                str2 := '';
                                for i:=1 to nb do str2 += str;
                                r:= new(Pchaine,init( str2 ));
                           end
                         else r:=Nil;
                if r<>nil then res.ajouter_fin(r) else {res.ajouter_fin(jump)};
               end;
           arg2:=Paffixe(arg2^.suivant)
          end;
     evaluer:=Paffixe(res.tete);
end;

function Tfois.deriver(arg:Pliste;const variable:string):Pcorps;
var aux1,aux2,aux3,aux4,p,p1,p2:Pcorps;
    q,q1:Poperation;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.deriver(variable);
     if aux3=nil then exit;
     aux4:=aux2^.deriver(variable);
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     q1:=operation('*');
     p1:=new(Pcorps,init(cat_operateur,q1));
     p1^.ajouter_arg(aux1^.dupliquer);
     p1^.ajouter_arg(aux4);
     p2:=new(Pcorps,init(cat_operateur,q1));
     p2^.ajouter_arg(aux3);
     p2^.ajouter_arg(aux2^.dupliquer);
     q:=operation('+');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(p1);
     p^.ajouter_arg(p2);
     deriver:=p;
end;

function Tfois.simplifier(arg:Pliste):Pcorps;
var p,aux1,aux2,aux3,aux4:Pcorps;
    r:Paffixe;
begin
     simplifier:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.simplifier;
     if aux3=nil then exit;
     aux4:=aux2^.simplifier;
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     if (aux3^.categorie=Cat_affixe) and (aux4^.categorie=cat_affixe)
      then begin
               r:=self.evaluer(Paffixe(aux3^.contenu),Paffixe(aux4^.contenu));
               if r<>nil then p:=new(Pcorps,init(cat_affixe,r)) else p:=nil;
               dispose(aux3,detruire); dispose(aux4,detruire);
           end
           else
      if (aux3^.categorie=Cat_affixe) and (Paffixe(aux3^.contenu)^.x=0) and (Paffixe(aux3^.contenu)^.y=0)
         and (Paffixe(aux3^.contenu)^.suivant=Nil)
       then begin
                 p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(0,0))));
                 dispose(aux4,detruire);
                 dispose(aux3,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=0) and (Paffixe(aux4^.contenu)^.y=0)
          and (Paffixe(aux4^.contenu)^.suivant=Nil)
       then begin
                 p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(0,0))));
                 dispose(aux4,detruire);
                 dispose(aux3,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=1) and (Paffixe(aux4^.contenu)^.y=0)
          and (Paffixe(aux4^.contenu)^.suivant=Nil)
       then begin
                 p:=aux3;
                 dispose(aux4,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=-1) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=new(Pcorps,init(cat_fonction,fonction('opp')));
                 p^.ajouter_arg(aux3);
                 dispose(aux4,detruire);
            end else
       if (aux3^.categorie=Cat_affixe) and (Paffixe(aux3^.contenu)^.x=1) and (Paffixe(aux3^.contenu)^.y=0)
          and (Paffixe(aux3^.contenu)^.suivant=Nil)
       then begin
                 p:=aux4;
                 dispose(aux3,detruire);
            end else
       if (aux3^.categorie=Cat_affixe) and (Paffixe(aux3^.contenu)^.x=-1) and (Paffixe(aux3^.contenu)^.y=0)
          and (Paffixe(aux3^.contenu)^.suivant=Nil)
       then begin
                 p:=new(Pcorps,init(cat_fonction,fonction('opp')));
                 p^.ajouter_arg(aux4);
                 dispose(aux3,detruire);
            end else
       begin p:=new(Pcorps,init(cat_operateur,operation(nom)));
             p^.ajouter_arg(aux3);
             p^.ajouter_arg(aux4)
       end;
       simplifier:=p;
end;
{=========================================================}
function listeDivListe(arg1,arg2:Paffixe):Paffixe; // produit de deux listes
var r:Presult;
    res:type_liste;
    one: boolean;
begin
     listeDivListe:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     res.init;
     one := (arg1^.suivant=Nil); // un seul élément dans arg1
     while (not(one) and (arg1<>nil)) or (arg2<>nil) do
           begin
           if arg1=nil then r:=Paffixe(arg2^.dup)
                       else
           if arg2= nil then r:=Paffixe(arg1^.dup)
                        else
           if (arg1^.cat=0) and (arg2^.cat=0) then
              begin
                  r:= diviserC(Paffixe(arg1),Paffixe(arg2));  // quotient de deux complexes
              end
              else r:=Nil;
           if r<>nil then res.ajouter_fin(r) else {res.ajouter_fin(jump)};
           if not one then if arg1<>nil then arg1:=Paffixe(arg1^.suivant);
           if arg2<>nil then arg2:=Paffixe(arg2^.suivant)
           end;
     listeDivListe:=Paffixe(res.tete);
end;
{Tdiv}
function Tdiv.evaluer(arg1,arg2:Paffixe):Paffixe;
var r:Paffixe;
 res:type_liste;
begin
     evaluer:=nil;
     res.init;
     if arg2=nil then exit;
     if arg2^.suivant <> Nil then // liste div liste
        begin
             evaluer := listeDivListe(arg1,arg2);
             exit;
        end;
     if Isjump(arg2) then while arg1<>Nil do
          begin
               res.ajouter_fin(arg2^.dup); arg1:=Paffixe(arg1^.suivant)
          end
     else
     while (arg1<>nil) do
      begin
           if Isjump(arg1) then res.ajouter_fin(arg1^.dup)
           else
           begin
           if (arg1^.cat=0) And (arg2^.cat=0) then r:= diviserC(Paffixe(arg1),Paffixe(arg2)) else r:=Nil;
           if r<>nil then res.ajouter_fin(r) else {res.ajouter_fin(jump)};
           end;
           arg1:=Paffixe(arg1^.suivant)
      end;
     evaluer:=Paffixe(res.tete);
end;

function Tdiv.deriver(arg:Pliste;const variable:string):Pcorps;
var aux1,aux2,aux3,aux4,p,p1,p2,p3,p4:Pcorps;
    q,q1,q2:Poperation;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.deriver(variable);
     if aux3=nil then exit;
     aux4:=aux2^.deriver(variable);
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     q1:=operation('*');
     p1:=new(Pcorps,init(cat_operateur,q1));
     p1^.ajouter_arg(aux4);
     p1^.ajouter_arg(aux1^.dupliquer);
     p2:=new(Pcorps,init(cat_operateur,q1));
     p2^.ajouter_arg(aux3);
     p2^.ajouter_arg(aux2^.dupliquer);
     q:=operation('-');
     p3:=new(Pcorps,init(cat_operateur,q));
     p3^.ajouter_arg(p2);
     p3^.ajouter_arg(p1);
     p4:=new(Pcorps,init(cat_operateur,q1));
     p4^.ajouter_arg(aux2^.dupliquer);
     p4^.ajouter_arg(aux2^.dupliquer);
     q2:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q2));
     p^.ajouter_arg(p3);p^.ajouter_arg(p4);
     deriver:=p;
end;

function Tdiv.simplifier(arg:Pliste):Pcorps;
var p,aux1,aux2,aux3,aux4:Pcorps;
    r:Paffixe;
begin
     simplifier:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.simplifier;
     if aux3=nil then exit;
     aux4:=aux2^.simplifier;
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     if (aux3^.categorie=Cat_affixe) and (aux4^.categorie=cat_affixe)
      then begin
               r:=self.evaluer(Paffixe(aux3^.contenu),Paffixe(aux4^.contenu));
               if r<>nil then p:=new(Pcorps,init(cat_affixe,r)) else p:=nil;
               dispose(aux3,detruire); dispose(aux4,detruire);
           end
           else
      if (aux3^.categorie=Cat_affixe) and (Paffixe(aux3^.contenu)^.x=0) and (Paffixe(aux3^.contenu)^.y=0)
       then begin
                 p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(0,0))));
                 dispose(aux4,detruire);
                 dispose(aux3,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=0) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=nil;
                 dispose(aux4,detruire);
                 dispose(aux3,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=1) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=aux3;
                 dispose(aux4,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=-1) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=new(Pcorps,init(cat_fonction,fonction('opp')));
                 p^.ajouter_arg(aux3);
                 dispose(aux4,detruire);
            end else

       begin p:=new(Pcorps,init(cat_operateur,operation(nom)));
             p^.ajouter_arg(aux3);
             p^.ajouter_arg(aux4)
       end;
       simplifier:=p;
end;

 {cap}
 function cap(A,B,C,D: Paffixe):Paffixe;
 var  V1,V2,V3:Paffixe;
     t,de:real;
 begin
      cap:=nil;
      V1:=soustraireC(B,D);
      V2:=soustraireC(C,D);
      V3:=soustraireC(A,B);
      if (v1<>nil) and (v2<>nil) and (v3<>nil)
       then begin
       CalcError:=false;
       de:=det(V2,v3);
       t:=diviser(det(V1,V2),de);
      if (not CalcError) then
      begin
      V2^.init(t,0);
      Kill(Pcellule(v1));
      V1:=multiplierC(V2,V3);
      if v1<>nil then cap:=ajouterC(V1,B);
      end;
            end;
      if v1<>nil then Kill(Pcellule(v1));
      if v2<>nil then Kill(Pcellule(v2));
      if v3<>nil then Kill(Pcellule(v3))
 end;

{TCap}
function TCapD.evaluer(arg1,arg2:Paffixe):Paffixe;
var A,B,C,D:Paffixe;
begin
     evaluer:=nil;
     A:=Paffixe(arg1);C:=Paffixe(Arg2);
     If (A=nil) or (C=nil) or (A^.cat<>0) or (C^.cat<>0) then exit;
     D:=Paffixe(C^.suivant);B:=Paffixe(A^.suivant);
     If (B=nil) or (D=nil) or (B^.cat<>0) or (D^.cat<>0) then exit;
     evaluer:=cap(A,B,C,D);
end;
{===============}
procedure GetRec(liste:Paffixe;var res:Trec);
var aux:Paffixe;
begin
     res.Xinf:=Reel_Max;res.Yinf:=Reel_Max;
     res.Xsup:=-Reel_Max;res.Ysup:=-Reel_Max;
     aux:=liste;
     while aux<>nil do
          begin
               if not Isjump(aux) then
                  begin
                       if aux^.x<res.Xinf then res.Xinf:=aux^.x;
                       if aux^.y<res.Yinf then res.Yinf:=aux^.y;
                       if aux^.x>res.Xsup then res.Xsup:=aux^.x;
                       if aux^.y>res.Ysup then res.Ysup:=aux^.y;

                  end;
               aux:=Paffixe(aux^.suivant)
          end;
end;
{===============}
function inside(point,liste:Paffixe;rec:Trec):boolean;
var
    A,B,res,L,C,D,auxC,auxD:Paffixe;
    F:Pexpression;
    compt:integer;
    stop,dessus:boolean;
    epsilon:real;
begin
     epsilon:=1E-17;
     inside:=false;
     if point=nil then exit;
     with rec do
     begin
     if (point^.x>Xsup) or (point^.x<Xinf) or
        (point^.y>Ysup) or (point^.y<Yinf) then exit;
     if (Liste=nil) or (liste^.suivant=nil) then exit;
     L:=(liste);
     C:=L;
     repeat
           stop:=abs(C^.y-point^.y)>epsilon;
           if not stop then C:=Paffixe(C^.suivant);
     until stop or (C=nil);
     if C=nil then begin inside:=true; exit end;
     new(A,init(Xinf-1,point^.y));
     new(B,init(point^.x,point^.y));
     compt:=0;
     C:=L;D:=Paffixe(C^.suivant);
     dessus:=(B^.y-C^.y<epsilon);
     New(F,init);
     F^.definir('[$A,$B] InterL [$C,$D]');
     auxC:=new(Paffixe,init(0,0));
     auxD:=new(Paffixe,init(0,0));
     F^.assigner('A',A);
     F^.assigner('B',B);
     F^.assigner('C',auxC);
     F^.assigner('D',auxD);
     while D<>nil do
       begin
       if (not IsJump(C)) and (not Isjump(D)) then
            begin
                auxC^.x:=C^.x;auxC^.y:=C^.y;
                auxD^.x:=D^.x;auxD^.y:=D^.y;
                res:=F^.evalNum;
                if (res<>nil) then if abs(res^.x-point^.x)<epsilon then
                   begin
                        inside:=false;
                        dispose(F,detruire);Kill(Pcellule(res));
                        exit
                   end
                   else begin
                     if (C^.y<D^.y) then
                        begin
                             if ((C^.y-B^.y<epsilon) and (B^.y-D^.y<epsilon)) or ((abs(C^.y-B^.y)<epsilon) and (not dessus)) then dec(compt);
                        end
                        else begin
                             if ((B^.y-C^.y<epsilon) and (D^.y-B^.y<epsilon)) or ((abs(C^.y-B^.y)<epsilon) and dessus) then inc(compt);
                             end;
                   dessus:=(B^.y-D^.y<epsilon);
                   end;
                Kill(Pcellule(res));
           end;
        C:=D;D:=Paffixe(D^.suivant)
       end;
     dispose(F,detruire);
     inside:=compt<>0;
     end;
end;

{TInside}
function TInside.evaluer(arg1,arg2:Paffixe):Paffixe;
var A,B:Paffixe;
    rec:Trec;
begin
     evaluer:=nil;
     A:=Paffixe(arg1);B:=Paffixe(arg2);
     if (A=nil) or (B=nil) then exit;
     A:=A^.evalNum; B:=B^.evalNum;
     GetRec(B,rec);
     evaluer:=new(Paffixe,init(byte(inside(A,B,rec)),0));
     Kill(Pcellule(A)); Kill(Pcellule(B));
end;

function cut(arg1,arg2:Paffixe; before:boolean): Paffixe;
var A,C,u,v,baru,Z: Paffixe;
    trouve:boolean;
    d,epsilon:real;
    resultat: type_liste;
begin
     cut:=nil; epsilon:=0.000001;
     if (arg1=nil) or (arg2=nil) then exit;
     C:=Paffixe(arg1);
     trouve:=false;
     u:=nil; v:=nil; A:=nil;
     while (not trouve) and (C<>nil) do
           begin
                while IsJump(C) do C:=Paffixe(C^.suivant);
                if C<>nil
                   then
                       begin
                            A:=C;
                            C:=Paffixe(A^.suivant);
                            v:=soustraireC(arg2,A);
                            CalcError:=false;
                            d:=sqrt(ajouter(sqr(soustraire(arg2^.x,A^.x)),sqr(soustraire(arg2^.y,A^.y))));
                            trouve:= (not CalcError) and (d<=epsilon);
                            while (not trouve) and (C<>nil) and (Not Isjump(C)) do
                                  begin
                                       Kill(PCellule(u));
                                       u:=v;
                                       v:=soustraireC(arg2,C);
                                       baru:=u; if baru<>nil then baru^.y:=-baru^.y;
                                       Z:=multiplierC(baru,v);
                                       trouve:= (Z<>nil) And (abs(Z^.y)<=epsilon) And (Z^.x<=0);
                                       Kill(PCellule(Z));
                                       A:=C; C:=Paffixe(C^.suivant)
                                  end;
                            Kill(Pcellule(v));
                            Kill(Pcellule(u));
                       end;
           end;
     if trouve
        then
            begin
                 resultat.init;
                 if before
                    then
                        begin
                             if (A^.x<>arg2^.x) or (A^.y<>arg2^.y) then
                                resultat.ajouter_fin(New(Paffixe,init(arg2^.x,arg2^.y)));
                             resultat.ajouter_fin(A^.evaluer);
                        end
                    else
                        begin
                             Z:=arg1;
                             while Z<>A do
                                   begin
                                        resultat.ajouter_fin(New(Paffixe,init(Z^.x,Z^.y)));
                                        Z:=Paffixe(Z^.suivant)
                                   end;
                             resultat.ajouter_fin(New(Paffixe,init(arg2^.x,arg2^.y)));
                        end;
                 cut:=Paffixe(resultat.tete)
            end
end;

{TCutB}
function TCutB.evaluer(arg1,arg2:Paffixe):Paffixe;
var A,B:Paffixe;
begin
     evaluer:=Nil;
     if (arg1<>Nil) and (arg2<>Nil) then
     begin
          A:=arg1^.evalNum; B:=arg2^.evalNum;
          evaluer:=cut(A,B,true);
          Kill(Pcellule(A)); Kill(Pcellule(B));
     end;
end;

{TCutA}
function TCutA.evaluer(arg1,arg2:Paffixe):Paffixe;
var A,B:Paffixe;
begin
     evaluer:=Nil;
     if (arg1<>Nil) and (arg2<>Nil) then
     begin
          A:=arg1^.evalNum; B:=arg2^.evalNum;
          evaluer:=cut(A,B,false);
          Kill(Pcellule(A)); Kill(Pcellule(B));
     end;
end;
                     

{TCap}
function TCapL.evaluer(arg1,arg2:Paffixe):Paffixe;
var A,B,C,D,res,V1,V2,V3:Paffixe;
    liste:type_liste;
    t,t1,de:real;
    OkAB,OkCD,firstAB,firstCD:boolean;

    function chercheSeg(var U,V:Paffixe):boolean;
    var ok:boolean;
    begin
          U:=V;
          ok:=false;
          repeat
          while (U<>nil) and IsJump(U) do U:=Paffixe(U^.suivant);
           If (U=nil) then ok:=true
                      else
                      begin
                   V:=Paffixe(U^.suivant);
                   if V=nil then ok:=true
                            else
                            if IsJump(V) then U:=V else ok:=true;
                      end
          until ok;
          chercheSeg:=(U<>nil) and (V<>nil);

     end;
begin
     B:=arg1;
     liste.init;
     OkAB:=chercheSeg(A,B);
     firstAB:=true;
     while  OkAB do
           begin
                 V3:=soustraireC(A,B);
                 if V3<>nil then
                 begin
                 D:=arg2;
                 OkCD:=chercheSeg(C,D);
                 firstCD:=true;
                 while OkCD do
                       begin
                            V1:=soustraireC(B,D);
                            V2:=soustraireC(C,D);
                            if (v1<>nil) and (v2<>nil)
                            then begin
                                 CalcError:=false;
                                 de:=det(V2,v3);
                                 t:=diviser(det(v1,v2),de);
                                 if not CalcError and (t>=0) and ((firstAB  and (t<=1)) or ((not firstAB) and (t<1))) then
                                 begin
                                 t1:=diviser(det(V1,V3),de);
                                 if (not CalcError) and (t1>=0) and ((firstCD  and (t1<=1)) or ((not firstCD) and (t1<1))) then
                                 begin
                                      V2^.init(t,0);
                                      Kill(Pcellule(v1));
                                      V1:=multiplierC(V2,V3);
                                      if v1<>nil then begin res:=ajouterC(V1,B);
                                      if res<>nil then begin liste.ajouter_fin(res); end;

                                                      end;
                                 end;
                                 end;
                                 end;
                            Kill(Pcellule(v1));
                            Kill(Pcellule(v2));
                            firstCD:=false;
                            OkCD:=chercheSeg(C,D)
                       end;
                 end;
                 Kill(Pcellule(v3));
                 firstAB:=false;
                 OkAB:=chercheSeg(A,B)
           end;
     evaluer:=Paffixe(liste.tete)
end;

{Texpo}
function Texpo.evaluer(arg1,arg2:Paffixe):Paffixe;
var resultat:Paffixe;
    r:real;
begin
     evaluer:=nil;
     resultat:=nil;
     if (arg1=nil) or (arg2=nil) or (arg1^.cat=1) then exit;
     if (arg2^.y=0) then
             if arg1^.y=0 then begin
                              CalcError:=false;
                              r:=puissance(arg1^.x,arg2^.x);
                              if not CalcError then resultat:=new(Paffixe,init(r,0));
                              end
                         else if Int(arg2^.y)=arg2^.y then
                              resultat:=puissanceC(arg1,Trunc(arg2^.x));
     evaluer:=resultat;
end;

function Texpo.deriver(arg:Pliste;const variable:string):Pcorps;
var aux1,aux2,aux3,p,p1,p2,p3:Pcorps;
    q,q1,q2:Poperation;
    f:Pfonction;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.deriver(variable);
     if aux3=nil then exit;
     if not aux2^.dependDe(variable) then
        begin
        q:=operation('*');
        p3:=new(Pcorps,init(cat_operateur,q));
        p3^.ajouter_arg(aux2^.dupliquer);
        q1:=operation('^');
        p1:=new(Pcorps,init(cat_operateur,q1));
        p1^.ajouter_arg(aux1^.dupliquer);
        q2:=operation('-');
        p2:=new(Pcorps,init(cat_operateur,q2));
        p2^.ajouter_arg(aux2^.dupliquer);
        p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
        p1^.ajouter_arg(p2);
        p3^.ajouter_arg(p1);
        p:=new(Pcorps,init(cat_operateur,q));
        p^.ajouter_arg(p3);
        p^.ajouter_arg(aux3);
        end
     else begin
               f:=fonction('exp');
               p1:=new(Pcorps,init(cat_fonction,f));
               q:=operation('*');
               p2:=new(Pcorps,init(cat_operateur,q));
               p2^.ajouter_arg(aux2^.dupliquer);
               f:=fonction('ln');
               p3:=new(Pcorps,init(cat_fonction,f));
               p3^.ajouter_arg(aux1^.dupliquer);
               p2^.ajouter_arg(p3);
               p1^.ajouter_arg(p2);
               p:=p1^.deriver(variable);
               dispose(p1,detruire)
          end;
     deriver:=p;
end;

function Texpo.simplifier(arg:Pliste):Pcorps;
var p,aux1,aux2,aux3,aux4:Pcorps;
    r:Paffixe;
begin
     simplifier:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     aux2:=Pcorps(aux1^.suivant);
     if aux2=nil then exit;
     aux3:=aux1^.simplifier;
     if aux3=nil then exit;
     aux4:=aux2^.simplifier;
     if aux4=nil then begin dispose(aux3,detruire);exit end;
     if (aux3^.categorie=Cat_affixe) and (aux4^.categorie=cat_affixe)
      then begin
               r:=self.evaluer(Paffixe(aux3^.contenu),Paffixe(aux4^.contenu));
               if r<>nil then p:=new(Pcorps,init(cat_affixe,r)) else p:=nil;
               dispose(aux3,detruire); dispose(aux4,detruire);
           end
           else
      if (aux3^.categorie=Cat_affixe) and (Paffixe(aux3^.contenu)^.x=1) and (Paffixe(aux3^.contenu)^.y=0)
       then begin
                 p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0))));
                 dispose(aux4,detruire);
                 dispose(aux3,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=0) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0))));
                 dispose(aux4,detruire);
                 dispose(aux3,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=1) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=aux3;
                 dispose(aux4,detruire);
            end else
       if (aux4^.categorie=Cat_affixe) and (Paffixe(aux4^.contenu)^.x=-1) and (Paffixe(aux4^.contenu)^.y=0)
       then begin
                 p:=new(Pcorps,init(cat_operateur,operation('/')));
                 p^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
                 p^.ajouter_arg(aux3);
                 dispose(aux4,detruire);
            end else
       begin p:=new(Pcorps,init(cat_operateur,operation(nom)));
             p^.ajouter_arg(aux3);
             p^.ajouter_arg(aux4)
       end;
       simplifier:=p;
end;

{Operation OR
function TOr.evaluer(arg1,arg2:Paffixe):Paffixe;
var resultat:Paffixe;
    r:byte;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     if (arg2^.y<>0) or (arg1^.y<>0) or ((arg1^.x<>0) and (arg1^.x<>1)) or
     ((arg2^.x<>0) and (arg2^.x<>1)) then exit;
     r:=byte((arg1^.x=1) or (arg2^.x=1));
     resultat:=new(Paffixe,init(r,0));
     evaluer:=resultat;
end; }

function TOr.executer(arg:Pliste):Presult;
var resultat:Presult;
    r:byte;
    index:Pcorps;
    r1,r2:PAffixe;
    KillArg1,KillArg2:boolean;
begin
     executer:=Nil;
     index:=Pcorps(arg^.tete);
     if Pcorps(index)^.categorie=cat_constante
        then        {si le premier argument est une constante, on ne la duplique pas}
                    begin
                         r1:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe);
                         KillArg1:=false;
                    end
        else
            begin
                 r1:= Pcorps(index)^.evalNum;   {sinon on duplique}
                 KillArg1:=true;
            end;
     r:=Byte((r1<>NIl) and (r1.x=1) and (r1.y=0));
     If KillArg1 then Kill(Pcellule(r1));
     index:=Pcorps(index^.suivant);r2:=nil;KillArg2:=false;
     if (r=0) and (index<>nil)
        then
        begin
            if Pcorps(index)^.categorie=cat_constante
               then r2:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe)
               else
                   begin
                        r2:= Pcorps(index)^.evalNum;
                        KillArg2:=true;
                   end;
            r:=Byte( (r2<>NIl) and (r2.x=1) and (r2.y=0));
            If KillArg2 then Kill(Pcellule(r2));
        end;
     resultat:=new(Paffixe,init(r,0));
     executer:=resultat;
end;

{function TAnd.evaluer(arg1,arg2:Paffixe):Paffixe;
var resultat:Paffixe;
    r:byte;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     if (arg2^.y<>0) or (arg1^.y<>0) or ((arg1^.x<>0) and (arg1^.x<>1)) or ((arg2^.x<>0) and (arg2^.x<>1)) then exit;
     r:=byte((arg1^.x=1) and (arg2^.x=1));
     resultat:=new(Paffixe,init(r,0));
     evaluer:=resultat;
end;}

function TAnd.executer(arg:Pliste):Presult;
var resultat:Presult;
    r:byte;
    index:Pcorps;
    r1,r2:Paffixe;
    KillArg1,KillArg2:boolean;
begin
     executer:=Nil;
     index:=Pcorps(arg^.tete);
     if Pcorps(index)^.categorie=cat_constante
        then        {si le premier argument est une constante, on ne la duplique pas}
                    begin
                         r1:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe);
                         KillArg1:=false;
                    end
        else
            begin
                 r1:= Pcorps(index)^.evalNum;   {sinon on duplique}
                 KillArg1:=true;
            end;
     r:=Byte((r1<>NIl) and (r1.x=1) and (r1.y=0));
     If KillArg1 then Kill(Pcellule(r1));
     index:=Pcorps(index^.suivant);r2:=nil;KillArg2:=false;
     if (r=1) and (index<>nil)
        then
        begin
            if Pcorps(index)^.categorie=cat_constante
               then r2:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe)
               else
                   begin
                        r2:= Pcorps(index)^.evalNum;
                        KillArg2:=true;
                   end;
            r:=Byte((r2<>NIl) and (r2.x=1) and (r2.y=0));
            If KillArg2 then Kill(Pcellule(r2));
        end;
     resultat:=new(Paffixe,init(r,0));
     executer:=resultat;
end;

function TEgal.executer(arg:Pliste):Presult;
var resultat:Presult;
    r:byte;
    index:Pcorps;
    r1,r2:Presult;
    KillArg1,KillArg2:boolean;
begin
     executer:=Nil;
     index:=Pcorps(arg^.tete);
     if Pcorps(index)^.categorie=cat_constante
        then        {si le premier argument est une constante, on ne la duplique pas}
                    begin
                         r1:=Pconstante(Pcorps(index)^.contenu)^.affixe;
                         KillArg1:=false;
                    end
        else
            begin
                 r1:= Pcorps(index)^.evaluer;   {sinon on duplique}
                 KillArg1:=true;
            end;
     index:=Pcorps(index^.suivant);r2:=nil;KillArg2:=false;
     if index<>nil
        then
            if Pcorps(index)^.categorie=cat_constante
               then r2:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe)
               else
                   begin
                        r2:= Pcorps(index)^.evaluer;
                        KillArg2:=true;
                   end;
     if (r1=nil) And (r2=nil) then r:=1
        else
     if (r1=nil) Or (r2=nil) then r:=0
        else
     r:=byte(CompResult(r1,r2));
     If KillArg1 then Kill(Pcellule(r1));
     If KillArg2 then Kill(Pcellule(r2));
     resultat:=new(Paffixe,init(r,0));
     executer:=resultat;
end;

function TNEgal.executer(arg:Pliste):Presult;
var resultat:Presult;
    r:byte;
    index:Pcorps;
    r1,r2:Presult;
    KillArg1,KillArg2:boolean;
begin
     executer:=Nil;
     index:=Pcorps(arg^.tete);
     if Pcorps(index)^.categorie=cat_constante
        then        {si le premier argument est une constante, on ne la duplique pas}
                    begin
                         r1:=Pconstante(Pcorps(index)^.contenu)^.affixe;
                         KillArg1:=false;
                    end
        else
            begin
                 r1:= Pcorps(index)^.evaluer;   {sinon on duplique}
                 KillArg1:=true;
            end;
     index:=Pcorps(index^.suivant);r2:=nil;KillArg2:=false;
     if index<>nil
        then
            if Pcorps(index)^.categorie=cat_constante
               then r2:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe)
               else
                   begin
                        r2:= Pcorps(index)^.evaluer;
                        KillArg2:=true;
                   end;
     if (r1=nil) And (r2=nil) then r:=1
        else
     if (r1=nil) Or (r2=nil) then r:=0
        else
     r:=byte(CompResult(r1,r2));
     If KillArg1 then Kill(Pcellule(r1));
     If KillArg2 then Kill(Pcellule(r2));
     resultat:=new(Paffixe,init(1-r,0));
     executer:=resultat;
end;

function TSup.evaluer(arg1,arg2:Paffixe):Paffixe;
var resultat:Paffixe;
    r:byte;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     if (arg2^.y<>0) or (arg1^.y<>0) then exit;
     r:=byte((arg1^.x > arg2^.x));
     resultat:=new(Paffixe,init(r,0));
     evaluer:=resultat;
end;

function TSupOuE.evaluer(arg1,arg2:Paffixe):Paffixe;
var resultat:Paffixe;
    r:byte;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     if (arg2^.y<>0) or (arg1^.y<>0) then exit;
     r:=byte((arg1^.x >= arg2^.x));
     resultat:=new(Paffixe,init(r,0));
     evaluer:=resultat;
end;

function TInf.evaluer(arg1,arg2:Paffixe):Paffixe;
var resultat:Paffixe;
    r:byte;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     if (arg2^.y<>0) or (arg1^.y<>0) then exit;
     r:=byte((arg1^.x < arg2^.x));
     resultat:=new(Paffixe,init(r,0));
     evaluer:=resultat;
end;

function TInfOuE.evaluer(arg1,arg2:Paffixe):Paffixe;
var resultat:Paffixe;
    r:byte;
begin
     evaluer:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     if (arg2^.y<>0) or (arg1^.y<>0) then exit;
     r:=byte((arg1^.x <= arg2^.x));
     resultat:=new(Paffixe,init(r,0));
     evaluer:=resultat;
end;

{================== fonctions =====================}
{Tsqr}
function Tsqr.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=false;
     r:=new(Paffixe,init(ajouter(sqr(arg^.x),-sqr(arg^.y)),
             multiplier(2,multiplier(arg^.x,arg^.y))));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tsqr.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    aux1,p,p1:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     q:=operation('*');
     p1:=new(Pcorps,init(cat_operateur,q));
     p1^.ajouter_arg(aux1^.dupliquer);
     p1^.ajouter_arg(aux1^.dupliquer);
     p:=p1^.deriver(variable);
     dispose(p1,detruire);
     deriver:=p;
end;

{Topp}
function Topp.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
    res:type_liste;
begin
     evaluer:=nil;
     res.init;
     if arg=nil then exit;
     while (arg<>nil) do
           begin
           r:= new(Paffixe,init(-arg^.x,-arg^.y));
           if r<>nil then res.ajouter_fin(r) else {res.ajouter_fin(jump)};
           arg:=Paffixe(arg^.suivant)
           end;
     evaluer:=Paffixe(res.tete);
end;

function Topp.deriver(arg:Pliste;variable:string):Pcorps;
var q:Pfonction;
    aux1,p,p1:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     p1:=aux1^.deriver(variable);
     if p1=nil then exit;
     q:=fonction('opp');
     p:=new(Pcorps,init(cat_fonction,q));
     p^.ajouter_arg(p1);
     deriver:=p;
end;

{TRand}
function TRand.evaluer(arg:Paffixe):Paffixe;
begin
     if arg=nil then
     evaluer:=new(Paffixe,init(Random,0))
     else
     evaluer:=new(Paffixe,init(Random(round(abs(arg^.x))),0));
end;

{TEnt}
function TEnt.evaluer(arg:Paffixe):Paffixe;
var u1,u2:real;
begin
     evaluer:=nil;
     if arg=nil then exit;
     u1:=Int(arg^.x);
     if u1>arg^.x then u1:=u1-1;
     u2:=Int(arg^.y);
     if u2>arg^.y then u2:=u2-1;
     evaluer:=new(Paffixe,init(u1,u2));
end;

function TEnt.deriver(arg:Pliste;variable:string):Pcorps;
var p:Pcorps;
    q:Pexpression;
begin
     p:=Pcorps(arg^.tete);
     new(q,init);
     q^.definir('Si((x-Ent(x))>0,0)');
     q^.corps^.composer('x',p);
     deriver:=q^.corps;
     q^.corps:=nil;
     dispose(q,detruire);
end;

function Tsin.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if (arg=nil) or (arg^.y<>0) then exit;
     r:=new(Paffixe,init(sin(arg^.x),0));
     evaluer:=r;
end;

function Tsin.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('*');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('cos');
     p1:=new(pCorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     p^.ajouter_arg(p1);
     deriver:=p;
end;

{Tcos}
function Tcos.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if (arg=nil) or (arg^.y<>0) then exit;
     r:=new(Paffixe,init(cos(arg^.x),0));
     evaluer:=r;
end;

function Tcos.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('*');
     p2:=new(Pcorps,init(cat_operateur,q));
     p2^.ajouter_arg(aux2);
     f:=fonction('sin');
     p1:=new(pCorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     p2^.ajouter_arg(p1);
     f:=fonction('opp');
     p:=new(Pcorps,init(cat_fonction,f));
     p^.ajouter_arg(p2);
     deriver:=p;
end;

function Ttan.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if (arg=nil) or (arg^.y<>0) then exit;
     CalcError:=false;
     r:=new(Paffixe,init(tan(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Ttan.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('cos');
     p2:=new(Pcorps,init(cat_fonction,f));
     p2^.ajouter_arg(aux1^.dupliquer);
     f:=fonction('sqr');
     p1:=new(pCorps,init(cat_fonction,f));
     p1^.ajouter_arg(p2);
     p^.ajouter_arg(p1);
     deriver:=p;
end;

{contribution de Patrick BESSE 29/03/08}
function Tcot.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if (arg=nil) or (arg^.y<>0) then exit;
     CalcError:=false;
     r:=new(Paffixe,init(cot(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tcot.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps;
begin
     deriver:=nil; {on dérive cot(u)=-u'/sqr(sin(u))}
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable); {aux2=u'}
     if aux2=nil then exit;

     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));

     f:=fonction('opp');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux2);
     p^.ajouter_arg(p1); {dans p on a -u'/ (et p1 est libre)}

     f:=fonction('sin');
     p2:=new(Pcorps,init(cat_fonction,f));
     p2^.ajouter_arg(aux1^.dupliquer); {on construit sin(u) dans p2}

     f:=fonction('sqr');
     p1:=new(pCorps,init(cat_fonction,f));
     p1^.ajouter_arg(p2); {on construit sqr(sin(u)) dans p1}

     p^.ajouter_arg(p1); {dans p on a -u'/sqr(sin(u))}
     deriver:=p;
end;

function Tarccot.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(arccot(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tarccot.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));

     f:=fonction('opp');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux2);

     p^.ajouter_arg(p1); {dans p on a -u'/ (et p1 est libre)}

     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer); {p1 contient sqr(u)}

     q:=operation('+');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0))))); {p2 contient 1+}
     p2^.ajouter_arg(p1); {p2 contient 1+sqr(u)}

     p^.ajouter_arg(p2); {p contient -u'/(1+sqr(u)}
     deriver:=p;
end;

function Tcth.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(cth(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tcth.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;

     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));

     f:=fonction('opp');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux2);

     p^.ajouter_arg(p1); {p contient -u'/ (et p1 est libre)}

     f:=fonction('sh');
     p2:=new(Pcorps,init(cat_fonction,f));
     p2^.ajouter_arg(aux1^.dupliquer); {p2 contient sh(u)}

     f:=fonction('sqr');
     p1:=new(pCorps,init(cat_fonction,f));
     p1^.ajouter_arg(p2); {p1 contient sqr(sh(u))}

     p^.ajouter_arg(p1); {p contient -u'/sqr(sh(u))}
     deriver:=p;
end;

function Targcth.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(argcth(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Targcth.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('-');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
     p2^.ajouter_arg(p1);
     p^.ajouter_arg(p2);
     deriver:=p;
end;
{======================fin contribution du 2903/08================================}
function Tarcsin.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if (arg=nil) or (arg^.y<>0) then exit;
     CalcError:=false;
     r:=new(Paffixe,init(arcsin(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tarcsin.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2,p3:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('-');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
     p2^.ajouter_arg(p1);
     f:=fonction('sqrt');
     p3:=new(Pcorps,init(cat_fonction,f));
     p3^.ajouter_arg(p2);
     p^.ajouter_arg(p3);
     deriver:=p;
end;

function Tarccos.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if (arg=nil) or (arg^.y<>0) then exit;
     CalcError:=false;
     r:=new(Paffixe,init(arccos(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tarccos.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2,p3,p4:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('-');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
     p2^.ajouter_arg(p1);
     f:=fonction('sqrt');
     p3:=new(Pcorps,init(cat_fonction,f));
     p3^.ajouter_arg(p2);
     p^.ajouter_arg(p3);
     f:=fonction('opp');
     p4:=new(Pcorps,init(cat_fonction,f));
     p4^.ajouter_arg(p);
     deriver:=p4;
end;

function Tarctan.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(arctan(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tarctan.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('+');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
     p2^.ajouter_arg(p1);
     p^.ajouter_arg(p2);
     deriver:=p;
end;

function Tsh.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(sh(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tsh.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('*');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('ch');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     p^.ajouter_arg(p1);
     deriver:=p;
end;

function Tch.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(ch(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tch.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('*');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sh');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     p^.ajouter_arg(p1);
     deriver:=p;
end;

function Tth.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(th(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tth.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('ch');
     p2:=new(Pcorps,init(cat_fonction,f));
     p2^.ajouter_arg(aux1^.dupliquer);
     f:=fonction('sqr');
     p1:=new(pCorps,init(cat_fonction,f));
     p1^.ajouter_arg(p2);
     p^.ajouter_arg(p1);
     deriver:=p;
end;

function Targsh.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(argsh(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;
function Targsh.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2,p3:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('+');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
     p2^.ajouter_arg(p1);
     f:=fonction('sqrt');
     p3:=new(Pcorps,init(cat_fonction,f));
     p3^.ajouter_arg(p2);
     p^.ajouter_arg(p3);
     deriver:=p;
end;

function Targch.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(argch(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Targch.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2,p3:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('-');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(p1);
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
     f:=fonction('sqrt');
     p3:=new(Pcorps,init(cat_fonction,f));
     p3^.ajouter_arg(p2);
     p^.ajouter_arg(p3);
     deriver:=p;
end;

function Targth.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(argth(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Targth.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqr');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('-');
     p2:=new(pCorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0)))));
     p2^.ajouter_arg(p1);
     p^.ajouter_arg(p2);
     deriver:=p;
end;

function Texp.evaluer(arg:Paffixe):Paffixe;
var res:Paffixe;
    r:real;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=false;
     r:=exp(arg^.x);
     if not CalcError then
             res:=new(Paffixe,init(multiplier(r,cos(arg^.y)),multiplier(r,sin(arg^.y))))
             else  res:=nil;
           
     evaluer:=res;
end;

function Texp.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1:Pcorps; 
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('*');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('exp');
     p1:=new(pCorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     p^.ajouter_arg(p1);
     deriver:=p;
end;

function Tln.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=new(Paffixe,init(ln(arg^.x),0));
     if CalcError then Kill(Pcellule(r));
     evaluer:=r;
end;

function Tln.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    aux1,aux2,p:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     p^.ajouter_arg(aux1^.dupliquer);
     deriver:=p;
end;

function Tbar.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     r:=new(Paffixe,init(arg^.x,-arg^.y));
     evaluer:=r;
end;

function Tbar.deriver(arg:Pliste;variable:string):Pcorps;
var q:Pfonction;
    aux1,aux2,p:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=fonction('bar');
     p:=new(Pcorps,init(cat_fonction,q));
     p^.ajouter_arg(aux2);
     deriver:=p;
end;

{TRe}
function TRe.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     r:=new(Paffixe,init(arg^.x,0));
     evaluer:=r;
end;

function TRe.deriver(arg:Pliste;variable:string):Pcorps;
var q:Pfonction;
    aux1,aux2,p:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=fonction('Re');
     p:=new(Pcorps,init(cat_fonction,q));
     p^.ajouter_arg(aux2);
     deriver:=p;
end;

{TIm}
function TIm.evaluer(arg:Paffixe):Paffixe;
var r:Paffixe;
begin
     evaluer:=nil;
     if arg=nil then exit;
     r:=new(Paffixe,init(arg^.y,0));
     evaluer:=r;
end;

function TIm.deriver(arg:Pliste;variable:string):Pcorps;
var q:Pfonction;
    aux1,aux2,p:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=fonction('Im');
     p:=new(Pcorps,init(cat_fonction,q));
     p^.ajouter_arg(aux2);
     deriver:=p;
end;

function Tsqrt.evaluer(arg:Paffixe):Paffixe;
var res:Paffixe;
    r:real;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=arg^.y<>0;
     r:=sqrt(arg^.x);
     if not CalcError then res:=new(Paffixe,init(r,0)) else res:=nil;
     evaluer:=res;
end;

function Tsqrt.deriver(arg:Pliste;variable:string):Pcorps;
var q:Poperation;
    f:Pfonction;
    aux1,aux2,p,p1,p2:Pcorps;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     q:=operation('/');
     p:=new(Pcorps,init(cat_operateur,q));
     p^.ajouter_arg(aux2);
     f:=fonction('sqrt');
     p1:=new(Pcorps,init(cat_fonction,f));
     p1^.ajouter_arg(aux1^.dupliquer);
     q:=operation('*');
     p2:=new(Pcorps,init(cat_operateur,q));
     p2^.ajouter_arg(new(Pcorps,init(cat_affixe,new(Paffixe,init(2,0)))));
     p2^.ajouter_arg(p1);
     p^.ajouter_arg(p2);
     deriver:=p;
end;

function Tabs.evaluer(arg:Paffixe):Paffixe;
var res:Paffixe;
    r:real;
begin
     evaluer:=nil;
     if arg=nil then exit;
     CalcError:=false;
     if (arg^.y=0) then r:=abs(arg^.x)
                   else r:=sqrt(ajouter(sqr(arg^.x),sqr(arg^.y)));
     if not CalcError then res:=new(Paffixe,init(r,0))
                   else res:=nil;
     evaluer:=res;
end;

function Tabs.deriver(arg:Pliste;variable:string):Pcorps;
var aux1,aux2:Pcorps;
    f:Pexpression;
begin
     deriver:=nil;
     if arg=nil then exit;
     aux1:=Pcorps(arg^.tete);
     if aux1=nil then exit;
     aux2:=aux1^.deriver(variable);
     if aux2=nil then exit;
     new(f,init);
     f^.definir('($up*bar($u)+u*bar(up))/(2*abs(u))');
     f^.corps^.composer('up',aux2);
     f^.corps^.composer('u',aux1);
     dispose(aux2,detruire);
     deriver:=f^.corps^.dupliquer;
     dispose(f,detruire);
end;

function TArg.evaluer(arg:Paffixe):Paffixe;
var res:Paffixe;
    r:real;
begin
     evaluer:=nil;
     if arg=nil then exit;
     if (arg^.x=0) and (arg^.y=0) then exit;
     CalcError:=false;
     if (arg^.x=0) then if arg^.y>0 then r:=pi/2 else r:=-pi/2
                          else
     if arg^.x>0 then r:=arctan(diviser(arg^.y,arg^.x))
                        else
     if arg^.y>=0 then r:=ajouter(pi,arctan(diviser(arg^.y,arg^.x)))
                         else r:=ajouter(-pi,arctan(diviser(arg^.y,arg^.x)));
     if not CalcError then res:=new(Paffixe,init(r,0)) else res:=nil;
     evaluer:=res;
end;

procedure restoreVarG(Const nom:string;valeur:Presult);
var aux:PVarGlob;
begin
     aux:=PVarGlob(VariablesGlobales^.tete);
     while aux<>nil do
           begin
                if nom=aux^.variable^.nom
                   then begin
                        aux^.commande:='';
                        ChangeVarG:=true;
                        end;
                aux:=PVarGlob(aux^.suivant);
           end;
end;

{Commande TSetVar}
function TSetVar.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    T:Presult;
    c:Pconstante;
    Anom:string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     if f1^.categorie=cat_constante then
        begin
             c:=Pconstante(f1^.contenu);
             if (c^.predefinie) then exit;
        end
     else
         begin
              Anom:=MakeString(f1);
              if (Anom='') then exit;
              c:=VarLocale(Anom);   {c'est une variable locale?}
              if c=nil
                 then {non}
                      begin
                           c:=constante(Anom); {variable globale?}
                           if c=nil            {non}
                              then
                                  begin        {on la crée en locale}
                                    if not identifierOk(Anom) then exit;
                                    c:=new(Pconstante,init(Anom,nil,true));
                                    LesVarLoc^.ajouter_fin(PCellule(c));
                                  end
                              else if (c^.predefinie) then exit;
                      end;
         end;
     T:=f2^.evaluer;
     if c^.affixe<>nil then Kill(Pcellule(c^.affixe));
     c^.affixe:=T;
     if not c^.locale then restoreVarG(c^.nom,T);
end;

{Commande TInc}
function TInc.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    T,res,aux,aux1:Presult;
    c:Pconstante;
    r:type_liste;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) then exit;
     c:=Pconstante(f1^.contenu);
     if (c^.predefinie) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     T:=f2^.evaluer;
     if T=Nil then exit;
     r.init;
     aux:=T;
     aux1:=c^.affixe;
     while (aux1<>nil) or (aux<>nil) do
           begin
           if aux1=nil then res:=aux^.dup
                       else
           if aux=nil then res:=aux1^.dup
                      else
           if (aux^.cat=0) and (aux1^.cat=0) then res:=ajouterC(Paffixe(aux1),Paffixe(aux))
                      else
           if (aux^.cat=1) and (aux1^.cat=1) then res:=new(Pchaine,init(Pchaine(aux1)^.chaine+Pchaine(aux)^.chaine))
                      else res:=Nil;
           if res<>nil then r.ajouter_fin(res) else;
           if aux<>nil then  aux:=Paffixe(aux^.suivant);
           if aux1<> nil then aux1:=Paffixe(aux1^.suivant);
           end;
     Kill(Pcellule(c^.affixe));
     c^.affixe:=Paffixe(r.tete);
     Kill(Pcellule(T));
     if not c^.locale then restoreVarG(c^.nom,c^.affixe);
end;

{Commande TEchange}
function TEchange.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    T:Presult;
    c1,c2:Pconstante;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) then exit;
     c1:=Pconstante(f1^.contenu);
     c2:=Pconstante(f2^.contenu);
     if (c1^.predefinie) or (c2^.predefinie) then exit;
     T:=c1^.affixe;
     c1^.affixe:=c2^.affixe;
     c2^.affixe:=T;
     if not c1^.locale then restoreVarG(c1^.nom,c1^.affixe);
     if not c2^.locale then restoreVarG(c2^.nom,c2^.affixe);
end;

{fonction TAppend}
function TAppend.executer(arg:Pliste):Presult;
// Insert(variable, élément [, position] ): insère l'élément dans variable( liste) à la position voulue (fin par défaut)
var f1,f2,f3:Pcorps;
    T:Presult;
    aux1:Paffixe;
    l:type_liste;
    position,compt, lenStr:longint;
    c:Pconstante;
    aux,fin:Presult;
    inverse: boolean;
    str: string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) or (Pconstante(f1^.contenu)^.predefinie) then  exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     T:=f2^.evaluer;
     if T=nil then exit;
     c:=Pconstante(f1^.contenu);
     f3:=Pcorps(f2^.suivant);
     position:=0;       // position d'insertion, fin par défaut
     if f3<>nil then begin
                     aux1:=f3^.evalNum;
                     if aux1<>nil then position:= Round(aux1^.x);
                     Kill(Pcellule(aux1));
                     end;
     {if (c^.affixe<>Nil) and (c^.affixe^.cat = 1) and (c^.affixe^.suivant=Nil) //chaine : non surtout pas !
        then
            begin
                  str := c^.affixe^.getchaine;
                  if position = 0 //fin
                     then str += makestring(f2) // chaine à insérer
                     else
                  if position = 1 //debut
                     then str := makestring(f2) + str
                     else
                         begin
                              lenStr := length(str);
                              inverse := (position<0);
                              if inverse then begin position := lenStr+position+1 end;
                              str := copy(str,1,position-1) + makestring(f2) + copy(str,position,lenStr-position+1);
                         end;
                  c^.affixe^.setchaine(str);
                  if not c^.locale then restoreVarG(c^.nom,c^.affixe);
            end
        else // liste}
        begin
             l.init;
             if (position=0)  // ajout à la fin
                then
                    begin
                         if c^.affixe<>nil then l.ajouter_fin(c^.affixe);
                         l.ajouter_fin(T)
                    end
             else
             if position=1 then   // ajout au début
                 begin
                      l.ajouter_fin(T);
                      if c^.affixe<>nil then l.ajouter_fin(c^.affixe);
                 end
             else     // ajout dans la liste
                 begin
                      if c^.affixe<>nil then l.ajouter_fin(c^.affixe);
                      inverse := (position<0);
                      if inverse then begin position := -position {; l.inverser} end;
                      compt:=1;
                      if not inverse then
                          begin
                              aux:=Paffixe(l.tete);
                              while (aux<>nil) and (compt<position) do begin aux:=Paffixe(aux^.suivant); inc(compt) end
                          end
                      else
                          begin
                               aux:=Paffixe(l.queue);
                               while (aux<>nil) and (compt<position) do begin aux:=Paffixe(aux^.precedent); inc(compt) end
                          end;
                      if (aux=nil) then l.ajouter_fin(T)
                      else
                          begin
                               T^.precedent:=aux^.precedent;
                               aux^.precedent^.suivant:=T;
                               fin:=T;
                               while fin^.suivant<>nil do fin:=Paffixe(fin^.suivant);
                               fin^.suivant:=aux;
                               aux^.precedent:=fin;
                          end;
                     //Messagedlg(Paffixe(l.tete)^.en_chaine, mtwarning, [mbok],0);
                     //if inverse then l.inverser;
                 end;
     c^.affixe:=Paffixe(l.tete);
     if not c^.locale then restoreVarG(c^.nom,c^.affixe);
     end;
end;

{=======================}
{fonction TStrInsert}
function TStrInsert.executer(arg:Pliste):Presult;
// StrInsert(variable, élément [, position] ): insère l'élément dans variable( liste) à la position voulue (fin par défaut)
var f1,f2,f3:Pcorps;
    T:Presult;
    aux1:Paffixe;
    position,compt, lenStr:longint;
    c:Pconstante;
    aux,fin:Presult;
    inverse: boolean;
    str: string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) or (Pconstante(f1^.contenu)^.predefinie) then  exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     T:=f2^.evaluer;
     if T=nil then exit;
     c:=Pconstante(f1^.contenu);
     f3:=Pcorps(f2^.suivant);
     position:=0;       // position d'insertion, fin par défaut
     if f3<>nil then begin
                     aux1:=f3^.evalNum;
                     if aux1<>nil then position:= Round(aux1^.x);
                     Kill(Pcellule(aux1));
                     end;
     if (c^.affixe<>Nil) and (c^.affixe^.cat = 1) and (c^.affixe^.suivant=Nil) //chaine
        then
            begin
                  str := c^.affixe^.getchaine;
                  if position = 0 //fin
                     then str += makestring(f2) // chaine à insérer
                     else
                  if position = 1 //debut
                     then str := makestring(f2) + str
                     else
                         begin
                              lenStr := length(str);
                              inverse := (position<0);
                              if inverse then begin position := lenStr+position+1 end;
                              str := copy(str,1,position-1) + makestring(f2) + copy(str,position,lenStr-position+1);
                         end;
                  c^.affixe^.setchaine(str);
                  if not c^.locale then restoreVarG(c^.nom,c^.affixe);
            end
 end;

{=======================}
procedure stringDel(var chaine: string; depart,nombre: longint);
var
  i: longint;
begin
     i:=length(chaine);
     if depart<0 then //on supprime les "nombre" derniers
        begin
             if (nombre=0) or (nombre>=i) then
             else  delete(chaine,i-nombre+1,nombre)
        end
        else   //on supprime les "nombre" termes partant du n°depart
        begin
             if nombre=0 then nombre:=i;
             delete(chaine,depart,nombre)
        end;
end;

function stringinverser(const c: string): string;
var aux: string;
    i: longint;
begin
     aux := '';
     for i:=1 to length(c) do aux := c[i] + aux;
     result := aux
end;
{=======================}
{commande TDel}
function TDel.executer(arg:Pliste):Presult;
var f1,f2,f3:Pcorps;
    T:Paffixe;
    aux:Presult;
    i,depart,nombre:longint;
    l:type_liste;
    all,inverse:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) or (Pconstante(f1^.contenu)^.predefinie) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     T:=f2^.evalNum;
     if T=nil then exit;
     depart:=Round(T^.x); Kill(Pcellule(T));
     if depart=0 then depart:=-1; // on part du dernier élément de la liste
     inverse:=(depart<0); if inverse then depart:=-depart;
     T:=f3^.evalNum;
     if T=nil then exit;
     nombre:=Round(T^.x); Kill(Pcellule(T));
     All:=(nombre=0);
     aux:=Pconstante(f1^.contenu)^.affixe;
     if aux=nil then exit;
     {if (aux^.cat=1) and (aux^.suivant=Nil) // chaine
        then
            begin
                 str := aux^.getchaine;
                 if inverse then str := stringinverser(str);
                 stringDel(str,depart,nombre);
                 if inverse then str := stringinverser(str);
                 aux^.setchaine(str);
                 if not Pconstante(f1^.contenu)^.locale then
                    restoreVarG(Pconstante(f1^.contenu)^.nom,aux);
            end
     else // liste}
         begin
             l.init;l.ajouter_fin(aux);
             if inverse then l.inverser;
             i:=1;
             aux:=Presult(l.tete);
             while (aux<>nil) and (i<depart) do begin aux:=Presult(aux^.suivant); inc(i) end;
             if aux=nil then begin exit end;
             i:=0;
             while (aux<>nil) and (All or (i<nombre)) do
                   begin l.supprimer(PCellule(aux));
                         inc(i);
                   end;
             if inverse then l.inverser;
             Pconstante(f1^.contenu)^.affixe:=Presult(l.tete);
             if not Pconstante(f1^.contenu)^.locale then
                restoreVarG(Pconstante(f1^.contenu)^.nom,Presult(l.tete));
         end;

end;
{================== TSubs(liste,deb,nombre,par) =====================}
function TSubs.executer(arg:Pliste): PResult;
//Subs(liste,deb, [nombre,] par)
//la liste doit être une variable (complexes), les éléments partant de deb jusqu'à deb+nombre sont remplacés avec <par>.
var
    f1,f2,f3,f4:Pcorps;
    L1: Paffixe;
    L2, L3: Presult;
    depart, nombre, i, dep, fin, lenStr: longint;
    inverse, All : boolean;
    l:type_liste;
    str: string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) or
        (Pconstante(f1^.contenu)^.predefinie) then  exit;  //ce doit être une variable non constante
     f2:=Pcorps(f1^.suivant);
     if f2=Nil then exit; //depart
     f3:=Pcorps(f2^.suivant); // nombre ou <par>
     if f3=Nil then exit;
     f4:=Pcorps(f3^.suivant); // <par> ou Nil
     L1 := f2^.evalNum;
     if L1 = Nil then exit;
     depart := Round(L1^.x); Kill(Pcellule(L1));
     if depart=0 then depart:=-1; // on part du dernier élément de la liste
     inverse:=(depart<0); if inverse then depart:=-depart;
     L2:=Pconstante(f1^.contenu)^.affixe;
     if f4 = Nil then
        begin
                nombre := 1;
                f4 := f3;  // ce par quoi il faut remplacer
        end
        else
        begin
            L1 := f3^.evalNum;  // le paramètre nombre
            if L1 = Nil then nombre := 1
            else begin nombre := Round(L1^.x); Kill(Pcellule(L1)) end;
        end;
     All:=(nombre=0);
     if (L2^.cat = 1) and (L2^.suivant = Nil) // chaine
     then
        begin
          str := L2^.getchaine; lenStr := length(str);
          if (1<=depart) and (depart<=lenStr) then
          begin
            if nombre = 0 then
               if inverse then // vers la gauche, tout jusqu'au début
                  begin
                       dep := 1; fin := lenStr-depart+1;
                  end
                  else  // vers la droite, tout jusqu'à la fin
                  begin
                       dep := depart; fin := lenStr
                  end
            else // nombre >0
              if inverse then // nombre éléments vers la gauche
                 begin
                      fin := lenStr-depart+1;
                      dep := fin-nombre+1;
                      if dep<1 then dep := 1;
                 end
                 else  // // nombre éléments vers la droite
                 begin
                      dep := depart;
                      fin := depart+nombre-1;
                      if fin>lenStr then fin:=lenStr;
                 end;
            str := copy(str,1,dep-1)+MakeString(f4)+copy(str,fin+1,lenStr-fin);
          end;
          L2^.setchaine(str);
          if not Pconstante(f1^.contenu)^.locale then
             restoreVarG(Pconstante(f1^.contenu)^.nom,L2);
        end
     else // liste
        begin
          L3 := f4^.evaluer; // ce par quoi il faut remplacer
          l.init; l.ajouter_fin(L2);
          i:=1;
          if not inverse then
             begin
                  L2:=Presult(l.tete);
                  while (L2<>nil) and (i<depart) do begin L2:=Presult(L2^.suivant); inc(i) end;
             end
          else
              begin
                 L2:=Presult(l.queue);
                 while (L2<>nil) and (i<depart) do begin L2:=Presult(L2^.precedent); inc(i) end;
                 i := 1;
                 while (L2<>nil) and (All or (i<nombre)) do begin L2:=Presult(L2^.precedent); inc(i) end;
                 if All then begin nombre:= i-1; All:=false; L2:=Presult(l.tete);  end;
              end;
          if L2=nil then begin exit end;
          i:=0; // L2 pointe sur le bon élément, on supprime le nombre demandé
          while (L2<>nil) and (All or (i<nombre)) do
                begin l.supprimer(PCellule(L2));
                      inc(i);
                end;
          // maintenant on inserre L3 là où pointe L2
          l.inserer(L3,L2);
          Pconstante(f1^.contenu)^.affixe:=Presult(l.tete);
          if not Pconstante(f1^.contenu)^.locale then
             restoreVarG(Pconstante(f1^.contenu)^.nom,Presult(l.tete));
        end;
end;

{================== PermuteWith =====================}
//PermuteWith( permutation d'entiers de 1 à n, liste à permuter, taille des paquets ou jump): la taille de la liste doit être de n*paquets,
//la liste doit être une variable, elle est réarrangée avec la permutation indiquée.
function TPermuteWith.executer(arg:Pliste): Presult;
var f1,f2,f3:Pcorps;
    P1,L2,aux,aux2,pointeur:Presult;
    P2,L1:Paffixe;
    res:type_liste;
    list:TList;
    pris:array of boolean;
    by,compt:integer;
    Del1:boolean;

    procedure traiterPaquets; // on renvoie les paquets suivant la permutation voulue
    var i:integer;
    begin
         setlength(pris,list.count);
         for i:=0 to list.count-1 do pris[i]:=false;
         P2:=L1;
         while P2<>nil do
               begin
                    i:=Round(P2^.x)-1;
                    if (0<=i) And (i<list.count) then
                            if pris[i] then
                               res.ajouter_fin(Presult(list.Items[i])^.evaluer)  //paquet déjà pris, donc dupliqué
                            else
                               begin res.ajouter_fin(Presult(list.Items[i])^.evaluer); pris[i]:=true end;
                    P2:=Paffixe(P2^.suivant)
               end;
         for i:=0 to list.count-1 do begin pointeur:=Presult(list.Items[i]); Kill(Pcellule(pointeur)) end; //destruction des paquets restants
         finalize(pris)
    end;

    procedure traiterByJUmp;  // découpage de la liste par composantes connexes
    begin
         while P1<>Nil do
           if Isjump(P1) then
              begin
                   list.add(aux);
                   aux^.precedent:=Nil;
                   aux:=Presult(P1^.suivant);
                   P1^.suivant:=Nil;
                   P1:=aux
              end
           else P1:=Presult(P1^.suivant)
    end;

begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=Nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) or
        (Pconstante(f2^.contenu)^.predefinie) then  exit;
     L2:=Pconstante(f2^.contenu)^.affixe;
     f3:=Pcorps(f2^.suivant);
     if f3=Nil then by:=1   // paquets de 1
        else begin
                  L1:=f3^.evalNum;
                  if L1<>Nil then  if Isjump(L1) then by:=-1 else by:=round(L1^.x)
                  else by:=1;
                  Kill(Pcellule(L1))
             end;
     if (f1^.categorie=cat_constante) then begin Del1:=false;L1:=Paffixe(Pconstante(f1^.contenu)^.affixe) end
                                      else begin Del1:=true;L1:=f1^.evalNum end;
     if L1=Nil then begin Kill(Pcellule(L2)); Pconstante(f2^.contenu)^.affixe:=Nil; exit end;
     P1:=L2; compt:=0; aux:=P1; res.init;
     list:=Tlist.create;
     if by=-1 then traiterByJump //par composantes connexes
     else                        // par paquets de 1 ou 2 ou ...
      while P1<>Nil do
           if Isjump(P1) then
              begin
                 if aux<>P1 then //paquet non complet
                    begin
                         P1^.precedent^.suivant:=Nil;
                         Kill(Pcellule(aux))
                    end;
                 traiterPaquets;
                 list.clear; compt:=0;
                 aux2:=P1; P1:=Presult(P1^.suivant); aux:=P1;
                 aux2^.suivant:=Nil;
                 res.ajouter_fin(aux2);
              end
           else
           begin
                Inc(compt);
                if compt=by then
                   begin
                        list.add(aux);
                        aux^.precedent:=Nil;
                        aux:=Presult(P1^.suivant);
                        P1^.suivant:=Nil;
                        compt:=0; P1:=aux
                   end
                else P1:=Presult(P1^.suivant)
           end;

     Kill(Pcellule(aux)); //on détruit le dernier paquet non complet
     if (list.count>0) then traiterPaquets; //il y a des paquets à traiter
     list.Free;
     if Del1 then Kill(Pcellule(L1));
     Pconstante(f2^.contenu)^.affixe:=Presult(res.tete);
     if not Pconstante(f2^.contenu)^.locale then
     restoreVarG(Pconstante(f2^.contenu)^.nom,Presult(res.tete));
end;
{=========================== tri =============================}
function Trier(Item1, Item2: Pointer): Integer;
    var x:real; cat1,cat2:byte;
    begin
       cat1:=Presult(Item1)^.cat; cat2:=Presult(Item2)^.cat;
       if (cat1=0) and (cat2=0) then
        begin
         x:= Paffixe(Item1).x - Paffixe(Item2).x;
         if x<0 then result:=-1 else if x>0 then result:=1 else
                begin
                        x:= Paffixe(Item1).y - Paffixe(Item2).y;
                        if x<0 then result:=-1 else if x>0 then result:=1 else result:=0;
                end
        end else
        if (cat1=1) and (cat2=1) then
         if Pchaine(Item1)^.chaine < Pchaine(Item2)^.chaine then  result:=-1
            else
         if Pchaine(Item1)^.chaine > Pchaine(Item2)^.chaine then  result:=1
            else result:=0
        else
        if (cat1=1) and (cat2=0) then  result:=-1 else result:=1;
    end;
{=======================================}
{Tsort}
function TSort.executer(arg: Pliste):Presult;
var f,f2:Pcorps;
    P1,aux1:Presult;
    aux:Paffixe;
    mode:integer;
    res:type_liste;
    list:TList;
    Comparer:TlistSortCompare;

    procedure ajouter;
    var i:integer;
        pointeur:Presult;
    begin
        list.Sort(comparer);
        if mode=0 then
        for i:=0 to list.count-1 do
         begin
         pointeur:=Presult( list.Items[i] );
         pointeur^.suivant:=Nil; pointeur^.precedent:=Nil;
         res.ajouter_fin(pointeur);
         end
         else
         for i:=list.count-1 downto 0 do
         begin
         pointeur:=Presult( list.Items[i] );
         pointeur^.suivant:=Nil; pointeur^.precedent:=Nil;
         res.ajouter_fin(pointeur);
         end;
        list.Clear;
    end;

begin
     executer:=nil;
     if arg=nil then exit;
     comparer:=@Trier;
     f:=Pcorps(arg^.tete);
     if (f=nil) or (f^.categorie<>cat_constante) or
        (Pconstante(f^.contenu)^.predefinie) then  exit;
     res.init;
     P1:=Pconstante(f^.contenu)^.affixe;
     f2:=Pcorps(f^.suivant);
     if f2<>nil then aux:=f2^.evalNum else aux:=nil;
     if aux<>nil then mode:=Round(aux^.x) mod 2 else mode:=0;
     Kill(Pcellule(aux));
     list:=Tlist.create;
     while P1<>nil do
           begin
                if IsJump(P1) then
                   begin
                       if list.count>0 then ajouter;
                       aux1:=P1; P1:=Presult(P1^.suivant);
                       aux1^.suivant:=Nil;
                       res.ajouter_fin(aux1);
                   end
                else begin list.add(P1); P1:=Presult(P1^.suivant) end
           end;
      if list.count>0 then  ajouter;
      list.Free;
      Kill(Pcellule(P1));
      Pconstante(f^.contenu)^.affixe:=Presult(res.tete);
      if not Pconstante(f^.contenu)^.locale then
     restoreVarG(Pconstante(f^.contenu)^.nom,Presult(res.tete));
end;
{======================}
function TStrComp.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    s1,s2:string;
    res:Paffixe;
    T: Presult;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     T := f1^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s1 := T^.getchaine
        else s1 := T^.en_chaine;
     Kill(pcellule(T));
     T := f2^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s2 := T^.getchaine
        else s2 := T^.en_chaine;
     Kill(pcellule(T));
     new(res,init(byte(s1=s2),0));
     executer:=res
end;
{======================}
function TStrPos.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    s1,s2:string;
    res:Paffixe;
    T: Presult;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     T := f1^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s1 := T^.getchaine
        else s1 := T^.en_chaine;
     Kill(pcellule(T));
     T := f2^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s2 := T^.getchaine
        else s2 := T^.en_chaine;
     Kill(pcellule(T));
     new(res,init(pos(s1,s2),0));
     executer:=res
end;
{======================}
function TStrLength.executer(arg:PListe):Presult;
var f1:Pcorps;
    s1:string;
    T: Presult;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     T := f1^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s1 := T^.getchaine
        else s1 := T^.en_chaine;
     Kill(pcellule(T));
     executer:=new(Paffixe,init(length(s1),0))
end;
{======================}
function TStr2List.executer(arg:PListe):Presult;
var f1:Pcorps;
    s1:string;
    T: Presult;
    res: type_liste;
    i:longint;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     T := f1^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s1 := T^.getchaine
        else s1 := T^.en_chaine;
     Kill(pcellule(T));
     res.init;
     for i:=1 to length(s1) do
     begin
          res.ajouter_fin(new(Pchaine,init(s1[i])))
     end;
     executer:=Presult(res.tete)
end;
{======================}
function TStrCopy.executer(arg:Pliste):Presult;
var f1,f2,f3:Pcorps;
    //T,aux:Presult;
    num:Paffixe;
    depart,nombre:longint;
    //all: boolean;
    //chaine:string;
    T: Presult;
    s: string;
begin
     executer:=Nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     num:=f2^.evalNum;
     if num=nil then exit;
     depart:=Round(num^.x);
     if depart=0 then depart:=-1; //dernier element de la liste
     //if depart<0 then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then if num^.suivant<>nil then nombre:=Round(Paffixe(num^.suivant)^.x) else nombre:=1
               else begin
                    Kill(Pcellule(num));
                    num:=f3^.evalNum;
                    if num=nil then exit;
                    nombre:=Round(num^.x);
                    end;
     Kill(Pcellule(num));
     T := f1^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s := T^.getchaine
        else s := T^.en_chaine;
     Kill(pcellule(T));
     executer := stringcopy(s,depart,nombre);
     {if chaine='' then exit; res:='';
     i:=length(chaine);
     //aux:=T;
     if depart<0 then //on renvoit les "nombre" derniers
        begin
             if (nombre=0) or (nombre>=i) then res:=chaine
             else res:= copy(chaine,i-nombre+1,nombre)
        end
        else   //on renvoit les "nombre" termes partant du n°depart
        begin
             if nombre=0 then nombre:=i;
             res:=copy(chaine,depart,nombre)
        end;
        executer:=new(Pchaine,init(res)) }
end;
{=======================================}
function TStrDel.executer(arg:Pliste):Presult;
var f1,f2,f3:Pcorps;
    //T,aux:Presult;
    num:Paffixe;
    depart,nombre:longint;
    inverse: boolean;
    chaine:string;
    L:Presult;
begin
     executer:=Nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) or (f1^.categorie<>cat_constante) or
        (Pconstante(f1^.contenu)^.predefinie) then  exit;
     L:=Pconstante(f1^.contenu)^.affixe;
     if (L=Nil) or (L^.cat<>1) then exit;
     chaine:=Pchaine(L)^.chaine; //chaine initiale
     if chaine='' then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     num:=f2^.evalNum;
     if num=nil then exit;
     depart:=Round(num^.x);
     if depart=0 then depart:=-1; //dernier element de la chaine
     inverse:=(depart<0); if inverse then depart:=-depart;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then if num^.suivant<>nil then nombre:=Round(Paffixe(num^.suivant)^.x) else nombre:=1
               else begin
                    Kill(Pcellule(num));
                    num:=f3^.evalNum;
                    if num=nil then exit;
                    nombre:=Round(num^.x);
                    end;
     Kill(Pcellule(num));

     if inverse then chaine := stringinverser(chaine);
     stringDel(chaine,depart,nombre);
     if inverse then chaine := stringinverser(chaine);
     Pchaine(L)^.chaine:=chaine;
     if not Pconstante(f1^.contenu)^.locale then
           restoreVarG(Pconstante(f1^.contenu)^.nom,L);
end;
{=======================================}
function TStrReplace.executer(arg:Pliste):Presult;
var f1,f2,f3:Pcorps;
    T: Presult;
    s1,s2,s3,res:string;
begin
     executer:=Nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     T := f1^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s1 := T^.getchaine
        else s1 := T^.en_chaine;
     Kill(pcellule(T));
     T := f2^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s2 := T^.getchaine
        else s2 := T^.en_chaine;
     Kill(pcellule(T));
     T := f3^.evaluer;
     if T = Nil then exit;
     if (T^.cat=1) and (T^.suivant=Nil) //une chaine
        then s3 := T^.getchaine
        else s3 := T^.en_chaine;
     Kill(pcellule(T));
     res:=StringReplace(s1,s2,s3,[rfReplaceAll]);
     executer:=New(Pchaine,init(res))
end;
{==============================================}
{TReverse}
function TReverse.executer(arg: Pliste):Presult;
var f:Pcorps;
    P1:Presult;
    res:type_liste;
begin
     executer:=nil;
     if arg=nil then exit;
     f:=Pcorps(arg^.tete);
     if (f=nil) then  exit;
     res.init;
     P1:=f^.evaluer;
     if P1=nil then exit;
     res.ajouter_fin(P1);
     res.inverser;
     executer:=Paffixe(res.tete);
end;
{=======================================}
{TFree}
function TFree.executer(arg: Pliste):Presult;
var f1,f2:Pcorps;
    rep:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then  exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) or (Pconstante(f2^.contenu)^.predefinie) then exit;
     rep:=f1^.dependDe(Pconstante(f2^.contenu)^.nom);
     executer:=new(Paffixe,init(1-byte(rep),0));
end;
{=======================================}
{TMerge}
function TMerge.executer(arg: Pliste):Presult;
var f:Pcorps;
    P1:Paffixe;
begin
     executer:=nil;
     if arg=nil then exit;
     f:=Pcorps(arg^.tete);
     if (f=nil) then  exit;
     P1:=f^.evalNum;
     if P1=nil then exit;
     executer:=Merge(P1);
     //Kill(Pcellule(P1));
end;
{=======================================}
function clipDroite(liste,a,b:Paffixe; close:boolean):Paffixe;
var etat:byte;
    z,z1,last,index,directeur:Paffixe;
    val:real;
    res:type_liste;
    nextstop:boolean;
begin
     last:=nil; etat:=0; directeur:=soustraireC(a,b);
     index:=liste; res.init;
     nextstop:=false;
     while index<>Nil do
           begin
                z:=soustraireC(index,a); val:=det(z,directeur);
                if val>0 then {bon coté}
                   begin
                        if (etat=0) And (last<>Nil) then
                           begin
                               z1:=cap(index,last,a,b);
                               if z1<>Nil then res.ajouter_fin(new(Paffixe,init(z1^.x,z1^.y)));
                               Kill(Pcellule(z1))
                           end;
                        etat:=1;res.ajouter_fin(new(Paffixe,init(index^.x,index^.y)));
                   end
                else if val=0 then  begin etat:=1;res.ajouter_fin(new(Paffixe,init(index^.x,index^.y))); end
                else begin
                          if (etat=1) And (last<>Nil) then
                             begin
                                  z1:=cap(index,last,a,b);
                                  if z1<>Nil then res.ajouter_fin(new(Paffixe,init(z1^.x,z1^.y)));
                                  Kill(Pcellule(z1))
                             end;
                             etat:=0;
                     end;
                last:=index;
                Kill(Pcellule(z));
                if nextstop then index:=Nil else
                   begin
                        index:=Paffixe(index^.suivant);
                        if close and (index=Nil) then begin index:=liste; nextstop:=true end;
                   end;
           end;
     Kill(Pcellule(directeur));
     if close and (res.tete<>Nil) then res.ajouter_fin(new(Paffixe,init( Paffixe(res.tete)^.x,Paffixe(res.tete)^.y)));
     clipDroite:=Paffixe(res.tete);
end;

{TClip2D}
function TClip2D.executer(arg: Pliste):Presult;
var f1,f2,f3:Pcorps;
    points,liste,contour,devant,aux,index,res:Paffixe;
    A,B: Paffixe;
    dev:type_liste;
    delliste, delcontour, close:boolean;

begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     close:=false;
     if f3<>Nil then begin A:=f3^.evalNum; close:=(A<>Nil) and (A^.x=1); Kill(Pcellule(A)) end;
     if (f1^.categorie=cat_constante) then
        begin
             delliste:=false; liste:=Paffixe(Pconstante(f1^.contenu)^.affixe)
        end
        else begin delliste:=true; liste:=f1^.evalNum end;
     if (liste=nil) then exit;
     if (f2^.categorie=cat_constante) then
        begin
             delcontour:=false; contour:=Paffixe(Pconstante(f2^.contenu)^.affixe)
        end
        else begin delcontour:=true; contour:=f2^.evalNum end;
     if (contour=nil) then begin if delliste then Kill(Pcellule(liste)); exit; end;
     if (contour=nil) or (contour^.suivant=nil) {or (contour^.suivant^.suivant=nil)}
       then
          begin if delliste then Kill(Pcellule(liste));
                if delcontour then Kill(Pcellule(contour));
                exit
          end;
     points:=liste; dev.init;
     while (points<>nil) and Isjump(points) do points:=Paffixe(points^.suivant);
     while points<>nil do
           begin
                aux:=points;
                while (aux<>nil) and (not Isjump(aux)) do aux:=Paffixe(aux^.suivant);
                if IsJump(aux) then aux^.precedent^.suivant:=nil; {on décroche la liste du reste}
                devant:=points;
                index:=Paffixe(contour^.suivant); b:=contour;
                while index<>Nil do
                      begin
                           a:=b; b:=index;
                           res:=clipDroite(devant,a,b,close);
                           if devant<>points then Kill(Pcellule(devant));
                           devant:=res;
                           index:=Paffixe(index^.suivant)
                      end;
                if devant<>nil then
                   begin
                       dev.ajouter_fin(devant);
                       if aux<>nil then
                          dev.ajouter_fin(new(Paffixe,init(jump^.x,aux^.y)));
                   end;
                if IsJump(aux) then aux^.precedent^.suivant:=aux;{on raccroche la liste au reste}
                points:=aux;
                while Isjump(points) do points:=Paffixe(points^.suivant);
           end;
     if delliste then Kill(Pcellule(liste));
     if delcontour then Kill(Pcellule(contour));
     executer:= Paffixe(dev.tete);
end;
{============== Definir reel ==============}
 function definir_reel(Const chaine:String; var x:real):boolean;
 var f:Pexpression;
     r:Paffixe;
 begin
      definir_reel:=false;
      new(f,init);
      if f^.Definir(chaine)
         then
             begin
                  r:=f^.evalNum;
                  if r<>nil
                     then
                         begin
                              x:=r^.x;
                              definir_reel:=true; Kill(Pcellule(r))
                         end;
             end;
      dispose(f,detruire)
end;
{========== MakeSpeciale =============}
function MakeSpeciale(Const S:string): string;   //Pour la commande Special, remplacement des balises
begin
    result:='["'+ StringReplace(S,'\[','",',
               [rfReplaceAll, rfIgnoreCase])+'"]';
    result:=StringReplace(result,'\]',',"',
               [rfReplaceAll, rfIgnoreCase]);
end;
{=========================}
FUNCTION Executer(const commande: string): boolean;
var f:Pexpression;
    T:Presult;
begin
     Executer:=false;
     new(f,init);
     if f^.definir(commande) then
        begin
             T:=f^.evaluer;
             Executer:=(T=nil) Or ((T^.cat=0) and (Paffixe(T)^.x<>0)); //retour=0 => false
             Kill(Pcellule(T));
        end;
     dispose(f,detruire);
end;
{=======================}
function fusion(var source, cible: type_liste): boolean;
var ok:boolean;
    aux1,aux2:Paffixe;
    aux:Pcellule;
    x1,y1,x2,y2:real;
begin
        ok:=false;
        if cible.tete=nil then
         begin
                cible.tete:=source.tete;
                cible.queue:=source.queue;
         end
           else
                begin
                   aux1:=Paffixe(cible.tete);
                   x1:=Paffixe(source.tete)^.x; y1:=Paffixe(source.tete)^.y;
                   x2:=Paffixe(source.queue)^.x; y2:=Paffixe(source.queue)^.y;
                   while IsJump(aux1) do cible.supprimer(Pcellule(aux1));
                   while aux1<>nil do
                        begin
                                aux2:=aux1;
                                while (aux2^.suivant<>nil) and (not IsJump(Paffixe(aux2^.suivant))) do
                                        aux2:=Paffixe(aux2^.suivant);
                             if not ok then //tests
                                if (x1=aux1^.x) and (y1=aux1^.y) then
                                        begin
                                                source.inverser;
                                                aux:=source.queue;
                                                source.supprimer(aux);
                                                cible.inserer(source.tete,aux1);
                                                aux1:=nil;ok:=true;
                                        end else
                                 if (x1=aux2^.x) and (y1=aux2^.y) then
                                        begin
                                                aux:=source.tete;
                                                source.supprimer(aux);
                                                cible.inserer(source.tete,aux2^.suivant);
                                                aux1:=nil;ok:=true;
                                        end else
                                 if (x2=aux1^.x) and (y2=aux1^.y) then
                                        begin
                                                aux:=source.queue;
                                                source.supprimer(aux);
                                                cible.inserer(source.tete,aux1);
                                                aux1:=nil;ok:=true;
                                        end else
                                 if (x2=aux2^.x) and (y2=aux2^.y) then
                                        begin
                                                aux:=source.queue;
                                                source.supprimer(aux);
                                                source.inverser;
                                                cible.inserer(source.tete,aux2^.suivant);
                                                aux1:=nil;ok:=true;
                                        end else //pas de fusion ici
                                        begin
                                             aux1:=Paffixe(aux2^.suivant);
                                             if IsJump(aux1) then aux1:=Paffixe(aux1^.suivant);
                                        end
                        end;
                   if not ok then //il n'y a pas eu de fusion
                        begin
                            cible.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                            cible.ajouter_fin(source.tete);
                        end;
                end;
       source.init;
       result:=ok;
end;
{=======================}
function Merge(entree:Paffixe): Paffixe;
var ok:boolean;
     L,Q,Z:type_liste;
     aux1,aux2:Paffixe;
begin
     result:=nil;
     if entree=nil then exit;
     Q.init; Q.ajouter_fin(entree);L.init;Z.init;
     repeat
          L.tete:=Q.tete;L.queue:=Q.queue;Q.init;ok:=false;
          aux1:=Paffixe(L.tete);
          while IsJump(aux1) do L.supprimer(Pcellule(aux1));
          while aux1<>nil do
                begin
                      aux2:=aux1;
                      while (aux2<>nil) and (not IsJump(aux2)) do
                         aux2:=Paffixe(aux2^.suivant);
                      if aux2<>nil then aux2^.precedent^.suivant:=nil;
                      Z.ajouter_fin(aux1);
                      L.tete:=aux2;
                      while IsJump(aux2) do L.supprimer(Pcellule(aux2));
                      ok:=fusion(Z,Q) or ok;
                      aux1:=aux2;
                end;
     until not ok;
     result:=Paffixe(Q.tete);
end;
{=======================}
function TMix.executer(arg:Pliste):Presult;
//Mix(liste1, liste2, [by1,by2])
var
     f1,f2,f3:Pcorps;
     z1,z2,index1,index2:Presult;
     compt1,compt2,i:longint;
     kill1, kill2, stop:boolean;
     T:Paffixe;
     res:type_liste;
begin
     executer:=Nil; if arg=Nil then exit;
     f1:=Pcorps(arg^.tete); if f1=Nil then exit;
     f2:=Pcorps(f1^.suivant); if f2=Nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=Nil then begin compt1:=1; compt2:=1 end
     else
         begin
              T:=f3^.evalNum;
              if T=Nil then  begin compt1:=1; compt2:=1 end
              else begin
                    if IsJump(T) then compt1:=0 else compt1:=Round(T^.x);
                    if T^.suivant=Nil then  compt2:=1
                    else
                     if IsJump(Presult(T^.suivant)) then compt2:=0 else compt2:=Round(Paffixe(T^.suivant)^.x);
                   end;
              Kill(Pcellule(T))
         end;
     if (f1^.categorie=cat_constante) then begin kill1:=false; z1:=Pconstante(f1^.contenu)^.affixe end
                                      else begin kill1:=true; z1:=f1^.evaluer end;
     if (f2^.categorie=cat_constante) then begin kill2:=false; z2:=Pconstante(f2^.contenu)^.affixe end
                                           else begin kill2:=true; z2:=f2^.evaluer end;
     res.init;
     index1:=z1; index2:=z2;
     while index1<>Nil do
     begin
          i:=0; stop:=false;
          while not stop do
          begin
               res.ajouter_fin(index1^.dup);
               Inc(i,1); index1:=Presult(index1^.suivant);
               stop:= (index1=Nil) or (i=compt1) or ((compt1=0) And Isjump(Presult(index1^.precedent)))
          end;
          i:=0; stop:=(index2=Nil);
          while not stop do
          begin
               res.ajouter_fin(index2^.dup);
               Inc(i,1); index2:=Presult(index2^.suivant);
               stop:= (index2=Nil) or (i=compt2) or ((compt2=0) and Isjump(Presult(index2^.precedent)))
          end;
     end;
     while (index2<>Nil) do
          begin
               res.ajouter_fin(index2^.dup);
               index2:=Presult(index2^.suivant);
          end;
     if kill1 then Kill(Pcellule(z1)); if kill2 then Kill(Pcellule(z2));
     executer:=Presult(res.tete);
end;

Initialization
     LesOperations.ajouter_fin(new(Pplus,init('+',priorite_addition)));
     LesOperations.ajouter_fin(new(Pfois,init('*',priorite_multiplication)));
     LesOperations.ajouter_fin(new(Pdiv,init('/',priorite_division)));
     LesOperations.ajouter_fin(new(Pmoins,init('-',priorite_soustraction)));
     LesOperations.ajouter_fin(new(Pexpo,init('^',priorite_puissance)));
     LesOperations.ajouter_fin(new(PCapD,init('Inter',priorite_fonction)));
     LesOperations.ajouter_fin(new(PCapL,init('InterL',priorite_fonction)));
     LesOperations.ajouter_fin(new(PCutB,init('CutB',priorite_or)));
     LesOperations.ajouter_fin(new(PCutA,init('CutA',priorite_or)));
     LesOperations.ajouter_fin(new(PInside,init('Inside',priorite_egal)));
     LesOperations.ajouter_fin(new(PSup,init('>',priorite_superieur)));
     LesOperations.ajouter_fin(new(PSupOuE,init('>=',priorite_superieur)));
     LesOperations.ajouter_fin(new(PInf,init('<',priorite_inferieur)));
     LesOperations.ajouter_fin(new(PInfOuE,init('<=',priorite_inferieur)));
     LesOperations.ajouter_fin(new(POperation,init('Recoit',priorite_affectation)));
     LesOperations.ajouter_fin(new(POperation,init('Extract',priorite_copy)));
     LesOperations.ajouter_fin(new(POperation,init('Egal',priorite_egal)));
     LesOperations.ajouter_fin(new(POperation,init('NEgal',priorite_egal)));
     LesOperations.ajouter_fin(new(POperation,init('Or',priorite_or)));
     LesOperations.ajouter_fin(new(POperation,init('And',priorite_and)));

     LesFonctions.ajouter_fin(new(Psqr,init('sqr')));
     LesFonctions.ajouter_fin(new(Popp,init('opp')));
     LesFonctions.ajouter_fin(new(Psin,init('sin')));
     LesFonctions.ajouter_fin(new(Pcos,init('cos')));
     LesFonctions.ajouter_fin(new(Ptan,init('tan')));
     LesFonctions.ajouter_fin(new(Parcsin,init('arcsin')));
     LesFonctions.ajouter_fin(new(Parccos,init('arccos')));
     LesFonctions.ajouter_fin(new(Parctan,init('arctan')));
     LesFonctions.ajouter_fin(new(Psh,init('sh')));
     LesFonctions.ajouter_fin(new(Pch,init('ch')));
     LesFonctions.ajouter_fin(new(Pth,init('th')));
     LesFonctions.ajouter_fin(new(Pargsh,init('argsh')));
     LesFonctions.ajouter_fin(new(Pargch,init('argch')));
     LesFonctions.ajouter_fin(new(Pargth,init('argth')));
     LesFonctions.ajouter_fin(new(Pexp,init('exp')));
     LesFonctions.ajouter_fin(new(Pln,init('ln')));
     LesFonctions.ajouter_fin(new(Psqrt,init('sqrt')));
     LesFonctions.ajouter_fin(new(Pbar,init('bar')));
     LesFonctions.ajouter_fin(new(Pabs,init('abs')));
     LesFonctions.ajouter_fin(new(PArg,init('Arg')));
     LesFonctions.ajouter_fin(new(PEnt,init('Ent')));
     LesFonctions.ajouter_fin(new(PRe,init('Re')));
     LesFonctions.ajouter_fin(new(PIm,init('Im')));
     LesFonctions.ajouter_fin(new(PRand,init('Rand')));
{contribution de Patrick BESSE 29/03/08}
     LesFonctions.ajouter_fin(new(Pcot,init('cot')));
     LesFonctions.ajouter_fin(new(Parccot,init('arccot')));
     LesFonctions.ajouter_fin(new(Pcth,init('cth')));
     LesFonctions.ajouter_fin(new(Pargcth,init('argcth')));
{======================================}
    
     Constpredefinie:=true;
     LesConstantes.ajouter_fin(new(Pconstante,init('i',new(Paffixe,init(0,1)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('e',new(Paffixe,init(exp(1),0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('pi',new(Paffixe,init(pi,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('noline',new(Paffixe,init(-1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('solid',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('dashed',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('dotted',new(Paffixe,init(2,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('userdash',new(Paffixe,init(3,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('thinlines',new(Paffixe,init(2,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('thicklines',new(Paffixe,init(8,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('Thicklines',new(Paffixe,init(14,0)),false)));

     LesConstantes.ajouter_fin(new(Pconstante,init('dotcircle',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('dot',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('bigdot',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('square''',new(Paffixe,init(3,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('plus',new(Paffixe,init(4,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('cross',new(Paffixe,init(4,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('times',new(Paffixe,init(5,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('asterisk',new(Paffixe,init(6,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('oplus',new(Paffixe,init(7,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('otimes',new(Paffixe,init(8,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('diamond',new(Paffixe,init(9,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('diamond''',new(Paffixe,init(10,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('triangle',new(Paffixe,init(11,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('triangle''',new(Paffixe,init(12,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('pentagon',new(Paffixe,init(13,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('pentagon''',new(Paffixe,init(14,0)),false)));

     LesConstantes.ajouter_fin(new(Pconstante,init('butt',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('round',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('square',new(Paffixe,init(2,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('miter',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('bevel',new(Paffixe,init(2,0)),false)));

     LesConstantes.ajouter_fin(new(Pconstante,init('center',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('left',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('right',new(Paffixe,init(2,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('framed',new(Paffixe,init(16,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('stacked',new(Paffixe,init(32,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('special',new(Paffixe,init(64,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('top',new(Paffixe,init(4,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('bottom',new(Paffixe,init(8,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('baseline',new(Paffixe,init(12,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('jump',new(Paffixe,init(reel_Max,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('comp',new(Paffixe,init(-reel_Max,0)),false)));

     LesConstantes.ajouter_fin(new(Pconstante,init('line',new(Paffixe,init(reel_Max,1)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('linearc',new(Paffixe,init(reel_Max,2)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('bezier',new(Paffixe,init(reel_Max,3)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('curve',new(Paffixe,init(reel_Max,4)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('arc',new(Paffixe,init(reel_Max,5)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('move',new(Paffixe,init(reel_Max,6)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('ellipticArc',new(Paffixe,init(reel_Max,7)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('circle',new(Paffixe,init(reel_Max,8)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('ellipse',new(Paffixe,init(reel_Max,9)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('closepath',new(Paffixe,init(reel_Max,10)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('clinearc',new(Paffixe,init(reel_Max,11)),false)));

     LesConstantes.ajouter_fin(new(Pconstante,init('none',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('full',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('bdiag',new(Paffixe,init(2,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('hvcross',new(Paffixe,init(3,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('diagcross',new(Paffixe,init(4,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('fdiag',new(Paffixe,init(5,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('horizontal',new(Paffixe,init(6,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('vertical',new(Paffixe,init(7,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('gradient',new(Paffixe,init(8,0)),false)));

     LesConstantes.ajouter_fin(new(Pconstante,init('linear',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('radial',new(Paffixe,init(2,0)),false)));

     LesConstantes.ajouter_fin(new(Pconstante,init('tiny',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('scriptsize',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('footnotesize',new(Paffixe,init(2,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('small',new(Paffixe,init(3,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('normalsize',new(Paffixe,init(4,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('large',new(Paffixe,init(5,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('Large',new(Paffixe,init(6,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('LARGE',new(Paffixe,init(7,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('huge',new(Paffixe,init(8,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('Huge',new(Paffixe,init(9,0)),false)));
     
     LesConstantes.ajouter_fin(new(Pconstante,init('Nil',nil,false)));

     {$IFDEF MSWINDOWS}
     LesConstantes.ajouter_fin(new(Pconstante,init('Windows',new(Paffixe,init(1,0)),false)));
     {$ELSE}
     LesConstantes.ajouter_fin(new(Pconstante,init('Windows',new(Paffixe,init(0,0)),false)));
     {$ENDIF}

     {$IFDEF GUI}
     LesConstantes.ajouter_fin(new(Pconstante,init('GUI',new(Paffixe,init(1,0)),false)));
     {$ELSE}
     LesConstantes.ajouter_fin(new(Pconstante,init('GUI',new(Paffixe,init(0,0)),false)));
     {$ENDIF}



     //Au moment de l'export, Data contient les données de l'objet
     PData:=  new(Pconstante,init('Data',new(Paffixe,init(reel_Max,0)),false));
     LesConstantes.ajouter_fin(PData);
     //PDraw:=new(Pconstante,init('Draw',new(Paffixe,init(reel_Max-1,0)),false));
     //LesConstantes.ajouter_fin(PDraw));

     PXmin:=new(Pconstante,init('Xmin',new(Paffixe,init(-5,0)),false));
     LesConstantes.ajouter_fin(PXmin);

     PYmin:=new(Pconstante,init('Ymin',new(Paffixe,init(-5,0)),false));
     LesConstantes.ajouter_fin(PYmin);

     PXmax:=new(Pconstante,init('Xmax',new(Paffixe,init(5,0)),false));
     LesConstantes.ajouter_fin(PXmax);

     PYmax:=new(Pconstante,init('Ymax',new(Paffixe,init(5,0)),false));
     LesConstantes.ajouter_fin(PYmax);

     PXscale:=new(Pconstante,init('Xscale',new(Paffixe,init(1,0)),false));
     LesConstantes.ajouter_fin(PXscale);

     PYscale:=new(Pconstante,init('Yscale',new(Paffixe,init(1,0)),false));
     LesConstantes.ajouter_fin(PYscale);

     LesConstantes.ajouter_fin(new(Pconstante,init('margeG',new(Paffixe,init(0.5,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('margeD',new(Paffixe,init(0.5,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('margeH',new(Paffixe,init(0.5,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('margeB',new(Paffixe,init(0.5,0)),false)));

     PExportMode:=new(Pconstante,init('ExportMode',new(Paffixe,init(0,0)),false));
     LesConstantes.ajouter_fin(PExportMode);

     LesConstantes.ajouter_fin(new(Pconstante,init('teg',new(Paffixe,init(3,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('tex',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('pst',new(Paffixe,init(2,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('pgf',new(Paffixe,init(5,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('svg',new(Paffixe,init(9,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('eps',new(Paffixe,init(4,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('pdf',new(Paffixe,init(6,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('tkz',new(Paffixe,init(7,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('epsc',new(Paffixe,init(8,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('pdfc',new(Paffixe,init(10,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('psf',new(Paffixe,init(11,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('user',new(Paffixe,init(12,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('src4latex',new(Paffixe,init(13,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('obj',new(Paffixe,init(14,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('geom',new(Paffixe,init(15,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('jvx',new(Paffixe,init(16,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('js',new(Paffixe,init(19,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('bmp',new(Paffixe,init(17,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('texsrc',new(Paffixe,init(18,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('html',new(Paffixe,init(20,0)),false)));

     {constantes chaines}
     LesConstantes.ajouter_fin(new(Pconstante,init('LF',new(Pchaine,init(CRLF)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('DirSep',new(Pchaine,init(DirectorySeparator)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('Diese',new(Pchaine,init('#')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('InitialPath',new(Pchaine,init('')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('TmpPath',new(Pchaine,init('')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('UserMacPath',new(Pchaine,init('')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('ND',new(Pchaine,init('_ND')),false)));
     {numero de version}
     LesConstantes.ajouter_fin(new(Pconstante,init('version',new(Pchaine,init(version)),false)));
     {$IFDEF GUI}
     LesConstantes.ajouter_fin(new(Pconstante,init('DocPath',new(Pchaine,init('')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('PdfReader',new(Pchaine,init('')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('ImageViewer',new(Pchaine,init('')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('JavaviewPath',new(Pchaine,init('')),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('WebLoad',new(Pchaine,init('')),false)));
     {$ENDIF$}
     
     {type de projection}
     LesConstantes.ajouter_fin(new(Pconstante,init('ortho',new(Paffixe,init(0,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('central',new(Paffixe,init(1,0)),false)));
     LesConstantes.ajouter_fin(new(Pconstante,init('sep3D',new(Paffixe,init(reel_Max,-1)),false))); // séparateur d'éléments dans
     //la commande Build3D
     LesConstantes.ajouter_fin(new(Pconstante,init('sep',new(Paffixe,init(reel_Max,0)),false))); // séparateur de composantes dans une liste

     Constpredefinie:=false;
     LesCommandes.ajouter_fin(new(PBreak,init('break')));
     LesCommandes.ajouter_fin(new(PExit,init('exit')));
     LesCommandes.ajouter_fin(new(PSeq,init('Seq')));
     LesCommandes.ajouter_fin(new(PMap,init('Map')));
     LesCommandes.ajouter_fin(new(PFor,init('For')));
     LesCommandes.ajouter_fin(new(PRange,init('Range'))); // depuis version 2.0
     LesCommandes.ajouter_fin(new(PCmListe,init('Liste')));
     LesCommandes.ajouter_fin(new(PCmListe,init('List')));//english version
     LesCommandes.ajouter_fin(new(PSi,init('Si')));
     LesCommandes.ajouter_fin(new(PSi,init('If')));//english version
     LesCommandes.ajouter_fin(new(PCopy,init('Copy')));
     LesCommandes.ajouter_fin(new(PLoop,init('Loop')));
     LesCommandes.ajouter_fin(new(PWhile,init('While')));
     LesCommandes.ajouter_fin(new(PAssign,init('Assign')));
     LesCommandes.ajouter_fin(new(PNops,init('nops')));
     LesCommandes.ajouter_fin(new(PNops,init('Len'))); //version 2.0
     LesCommandes.ajouter_fin(new(PNops,init('Nops')));
     LesCommandes.ajouter_fin(new(PNargs,init('Nargs')));
     LesCommandes.ajouter_fin(new(PM,init('M')));
     LesCommandes.ajouter_fin(new(PArgs,init('Args')));
     LesCommandes.ajouter_fin(new(PStrArgs,init('StrArgs')));
     LesCommandes.ajouter_fin(new(PDiff,init('Diff')));
     LesCommandes.ajouter_fin(new(PInt,init('Int')));
     LesCommandes.ajouter_fin(new(PSolve,init('Solve')));
     LesCommandes.ajouter_fin(new(PRound,init('Round')));
     LesCommandes.ajouter_fin(new(PSetVar,init('Set')));
     LesCommandes.ajouter_fin(new(PEgal,init('Egal'))); //1.96 operation -> commande
     LesCommandes.ajouter_fin(new(PNEgal,init('NEgal')));//1.96 operation -> commande
     LesCommandes.ajouter_fin(new(POr,init('Or'))); //1.96 operation -> commande
     LesCommandes.ajouter_fin(new(PAnd,init('And')));//1.96 operation -> commande
     LesCommandes.ajouter_fin(new(PMix,init('Mix')));//1.96
     //Mix( liste1, liste2, [paquet1, paquet2] ): renvoie les deux listes mixées
     LesCommandes.ajouter_fin(new(PDel,init('Del')));
     LesCommandes.ajouter_fin(new(PSubs,init('Subs'))); //depuis version 2.0
     //Replace(variable (liste ou chaine), indice, [nombre ,] par) : remplacer l'élément d'indice par
     LesCommandes.ajouter_fin(new(PClip2D,init('Clip2D')));
     //Clip2D( liste, contour convexe, close)
     LesCommandes.ajouter_fin(new(PEchange,init('Echange')));
     LesCommandes.ajouter_fin(new(PEchange,init('Exchange')));//english version
     LesCommandes.ajouter_fin(new(PInc,init('Inc')));
     LesCommandes.ajouter_fin(new(PAppend,init('Append')));
     LesCommandes.ajouter_fin(new(PAppend,init('Insert')));
     LesCommandes.ajouter_fin(new(PRgb,init('Rgb')));
     LesCommandes.ajouter_fin(new(PHexacolor,init('HexaColor')));

     LesCommandes.ajouter_fin(New(PSort,init('Sort')));
     LesCommandes.ajouter_fin(New(PPermuteWith,init('PermuteWith')));
     //PermuteWith( permutation d'entiers de 1 à n, liste à permuter, taille des paquets ou jump): la liste doit être une variable,
     //elle est réarrangée avec la permutation indiquée et traitée par paquets (taille 1 par défaut).

     LesCommandes.ajouter_fin(new(PStrComp,init('StrComp')));
     LesCommandes.ajouter_fin(new(PStrPos,init('StrPos')));
     //StrPos(motif, chaine): entier (position du premier motif dans chaine)
     LesCommandes.ajouter_fin(new(PStrLength,init('StrLength'))); //
     LesCommandes.ajouter_fin(new(PStrLength,init('StrLen'))); //
     //commandes renvoyant une chaine
     LesCommandes.ajouter_fin(new(PStrReplace,init('StrReplace')));
     //StrReplace(chaine, motif à remplacer, motif de remplacement): chaine résultante
     LesCommandes.ajouter_fin(new(PStrCopy,init('StrCopy'))); //
     LesCommandes.ajouter_fin(new(PStrDel,init('StrDel'))); //
     LesCommandes.ajouter_fin(new(PStrInsert,init('StrInsert'))); //
     LesCommandes.ajouter_fin(new(PStr2List,init('Str2List'))); // chaine -> liste de caractères
     LesCommandes.ajouter_fin(new(PGetStr,init('GetStr'))); //1.96, pour compatibilité
     LesCommandes.ajouter_fin(new(PStr,init('Str'))); //1.96, pour compatibilité
     LesCommandes.ajouter_fin(new(PUpperCase,init('UpperCase'))); //1.96, pour compatibilité
     LesCommandes.ajouter_fin(new(PLowerCase,init('LowerCase'))); //1.96, pour compatibilité
     LesCommandes.ajouter_fin(new(PString,init('String'))); //1.96, pour compatibilité
     LesCommandes.ajouter_fin(new(PConcat,init('Concat'))); //1.96, pour concaténer
     //Concatener( chaine1, chaine2, ...) ou Concat( [chaine1, chaine2, ...] )
     LesCommandes.ajouter_fin(new(PIsString,init('IsString')));//1.96
     // Istring( argument ) renvoie 1 si argument est de type chaine
     LesCommandes.ajouter_fin(new(PString2Teg,init('String2Teg')));//1.96
     //String2Teg( argument1, argument2,... ) évalue les argments sous forme de chaines et les renvoie au format texgraph.
     LesCommandes.ajouter_fin(new(PScientificF,init('ScientificF')));//1.96
     //ScientificF( reel, deci): renvoie x en format scientifique (chaine) avec deci décimales (toutes si deci=0)

     LesCommandes.ajouter_fin(New(PReverse,init('Reverse')));//renvoie la liste renversée
     LesCommandes.ajouter_fin(New(PMerge,init('Merge')));
     LesCommandes.ajouter_fin(New(PFree,init('Free')));
     //Free( expression, variable): renvoit 1 si la variable ne figure pas dans l'expression

     jump:=Paffixe(constante('jump')^.affixe);
     sep:=Paffixe(constante('sep')^.affixe);
     ND:=Pchaine(constante('ND')^.affixe);
     Randomize

END.

