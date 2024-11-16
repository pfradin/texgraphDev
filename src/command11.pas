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


unit command11;

{$MODE Delphi}

  //commandes liées à l'interface

interface


implementation
uses
  SysUtils,classes, 
{$IFDEF GUI}
Controls,Graphics, Forms, Lresources, LcLIntf, LclType,BGRABitmap, //Dialogs,
{$ELSE}
UnitLog,
{$ENDIF}

   listes2,complex3,analyse4,command5,graph1_6,graph2_7,command9,command10, untres,
   {$IFDEF GUI}
   Unit1,Editeur;
   {$ELSE}
   main;
   {$ENDIF}
type

   POriginalCoord=^TOriginalCoord;
   TOriginalCoord= object(Tcommande)

                 function executer(arg:PListe):Presult;virtual;
                 end;

    PGrayscale= ^TGrayscale;
    TGrayscale= object(Tcommande)
                function executer(arg:PListe):Presult;virtual;
               end;

{$IFDEF GUI}
  PNewBitmap = ^TNewBitmap;
  TNewBitmap= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

  PDelBitmap = ^TDelBitmap;
  TDelBitmap= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

  PPixel = ^TPixel;
  TPixel= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

  PGetPixel = ^TGetPixel;
  TGetPixel= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

  PMaxPixel = ^TMaxPixel;
  TMaxPixel= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

  PPixel2Scr = ^TPixel2Scr;
  TPixel2Scr= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

  PScr2Pixel = ^TScr2Pixel;
  TScr2Pixel= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

   PVisibleGraph= ^TVisibleGraph;
   TVisibleGraph= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

   PListFiles= ^TListFiles;
   TListFiles= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

   PListWords= ^TListWords;
   TListWords= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;
   
   PNewItem= ^TNewItem;
   TNewItem= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

   PDelItem= ^TDelItem;
   TDelItem= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
             end;

   PNewButton= ^TNewButton;
   TNewButton= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                end;
   PDelButton= ^TDelButton;
   TDelButton= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                end;

   PNewTrackBar= ^TNewTrackBar;
   TNewTrackBar= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                end;
   PDelTrackBar= ^TDelTrackBar;
   TDelTrackBar= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                end;

   PNewText= ^TNewText;
   TNewText= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                end;

   PDelText= ^TDelText;
   TDelText= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                end;
   Predraw= ^Tredraw;
   Tredraw= object(Tcommande)
             function executer(arg:PListe):Presult;virtual;
             end;

  PInput= ^Tinput;
  Tinput= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

  PAttributs= ^TAttributs;
  TAttributs= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PLoadFond=^TLoadFond;
  TloadFond= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PDelay=^TDelay;
  TDelay= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PTimerOnOff=^TTimerOnOff;
  TTimerOnOff= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PTimerMac=^TTimerMac;
  TTimerMac= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PAddMenu2D=^TAddMenu2D;
  TAddMenu2D= object(Tcommande)
              function executer(arg:PListe):Presult;virtual;
              end;

  PAddMenu3D=^TAddMenu3D;
  TAddMenu3D= object(Tcommande)
              function executer(arg:PListe):Presult;virtual;
              end;
  PEditGraph=^TEditGraph;
  TEditGraph= object(Tcommande)
              function executer(arg:PListe):Presult;virtual;
              end;
{$ENDIF}

  Precalc= ^Trecalc;
  Trecalc= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

  PDelete= ^TDelete;
  TDelete= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

  PDefVar= ^TDefVar;
  TDefVar= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PDelVar= ^TDelVar;
  TDelVar= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PExistsVar= ^TExistsVar;
  TExistsVar= object(Tcommande)
              function executer(arg:PListe):Presult;virtual;
              end;

  PDefMac=^TDefMac;
  TDefMac= object(Tcommande)
              function executer(arg:Pliste):Presult;virtual;
              end;

  PDelMac=^TDelMac;
  TDelMac= object(Tcommande)
           function executer(arg:Pliste):Presult;virtual;
           end;

  PExistsMac= ^TExistsMac;
  TExistsMac= object(Tcommande)
              function executer(arg:PListe):Presult;virtual;
              end;

  PInputMac= ^TinputMac;
  TinputMac= object(Tcommande)

           function executer(arg:PListe):Presult;virtual;
           end;

  PMessage= ^TMessag;
  TMessag= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;
  PRenMac=^TRenMac;
  TRenMac= object(Tcommande)
              function executer(arg:Pliste):Presult;virtual;
              end;

  PRenCommand=^TRenCommand;
  TRenCommand= object(Tcommande)
              function executer(arg:Pliste):Presult;virtual;
              end;

  PReadData= ^TReadData;    //lecture de nombres
  TReadData= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PReadFlatPs= ^TReadFlatPs;
  TReadFlatPs= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PTeX2FlatPs= ^TTeX2FlatPs;
  TTeX2FlatPs= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;
           
  PExec=^TExec;
  TExec= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

  PExport=^TExport;
  TExport= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;
           
  PShow=^TShow;
  TShow= object(Tcommande)
               function executer(arg:PListe):Presult;virtual;
         end;

   PHide=^THide;
   THide= object(Tcommande)
                function executer(arg:PListe):Presult;virtual;
          end;

{$IFDEF GUI}
{===========================}
function TEditGraph.executer;
//EditGraph(nom,commande) : créer et ouvre l'élément graphique correspondant à nom
var f1,f2:Pcorps;
    commande:string;
    aux1:Pelement;
    EditForm:TeditForm;
    ok:boolean;
begin
   if contexteUtilisateur then exit;
   ok:=true;
   if arg=nil then ok:=false;
   f1:=PCorps(arg^.tete);
   if (f1=nil) then ok:=false;
   f2:=Pcorps(f1^.suivant);
   if (f2=nil) then ok:=false;
   //f1 contient le nom
   if ok then
   begin
      CurrentName:=MakeString(f1);
      aux1:=Pelement(liste_element.tete);
      commande:=MakeString(f2);
      while (aux1<>nil) and (aux1^.nom<>CurrentName) do aux1:=Pelement(aux1^.suivant);
      if aux1<>Nil then ok:=false;
      if ok then
      begin
           CurrentCat:=cat_utilisateur; CurrentGraph:=Nil;
           EditForm:=TEditForm.Create(MainForm);
           EditForm.Memo1.Highlighter:=MainForm.SynAnySyn1;
           EditForm.Visible:=False;
           EditForm.modal:=true;
           EditForm.Caption:=TgGraphElement+'-';
           EditForm.Memo1.text:=commande;
           ok:=(EditForm.ShowModal=mrOk);
           EditForm.free;
      end;
   end;
   if ok then executer:=New(Paffixe,init(1,0))
         else executer:=New(Paffixe,init(0,0));
   MainForm.ScrollBox1.Setfocus;
end;
{===========================}
function TNewBitmap.executer;
var x,y:longint;
   f1:Pcorps;
   coul:Tcolor;
   T:Paffixe;
begin
     executer:=nil;
     coul:=clwhite;
     if arg<>nil then
        begin
             f1:=Pcorps(arg^.tete);
             if f1<>nil then
                begin
                     T:=f1^.evalNum;
                     if T<>nil then coul:= Round(abs(T^.x));
                     Kill(Pcellule(T))
                end;
        end;
    YaDrawBitmap:=true; Yafond:=false;
    x:=maxX+GmargeG+GmargeD; y:=maxY+GmargeH+GmargeB;
    DrawBitmap.free;
    DrawBitmap:=TBGRABitmap.create(x,y,coul);
end;
{============================}
function TDelBitmap.executer;
// DelBitmap() détruit le bitmap en cours
var x,y:longint;
begin
    executer:=nil;
    YaDrawBitmap:=false;
end;
{============================}
function TPixel.executer;
//Pixel( liste ) avec liste de la forme [ a+ib, couleur, a+ib, couleur, ...] avec a b entiers
var f1:Pcorps;
    T,index:Paffixe;
    a,b,coul:longint;
    del:boolean;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    if f1^.categorie=cat_constante
        then
            begin
                 del:=false;       {si f1 est une constante on ne la duplique pas}
                 T:=Paffixe(Pconstante(f1^.contenu)^.affixe);
            end
        else
            begin
                 del:=true;T:=f1^.evalNum;   {f1 est dupliqué}
            end;
    if T=Nil then exit;
    index:=T;
    while index<>Nil do
          begin
               a:=Round(index^.x); b:=Round(index^.y);
               index:=Paffixe(index^.suivant);
               if index<>Nil then
                  begin
                       coul:=Round(index^.x);
                       index:=Paffixe(index^.suivant);
                  end
               else coul:=0;
               if (0<=a) And (a<=maxX) and (0<=b) and (b<=maxY) then
                  begin
                       Inc(a,GmargeG); Inc(b,GmargeH);
                       DrawBitMap.DrawPixel(a,b,coul);
                       //Canevas.pixels[a,b]:=coul;// pas d'interaction directe avec le GUI
                  end
          end;
    if del then Kill(Pcellule(T));
end;
{=================}
function TGetPixel.executer;
// GetPixel( liste de a+ib ) renvoie les couleurs des points d'affixes a+ib (entiers)
var f1:Pcorps;
    aux,T1:Paffixe;
    a,b,coul:longint;
    res:type_liste;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    T1:=f1^.evalNum;
    if T1=Nil then exit;
    res.init; aux:=T1;
    while aux<>Nil do
          begin
          a:=Round(aux^.x); b:=Round(aux^.y);
          Inc(a,GmargeG); Inc(b,GmargeH);
          coul:=MyBitmap.GetPixel(a,b);
          res.ajouter_fin(New(Paffixe,init((coul),0)));
          aux:=Paffixe(aux^.suivant)
          end;
    Kill(PCellule(T1));
    executer:=Paffixe(res.tete);
end;
{=================}
function TPixel2Scr.executer;
// Pixel2Scr( a+ib ) conversion:  coordonnées entières -> affixe
var f1:Pcorps;
    T1:Paffixe;
    a,b:real;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    T1:=f1^.evalNum;
    if T1=Nil then exit;
    a:=Xreel(Round(T1^.x)+GmargeG); b:=Yreel(Round(T1^.y)+GmargeH);
    Kill(PCellule(T1));
    executer:=New(paffixe,init(a,b));
end;
{=================}
function TScr2Pixel.executer;
// Scrl2Pixel( x+iy ) conversion:  affixe -> coordonnées entières
var f1:Pcorps;
    T1:Paffixe;
    a,b:real;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    T1:=f1^.evalNum;
    if T1=Nil then exit;
    a:=Xentier(T1^.x)-GmargeG; b:=Yentier(T1^.y)-GmargeH;
    Kill(PCellule(T1));
    executer:=New(paffixe,init(a,b));
end;
{=================}
function TMaxPixel.executer;
// Maxpixel() renvoie maxX+i*maxY
begin
    executer:=nil;
    executer:=New(paffixe,init(maxX,maxY));
end;
{=================}
function TDelay.executer;
var f1:Pcorps;
    nbsecond:Paffixe;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    nbsecond:=f1^.evalNum;
    if nbsecond=nil then exit;
    Sleep(abs(round(nbsecond^.x)));
    Kill(Pcellule(nbsecond));
end;
{=================}
function TVisibleGraph.executer;
var f1:Pcorps;
    T:Paffixe;
begin
    executer:=nil;
    if contexteUtilisateur then exit;
    if arg=nil then
    begin
    executer:=new(Paffixe,init( byte(VisibleGraph),0));
    exit;
    end;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    T:=f1^.evalNum;
    if T=nil then exit;
    VisibleGraph:=(T^.x=1);
    Kill(PCellule(T));
    if visibleGraph then MainForm.dessiner;
end;
{=================}
function TListFiles.executer;
var chaine:string;
    i:longint;
begin
    executer:=nil;
    if contexteUtilisateur then exit;
    chaine:=TgPredefinies+': '+CRLF+'  color.mac'+CRLF+'  TeXgraph.mac'+CRLF+'  draw2d.mac'+CRLF+'  draw3d.mac'+CRLF+
    '  axes.mac'+CRLF+'  Interface.mac'+CRLF+CRLF+'User:'+CRLF;
    for i:=0 to  ListeFicMac.Count-1 do chaine:=chaine+'  '+ListeFicMac.Strings[i]+CRLF;
    MainForm.AfficherMessage(TgMacFilesLoaded, chaine);
end;
{=================}
function TListWords.executer;
var T:TstringList;
    i:longint;
    //C:Pconstante;
    //P:Pfonction;
    //Co:PCommande;
    Ma:Pmacros;
    Va:PVarGlob;
begin
   executer:=Nil;
   if contexteUtilisateur then exit;
   T:=TstringList.Create; T.CaseSensitive:=true;
   T.Add('TegNumeric:');
   T.Add('0 1 2 3 4 5 6 7 8 9 . E + -');
   T.Add('');T.Add('TegSymbol:');
   T.Add(': = , < > [ ] ( ) + - * / \ # $ @');
   T.Add('');T.Add('TegKeyWord:');
   for i:=0 to KeyWordList.Count-1 do T.Add(KeyWordList[i]);
   T.Add('');T.Add('TegConstant:');
   with LesConstantes do
        for I:=0 to Count-1 do T.add(List[I].Key);

   T.Add('');T.Add('TegFunction:');
   with LesFonctions do
        for I:=0 to Count-1 do T.add(List[I].Key);

   T.Add('');T.Add('TegCommand:');
   with LesCommandes do
        for I:=0 to Count-1 do T.add(List[I].Key);

   T.Add('');T.Add('TegMacPredef:');
   with LesMacros do
        for I:=0 to Count-1 do T.add(List[I].Key);

   T.Add('');T.Add('TegVarPredef:');
   with LesConstantes do
        for I:=0 to Count-1 do T.add(List[I].Key);

   Va:=PVarGlob(VariablesGlobales^.tete);
   while Va<>Nil do begin if (Va^.statut=1) then T.Add(Va^.Variable^.nom); Va:=PVarGlob(Va^.suivant) end;

   T.Add('');T.Add('TegMacUser:');
   with LesMacros do
        for I:=0 to Count-1 do T.add(List[I].Key);

   T.Add('');T.Add('TegVarGlob:');
   Va:=PVarGlob(VariablesGlobales^.tete);
   while Va<>Nil do begin if (Va^.statut=0) then T.Add(Va^.Variable^.nom); Va:=PVarGlob(Va^.suivant) end;
   MainForm.AfficherMessage(TgWordsList, T.text);
   T.free
end;
{=================}
function TTimerOnOff.executer;   //Timer( nb milli-second ), 0=stop
var f1:Pcorps;
    nbsecond:Paffixe;
    intervalle:longint;
begin
    if contexteUtilisateur then exit;
    executer:=nil;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    nbsecond:=f1^.evalNum;
    if nbsecond=nil
        then intervalle:=0
        else intervalle:=round(nbsecond^.x);
    listes2.Kill(Pcellule(nbsecond));
    if intervalle>0 then
        begin
                MainForm.Timer1.Enabled:=true;
                MainForm.Timer1.interval:=intervalle;
        end
        else
        begin
                MainForm.Timer1.Enabled:=false;
                MainForm.Timer1.interval:=0;
                MainForm.MiseAJour
        end
end;
{=======================}
function TTimerMac.executer;//TimerMac( <definir macro pour timer> )
var f1:Pcorps;
    res:Paffixe;
    corps:string;
    f:Pexpression;
begin
    if contexteUtilisateur then exit;
    new(res,init(0,0));
    res^.x:=0;
    executer:=res;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    corps:=makestring(f1);
    if corps='' then exit;
    new(f,init);
    f^.definir(corps);
    if f^.corps=nil then begin dispose(f,detruire); exit end;
    dispose(TimerMac,detruire); TimerMac:=f; res^.x:=1;
end;
{=======================}
function TAddMenu2D.executer;//AddMenu2D( <macro>, <aide> )
var f1,f2:Pcorps;
    res:Paffixe;
    nomMac, aide:string;
begin
    executer:=Nil;
    if contexteUtilisateur then exit;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    nomMac:=makestring(f1);
    f2:=Pcorps(f1^.suivant);
    if f2=Nil then aide:=' ' else aide:=' ['+ makestring(f2)+']';
    mac2d.add(nomMac+aide)
end;
{======================}
function TAddMenu3D.executer;//AddMenu2D( <macro>, <aide> )
var f1,f2:Pcorps;
    res:Paffixe;
    nomMac, aide:string;
begin
    executer:=Nil;
    if contexteUtilisateur then exit;
    if arg=nil then exit;
    f1:=PCorps(arg^.tete);
    if (f1=nil) then exit;
    nomMac:=makestring(f1);
    f2:=Pcorps(f1^.suivant);
    if f2=Nil then aide:=' ' else aide:=' ['+ makestring(f2)+']';
    mac3d.add(nomMac+aide)
end;
{======================}
function TAttributs.executer;
var res:Paffixe;
        f1:Pcorps;
        Thenom:string;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then TheNom:=''
      else
        begin
         f1:=Pcorps(arg^.tete);
         if f1<>nil then
                Thenom:=MakeString(f1)
                else TheNom:='';
        end;
     if MainForm.sourisDown then
        begin
                
                ReleaseCapture;
                
             MainForm.sourisDown:=false;
        end;
     GetAttributs;
     if MainForm.GestionAttributs(thenom) then res:=new(Paffixe,init(1,0))
                                  else
     res:=new(Paffixe,init(0,0));
     executer:=res;
end;
{=================TLoadFond================================}
function TLoadFond.executer;
var f1:PCorps;
    source:file;
    aux:TFileName;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     aux:=MakeString(f1);
     if aux='' then exit;
     If (not FileExists(aux)) then
             if  not MainForm.GetOpenFile('Background: '+ExtractFileName(aux),'Image (jpeg, bmp, png)','*.jpg|*.bmp|*.png',aux)
                 then exit;
     Fondname:=aux;
     filechanged:=true;
     MainForm.LoadFond;
end;
{================= commande TNewItem ================}
function TNewItem.executer;
var f1,f2:PCorps;
    aux1,aux2:string;
    index:integer;
    q:TMyItem;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     aux1:=MakeString(f1);
     if aux1='' then exit;
     aux2:=MakeString(f2);
     if aux2='' then exit;
     index:=MainForm.ComboBox1.Items.IndexOf(aux1);
     if (index=-1) or (TMyItem(MainForm.ComboBox1.Items.Objects[index]).statut=0)
        then
            begin
                 if index>-1 then
                    begin
                         q:=TMyItem(MainForm.ComboBox1.Items.Objects[index]);
                         q.free;
                         MainForm.ComboBox1.Items.Delete(index);
                    end;
                 MainForm.ComboBox1.Items.AddObject(aux1, TMyItem.Create(aux2));
                 MainForm.ComboBox1.ItemIndex:=0;
            end;
end;
{============= TDelItem ========}
function TDelItem.executer;
var f1:PCorps;
    Anom:string;
    q:TMyItem;
    index:integer;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then
        begin   // on détruit tous les items
             index:=0;
             while index<= (MainForm.ComboBox1.Items.Count-1) do
             begin
                 q:=TMyItem(MainForm.ComboBox1.Items.Objects[index]);
                 q.free;
                 MainForm.ComboBox1.Items.delete(index);
             end;
        end
                else
        begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     Anom:=MakeString(f1);
                     index:=MainForm.ComboBox1.Items.IndexOf(Anom);
                     if index=-1 then exit;
                     q:=TMyItem(MainForm.ComboBox1.Items.Objects[index]);
                     q.free;
                     MainForm.ComboBox1.Items.Delete(index);
                end;
        end;
        MainForm.ComboBox1.ItemIndex:=MainForm.ComboBox1.Items.Count-1;
end;
{=======================}
function TNewButton.executer;
var f1,f2,f3,f4,f5,f6:PCorps;
    aux1,aux2:string;
    aide,name:string;
    res1,res2,res3:Paffixe;
    button:PMyBouton;
    AnId:Integer;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     f4:=Pcorps(f3^.suivant);
     if f4=nil then exit;
     f5:=Pcorps(f4^.suivant);
     if f5=nil then exit;
     aux1:=MakeString(f2);
     if aux1='' then exit;
     aux2:=MakeString(f5);
     if aux2='' then exit;
     f6:=PCorps(f5^.suivant);
     if f6=nil then aide:='' else aide:=String(MakeString(f6));
     res1:=f1^.evalNum;
     if res1=nil then exit;
     if res1^.y<>0 then begin listes2.Kill(Pcellule(res1)); exit end;
     res2:=f3^.evalNum;
     if res2=nil then begin listes2.Kill(Pcellule(res1));exit end;
     res3:=f4^.evalNum;
     if res3=nil then begin listes2.Kill(Pcellule(res1)); listes2.Kill(Pcellule(res2));exit end;
     AnId:=Round(res1^.x);
     name:='MyButton'+IntToStr(AnId);
     button:=PMyBouton(ListeBoutons^.tete);
     while (button<>nil) and (button^.bouton.name<>name) do button:=PMyBouton(button.suivant);
     if (button=nil) or (button^.statut=0)
        then
            begin
                 if button<>nil then
                    begin
                         AfficheMessage(TgButtonExists);
                         ListeBoutons^.supprimer(Pcellule(button));
                    end;
                 ListeBoutons^.ajouter_fin(New(PMyBouton,
                            init(MainForm.Panel1,AnId,aux1,aux2,
                                 Round(res2^.x),Round(res2^.y),Round(res3^.x),Round(res3^.y),aide)));
            end;
     listes2.Kill(Pcellule(res1)); listes2.Kill(Pcellule(res2));
     listes2.Kill(Pcellule(res3));
     end;

{=======================}
{commande DelButton}
function TDelButton.executer;
var f1:PCorps;
    Anom:string;
    button:PMyBouton;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then  ListeBoutons^.detruire
                else
        begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     Anom:=MakeString(f1);
                     button:=PMyBouton(ListeBoutons^.tete);
                     while (button<>nil) and (button^.bouton.caption<>Anom) do
                           button:=PMyBouton(button.suivant);
                     if (button<>nil) then ListeBoutons^.supprimer(Pcellule(button));
                     f1:=Pcorps(f1^.suivant);
                end;
        end;
end;
{======================}
function TNewTrackBar.executer;
//<Id>, <affixe>, <taille>, <min+i*max>, <variable> [, aide] )
var f1,f2,f3,f4,f5,f6:PCorps;
    aux1:string;
    aide:string;
    res:Paffixe;
    trackbar:PMytrackbar;
    AnId,Along,Aheight,posX,posY:Integer;
    amin,amax:longint;
begin
     executer:=nil; if arg=nil then exit;
     if contexteUtilisateur then exit;
     f1:=PCorps(arg^.tete); if (f1=nil) then exit; //Id
     f2:=Pcorps(f1^.suivant); if f2=nil then exit; //affixe
     f3:=Pcorps(f2^.suivant); if f3=nil then exit; //taille
     f4:=Pcorps(f3^.suivant); if f4=nil then exit; //min+i max
     f5:=Pcorps(f4^.suivant); if f5=nil then exit; // nom de variable
     aux1:=MakeString(f5); if aux1='' then exit; //nom de variable
     f6:=PCorps(f5^.suivant); //aide
     if f6=nil then aide:='' else aide:=String(MakeString(f6));
     res:=f1^.evalNum; if res=nil then exit; if res^.y<>0 then begin listes2.Kill(Pcellule(res)); exit end; //Id
     AnId:=Round(res^.x); listes2.Kill(Pcellule(res));
     res:=f2^.evalNum; if res=nil then begin exit end; //affixe
     posX:=Round(res^.x); posY:=Round(res^.Y); listes2.Kill(Pcellule(res));
     res:=f3^.evalNum; if res=nil then begin listes2.Kill(Pcellule(res));exit end;//taille
     Along:=Round(res^.X); Aheight:=Round(res^.Y); listes2.Kill(Pcellule(res));
     res:=f4^.evalNum; if res=nil then begin exit end;//min+i*max
     Amin:=round(res^.X); Amax:=round(res^.Y); listes2.Kill(Pcellule(res));
     if Amin>=Amax then exit;

     trackbar:=PMyTrackBar(ListeTrackbar^.tete);
     while (trackbar<>nil) and (trackbar^.trackbar.caption<>aux1) do trackbar:=PMyTrackBar(trackbar.suivant);
     if (trackbar=nil) or (trackbar^.statut=0)
        then
            begin
                 if Trackbar<>nil then
                    with trackbar^ do
                    begin
                         AfficheMessage(TgSliderExists);
                         //ListeTrackbar^.supprimer(Pcellule(Trackbar));
                         //mise à jour
                         TrackBar.min:=Amin; TrackBar.max:=Amax;
                         TrackBar.position:=Amin;
                         TrackBar.Left:=PosX;
                         TrackBar.Top:=PosY;
                         TrackBar.Width:=Along;
                         TrackBar.Height:=Aheight;
                         TrackBar.Hint:=aide;
                    end
                 else
                 ListeTrackbar^.ajouter_fin(New(PMyTrackbar,
                            init(MainForm.Panel1,AnId,aux1,posX,posY,Along,Aheight,AMin,Amax,aide)));
            end;
     end;
{=======================}
function TDelTrackbar.executer;
var f1:PCorps;
    Anom:string;
    Trackbar:PMyTrackbar;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then  ListeTrackbar^.detruire
                else
        begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     Anom:=MakeString(f1);
                     Trackbar:=PMyTrackbar(ListeTrackbar^.tete);
                     while (Trackbar<>nil) and (Trackbar^.Trackbar.caption<>Anom) do
                           Trackbar:=PMyTrackbar(Trackbar.suivant);
                     if (Trackbar<>nil) then ListeTrackbar^.supprimer(Pcellule(Trackbar));
                     f1:=Pcorps(f1^.suivant);
                end;
        end;
end;
{======================}
function TNewText.executer;      //posX+i*posY,text
var f1,f2:PCorps;
    Atext:string;
    res1:Paffixe;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     Atext:=MakeString(f2);

     res1:=f1^.evalNum;
     if res1=nil then exit;

     ListeLabels^.ajouter_fin(New(PMyLabel,
                            init(MainForm.Panel1,Atext, Round(res1^.x),Round(res1^.y) )));
     listes2.Kill(Pcellule(res1));
     end;
{=======================}
{commande DelText}
function TDelText.executer;
var f1:PCorps;
    Anom:string;
    mylabel:PMyLabel;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then  ListeLabels^.detruire
                else
        begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     Anom:=MakeString(f1);
                     mylabel:=PMyLabel(ListeLabels^.tete);
                     while (mylabel<>nil) and (mylabel^.Alabel.caption<>Anom)
                           do mylabel:=PMyLabel(mylabel.suivant);
                     if (mylabel<>nil) then ListeLabels^.supprimer(Pcellule(mylabel));
                     f1:=Pcorps(f1^.suivant);
                end;
        end;
end;
{=======================}
{commande Tredraw}
function Tredraw.executer;
var f1:Pcorps;
    aux:Pelement;
    Anom:string;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then MainForm.dessiner
                else
       begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom
                                                    else Anom:=MakeString(f1);
                             aux:=Pelement(liste_element.tete);
                             while (aux<>nil) and (aux^.nom<>Anom)
                                   do aux:=Pelement(aux^.suivant);
                             if aux<>nil then
                                begin
                                     aux^.show();
                                end;
                     f1:=Pcorps(f1^.suivant);
                end;
          MainForm.PaintBox1.invalidate
     end;
end;
{=====================}
{commande Tinput }
function Tinput.executer;
var f1,f3,f4:PCorps;
    f2,g:Pexpression;
    chaine,aux,titre: string;
    mac:Pmacros;
    res:Paffixe;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if MainForm.sourisDown then
        begin
                ReleaseCapture;
                Mainform.sourisDown:=false;
        end;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     aux:=MakeString(f1);
     if aux='' then exit;
     f3:=Pcorps(f1^.suivant);
     if f3=nil then begin Titre:=''; f4:=nil end
               else begin Titre:=MakeString(f3); f4:=Pcorps(f3^.suivant);end;
     if f4=nil then chaine:=''
               else begin chaine:=MakeString(f4); end;
     res:=new(Paffixe,init(0,0));
     GetAttributs;
     if not MainForm.MyInputQuery(Titre,aux,chaine) then begin executer:=res; exit;end;
     chaine:=StringReplace(chaine,'"','""',[rfreplaceAll]);
     chaine:='"'+chaine+'"';
     new(f2,init);
     if f2^.definir(chaine) then begin
                                       mac:=macros('chaine');
                                       if mac<>nil then
                                       begin
                                       g:=mac^.contenu;
                                       mac^.contenu:=f2;
                                       dispose(g,detruire);
                                       res^.x:=1;
                                       end else dispose(f2,detruire);
                                  end else dispose(f2,detruire);

     executer:=res;
end;
{$ENDIF}
{=================================================}
function TOriginalCoord.executer(arg:PListe):Presult;
var f1:Pcorps;
    T:Paffixe;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then
        begin
             executer:=New(Paffixe,init(byte(OriginalCoord),0));
             exit;
        end;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     T:=f1^.evalNum;
     if T=nil then exit;
     OriginalCoord:= Round(abs(T^.x)) mod 2 =1;
     Kill(PCellule(T));
{$IFDEF GUI}
     MainForm.ChangerRepere.checked:=not(OriginalCoord);
     Filechanged:=true;
     MainForm.AfficherModifie
{$ENDIF}
end;
{===============================}
{Tgrayscale}
function Tgrayscale.executer(arg:PListe):Presult;
var f1:Pcorps;
    T:Paffixe;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then
     begin
     executer:=New(Paffixe,init( byte(not(gestion_couleur)), 0));
     exit;
     end;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     T:=f1^.evalNum;
     if T=nil then exit;
     gestion_couleur:=(T^.x=0);
     Kill(PCellule(T));
{$IFDEF GUI}
     MainForm.opcouleurs.checked:=gestion_couleur;
     Filechanged:=true;
     MainForm.AfficherModifie;
     MainForm.dessiner;
{$ENDIF}
end;
{======================}
{commande Trecalc}
function Trecalc.executer;
var f1:Pcorps;
    Anom:string;
    aux:Pelement;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then
        begin //recalculer tout (var glob + macros + éléments graphiques)
              {$ifdef GUI}
              MainForm.recalculer(true);
              {$else}
              recalculer(true);
              {$endif}
        end
     else
     begin //liste d'éléments à recalculer
          Anom:='';
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom
                                                    else Anom:=MakeString(f1);
                             aux:=Pelement(liste_element.tete);
                             while (aux<>nil) and (aux^.nom<>Anom)
                                   do aux:=Pelement(aux^.suivant);
                             if aux<>nil then
                                begin
                                     aux^.Recalculer;
                                end;
                     f1:=Pcorps(f1^.suivant);
                end;
     {$IFDEF GUI}
          MainForm.dessiner
     {$ENDIF}
     end;
end;
{======================}
{commande TDel}
function TDelete.executer; {detruire un ou plusieurs objets graphiques}
var f1:Pcorps;
    aux:Pelement;
    Anom:string;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then  vider_liste
                else
     begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom
                                                    else Anom:=MakeString(f1);
                             aux:=Pelement(liste_element.tete);
                             while (aux<>nil) and (aux^.nom<>Anom)
                                   do aux:=Pelement(aux^.suivant);
                             if aux<>nil then
                                begin
                                     liste_element.supprimer(Pcellule(aux))
                                end;
                     f1:=Pcorps(f1^.suivant);
                end;
     end;
{$IFDEF GUI}
     ChangeGraph:=true;
     filechanged:=true;
     MainForm.dessiner
{$ENDIF}
end;
{=====================}
{commande TDefVar }
function TDefVar.executer;
var f1,f2:Pcorps;
    Anom:Tnom;
    chaine:string;
    p:PVarGlob;
    f:Pexpression;
    res:Presult;
    q:Pconstante;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;

     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     if (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.affixe=nil)
        then Anom:=Pconstante(f1^.contenu)^.nom
        else Anom:=MakeString(f1);
     if Anom='' then exit;
     if not VariableValide(Anom,true) then exit;
     q:=constante(Anom);
     if (q<>nil) and (q^.predefinie) then exit;
     p:=PVarGlob(VariablesGlobales^.tete);
     while (p<>nil) and (Anom<>p^.variable^.nom)
           do p:=PvarGlob(p^.suivant);
     chaine:=MakeString(f2); //deuxième argument
     if p<>nil
        then
            begin

                 p^.variable^.nom:=Anom;
                 p^.commande:=chaine;
                 Kill(Pcellule(p^.variable^.affixe));
                 new(f,init);
                 if f^.definir(chaine)
                    then
                        begin
                             res:=f^.evaluer;
                             p^.variable^.affixe:=res;
                        end;
                 dispose(f,detruire);
            end
            else if q=nil then VariablesGlobales^.ajouter_fin(new(PVarGlob,init(Anom,chaine)));
{$IFDEF GUI}
     ChangeVarG:=true;
     filechanged:=true;
{$ENDIF}
end;
{======================}
{TDelVar}
function TDelVar.executer(arg:PListe):Presult;
// DelVar( nom1, nom2, ...): détruit les variables globales non prédéfinies
var f1:Pcorps;
    aux:PVarGlob;
    Anom:string;
begin
     executer:=nil;
     if arg=nil then  exit
                else
     begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     if (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.affixe=nil)
                        then Anom:=Pconstante(f1^.contenu)^.nom
                        else Anom:=MakeString(f1);
                     //if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom  else Anom:=MakeString(f1);
                     aux:=PVarGlob(VariablesGlobales.tete);
                     while (aux<>nil) and (aux^.variable^.nom<>Anom)
                           do aux:=PVarGlob(aux^.suivant);
                           if aux<>nil then
                                begin
                                     if aux^.statut<>predefmac then VariablesGlobales.supprimer(Pcellule(aux))
                                end;
                     f1:=Pcorps(f1^.suivant);
                end;
     end;
{$IFDEF GUI}
     ChangeVarG:=true;
     filechanged:=true;
{$ENDIF}
end;
{======================}
{TExistsVar}
function TExistsVar.executer(arg:PListe):Presult;
// ExistsVar("nom1"): renvoie 1 si la variable globale existe, 0 sinon
var f1:Pcorps;
    aux:PVarGlob;
    Anom:string;
    ok:boolean;
begin
     executer:=nil; ok:=false;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1<>nil then
        begin
             if (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.affixe=nil)
                 then Anom:=Pconstante(f1^.contenu)^.nom
                 else Anom:=MakeString(f1);
             //if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom else Anom:=MakeString(f1);
             aux:=PVarGlob(VariablesGlobales.tete);
             while (aux<>nil) and (aux^.variable^.nom<>Anom)
                   do aux:=PVarGlob(aux^.suivant);
             ok:=aux<>nil;
        end;
     executer:=new(Paffixe,init(byte(ok),0));
end;
{======================}
{TDefMac}
function TDefMac.executer(arg:PListe):Presult;
// renvoie 0 en cas d'échec, 1 sinon
var f1,f2,f3,par:Pcorps;
    r:Pexpression;
    c:Pmacros;
    Anom:Tnom;
    chaine,aux:string;
    num:integer;
begin
     executer:=nil;
     //if not FoncSpeciales then exit;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);

     if (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.affixe=nil)
        then Anom:=Pconstante(f1^.contenu)^.nom
        else Anom:=MakeString(f1);
     if not NomMacroValide(Anom,true) then exit;
     chaine:=MakeString(f2);

     if length(chaine)>80 then aux:=FormatString(chaine,80)
                          else aux:=chaine;
     new(r,init);
     if r^.definir(chaine)
        then
            begin
            num:=0;
            while f3<>nil do  //paramètres?
            begin
            if (f3^.categorie=cat_constante) or (f3^.categorie=cat_string)  then
               begin
                    inc(num);
                    par:=new(Pcorps,init(cat_parametre,new(Pparametre,init(num))));
                    if  f3^.categorie=cat_constante then
                        r^.corps^.composer(Pconstante(f3^.contenu)^.nom,par)
                    else
                        r^.corps^.composer(Pstring(f3^.contenu)^.chaine,par);
                    dispose(par,detruire);
               end;
            f3:=Pcorps(f3^.suivant)
            end;
            c:=new(Pmacros,init(Anom,r));
            if num=0 then c^.commande:=aux
                     else c^.commande:=r^.corps^.en_chaine;
            ajouter_macros(c);
            executer:=new(Paffixe,init(1,0));
    {$IFDEF GUI}
            ChangeMac:=true;
            filechanged:=true;
    {$ENDIF}
            end
        else begin
             dispose(r,detruire);
             executer:=new(Paffixe,init(0,0));
             end
end;
{======================}
{TDelMac}
function TDelMac.executer(arg:PListe):Presult;
// DelMac( nom1, nom2, ...)
var f1:Pcorps;
    aux:Pmacros;
    Anom:string;
begin
     executer:=nil;
     if arg=nil then exit
                else
     begin
          f1:=Pcorps(arg^.tete);
          while f1<>nil do
                begin
                     if (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.affixe=nil)
                        then Anom:=Pconstante(f1^.contenu)^.nom
                        else Anom:=MakeString(f1);
                     //if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom else Anom:=MakeString(f1);
                     aux:=Pmacros(Trouver2(Anom,LesMacros));
                     if aux<>nil then
                        begin
                             if aux^.statut<>predefmac then LesMacros.supprimer(aux)
                        end;
                     f1:=Pcorps(f1^.suivant);
                end;
     end;
{$IFDEF GUI}
     ChangeMac:=true;
     filechanged:=true;
{$ENDIF}
end;
{======================}
{TExistsMac}
function TExistsMac.executer(arg:PListe):Presult;
// ExistsMac("nom"): renvoie 1 si la macro nom existe, 0 sinon
var f1:Pcorps;
    aux:Pmacros;
    Anom:string;
    ok:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1<>nil then
        begin
             if (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.affixe=nil)
                        then Anom:=Pconstante(f1^.contenu)^.nom
                        else Anom:=MakeString(f1);
             aux:=Pmacros(Trouver2(Anom,LesMacros));
             ok:=aux<>nil;
        end;
     executer:=new(paffixe,init(byte(ok),0))
end;
{======================}
function TRenMac.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    I:longint;
    m: PMacros;
    Anom1,Anom2:Tnom; //ancien et nouveau
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;

     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;

     Anom1:=MakeString(f1);
     if Anom1='' then exit;
     I:=LesMacros.Find(Anom1);
     if I<0 then exit;
     Anom2:=MakeString(f2);
     //if NomMacroValide(Anom2)
     if identifierOk(Anom2) and (macros(Anom2)=Nil) and (commande(Anom2)=Nil) and (fonction(Anom2)=Nil)
        then
            begin
                 m:=Pmacros(LesMacros.List[I]^.data);
                 m^.nom:=Anom2;
                 LesMacros.remove(Anom1);
                 LesMacros.ajouter_fin(m); //mises à jour de la clé
{$IFDEF GUI}
                 ChangeMac:=true;
                 filechanged:=true;
{$ENDIF}
            end;
end;
{======================}
function TRenCommand.executer(arg:PListe):Presult;
var f1,f2:Pcorps;
    I:longint;
    c: PCommande;
    Anom1,Anom2:Tnom; //ancien et nouveau
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;

     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;

     Anom1:=MakeString(f1);
     if Anom1='' then exit;
     I:=LesCommandes.Find(Anom1);
     if I<0 then exit;
     Anom2:=MakeString(f2);
     if identifierOk(Anom2) and (macros(Anom2)=Nil) and (commande(Anom2)=Nil) and (fonction(Anom2)=Nil)
        then
            begin
                 c:= PCommande(LesCommandes.List[I]^.data);
                 c^.nom:=Anom2;
                 LesCommandes.remove(Anom1);
                 LesCommandes.ajouter_fin(c);
{$IFDEF GUI}
                 filechanged:=true;
{$ENDIF}
            end;
end;
{================= TrouverFile ================================}
function TrouverFichier(const nom:string; const dossier: string): string;
//TrouverFichier( nom du fichier sans chemin, chemin terminé par sep) renvoie le nom complet ou une chaine vide
//recherche récursive dans les sous-dossiers
Var
  S : TSearchRec;
  stop:boolean;
  rep:string;
begin
  rep:='';
  stop:=FileExists(dossier+nom);
  if stop then rep:=dossier+nom
  else
    while not stop do
    begin
       stop:= (FindFirst(dossier+'*',faDirectory,S)<>0);
       while not stop do                          { Tant qu'il n'y a pas d'erreurs... }
             begin
                  If ((S.Attr and faDirectory) = faDirectory)
                     and (S.Name<>'.') and ( S.Name<>'..') then
                     rep:= TrouverFichier(nom,dossier+S.Name+sep);
                  stop:=(rep<>'') or (FindNext(S)<>0);            { Recherche de la prochaine occurence }
             end;
       FindClose(S);                   { Clôture la recherche }
    end;
  result:=rep
end;
{=================TInputMac================================}
function TinputMac.executer;
var f1:PCorps;
    titre,ext,LeNom:string;
    source:text;
    aux:TFileName;
    changeStat:boolean;
    oldStat:byte;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
   while (f1<>nil) do
   begin
     aux:=MakeString(f1); titre:=''; ext:='';
     if aux<>'' then begin titre:=ExtractFileName(aux); ext:=ExtractFileExt(aux); end;
     if  (titre<>'') and (ListeFicMac.IndexOf(titre)=-1)
     then
     begin
       if  not FileExists(aux) then
       begin
       LeNom:=TrouverFichier(aux,UserMacPath);
       if LeNom<>'' then aux:= LeNom
          else
       {$IFDEF GUI}
            if (not FileExists(MacPath+aux))
            then
               if AfficheError
               then
                if  MainForm.GetOpenFile(TgFindFile+' '+aux,TgMacFile,'*.mac',aux)
                 then
                     begin
                          If (not FileExists(aux)) then
                             AfficheMessage(aux+': '+TgFileNotFound)
                          else begin titre:=ExtractFileName(aux); ext:=ExtractFileExt(aux);
                                     if  (titre='') or (ListeFicMac.IndexOf(titre)<>-1) then exit;
                               end;
                     end
                 else exit
                else begin  AnalyseError:=true; ErrorMessage:=aux+': '+TgFileNotFound end
            else aux:=MacPath+aux;
	{$ELSE}
		//if not FileExists(aux) then
        	begin
             	  aux:=MacPath+aux;
             	  if not FileExists(aux) then
              	   begin
                	WriteLog(aux+': '+TgFileNotFound);
                	exit;
              	   end;
                end;
        {$ENDIF}
     end;
     oldstat:=MacroStatut;
     if (ext='.mod') and (MacroStatut<>predefMac) then MacroStatut:=usermac;//utilisateur
     if (ext='.mac') and (MacroStatut<>predefMac) then MacroStatut:=tempmac;//temporaire
{$IFDEF GUI}
     if not lireFichier(aux)
                     then  AfficheMessage(TgDataError+aux);
     MainForm.opbordure.checked:=cadre;
     MainForm.opCouleurs.checked:= gestion_couleur;
{$ELSE}
     if not LireFichier(aux)
                     then  begin
                             writeLog('Stop: '+ErrorMessage);
                             writeLog(aux+': '+TgStopReading)
                            end;
{$ENDIF}
    if (MacroStatut=tempMac) then ListeFicMac.Add(Titre);
    MacroStatut:=oldstat;
    end;
    f1:=pcorps(f1^.suivant)
  end;
end;
{======================}
function TExec.executer; //Exec(<commande>, <arguments>, <répertoire>,<Waitfor>,<console>)
var f1:PCorps;
    oldDir,commande,arguments,repertoire:string;
    res:Presult;
    aux:Paffixe;
    mode,console:integer;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     commande:=MakeString(f1);
     if commande='' then exit;
     arguments:='';repertoire:='';mode:=0;console:=0;
     f1:=Pcorps(f1^.suivant);
     if f1=nil then
               else
                begin
                        arguments:=MakeString(f1);
                        f1:=Pcorps(f1^.suivant);
                        if f1=nil then
                                  else
                                    begin
                                        repertoire:=MakeString(f1);
                                        f1:=Pcorps(f1^.suivant);
                                        if f1=nil then
                                                else begin
                                                        aux:=f1^.evalNum;
                                                        if aux<>nil then; mode:=Round(aux^.x) mod 2;
                                                        listes2.Kill(Pcellule(aux));
                                                        f1:=Pcorps(f1^.suivant);
                                                        if f1=nil then
                                                           else begin
                                                                aux:=f1^.evalNum;
                                                                if aux<>nil then; console:=Round(aux^.x) mod 2;
                                                                listes2.Kill(Pcellule(aux))
                                                                end
                                                     end
                                    end
                end;
      if repertoire<>'' then
        begin
                GetDir(0,oldDir);
                if not DirectoryExists(repertoire) then 
                   AfficheMessage(repertoire+': '+TgRepositoryNotFound)
                                                   else ChDir(repertoire);
        end;
     SystemExec(commande+' '+arguments,(mode=1), (console=1));
     if repertoire<>'' then ChDir(oldDir);
end;
{======================}
function TExport.executer; // Export(mode, nom de fichier)
var f1,f2:PCorps;
    mode:Paffixe;
    fichier:string;
    f:textfile;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     mode:=f1^.evalNum;
     if mode=nil then exit;
     fichier := MakeString(f2);
     Assignfile(f,fichier);
     {$I-} rewrite(f); closefile(f);{$I+}
     if IOresult<>0 then
                AfficheMessage(TgCannotCreateFile)
        else 
		begin   DeleteFile(fichier);
			ExportName:=fichier;
			GraphExport(Round(mode^.x));
		end;
end;
{======================}
function TMessag.executer;
// Message(arg1, ar2, ...) : affiche les arguments dans une fenêtre ou dans le fichier log
var f1:PCorps;
    aux, aux2: string;
    T: Presult;
begin
     executer:=nil;
     aux := '';
     f1:=Pcorps(arg^.tete);
     while f1 <> Nil do
           begin
                T := f1.evaluer; aux2 := '';
                if T<>Nil then
                   begin
                        if (T^.cat=1) and (T^.suivant=Nil) // c'est une chaine
                           then aux2 := T^.getchaine
                           else aux2 := T^.en_chaine;   // liste
                        Kill(Pcellule(T))
                   end;
                aux += aux2;
                f1 := Pcorps(f1^.suivant)
           end;
{$IFDEF GUI}
     AfficheMessage(aux)
{$ELSE}
     WriteLog(FormatString(aux,70))
{$ENDIF}
end;
{=======================}
function TShow.executer(arg:PListe):Presult; //le graphique n'est pas redessiné
var f1,f2:Pcorps;
    aux:Pelement;
    Anom:string;
    sauf: boolean;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then //tout montrer
        begin
             aux:=Pelement(liste_element.tete);
             while (aux<>nil) do begin aux^.visible:=true; aux:=Pelement(aux^.suivant) end;
        end
     else
     begin;
           f1:=Pcorps(arg^.tete);
           sauf:= (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.nom='except');
           if sauf then f1:=Pcorps(f1^.suivant);
           aux:=Pelement(liste_element.tete);
           while aux<>Nil do
                 begin
                      f2:=f1;
                      if sauf then aux^.visible:=true;
                      while f2<>nil do
                            begin
                                 if f1^.categorie=cat_constante then Anom:=Pconstante(f2^.contenu)^.nom
                                                     else Anom:=MakeString(f2);

                                 if aux^.nom=Anom then
                                    if sauf then aux^.visible:=false
                                            else aux^.visible:=true;
                                 f2:=Pcorps(f2^.suivant)
                            end;
                     aux:=Pelement(aux^.suivant)
                end;
     end;
     {$IFDEF GUI}
     ChangeGraph:=true;
     filechanged:=true;
     MainForm.MiseAJour;
     {$ENDIF}
end;
{=======================}
function THide.executer(arg:PListe):Presult; //le graphique n'est pas redessiné
var f1,f2:Pcorps;
    aux:Pelement;
    Anom:string;
    sauf: boolean;
begin
     executer:=nil;
     if contexteUtilisateur then exit;
     if arg=nil then //tout cacher
        begin
             aux:=Pelement(liste_element.tete);
             while (aux<>nil) do begin aux^.visible:=false; aux:=Pelement(aux^.suivant) end;
        end
     else
     begin;
           f1:=Pcorps(arg^.tete);
           sauf:= (f1^.categorie=cat_constante) and (Pconstante(f1^.contenu)^.nom='except');
           if sauf then f1:=Pcorps(f1^.suivant);
           aux:=Pelement(liste_element.tete);
           while aux<>Nil do
                 begin
                      f2:=f1;
                      if sauf then aux^.visible:=false;
                      while f2<>nil do
                            begin
                                 if f1^.categorie=cat_constante then Anom:=Pconstante(f2^.contenu)^.nom
                                                     else Anom:=MakeString(f2);

                                 if aux^.nom=Anom then
                                    if sauf then aux^.visible:=true
                                            else aux^.visible:=false;
                                 f2:=Pcorps(f2^.suivant)
                            end;
                      aux:=Pelement(aux^.suivant)
                end;
     end;
     {$IFDEF GUI}
     ChangeGraph:=true;
     filechanged:=true;
     MainForm.MiseAJour;
    {$ENDIF}
end;
{==================================}
function TReadData.executer;
var f1,f2,f3:Pcorps;
    source:text;
    resultat:type_liste;
    x,y,z:real;
    erreur:integer;
    balise,chaine,fichier,errorString:string;// balise = balise de fin de liste
    car:char;
    nb, type_lecture:byte; //type_lecture=0 1 2 ou 3 (0=text)
    signaleError,YaBalise, wasjump:boolean;
    aux:Paffixe;
    {==================================}
    procedure lireNombre;
    var fin:boolean;
    begin
          fin:=false;
          While (not fin) and (car in ['0'..'9','.','E','e','+','-','\']) do
                begin
                     if not (car in ['\']) then chaine:=chaine+car;
                     fin:=eof(source);
                     if not fin then read(source,car);
                end;
          If (chaine<>'') then
                   begin
                        If nb=1 then
                           begin
                                val(chaine,x,erreur);
                                if erreur<>0  then begin errorString:=chaine+': '+TgNumericError; signaleError:=true; {erreur sur x?} end;
                                if (type_lecture=1) or (type_lecture=4) then begin
                                                            resultat.ajouter_fin(new(Paffixe,init(x,0)));
                                                            wasjump:=false
                                                        end
                                                   else  nb:=2;
                           end
                                else
                        If nb=2 then
                           begin
                                if erreur=0 then
                                     begin
                                          val(chaine,y,erreur);
                                          if erreur<>0  then begin errorString:=chaine+': '+TgNumericError; signaleError:=true {erreur sur y?} end
                                                        else if type_lecture=2 then
                                                             begin
                                                                  resultat.ajouter_fin(new(Paffixe,init(x,y)));
                                                                  wasjump:=false
                                                             end;
                                     end;
                                if type_lecture=2 then  nb:=1 else nb:=3;
                           end
                                     else
                           begin
                                if erreur=0 then
                                     begin
                                          val(chaine,z,erreur);
                                          if erreur<>0  then begin errorString:=chaine+': '+TgNumericError; signaleError:=true {erreur sur z?} end
                                                        else begin
                                                                  resultat.ajouter_fin(new(Paffixe,init(x,y)));
                                                                  resultat.ajouter_fin(new(Paffixe,init(z,0)));
                                                                  wasjump:=false
                                                             end;
                                     end;
                                nb:=1;
                           end;
                        chaine:='';
                   end;
    end;
    {==================================}
    procedure lirechaine;
    var fin, okchaine: boolean;
    begin
         okchaine:=false; fin:=eof(source);
         while not fin do
               begin
                    read(source,car); fin:=eof(source);
                    if car='"' then
                       begin
                            if not fin then
                               begin
                                  read(source,car);
                                  if car<>'"' then begin fin:=true; okchaine:=true end
                                              else begin fin:=false; chaine:=chaine+car end
                               end
                       end
                    else chaine:=chaine+car;
               end;
             if not okchaine then
                begin signaleError:=true; errorString:=chaine+': '+TgEndStringMissing end
             else begin wasjump:=false; resultat.ajouter_fin(new(Pchaine,init(chaine))) end;
             chaine:='';  nb:=1;
    end;
    {==================================}
    procedure lirecommentaire;
    var fin:boolean;
    begin
         while not( eof(source) or (car in [#10,#13])) do read(source,car);
         if not eof(source) then read(source,car);
         chaine:=''
    end;
    {==================================}
    procedure lireTexte;
    begin
           while not eof(source) do
           begin
                read(source,car);
                if YaBalise And ( (car=balise) or ((balise='LF') and (car in [#10,#13]) ) ) then
                   begin
                        if chaine<>'' then resultat.ajouter_fin(new(Pchaine,init(chaine)));
                        chaine:='' //on commence une nouvelle chaine
                   end
                   else chaine:=chaine+car;
           end;
           if chaine<>'' then resultat.ajouter_fin(new(Pchaine,init(chaine)));
    end;

    {==================================}
    procedure lireCsv;
    var isempty:boolean;
        procedure chercheSep;
        begin
           if not eof(source) then
               while (car<>balise) and not(car in [#10,#13]) and not eof(source)
               do read(source,car);
           if car=balise then begin isempty:=true; read(source,car) end else isempty:=false;
        end;
    begin
           if not YaBalise then balise:=','; chaine:=''; isempty:=true;
           read(source,car);
           while not eof(source) do
           begin
                if (car=balise) and isempty then
                   begin
                        resultat.ajouter_fin(new(Pchaine,init(ND^.chaine))); wasjump:=false;
                        read(source,car);
                   end
                else
                if car='"' then
                   begin
                        chaine:=''; lirechaine;chercheSep
                   end
                else
                if car in ['0'..'9','.','+','-','\'] then
                       begin
                            chaine:='';lireNombre;chercheSep
                       end
                else
                if (car in [#10,#13]) then
                   begin
                        if isempty then resultat.ajouter_fin(new(Pchaine,init(ND^.chaine)));
                        if not wasjump then resultat.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)));
                        wasjump:=true; isempty:=true; read(source,car); nb:=1 //on commence une nouvelle liste
                   end
                else read(source,car);
           end;
    end;

begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     fichier:=MakeString(f1);
     if not FileExists(fichier) then
        begin
             AfficheMessage(fichier+': '+TgFileNotFound);
             exit;
        end;
      assign(source,fichier);
         {$I-}
      system.reset(source);
         {$I+}
     if eof(source) then begin close(source);exit;end;
     f2:=Pcorps(f1^.suivant);
     type_lecture:=2;
     if f2<>Nil then
        begin
             aux:=f2^.evalNum;
             if aux<>Nil then type_lecture:=abs(Round(aux^.x));
             if not type_lecture in [0,1,2,3,4] then type_lecture:=2;
             f3:=Pcorps(f2^.suivant);
        end
     else f3:=Nil;
     YaBalise:=false;
     if f3<>nil then
        begin
             chaine:=MakeString(f3);
             balise:=chaine;
             YaBalise:=(balise<>'');
        end;
     car:=' ';
     chaine:='';nb:=1;resultat.init;signaleError:=false; wasjump:=false;
     if type_lecture=0 then lireTexte
     else
     if type_lecture=4 {Csv} then lireCsv
     else
     while not eof(source) do
           begin
                if car='#' then lirecommentaire
                           else
                if YaBalise And ( (car=balise) or ((balise='LF') and (car in [#10,#13]) ) ) then
                   begin
                        if not wasjump then resultat.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)));
                        wasjump:=true; read(source,car); nb:=1 //on commence une nouvelle liste
                   end
                           else
                if car='"' then begin chaine:=''; lirechaine end
                           else
                if car in ['0'..'9','.','+','-','\'] then lireNombre
                           else read(source,car);
           end;
     close(source);
     if signaleError then
     AfficheMessage(fichier+': '+TgErrorWhileReading+' ('+errorString+')');
     executer:=Paffixe(resultat.tete);
end;
{==================================}
function TReadFlatPs.executer;
var f1:Pcorps;
    source:text;
    resultat:type_liste;
    nb:byte;
    x,y:real;
    erreur:integer;
    fichier:string;
    couleur:longint;
    epaisseur,x1,x2,y1,y2: real;
    car:char;

    function cmyk2rgb(c,m,y,k:real):longint;
    var r,g,b:real;
    begin
         r:=1-c-k; if r<0 then r:=0;
         g:=1-m-k; if g<0 then g:=0;
         b:=1-y-k; if b<0 then b:=0;
         result:=Rgb(Round(r*255),Round(g*255),Round(b*255))
    end;

    function Trouve_newpath:boolean;
    var s:string; i,p:longint;
        c:string; c1,c2,c3,c4:real;
    begin
          repeat readln(source,s); c:='';
                 p:=pos('setlinewidth',s);
                 if p<>0 then begin
                    delete(s,p-1,13);delete(s,1,1);
                    val(s,epaisseur,erreur);
                    end;
                 p:=pos('setcmykcolor',s);
                 if p<>0 then begin
                                i:=1;
                                while s[i]=' ' do inc(i);
                                while (s[i] in ['0'..'9','.']) do begin c:=c+s[i]; inc(i) end;
                                val(c,c1,erreur); while s[i]=' ' do inc(i); c:='';
                                while (s[i] in ['0'..'9','.']) do begin c:=c+s[i]; inc(i) end;
                                val(c,c2,erreur); while s[i]=' ' do inc(i); c:='';
                                while (s[i] in ['0'..'9','.']) do begin c:=c+s[i]; inc(i) end;
                                val(c,c3,erreur); while s[i]=' ' do inc(i); c:='';
                                while (s[i] in ['0'..'9','.']) do begin c:=c+s[i]; inc(i) end;
                                val(c,c4,erreur);
                                couleur:=cmyk2rgb(c1,c2,c3,c4);
                                end;
                 result:= (s='newpath')
          until  eof(source) or (result);
    end;

    function lire_mot:string;
    var s:string;
        c:char;
    begin
         s:='';
         repeat read(source,c) until c in ['0'..'9','a'..'z','.'];
         while c in ['0'..'9','a'..'z','.'] do begin s:=s+c; read(source,c) end;
         result:=s
    end;

    procedure lire_path;
    var c:string;
        xfirst,yfirst:real;
    begin resultat.ajouter_fin(new(Paffixe,init(couleur,epaisseur)));
          repeat
              c:=lire_mot;
              if c[1] in ['0'..'9','.'] then
                 If nb=1 then
                           begin
                                val(c,x,erreur);
                                if x<x1 then x1:=x; if x>x2 then x2:=x;
                                nb:=2;
                           end
                                else
                           begin
                                if erreur=0 then
                                     begin
                                          val(c,y,erreur);
                                          if y<y1 then y1:=y; if y>y2 then y2:=y;
                                          resultat.ajouter_fin(new(Paffixe,init(x,y)));
                                     end;
                                nb:=1;
                           end
                 else
                 if c='curveto' then resultat.ajouter_fin(new(Paffixe,init(jump^.x,3))) {bezier}
                 else
                 if c='lineto' then resultat.ajouter_fin(new(Paffixe,init(jump^.x,1))) {line}
                 else
                 if c='moveto' then begin xfirst:=x; yfirst:=y;
                                          resultat.ajouter_fin(new(Paffixe,init(jump^.x,6))) {move};
                                    end
                 else
                 if c='closepath' then begin
                                       //resultat.ajouter_fin(new(Paffixe,init(xfirst,yfirst)));
                                       resultat.ajouter_fin(new(Paffixe,init(jump^.x,10))) {closepath}
                                       end;
          until (c='eofill') or (c='stroke') or (c='fill') or (c='clip');
          if c='eofill' then
          resultat.ajouter_fin(new(Paffixe,init(jump^.x,-1)))   //-1=eofill,
          else if c='fill' then
          resultat.ajouter_fin(new(Paffixe,init(jump^.x,-2)))   //-2=fill
          else if c='stroke' then
          resultat.ajouter_fin(new(Paffixe,init(jump^.x,-3)))   //-3=stroke
          else
          resultat.ajouter_fin(new(Paffixe,init(jump^.x,-4)));   //-4=clip
      end;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     fichier:=MakeString(f1);
     if not FileExists(fichier) then
        begin
             AfficheMessage(fichier+': '+TgFileNotFound);
             exit;
        end;
      assign(source,fichier);
         {$I-}
      system.reset(source);
         {$I+}
     if eof(source) then begin close(source);exit;end;

     nb:=1;resultat.init; x1:=1000; x2:=0; y1:=1000; y2:=0;
     while trouve_newpath do  lire_path;
     close(source);
     resultat.ajouter_debut(new(Paffixe,init(x2,y2)));
     resultat.ajouter_debut(new(Paffixe,init(x1,y1)));
     executer:=Paffixe(resultat.tete);
end;
{=======================}
function TTeX2FlatPs.executer;
var f1,f2:Pcorps;
    source:text;
    dollar:boolean;
    res:Paffixe;
    formule:string;
    F:Pexpression;
    labelsize:longint;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=PCorps(f1^.suivant);
     dollar:=false;
     if f2<>Nil then
        begin
             res:=f2^.evalNum;
             if res<>Nil then dollar:=(res^.x=1);
             Kill(Pcellule(res))
        end;
     formule:=MakeString(f1); if formule='' then exit;
     AssignFile(source, tmpPath+'formula.tex'); ReWrite(source);
     if PLabelSize^.affixe<>nil then labelsize:=round(PLabelSize^.affixe^.getX) mod 10 else labelsize:=3;
     case labelsize of
     0: writeln(source,'{\tiny');
     1: writeln(source,'{\scriptsize');
     2: writeln(source,'{\footnotesize');
     3: writeln(source,'{\small');
     5: writeln(source,'{\large');
     6: writeln(source,'{\Large');
     7: writeln(source,'{\LARGE');
     8: writeln(source,'{\huge');
     9: writeln(source,'{\Huge');
     else writeln(source,'{')
     end;
     if dollar then writeln(source,'\['+formule+'\]') else writeln(source,formule);
     writeln(source,'}');
     Closefile(source);
     New(F,init); res:=Nil;
     if F^.definir('[compileFormule(), loadFlatPs([TmpPath,"tex2FlatPs.eps"])]') then res:=F^.evalNum;
     dispose(F,detruire);
     executer:=res
end;
{=======================}
Initialization

{$IFDEF GUI}
     LesCommandes.ajouter_fin(new(PPixel,init('Pixel')));
     LesCommandes.ajouter_fin(new(PGetPixel,init('GetPixel')));//1.96
     // GetPixel( liste de complexes a+ib ) renvoie les couleurs des points d'affixes a+ib (entiers)
     LesCommandes.ajouter_fin(new(PNewBitmap,init('NewBitmap')));
     LesCommandes.ajouter_fin(new(PDelBitmap,init('DelBitmap')));
     LesCommandes.ajouter_fin(new(PMaxPixel,init('MaxPixels')));
     LesCommandes.ajouter_fin(new(PPixel2Scr,init('Pixel2Scr')));
     LesCommandes.ajouter_fin(new(PScr2Pixel,init('Scr2Pixel')));
     LesCommandes.ajouter_fin(new(PListFiles,init('ListFiles'))); //liste des fichiers mac en mémoire
     LesCommandes.ajouter_fin(new(PListWords,init('ListWords'))); //1.96, liste des mots en mémoire
     LesCommandes.ajouter_fin(new(PVisibleGraph,init('VisibleGraph')));
     LesCommandes.ajouter_fin(new(PDelay,init('Delay')));
     LesCommandes.ajouter_fin(new(PTimeronOff,init('Timer')));
     LesCommandes.ajouter_fin(new(PTimerMac,init('TimerMac')));
     LesCommandes.ajouter_fin(new(PInput,init('Input')));
     LesCommandes.ajouter_fin(new(PRedraw,init('ReDraw')));
     LesCommandes.ajouter_fin(new(PNewItem,init('NewItem')));
     LesCommandes.ajouter_fin(new(PDelItem,init('DelItem')));
     LesCommandes.ajouter_fin(new(PNewButton,init('NewButton')));
     //<Id>, <nom>, <affixe>, <taille>, <commande> [, aide] ).
     LesCommandes.ajouter_fin(new(PDelButton,init('DelButton')));
     LesCommandes.ajouter_fin(new(PNewText,init('NewText')));
     LesCommandes.ajouter_fin(new(PDelText,init('DelText')));
     LesCommandes.ajouter_fin(new(PNewTrackBar,init('NewTrackBar')));
     //<Id>, <affixe>, <taille>, <min+i*max>, <pas>, <variable> [, aide] ).
     LesCommandes.ajouter_fin(new(PDelTrackBar,init('DelTrackBar')));
     LesCommandes.ajouter_fin(new(PLoadFond,init('LoadImage')));
     LesCommandes.ajouter_fin(new(PAttributs,init('Attributs')));
     LesCommandes.ajouter_fin(new(PAttributs,init('Attributes')));//english version
     LesCommandes.ajouter_fin(new(PAddMenu2D,init('AddMenu2D'))); //AddMenu2D( nom, "aide")
     LesCommandes.ajouter_fin(new(PAddMenu2D,init('AddMenu3D'))); //AddMenu3D( nom, "aide")
     LesCommandes.ajouter_fin(new(PEditGraph,init('EditGraph'))); //EditGraph(nom, commande): éditer un élément graphique
{$ENDIF}
     LesCommandes.ajouter_fin(new(PShow,init('Show')));
     LesCommandes.ajouter_fin(new(PHide,init('Hide')));
     LesCommandes.ajouter_fin(new(PInputMac,init('InputMac')));
     LesCommandes.ajouter_fin(new(PInputMac,init('Load')));
     LesCommandes.ajouter_fin(new(PRenMac,init('RenMac')));
     //RenMac(oldname, new name) pour renommer une macro
     LesCommandes.ajouter_fin(new(PRenCommand,init('RenCommand')));
     //RenCommand(oldname, new name) pour renommer une commande

     LesCommandes.ajouter_fin(new(PReadData,init('ReadData')));   //lecture de nombres et "chaines", ou de textes
     // ReadData( <fichier> [, type lecture 0/1/2/3/4, séparateur de liste] )
     //le séparateur peut être "LF",
     //type=0 signifie texte depuis 1.962, type=4 signifie Csv depuis 1.971
     LesCommandes.ajouter_fin(new(PTeX2FlatPs,init('TeX2FlatPs'))); //renvoie une formule TeX sous forme de chemins, peut être dessinée avec drawFlatPs()
     // TeX2FlatPs( "formule", dollar(0/1) )    dollar=1 pour ajouter \[ et \] autour de la formule
     LesCommandes.ajouter_fin(new(PReadFlatPs,init('ReadFlatPs'))); //flattened ps produit par pstoedit
     LesCommandes.ajouter_fin(new(PMessage,init('Message')));
     LesCommandes.ajouter_fin(new(PMessage,init('Print'))); // depuis version 2.0
     LesCommandes.ajouter_fin(new(PDelete,init('DelGraph')));
     LesCommandes.ajouter_fin(new(PDefVar,init('DefVar')));//obsolete
     LesCommandes.ajouter_fin(new(PDelVar,init('DelVar')));
     //DelVar(nom1, nom2, ...) détruit les variables globales créées par l'utilisateur.
     LesCommandes.ajouter_fin(new(PExistsVar,init('IsVar')));
     LesCommandes.ajouter_fin(new(PDefVar,init('NewVar')));
     LesCommandes.ajouter_fin(new(PDefMac,init('DefMac')));//obsolete
     LesCommandes.ajouter_fin(new(PDefMac,init('NewMac')));
     LesCommandes.ajouter_fin(new(PDelMac,init('DelMac')));
     //DelMac(nom1, nom2, ...) détruit les macros créées par l'utilisateur.
     LesCommandes.ajouter_fin(new(PExistsMac,init('IsMac')));
     LesCommandes.ajouter_fin(new(PExec,init('Exec')));
     //Exec( "commande", "arguments", "répertoire", wait (0/1, 0 par défaut), show window (0/1, pour windows)) 1.96
     LesCommandes.ajouter_fin(new(PExport,init('Export')));
     LesCommandes.ajouter_fin(new(POriginalCoord,init('OriginalCoord')));
     //OriginalCoord(0/1) ou OriginalCoord() qui renvoie alors 0 ou 1
     LesCommandes.ajouter_fin(new(PGrayscale,init('GrayScale')));
     //GrayScale(0/1) ou GrayScale() qui renvoie alors 0 ou 1
     LesCommandes.ajouter_fin(new(PRecalc,init('ReCalc')));
end.
