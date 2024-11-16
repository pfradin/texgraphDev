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

unit command10;//commandes communes au deux modes

{$MODE Delphi}

interface
Uses 
Sysutils,
{$IFDEF GUI}
Dialogs, controls, Graphics,BGRAbitmaptypes,BGRABitmap,
{$ELSE}
UnitLog,
{$ENDIF}
classes, listes2, complex3, analyse4,command5,command53d,graph1_6,graph2_7,untres;

const
	{$IFDEF WINDOWS}
	sep='\';
	{$ENDIF}
	{$IFDEF UNIX}
	sep='/';
	{$ENDIF}
        AfficheError:boolean=true;

procedure Export2PrettyLaTeX(Const chaine:string); //exporte le source TeXgraph écrit en TeX
//{$IFDEF GUI}
procedure Export2PrettyHtml(Const chaine:string); //exporte le source TeXgraph écrit en Html
//{$ENDIF}
procedure GraphExport(mode: integer); //exporte le graphique dans le fichier ExportName

procedure recalculer(tous:boolean);

function LireFichier(Const fichier: string):boolean;//lecture d'un fichier source
procedure NewReadFile(Const fichier: string);{lire un fichier source}

procedure initialisation;//au chargement du programme
procedure finalisation; //au changement de fichier
var
{$IFDEF GUI}
         mac2d, mac3d:Tstrings;
         TimerMac: Pexpression;
         drawBitmap: TBGRAbitmap; // image de fond s'il y en a une
         YaDrawBitmap: boolean;  // indique s'il y a une image de fond
{$ENDIF}
        KeyWordList: TStringList;

Implementation
{============== export source vers LaTeX ===============}
function IsKeyword(const AKeyword: string): boolean;
begin
  result:=(KeyWordList.Indexof(AKeyword)<>-1) or (fonction(AKeyword)<>nil) or (commande(AKeyword)<>nil)
end; { IsKeyWord }
{==============}
function IsConstant(const AConstant: string): boolean;
var C:Pconstante;
begin
     C:=Constante(AConstant);
     result:= (C<>nil) and (C^.Predefinie)
end; { IsConstant }
{==============}
function IsMacPredef(const AConstant: string): boolean;
var mac:Pmacros;
begin
  mac:=macros(AConstant);
  result:= ((mac<>Nil) and (mac^.statut>0))
end; { IsMacPredef }
{==============}
function IsMacUser(const AConstant: string): boolean;
var mac:Pmacros;
begin
  mac:=macros(AConstant);
  result:= ((mac<>Nil) and (mac^.statut=0))
end; { IsMacUser }
{==============}
function IsVarGlob(const AConstant: string): boolean;
var V:Pvarglob;
begin
  V:=VarGlob(AConstant);
  result:= (VarGlob(AConstant)<>Nil) and (V^.statut=0);
end; { IsVarGlob }
{==============}
function IsVarPredef(const AConstant: string): boolean;
var V:Pvarglob;
    C:Pconstante;
begin
  V:=VarGlob(AConstant);
  C:=Constante(AConstant);
  result:= ((VarGlob(AConstant)<>Nil) and (V^.statut=1))
           or
           ((VarGlob(AConstant)=Nil) and (C<>Nil) and (not C^.predefinie))
end; { IsVarPredef }
{==============}
procedure Export2PrettyLaTeX(Const chaine:string);
const
     clComment : string='TegComment';
     clNumeric : string='TegNumeric';
     clConstant : string='TegConstant';
     clString : string='TegString';
     clSymbol : string='TegSymbol';
     clKeyWord : string='TegKeyWord';
     clVarGlob : string='TegVarGlob';
     clMacUser : string='TegMacUser';
     clVarPredef : string='TegVarPredef';
     clMacPredef : string='TegMacPredef';
     clParam : string='TegParam';
     clIdentifier: string='TegIdentifier';
     clGraphElem: string='TegGraphElem';

var comptParO,comptCrO,comptIf,comptDo,
    comptUntil,k,comptAcc,indice,longueur:longint;{compteurs}
    car:char;
    mot:string;
    reel: real;
    isparam,isstring: boolean;

  procedure writecar;
  begin
       case car of
       '_', '%', '{','}','#','&':  write(ExportFile, '\'+car);
       '$': write(ExportFile, '\$');
       '^': write(ExportFile, '\textasciicircum{}');
       '\': write(ExportFile, '$\backslash$');
       ' ': write(ExportFile,'\ ');
       ',': if isstring then write(ExportFile,',') else write(ExportFile,',');
       '''': write(ExportFile,'\textquotesingle{}');
       #13,#10: writeln(ExportFile,'\par');
       #9:  write(ExportFile, '\hspace{1cm}');
       '*','<','>','=','+','-': write(ExportFile, car);
       //'+','-': if isnum then write(ExportFile, car) else write(ExportFile, '$'+car+'$');
       else write(ExportFile,car)
       end;
  end;

  procedure LireIdentificateur;
  var k:longint;
  begin
     k:=indice;
     while (indice<=longueur) and (chaine[indice] in set_nom) do inc(indice);
     mot:=Copy(chaine,k,indice-k);
     if IsKeyWord(mot) then write(ExportFile, '\textbf{\color{'+clKeyWord+'}')
        else
     if IsConstant(mot) then write(ExportFile, '\textbf{\color{'+clConstant+'}')
        else
     if IsMacPredef(mot) then write(ExportFile, '\textbf{\color{'+clMacPredef+'}')
        else
     if IsMacUser(mot) then write(ExportFile, '{\color{'+clMacUser+'}')
        else
     if IsVarGlob(mot) then write(ExportFile, '{\color{'+clVarGlob+'}')
        else
     if IsVarPredef(mot) then write(ExportFile, '\textbf{\color{'+clVarPredef+'}')
        else
     if IsGraphElem(mot) then write(ExportFile, '\textbf{\color{'+clGraphElem+'}')
        else write(ExportFile, '\textit{\color{'+clIdentifier+'}');
     for car in mot do writecar ;
     write(Exportfile,'}');
  end;

  procedure LireMessage;
  var
   stop,ok:boolean;
   first,firstlg:longint;
   begin
    mot:='';                    {on pointe sur la première case de mot}
    stop:=(Indice>longueur);    {le booléen stop permettra de stopper la lecture}
    ok:=false;                  {le booléen ok permettra de savoir si le message se termine correctement}
    while not stop do
          begin
          car:=chaine[Indice];
          writecar; {on copie le caractère de chaine dans mot}
          if car='"'
             then            {le caractère lu est le délimitateur "}
                  if (Indice<longueur) and (chaine[Indice+1]='"')
                     then   {on teste si le caractère suivant est aussi un "}
                         begin
                              inc(Indice,2); {on a un double "" cela représente le caractère ", on avance de deux
                                                    cases dans chaine et d'une seule dans mot}
                         end
                     else
                         begin
                              inc(Indice);ok:=true;
                               {on a un seul ", c'est la fin du message, on avance d'une case
                                                    dans chaine, mais pas dans mot pour écraser le caractère "
                                                    qui vient d'être lu. Ok prend la valeur true, pas d'erreur}
                         end
             else
                 begin
                      inc(Indice);  {on est toujours dans le message, on avance d'une case}
                 end;
          stop:=ok or (Indice>longueur); {on s'arrête en bout de chaine ou si le message est terminé}
          end;
   end;

   procedure LireReel;
   var aux:string;
       first,Error:longint;
       sortie:extended;
       stop:boolean;
   begin
    aux:='';  {cette chaine standard reçoit les caractères constituant la valeur numérique à lire}
    stop:=false;
    first:=indice;
    if not isparam then write(ExportFile, '{\color{'+clNumeric+'}') else isparam:=false;
    car:=chaine[Indice];
    while (not stop) and (indice<=longueur) and (chaine[indice] in set_num) do
          begin
               if (indice>first) and
                   ((car='-') or (car='+')) and
                   (chaine[indice-1]<>'E')
                  then begin stop:=true; dec(indice) end
                               {si on a un + ou un - et le caractère précédent
                                               n'est pas E, alors on n'est plus dans une
                                               expression numérique}
                  else writecar;
               inc(indice);                    {on passe au suivant}
               car:=chaine[Indice];
          end;
    write(ExportFile,'}')
   end;

begin
     if chaine='' then exit; longueur:=length(chaine); isparam:=false; isstring:=false;
     k:=1; comptParO:=0;comptCrO:=0; comptIf:=0; comptDo:=0;comptUntil:=0;
     AssignFile(ExportFile, ExportName); rewrite(exportFile);
     writeln(ExportFile,'\begin{\TegSrcFontSize}%');
     writeln(ExportFile,'\setlength{\parskip}{0pt}\setlength{\parindent}{0pt}%');
     writeln(ExportFile,'\par');
     while (k<=longueur) do    {tant qu'on n'est pas en fin de chaine}
       begin
         car:=chaine[k];
         case car of
         #9,#10,#13,' ': writecar;
         '%': begin write(ExportFile,'{\color{'+clParam+'}');writecar; isparam:=true end;
         '{' :   begin {début d'un commentaire}
                       comptAcc:=1; inc(k);
                       write(ExportFile,'{\color{'+clComment+'}');writecar;
                       while (comptAcc<>0) and (k<=longueur) do
                                begin
                                        car:=chaine[k];
                                        writecar;
                                        if car='{' then Inc(comptAcc);
                                        if car='}' then Dec(comptAcc);
                                        inc(k);  {on avance dans chaine jusqu'à
                                        la fin du commentaire ou de la chaine}
                                end;
                       write(ExportFile,'}'); dec(k)
                  end;
            '"': begin {debut d'un message}
                      indice:=k+1; writecar; isstring:=true;
                      write(ExportFile,'{\color{'+clString+'} ');
                      LireMessage; isstring:=false; write(ExportFile,'}');
                      k:=indice-1;
                 end;

       ':','=','<','>','[',']','(',')',',','+','-','*','^',';','$','@','\','#': //symboles
                   begin
                        write(ExportFile,'{\color{'+clSymbol+'}');
                        writecar;
                        case car of
                        ':','<','>':if (k<longueur) then
                                begin
                                     car:=chaine[k+1];
                                     if car='=' then begin writecar; Inc(k) end;
                                end;
                        end;
                        write(ExportFile,'}');
                   end;
       '/':  If (k=longueur) or (chaine[k+1]<>'/')  then
             begin
                   write(ExportFile,'{\color{'+clSymbol+'} ');
                   writecar;
                   write(ExportFile,'}');
             end
               else begin
                         write(ExportFile,'{\color{'+clComment+'} ');
                         repeat   //commentaire jusqu'à la fin de la ligne
                         writecar;
                         Inc(k); car:=chaine[k]
                         until car in [#10, #13];
                         write(ExportFile,'}');
                         dec(k)
                         end;

     'a'..'z','A'..'Z': begin
                        indice:=k;
                        LireIdentificateur;
                        k:=indice-1;
                        end;

  '0'..'9','.': begin
                indice:=k;
                LireReel;
                k:=indice-1;
                end;
       end; {fin du case}
       inc(k); {on avance d'une case}
       end;
  write(ExportFile,'\end{\TegSrcFontSize}%');
  CloseFile(ExportFile);
end;
{===================}
//{$IFDEF GUI}
procedure Export2PrettyHtml(Const chaine:string);
const
     clComment : string='TegComment';
     clNumeric : string='TegNumeric';
     clConstant : string='TegConstant';
     clString : string='TegString';
     clSymbol : string='TegSymbol';
     clKeyWord : string='TegKeyWord';
     clVarGlob : string='TegVarGlob';
     clMacUser : string='TegMacUser';
     clVarPredef : string='TegVarPredef';
     clMacPredef : string='TegMacPredef';
     clParam : string='TegParam';
     clIdentifier: string='TegIdentifier';
     clGraphElem: string='TegGraphElem';

var comptParO,comptCrO,comptIf,comptDo,
    comptUntil,k,comptAcc,indice,longueur:longint;{compteurs}
    car:char;
    mot:string;
    reel: real;
    isparam,isstring,newline: boolean;

  procedure writecar;
  begin
       case car of
       '"': write(ExportFile, '&quot;');
       '&': write(ExportFile, '&amp;');
       '<': write(ExportFile, '&lt;');
       '>': write(ExportFile, '&gt;');
       ' ': write(ExportFile, '&nbsp;');
       ',': if isstring then write(ExportFile,',') else write(ExportFile,',');
       #13,#10: begin writeln(ExportFile,'</li>'); newline:=true end;
       #9:  write(ExportFile, '&nbsp;&nbsp;&nbsp;&nbsp;');
       else write(ExportFile,car)
       end;
  end;

  procedure LireIdentificateur;
  var k:longint;
      bold,it: boolean;
  begin
     k:=indice;  bold:=false; it:=false;
     while (indice<=longueur) and (chaine[indice] in set_nom) do inc(indice);
     mot:=Copy(chaine,k,indice-k);
     if newline then begin write(ExportFile,'<li>'); newline:=false; end;
     if IsKeyWord(mot) then begin bold:=true; write(ExportFile, '<b><span class="'+clKeyWord+'">') end
        else
     if IsConstant(mot) then begin bold:=true; write(ExportFile, '<b><span class="'+clConstant+'">') end
        else
     if IsMacPredef(mot) then begin bold:=true; write(ExportFile, '<b><span class="'+clMacPredef+'">') end
        else
     if IsMacUser(mot) then write(ExportFile, '<span class="'+clMacUser+'">')
        else
     if IsVarGlob(mot) then write(ExportFile, '<span class="'+clVarGlob+'">')
        else
     if IsVarPredef(mot) then write(ExportFile, '<span class="'+clVarPredef+'">')
        else
     if IsGraphElem(mot) then begin bold:=true; write(ExportFile, '<b><span class="'+clGraphElem+'">') end
        else begin it:=true; write(ExportFile, '<i><span class="'+clIdentifier+'">') end;
     for car in mot do writecar ;
     write(Exportfile,'</span>'); if bold then write(Exportfile,'</b>'); if it then write(Exportfile,'</i>');
  end;

  procedure LireMessage;
  var
   stop,ok:boolean;
   first,firstlg:longint;
   begin
    mot:='';                    {on pointe sur la première case de mot}
    stop:=(Indice>longueur);    {le booléen stop permettra de stopper la lecture}
    ok:=false;                  {le booléen ok permettra de savoir si le message se termine correctement}
    while not stop do
          begin
          car:=chaine[Indice];
          writecar; {on copie le caractère de chaine dans mot}
          if car='"'
             then            {le caractère lu est le délimitateur "}
                  if (Indice<longueur) and (chaine[Indice+1]='"')
                     then   {on teste si le caractère suivant est aussi un "}
                         begin
                              inc(Indice,2); {on a un double "" cela représente le caractère ", on avance de deux
                                                    cases dans chaine et d'une seule dans mot}
                         end
                     else
                         begin
                              inc(Indice);ok:=true;
                               {on a un seul ", c'est la fin du message, on avance d'une case
                                                    dans chaine, mais pas dans mot pour écraser le caractère "
                                                    qui vient d'être lu. Ok prend la valeur true, pas d'erreur}
                         end
             else
                 begin
                      inc(Indice);  {on est toujours dans le message, on avance d'une case}
                 end;
          stop:=ok or (Indice>longueur); {on s'arrête en bout de chaine ou si le message est terminé}
          end;
   end;

   procedure LireReel;
   var aux:string;
       first,Error:longint;
       sortie:extended;
       stop:boolean;
   begin
    aux:='';  {cette chaine standard reçoit les caractères constituant la valeur numérique à lire}
    stop:=false;
    first:=indice;
    if newline then begin write(ExportFile,'<li>'); newline:=false; end;
    if not isparam then write(ExportFile, '<span class="'+clNumeric+'">') else isparam:=false;
    car:=chaine[Indice];
    while (not stop) and (indice<=longueur) and (chaine[indice] in set_num) do
          begin
               if (indice>first) and
                   ((car='-') or (car='+')) and
                   (chaine[indice-1]<>'E')
                  then begin stop:=true; dec(indice) end
                               {si on a un + ou un - et le caractère précédent
                                               n'est pas E, alors on n'est plus dans une
                                               expression numérique}
                  else writecar;
               inc(indice);                    {on passe au suivant}
               car:=chaine[Indice];
          end;
    write(ExportFile,'</span>')
   end;

begin
     if chaine='' then exit; longueur:=length(chaine); isparam:=false; isstring:=false;
     k:=1; comptParO:=0;comptCrO:=0; comptIf:=0; comptDo:=0;comptUntil:=0;
     AssignFile(ExportFile, ExportName); rewrite(exportFile);
     writeln(ExportFile,'<ol class="code">'); newline:=true;
     while (k<=longueur) do    {tant qu'on n'est pas en fin de chaine}
       begin
         car:=chaine[k];
         if newline then begin write(ExportFile,'<li>'); newline:=false; end;
         case car of
         #9,#10,#13,' ': writecar;
         '%': begin write(ExportFile,'<span class="'+clParam+'">');writecar; isparam:=true end;
         '{' :   begin {début d'un commentaire}
                       comptAcc:=1; inc(k);
                       write(ExportFile,'<span class="'+clComment+'">');writecar;
                       while (comptAcc<>0) and (k<=longueur) do
                                begin
                                        car:=chaine[k];
                                        writecar;
                                        if car='{' then Inc(comptAcc);
                                        if car='}' then Dec(comptAcc);
                                        inc(k);  {on avance dans chaine jusqu'à
                                        la fin du commentaire ou de la chaine}
                                end;
                       write(ExportFile,'</span>'); dec(k)
                  end;
            '"': begin {debut d'un message}
                      indice:=k+1; writecar; isstring:=true;
                      write(ExportFile,'<span class="'+clString+'">');
                      LireMessage; isstring:=false; write(ExportFile,'</span>');
                      k:=indice-1;
                 end;

       ':','=','<','>','[',']','(',')',',','+','-','*','^',';','$','@','\','#': //symboles
                   begin
                        write(ExportFile,'<span class="'+clSymbol+'">');
                        writecar;
                        case car of
                        ':','<','>':if (k<longueur) then
                                begin
                                     car:=chaine[k+1];
                                     if car='=' then begin writecar; Inc(k) end;
                                end;
                        end;
                        write(ExportFile,'</span>');
                   end;
       '/':  If (k=longueur) or (chaine[k+1]<>'/')  then
             begin
                   write(ExportFile,'<span class="'+clSymbol+'">');
                   writecar;
                   write(ExportFile,'</span>');
             end
               else begin
                         write(ExportFile,'<span class="'+clComment+'">');
                         repeat   //commentaire jusqu'à la fin de la ligne
                         writecar;
                         Inc(k); car:=chaine[k]
                         until car in [#10, #13];
                         write(ExportFile,'</span>');
                         dec(k)
                         end;

     'a'..'z','A'..'Z': begin
                        indice:=k;
                        LireIdentificateur;
                        k:=indice-1;
                        end;

  '0'..'9','.': begin
                indice:=k;
                LireReel;
                k:=indice-1;
                end;
       end; {fin du case}
       inc(k); {on avance d'une case}
       end;
  writeln(ExportFile,'</ol>');
  CloseFile(ExportFile);
end;
//{$ENDIF}
{===================}
procedure GraphExport(mode: integer);
var chemin, aux, oldDir:string;
    mac: Pmacros;
    T: TstringList;
    {$IFDEF GUI}
    pict:tbitmap;
    {$ENDIF}
begin
	    //assignFile(f,ExportName);
            aux:=ExportName;
	    case mode of
              obj : //export de la scene 3D construite avc Build3D  au format obj (facettes+lignes seulement)
                   begin
                        enregistrer_elements(obj,cadre,Exportname);
                   end;
              geom : //export de la scene 3D construite avc Build3D  au format geomview (facettes+lignes seulement)
                   begin
                        enregistrer_elements(geom,cadre,Exportname);
                   end;
              jvx : //export de la scene 3D construite avc Build3D  au format javaview (facettes+lignes+labels )
                   begin
                        enregistrer_elements(jvx,cadre,Exportname);
                   end;
              js : //export de la scene 3D construite avc Build3D  au format javaview (facettes+lignes+dot+TeXlabel3d )
                   begin
                        enregistrer_elements(js,cadre,Exportname);
                   end;

              texsrc : begin
                            enregistrer_elements(teg,cadre,ExportName); //source écrit en TeX
                            T:=TstringList.Create;
                            T.LoadFromFile(ExportName);
                            Export2PrettyLaTeX(T.text);
                            T.free;
                       end;
              htmlsrc : begin
                            enregistrer_elements(teg,cadre,ExportName); //source écrit en html
                            T:=TstringList.Create;
                            T.LoadFromFile(ExportName);
                            Export2PrettyHtml(T.text);
                            T.free;
                       end;
               {$IfDef GUI}
              bmp: begin
                          MyBitmap.SaveToFile(Exportname);
                    end;
              {$EndIf}
              psf:  //export eps+Psfrag
                 begin
                       UsePsfrag:=true;
                       delete(aux,Length(aux)-2,3);
                       aux:=aux+'eps';
                       assignFile(psfrag,ExportName);
                       //AssignFile(f,aux);
                       enregistrer_elements(eps,cadre,aux);
                       writeln(psfrag,'\includegraphics{'+ExtractFileName(aux)+'}');
                       CloseFile(psfrag);
                       UsePsfrag:=false;
                 end;
              pdf:   //export pdf non compilé
                     begin
                          delete(aux,Length(aux)-2,3);
                          aux:=aux+'eps';
                          //assignFile(f,aux);
                          enregistrer_elements(eps,cadre,aux);
                          mac:=macros('pdfprog');
                          if (mac=nil) or (mac^.contenu=nil) or (mac^.contenu^.corps=nil)
                             then chemin:='epstopdf --gsopt=-dNOSAFER --gsopt=-dALLOWPSTRANSPARENCY'
                             else chemin:=MakeString(mac^.contenu^.corps);
                          systemExec(chemin+' "'+aux+'"',true,false)
                     end;
            compileEps: //export eps compilé
                        begin
                        GetDir(0,oldDir);ChDir(TmpPath);
                        {$IFDEF GUI} Apercu:=true;{$ENDIF}
                        //AssignFile(f,'file.pst');
                        enregistrer_elements(pstricks,cadre,'file.pst');
                        mac:=macros('CompileEps');
                        if (mac=nil) or (mac^.contenu=nil) or (mac^.contenu^.corps=nil)
                             then
                             else begin
                                chemin:=MakeString(mac^.contenu^.corps);
                                systemExec(chemin+' "'
				{$IFNDEF GUI}+oldDir+sep{$ENDIF}
				+aux+'"',true,false);
                                end;
                          {$IFDEF GUI} Apercu:=false;{$ENDIF}
                          ChDir(oldDir);
                     end;
            compilePdf: //export pdf compilé
                        begin
                          GetDir(0,oldDir);
                          ChDir(TmpPath);
                          //assignFile(f,'frame1.pgf');
                          {$IFDEF GUI} Apercu:=true;{$ENDIF}
                          enregistrer_elements(pgf,cadre,'frame1.pgf');
                          mac:=macros('CompilePdf');
                          if (mac=nil) or (mac^.contenu=nil) or (mac^.contenu^.corps=nil)
                             then
                             else begin
                              chemin:=MakeString(mac^.contenu^.corps);
                              SystemExec(chemin+' "'
                              {$IFNDEF GUI}+oldDir+sep{$ENDIF}
				+aux+'"',true,false);
                                   end;
                          {$IFDEF GUI} Apercu:=false;{$ENDIF}
                          ChDir(oldDir);
                     end;
              else enregistrer_elements(mode,cadre,ExportName);
              end;
end;
{===================}
procedure recalculer(tous:boolean);
var aux:PVarGlob;
    I: longint;
begin
     aux:=PVarGlob(VariablesGlobales^.tete);
     while aux<>nil do
           begin
                aux^.recalculer;
                aux:=PVarGlob(aux^.suivant);
           end;

     with LesMacros do
          for I:=0 to Count-1 do
                   Pmacros(List[I]^.Data)^.Recompiler;;

     recalculer_elements(tous) (* éléments graphiques, tous ou peut etre pas tous ou un nominatif *);
end;

{============================= Lecture en entrée ==============}
procedure NewReadFile(Const fichier: string);{lire un fichier source}
type Tetat=(load,defvar,defmac,defCmd,defgraph);

var p,p1:Pcorps; h:Pexpression; mac:Pmacros;
    graph:Putilisateur;
    dep,arriv,i,j:longint;
    etat:Tetat;
    tok:Ptoken;
    nom,Unechaine:string;
    res:Presult;
    aux:Pliste;
    ok:boolean;
    Ltoken:Tlist;
    memo:TStringList;

    function lireNext:boolean;
    begin
         Inc(i);Result:=true;
         if i<Ltoken.Count then tok:=PToken(Ltoken.Items[i]);
         if (i>=Ltoken.Count) then
            begin
                ErrorPos:=tok.index;
                Result:=false;
            end
         else
             if (tok.code=Trubrique)
             then
              if tok.contenu='Include' then etat:=load
                                   else
              if tok.contenu='Var' then etat:=defvar
                                  else
              if tok.contenu='Mac' then etat:=defmac
                                  else
              if tok.contenu='Graph' then etat:=defgraph
                                    else
              if tok.contenu='Cmd' then etat:=defcmd else
             else dec(i);//on reste dans la m^eme rubrique

    end;

    function lireNom:boolean;
    begin
         Inc(i);Result:=true;
         if i<Ltoken.Count then tok:=PToken(Ltoken.Items[i]);
         if (i>=Ltoken.Count) or (tok.code<>Tid) then
            begin
                AnaLyseError:=true;
                ErrorMessage:=TgIdentifierExpected;
                if tok^.contenu<>'' then
                ErrorMessage:=ErrorMessage+TgAnd+tok^.contenu+Tgfound;
                ErrorPos:=tok.index;
                ErrorLg:=tok.lg;
                Result:=false;
            end
         else nom:=tok.contenu;
    end;

    function lireEgalite:boolean;
    begin
         Inc(i); Result:=true;
         if i<Ltoken.Count then tok:=PToken(Ltoken.Items[i]);
         if (i>=Ltoken.Count) or (tok.code<>Tope)
            or (tok.contenu<>'Egal') then
            begin
                AnaLyseError:=true;
                ErrorMessage:=TgsymbolEqual;
                if tok^.contenu<>'' then
                ErrorMessage:=ErrorMessage+TgAnd+tok^.contenu+TgFound;
                ErrorPos:=tok.index;
                ErrorLg:=tok.lg;
                Result:=false;
            end
    end;

    function ChercherEnd:boolean;
    var stop:boolean;
    begin
         j:=i+1; Result:=true; stop:=(j>=Ltoken.Count);
         while  (not stop) do
                begin
                    tok:=PToken(Ltoken.Items[j]);
                    Inc(j);
                    stop:= (tok.code=Tend) or (tok.code=Trubrique) or (j>=Ltoken.Count)
               end;
         if  (tok.code<>Tend) then
             if (tok.code=Trubrique)then
                begin
                     AnaLyseError:=true;
                     ErrorMessage:=TgSymbolPV;
                     if tok^.contenu<>'' then
                     ErrorMessage:=ErrorMessage+TgAnd+tok^.contenu+TgFound;
                     ErrorPos:=tok.index;
                     ErrorLg:=tok.lg;
                     Result:=false;
                end
             else begin
                     AnaLyseError:=true;
                     ErrorMessage:=TgExpectedNotFound;
                     ErrorPos:=tok.index;
                     ErrorLg:=tok.lg;
                     Result:=false;
                  end;

    end;
    

begin
     AnalyseError:=false; ErrorMessage:='';  {initialisation pour la gestion des erreurs}
     Ltoken:=Tlist.create;
     memo:=TstringList.Create;
     memo.LoadFromFile(fichier);
     memo.Delete(0);              // la première ligne est TeXgraph#
     Unechaine:=memo.text;
     memo.free;
     decoupage(LToken, Unechaine,false);        {tokenisation du fichier vers Ltoken}
     p:=nil; i:=-1; etat:=defcmd;
     AnalyseError:=AnalyseError or (not lirenext);
     If (not AnalyseError) and (Ltoken.Count>0)
         then                                          //parcourt des tokens
         begin
             DefaultSettings;
             while (not AnalyseError) and (i<Ltoken.Count) do
              begin
                  case etat of
                  load: begin
                             Inc(i);
                             if i<Ltoken.Count then tok:=PToken(Ltoken.Items[i]);
                             if (i>=Ltoken.Count) or (tok.code<>Tmess) then
                                begin
                                     AnaLyseError:=true;
                                     ErrorMessage:='Include: '+TgStringExpected;
                                     ErrorPos:=tok.index;
                                     ErrorLg:=tok.lg;
                                end
                             else
                             begin
                                  nom:=tok.contenu;
                                  Inc(i);
                                  if i<Ltoken.Count then tok:=PToken(Ltoken.Items[i]);
                                  if (i>=Ltoken.Count) or (tok.code<>Tend) then
                                     begin
                                          AnaLyseError:=true;
                                          ErrorMessage:='Include '+nom+': '+TgSymbolPV;
                                          ErrorPos:=tok.index;
                                          ErrorLg:=tok.lg;
                                     end
                                  else
                                      begin //on crée la commande InpuMac(nom)
                                         p:=new(Pcorps,init(cat_commande,commande('InputMac')));
                                         p^.ajouter_arg(new(Pcorps,init(cat_string,new(Pstring,init(nom)))));
                                         res:=p^.evaluer;
                                         Kill(Pcellule(res));
                                         dispose(p,detruire);
                                         lirenext
                                      end
                             end;
                           end;
                   defCmd: if ChercherEnd then
                           begin //exécution d'une commande
                                 new(h,init);
                                 aux:=LesVarLoc;
                                 LesVarLoc:=h^.VarLoc;
                                 analyser(Ltoken,i+1,j-2,p);
                                 h^.corps:=p;
                                 LesVarLoc:=aux;
                                 if not AnalyseError then
                                    begin
                                         res:=h^.evaluer;
                                         Kill(Pcellule(res))
                                    end;
                                 dispose(h,detruire);
                                 i:=j-1;
                                 lirenext
                           end
                           else ErrorMessage:='Cmd: '+ErrorMessage;
                   defvar: begin
                             nom:='';
                             if lireNom and lireEgalite and ChercherEnd then
                                      //on crée la variable
                                      if VariableValide(nom,false) then
                                      begin
                                           new(h,init);
                                           aux:=LesVarLoc;
                                           LesVarLoc:=h^.VarLoc;
                                           analyser(Ltoken,i+1,j-2,p);
                                           h^.corps:=p;
                                           LesVarLoc:=aux;
                                          if not AnalyseError then
                                           if MacroStatut<>predefmac then
                                           begin
                                            dep:=Ptoken(Ltoken.Items[i+1])^.index;
                                            arriv:=Ptoken(Ltoken.Items[j-1])^.index-1;
                                            VariablesGlobales^.ajouter_fin(new(PVarGlob,init(Nom,
                                             Stringreplace(Copy(Unechaine,dep,arriv-dep+1),slineBreak+#9,'',[rfReplaceAll])
                                             )));
                                           end
                                           else
                                            begin
                                            res:=h^.evaluer;
                                            LesConstantes.ajouter_fin(new(Pconstante,
                                                                       init(Nom,res,false)));
                                            end;
                                           dispose(h,detruire);
                                           i:=j-1;
                                           lirenext
                                      end
                                      else
                                          begin
                                          {$IFDEF GUI}
                                                  if False{AfficheError} then
                                                  AfficheError:=(Messagedlg(nom+': '+TgNameError,mtWarning,[mbok,mbcancel],0)=mrOk);
                                          {$ENDIF}
                                          i:=j-1;
                                          lirenext
                                               {AnalyseError:=true;
                                               ErrorMessage:='Variable '+nom+': nom invalide';
                                               ErrorLg:=tok.lg;}
                                          end
                                else ErrorMessage:='Variable '+nom+': '+ErrorMessage
                             end;

                   defmac: begin
                             nom:='';
                             if lireNom and lireEgalite and ChercherEnd then
                                      //on crée la macro
                                      if NomMacroValide(nom,MacroStatut=predefmac) then
                                      begin
                                           new(h,init);
                                           aux:=LesVarLoc;
                                           LesVarLoc:=h^.VarLoc;
                                           analyser(Ltoken,i+1,j-2,p);
                                           h^.corps:=p;
                                           LesVarLoc:=aux;
                                         if not AnalyseError then
                                         begin
                                           mac:=new(PMacros,init(nom,h));
                                           if MacroStatut=usermac then
                                            begin
                                              dep:=Ptoken(Ltoken.Items[i+1])^.index;
                                              arriv:=Ptoken(Ltoken.Items[j-1])^.index-1;
                                              mac^.SetCommande(
                                                Stringreplace(Copy(Unechaine,dep,arriv-dep+1),slineBreak+#9,slinebreak,[rfReplaceAll]));
                                            end;
                                           if nom='Exit' then
                                              begin
                                                   ExitMacros^.ajouter_debut(PCellule(mac));
                                                   if  MacroStatut=usermac then ajouter_macros(mac^.dupliquer);
                                              end
                                           else ajouter_macros(mac);
                                         end else dispose(h,detruire);
                                           i:=j-1;
                                           lirenext
                                      end
                                      else
                                          begin
                                          {$IFDEF GUI}
                                          if False{AfficheError} then
                                          AfficheError:=(Messagedlg(nom+': '+TgNameError,
                                                          mtWarning,[mbok,mbcancel],0)=mrOk);
                                          {$ENDIF}
                                          i:=j-1;
                                          lirenext
                                               {AnalyseError:=true;
                                               ErrorMessage:='Macro '+nom+': nom invalide';
                                               ErrorLg:=tok.lg;}
                                          end
                               else ErrorMessage:='Macro '+nom+': '+ErrorMessage;
                             end;

                   defgraph: begin
                             if i<Ltoken.Count then tok:=PToken(Ltoken.Items[i+1]);
                             if (i>=Ltoken.Count) or (tok.code<>Tid) then
                               begin ok:=true;nom:='';end//pas de nom
                             else ok:=lireNom and lireEgalite;

                             if ok and ChercherEnd then
                                      //on crée l'élément graphique
                                      begin
                                         //DefaultSettings;
                                         new(h,init);
                                         aux:=LesVarLoc;
                                         LesVarLoc:=h^.VarLoc;
                                         analyser(Ltoken,i+1,j-2,p);
                                         h^.corps:=p;
                                         LesVarLoc:=aux;
                                        if not AnalyseError then
                                         begin
                                         graph:=new(PUtilisateur,init(nom,'',-1));
                                         liste_element.ajouter_fin(graph);
                                         graph.DefCommande:=false;
                                         graph.arbre:=h;
                                         graph.ReCalculer;
                                         //{$IFDEF GUI}
                                         dep:=Ptoken(Ltoken.Items[i+1])^.index;
                                         arriv:=Ptoken(Ltoken.Items[j-1])^.index-1;
                                         graph.LigneCommande:=
                                           Stringreplace(Copy(Unechaine,dep,arriv-dep+1),slineBreak+#9,slinebreak,[rfReplaceAll]);
                                         //{$ENDIF}
                                         end else dispose(h,detruire);
                                         i:=j-1;
                                         lirenext
                                      end
                               else ErrorMessage:='Graph '+nom+': '+ErrorMessage
                             end;
                  end;
             end
         end
          else if not AnaLyseError
               then ErrorMessage:=TgEmptyString;

      for i:=0 to Ltoken.Count-1 do dispose(Ptoken(Ltoken.Items[i]));
      Ltoken.free;
end;
{==================================}
function LireFichier(Const fichier: string):boolean; //ancienne syntaxe
const forbidden1=[' ',#13,#10,#9];

type Tlecture=(Lvaleur, Lnom, Lcommande,Lautre,Lfinie);
var
     mot,commande:string;
     f: textFile;
     nom:Tnom;
     a,b,c,d,e,g:real;
     cat,style,code:integer;
     error:integer;
     h:Pexpression;
     mac:PMacros;
     res:Presult;
     stop:boolean;
     diviser,saut:byte;
     lecture:Tlecture;
     forbidden:set of char;

     function test_error:boolean;
     begin
      test_error:=false;
      if error<>0 then
         begin
              LireFichier:=false;
              stop:=true;
              test_error:=true;
              AfficheMessage(TgNumericError+': '+mot)
         end;
     end;


     function Lire_Mot:string;
     var car:char;
         arret:boolean;
     begin
        if (lecture=Lfinie) or eof(f) then begin result:='0'; exit end;
        mot:='';
        result:='';
        arret:=false;
        repeat
                if eof(f) then begin result:=''; exit end;
                read(f,car);
                if (car='%') and (lecture<>Lcommande)
                            then readln(f)
                            else
                if car=car_special
                        then arret:=true
                        else if not (car in forbidden)
                                then result:=result+car;
        until arret;
        if (result='') and (lecture<>Lnom) and (lecture<>Lcommande)
                then
                        begin
                          lecture:=Lfinie; result:='0';
                        end;
        mot:=result;
     end;

     procedure lire_fenetre;
     begin
      val(lire_mot,a,error); if test_error then exit;
      val(lire_mot,b,error); if test_error then exit;
      val(lire_mot,c,error); if test_error then exit;
      val(lire_mot,d,error); if test_error then exit;
      val(lire_mot,e,error); if test_error then exit;
      val(lire_mot,g,error); if test_error then exit;
      graph1_6.fenetre(a,c,b,d,e,g);
      DefaultSettings;
      end;

     procedure lire_marges;
     begin
      val(lire_mot,a,error); if test_error then exit;
      val(lire_mot,b,error); if test_error then exit;
      val(lire_mot,c,error); if test_error then exit;
      val(lire_mot,d,error); if test_error then exit;
      val(lire_mot,style,error); if test_error then exit;
      val(lire_mot,cat,error); if test_error then exit;
      graph1_6.marges(a,b,c,d);
      cadre:=style=1; gestion_couleur:=cat=1;
      PcomptGraph^.affixe^.setx(0);
      val(lire_mot,cat,error); if not test_error then
             PcomptGraph^.affixe^.setx(cat)
     end;


     procedure lire_element;
     begin
      lecture:=Lvaleur; forbidden:=forbidden1;
      if (lire_mot='') or eof(f) then exit;
      if mot='TeXgraph' then begin stop:=true;
                                       closefile(f);
                                       NewReadFile(fichier);
                                       system.reset(f);
                             end
                        else
      begin
      val(mot,cat,error);if test_error then exit;
      if cat=cat_ModeInLine then begin stop:=true;
                                       closefile(f);
                                       NewReadFile(fichier);
                                       system.reset(f);
                             end
                        else
      if cat=cat_fenetre then lire_fenetre
                         else
      if cat=cat_marges then lire_marges
                        else
       begin //element macro, variable, commandes, graphiques
      lecture:=Lnom;
      nom:=lire_mot;
      lecture:=Lcommande;
      if cat=cat_const then forbidden:=[#13,#10,#9] else forbidden:=[];
      commande:=lire_mot;
      if commande='' then commande:='Nil';
      lecture:=Lautre; forbidden:=forbidden1;
      case cat of
cat_mac, cat_macGraph2D, cat_macGraph3D:
               if NomMacroValide(nom,MacroStatut=predefmac) then
                 begin
                        new(h,init);
                        if not h^.definir(commande{aux^})
                          then  begin
                                        AfficheMessage('Macro '+nom+': '+ErrorMessage);
                                        dispose(h,detruire)
                                end
                          else  begin mac:=new(PMacros,init(nom,h));
                                      if MacroStatut=0 then mac^.SetCommande(commande);
                                      ajouter_macros(mac);
                                      if (MacroStatut=2) and (cat in [cat_macGraph2D, cat_macGraph3D])
                                        then begin
                                             lecture:=Lcommande; forbidden:=[];
                                             //system.delete(nom,pos('''',nom),1);
                                             {$IFDEF GUI}
                                             case cat of
                                             cat_macGraph2D: mac2d.add(nom+' ['+lire_mot+']');
                                             cat_macGraph3D: mac3d.add(nom+' ['+lire_mot+']');
                                             end;
                                             {$ENDIF}
                                             lecture:=Lautre; forbidden:=forbidden1;
                                             end;
                                end;
                 end
                 else
{$IFDEF GUI}
                 if AfficheError then
                    AfficheError:=(Messagedlg('Macro '+nom+': '+TgNameError,mtWarning,[mbok,mbcancel],0)=mrOk)
{$ENDIF};

      cat_command: begin new(h,init);
                        //FoncSpeciales:=true;
                         if not h^.definir(commande)
                             then AfficheMessage(commande+': '+ErrorMessage)
                             else h^.evaluer;
                         //FoncSpeciales:=false;
                         dispose(h,detruire);
                    end;

      cat_const: if VariableValide(nom,false) then
                   begin
                      new(h,init);
                      if not h^.definir(commande)
                         then AfficheMessage('Variable '+nom+': '+ErrorMessage)
                         else if MacroStatut=2
                                then LesConstantes.ajouter_fin(new(Pconstante,init(Nom,h^.evaluer,false)))
                                else VariablesGlobales^.ajouter_fin(new(PVarGlob,init(Nom,commande)));
                      dispose(h,detruire);
                   end else
{$IFDEF GUI}
                   if AfficheError then AfficheError:=MessageDlg('Variable '+nom+': '+TgNameError,mtWarning,[mbok,mbCancel],0)=mrOk
{$ENDIF};

      cat_axes: ajouter_element(new(Putilisateur,init(nom,'Axes('+copy(commande,2,length(commande)-2)+')',-1)));
      cat_grille: ajouter_element(new(Putilisateur,init(nom,'Grille('+copy(commande,2,length(commande)-2)+')',-1)));
      else
      begin
      if NomValide(nom,false) then
      case cat of

      cat_dot: ajouter_element(new(Pdot,init(nom,commande)));
      cat_utilisateur: begin
                        lecture:=Lvaleur; val(lire_mot,code,error);
                        if test_error or (code=0) then code:=-1;
                        ajouter_element(new(PUtilisateur,init(nom,commande,code)));
                       end;
      cat_cercle: begin //pour compatibilité
                       ajouter_element(new(PUtilisateur,init(nom,'Cercle('+commande+')',-1)));
                  end;
      cat_label: begin forbidden:=[#10,#13,#9]; ajouter_element(new(Plabel,init(nom,commande,lire_mot))) end;
      cat_ellipse: ajouter_element(new(Pellipse,init(nom,commande)));
      cat_droite: ajouter_element(new(Pdroite,init(nom,commande)));
      cat_parametree, cat_cartesienne, cat_polaire:
                      begin
                      diviser:=0;saut:=0; lecture:=Lvaleur;
                      val(lire_mot,style,error);if not test_error then diviser:=style;
                      val(lire_mot,style,error);if not test_error then saut:=style;
                      case cat of
                      cat_parametree:
                      ajouter_element(new(Pparametree,init(nom,commande,diviser,saut)));
                      cat_cartesienne:
                      ajouter_element(new(Pcartesienne,init(nom,commande,diviser,saut)));
                      cat_polaire:
                      ajouter_element(new(Ppolaire,init(nom,commande,diviser,saut)));
                      end;
                      end;
      cat_bezier: ajouter_element(new(Pbezier,init(nom,commande)));
      cat_spline: ajouter_element(new(Pspline,init(nom,commande)));
      cat_ellipticarc: begin
                    lecture:=Lvaleur;
                    val(lire_mot,cat,error);if test_error then cat:=1;
                    ajouter_element(new(Pellipticarc,init(nom,commande,cat)));
               end;
      cat_polygone: begin
                    lecture:=Lvaleur;
                    val(lire_mot,cat,error);if test_error then exit;
                    val(lire_mot,a,error);if test_error then a:=0;
                    ajouter_element(new(Pligne,init(nom,commande,cat,a)));
                    end;
      cat_Path: begin
                    lecture:=Lvaleur;
                    val(lire_mot,cat,error);if test_error then exit;
                    val(lire_mot,a,error);
                    ajouter_element(new(PPath,init(nom,commande,cat)));
                    end;

      cat_EquaDif:  begin
                    lecture:=Lvaleur;
                    val(lire_mot,cat,error);if test_error then exit;
                    ajouter_element(new(PEquaDif,init(nom,commande,cat)));
                    end;
      cat_Implicit: ajouter_element(new(PImplicit,init(nom,commande)));
      else
      {$IFDEF GUI}
      if AfficheError then AfficheError:= Messagedlg('Catégorie: '+IntToStr(cat)+': invalide',mtWarning,[mbok,mbCancel],0)=mrOk
      {$ENDIF};
      end
      else
{$IFDEF GUI}
      if AfficheError then AfficheError:= Messagedlg(TgObject+': '+nom+': '+TgInvalidName,mtWarning,[mbok,mbCancel],0)=mrOk
{$ENDIF};
      end;
      end;
      end;
      end;
         while not ((lecture=Lfinie) or eof(f)) do lire_mot;
     end;


 begin
      LireFichier:=true;
      assignFile(f,fichier);
      {$I-}
      system.reset(f);
      {$I+}
      If IOresult<>0 then begin LireFichier:=false;exit; end;
      {$IFNDEF GUI}
      WriteLog(TgReading+' '+fichier+'...');
      {$ENDIF}
      stop:=false;
      while not stop do
        begin
                lire_element;
                if AnalyseError then
                   begin
                        stop:=true;
                        {$IFNDEF GUI}
                        AfficheMessage(TgLine+' '+Streel(ErrorLg)+': '+ErrorMessage);
                        {$ELSE}
                        AfficheMessage('['+fichier+']'+CRLF+TgLine+' '+Streel(ErrorLg)+': '+ErrorMessage);
                        {$ENDIF}
                        LireFichier:=false;
                        closeFile(f); exit
                   end;
                stop:=stop or eof(f)
        end;
      closeFile(f);

      mac:=macros('Init');
      if (mac<>nil) and (mac^.statut=MacroStatut) then
        begin
                new(h,init);
                if h^.definir('Init()') then
                        begin
                                res:=h^.evaluer;
                                listes2.Kill(pcellule(res));
                        end;
                dispose(h,detruire);
                if mac^.statut>0 then LesMacros.supprimer(mac);
        end;
{$IfNDEF GUI}
      writeLog(fichier+' '+TgEndReading)
{$ENDIF}
 end;
{=================}
procedure finalisation;
var mac:PCellule;
begin
     mac:=ExitMacros^.tete;  //macros de sortie
     while (mac<>nil) do
        begin
                Pmacros(mac)^.executer(nil);
                mac:=mac^.suivant
        end;
     ExitMacros^.detruire;
     vider_liste;                    // éléments graphiques
     detruireMacNonPredef;           // macros utilisateurs
     VariablesGlobales^.detruire;    // variales globales
     ListeFicMac.Clear;              // macros chargées
     filechanged:=false;
end;
{=================}
procedure initialisation;
var  m:Pconstante;
begin
     InitialPath:=GetEnvironmentVariable('TeXgraphDir');
     if InitialPath='' then InitialPath:=GetCurrentDir;
     {$IFDEF MSWINDOWS}
     InitialPath:=InitialPath+'\';
     UserMacPath:=GetEnvironmentVariable('TeXgraphMac');
     if UserMacPath<>'' then  UserMacPath:=UserMacPath+'\';
     TmpPath:='c:\tmp\';
     if not DirectoryExists(TmpPath) then CreateDir(TmpPath);
     MacPath:=InitialPath+'macros\';
     if not FileExists(TmpPath+'CompileEps.tex') then
       SystemExec('cmd /C copy "'+InitialPath+'CompileEps.tex" "' +TmpPath+'CompileEps.tex"',true,false);
     if not FileExists(TmpPath+'modelViewer.html') then
       SystemExec('cmd /C copy "'+InitialPath+'modelViewer.html" "' +TmpPath+'modelViewer.html"',true,false);
     if not FileExists(TmpPath+'modelViewer.js') then
       SystemExec('cmd /C copy "'+InitialPath+'modelViewer.js" "' +TmpPath+'modelViewer.js"',true,false);
     if not FileExists(TmpPath+'three.js') then
       SystemExec('cmd /C copy "'+InitialPath+'three.js" "' +TmpPath+'three.js"',true,false);
     if not FileExists(TmpPath+'TrackballControls.js') then
       SystemExec('cmd /C copy "'+InitialPath+'TrackballControls.js" "' +TmpPath+'TrackballControls.js"',true,false);
     if not FileExists(TmpPath+'dat.gui.min.js') then
            SystemExec('cmd /C copy "'+InitialPath+'dat.gui.min.js" "' +TmpPath+'dat.gui.min.js"',true,false);
     if not FileExists(TmpPath+'modelViewer.css') then
       SystemExec('cmd /C copy "'+InitialPath+'modelViewer.css" "' +TmpPath+'modelViewer.css"',true,false);
     if not FileExists(TmpPath+'tex2FlatPs.tex') then
       SystemExec('cmd /C copy "'+InitialPath+'tex2FlatPs.tex" "' +TmpPath+'tex2FlatPs.tex"',true,false);
	{$IFDEF GUI}
        Docpath:=InitialPath+'doc\';
       UserPath:=initialPath;
       if not FileExists(TmpPath+'formule.tex') then
       SystemExec('cmd /C copy "'+InitialPath+'formule.tex" "' +TmpPath+'formule.tex"',true,false);
     if not FileExists(TmpPath+'apercu.tex') then
       SystemExec('cmd /C copy "'+InitialPath+'apercu.tex" "' +TmpPath+'apercu.tex"',true,false);
     if not FileExists(TmpPath+'TeXgraph.cfg') then
       SystemExec('cmd /C copy "'+InitialPath+'TeXgraph.cfg" "' +TmpPath+'TeXgraph.cfg"',true,false);
	{$ENDIF}
     {$ENDIF}
     {$IFDEF UNIX}
     InitialPath:=InitialPath+'/';
     TmpPath:=GetEnvironmentVariable('HOME')+'/.TeXgraph/';
     UserMacPath:=TmpPath+'TeXgraphMac/';
     if not DirectoryExists(TmpPath) then CreateDir(TmpPath);
     if not DirectoryExists(UserMacPath) then CreateDir(UserMacPath);
     MacPath:=InitialPath+'macros/';
     if not FileExists(TmpPath+'CompileEps.tex') then
       SystemExec('cp -f "'+InitialPath+'CompileEps.tex" "' +TmpPath+'CompileEps.tex"',true,false);
     if not FileExists(TmpPath+'tex2FlatPs.tex') then
       SystemExec('cp -f "'+InitialPath+'tex2FlatPs.tex" "' +TmpPath+'tex2FlatPs.tex"',true,false);
     if not FileExists(TmpPath+'modelViewer.html') then
       SystemExec('cp -f "'+InitialPath+'modelViewer.html" "' +TmpPath+'modelViewer.html"',true,false);
     if not FileExists(TmpPath+'modelViewer.js') then
       SystemExec('cp -f "'+InitialPath+'modelViewer.js" "' +TmpPath+'modelViewer.js"',true,false);
     if not FileExists(TmpPath+'three.js') then
       SystemExec('cp -f "'+InitialPath+'three.js" "' +TmpPath+'three.js"',true,false);
     if not FileExists(TmpPath+'TrackballControls.js') then
       SystemExec('cp -f "'+InitialPath+'TrackballControls.js" "' +TmpPath+'TrackballControls.js"',true,false);
     if not FileExists(TmpPath+'dat.gui.min.js') then
            SystemExec('cp -f copy "'+InitialPath+'dat.gui.min.js" "' +TmpPath+'dat.gui.min.js"',true,false);
     if not FileExists(TmpPath+'modelViewer.css') then
       SystemExec('cp -f "'+InitialPath+'modelViewer.css" "' +TmpPath+'modelViewer.css"',true,false);

	{$IFDEF GUI}
	DocPath:=GetEnvironmentVariable('TeXgraphDocDir');
        if DocPath='' then DocPath:=InitialPath+'doc/'
                   else DocPath:=DocPath+'/';

        if not FileExists(TmpPath+'formule.tex') then
           SystemExec('cp -f "'+InitialPath+'formule.tex" "' +TmpPath+'formule.tex"',true,false);
        if not FileExists(TmpPath+'apercu.tex') then
           SystemExec('cp -f "'+InitialPath+'apercu.tex" "' +TmpPath+'apercu.tex"',true,false);
        if not FileExists(TmpPath+'TeXgraph.cfg') then
           SystemExec('cp -f "'+InitialPath+'TeXgraph.cfg" "' +TmpPath+'TeXgraph.cfg"',true,false);
	{$ENDIF}
     {$ENDIF}

     m:=constante('InitialPath');
     Pchaine(m^.affixe)^.chaine:= InitialPath;

     m:=constante('TmpPath');
     Pchaine(m^.affixe)^.chaine:=TmpPath;

     m:=constante('UserMacPath');
     Pchaine(m^.affixe)^.chaine:= UserMacPath;

     {$IFDEF GUI}
     m:=constante('DocPath');
     Pchaine(m^.affixe)^.chaine:=DocPath;
     
     //Timer
     new(TimerMac,init);
     TimerMac^.definir('"Nil"');
     {$ENDIF}

     macroStatut:=predefmac; //macro permanente
     //lecture color.mac
     Constpredefinie:=true;
     If not FileExists(MacPath+'color.mac') then  AfficheMessage('color.mac '+TgIsNotIn+' '+MacPath)
     else begin LireFichier(MacPath+'color.mac');
          end;
     Constpredefinie:=false;

     //lecture TeXgraph.mac
     If not FileExists(MacPath+'TeXgraph.mac') then AfficheMessage('TeXgraph.mac '+TgIsNotIn+' '+MacPath)
     else LireFichier(MacPath+'TeXgraph.mac');
     macroStatut:=usermac; //macros utilisateur
end;
{=======================}
Initialization

        {$IFDEF GUI}
        mac2d:=TStringList.Create; mac3d:=TStringList.Create;
        {$ENDIF}
        KeyWordList:=TStringList.Create;
        KeyWordList.CaseSensitive:=true;
        with KeyWordList do
                   begin
               add('And');
               add('andif');
               add('AngleStep');
               add('Arrows');
               add('AutoReCalc');
               add('by');
               add('By');
               add('Cmd');
               add('Color');
               add('ComptGraph');
               add('ComptLabel3d');
               add('CutA');
               add('CutB');
               add('DashPattern');
               add('do');
               add('DotAngle');
               add('DotScale');
               add('DotStyle');
               add('elif');
               add('else');
               add('Eofill');
               add('except');
               add('fi');
               add('FillColor');
               add('FillOpacity');
               add('FillStyle');
               add('for');
               add('ForMinToMax');
               add('from');
               add('Graph');
               add('GradStyle'); add('GradColor');add('GradAngle');add('GradCenter');
               add('if');
               add('in');
               add('Include');
               add('Inside');
               add('Inter');
               add('InterL');
               add('IsVisible');
               add('LabelAngle');
               add('LabelSize');
               add('LabelStyle');
               add('MouseCode');
               add('LineCap');
               add('LineJoin');
               add('LineStyle');
               add('Mac');
               add('MiterLimit');
               add('NbPoints');
               add('od');
               add('odfi');
               add('Or');
               add('PenMode');
               add('repeat');
               add('step');
               add('StrokeOpacity');
               add('TeXgraph');
               add('TeXLabel');
               add('then');
               add('tMax');
               add('tMin');
               add('to');
               add('until');
               add('Var');
               add('while');
               add('Width');
               //add('xylabelpos');
               //add('xylabelsep');
               //add('xyticks');
           end;
Finalization
        {$IFDEF GUI}
        mac2d.free; mac3d.free;
        {$ENDIF}
       KeyWordList.free
end.
