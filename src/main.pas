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


unit main;
{$mode Delphi}
INTERFACE
uses SysUtils,classes,fptimer,Unitlog,listes2,complex3,analyse4,command5,command53d,graph1_6,graph2_7,
command9,command10,untres;

procedure run;

IMPLEMENTATION
{====================}
procedure run;
var I:integer;
    fichier,OptionExport,ext:string;
    T: TstringList;
    src, keep: boolean;
    oldMacroStatut: byte;
    h:pexpression;
    res:Presult;

    procedure traiter; //le fichier
    begin
         if not FileExists(fichier+'.teg') then writeLog(fichier+'.teg '+TgFileNotFound)
         else
         begin
              if FileExists(fichier+ext) and (ext<>'.teg')
              then
                  begin
                       WriteLog(TgRemove+' '+fichier+ext);
                       DeleteFile (fichier+ext)
                  end;
              oldMacroStatut:=macroStatut;
              if keep then macroStatut:=predefmac; //macros permanentes
              if LireFichier(fichier+'.teg') then
              begin
                   if  src then
                       begin
                            WriteLog(TgRemove+' '+fichier+'.src');
                            DeleteFile (fichier+'.src');
                            T:=TstringList.Create;
                            T.LoadFromFile(fichier+'.teg');
                            if (T.count>0) then T[0]:='\begin{texgraph}[name='+ExtractFileName(fichier)+', file]';
                            T.add('\end{texgraph}');
                            ExportName:=fichier+'.src';
                            Export2PrettyLaTeX(T.text);
                            T.free;
                       end;
                   if (ext<>'.non') then
                       if ext='.htm' then
                           begin
                                WriteLog(TgRemove+' '+fichier+'.htm');
                                DeleteFile (fichier+'.htm');
                                T:=TstringList.Create;
                                T.LoadFromFile(fichier+'.teg');
                                if (T.count>0) then T[0]:='\begin{texgraph}[name='+ExtractFileName(fichier)+', file]';
                                T.add('\end{texgraph}');
                                ExportName:=fichier+'.htm';
                                Export2PrettyHtml(T.text);
                                T.free;
                           end
                       else
                           begin
                                WriteLog(TgExportTo+' '+fichier+ext);
                                if liste_element.tete=nil then WriteLog(TgNoGraphElement);
                                Executer('Export('+OptionExport+',"'+fichier+ext+'")');
                                WriteLog(TgExportFinished)
                           end;
              end else writeLog(fichier+' '+TgStopReading+'. '+TgNoExport);
              macroStatut:=oldMacroStatut;
              finalisation; //nettoyage
              graph1_6.fenetre(-5,-5,5,5,1,1);
              graph1_6.marges(0.5,0.5,0.5,0.5);
              Dispose(Matrix3d); Matrix3d:=Nil;
              Ptheta^.affixe:=New(Paffixe,init(pi/6,0));
              Pphi^.affixe:=New(Paffixe,init(pi/3,0));
              res:=h^.evaluer;
              Kill(Pcellule(res));
              CurrentMatrix:=DefaultMatrix;
              DefaultSettings;
         end;
    end;
// analyse d'un paramètre
    procedure analyseParametre(Const param: string);
     begin
         if (param[1]='-') then  {option}
            if param='-quiet' then OptionLog:=false
                             else
            if param='-src' then src:=true
                           else
            if param='-nosrc' then src:=false
                         else
            if param='-keep' then keep:=true
               else
            if param='-nokeep' then keep:=false
               else
            begin {export}
              OptionExport:=param;
              delete(OptionExport,1,1);
              ext:='.'+Copy(OptionExport,1,3);
            end
         else  {fichier}
               begin
                    fichier:=param;
                    traiter;
               end;
     end;

// fonctionnement en mode serveur
   procedure modeServeur;
   var quit : boolean;
       T:TStringList;
       I: longint;

   begin
        quit:=false; T:=TStringList.Create;
        if FileExists(TmpPath+'TeXgraphServer.cmd') then DeleteFile(TmpPath+'TeXgraphServer.cmd'); //on efface toute ancienne trace éventuelle
        T.add('Open');
        T.SaveToFile(TmpPath+'TeXgraphServer.On');
        T.Clear;
        WriteLog(TgServerMode);
        repeat
             repeat Sleep(100) until FileExists(TmpPath+'TeXgraphServer.cmd'); //scrutation toutes les 100 ms
             T.LoadFromFile(TmpPath+'TeXgraphServer.cmd');
             if (T.Count=0) then WriteLog(TgEmptyFile)
             else
                 if (T[0]='end') then quit:=true
                 else
                     begin
                          WriteLog(' ');
                          ext:='.non'; src:=false; keep:=false; //initialisation
                          for I:=0 to T.Count-1 do analyseParametre(T[I]);
                     end;
             DeleteFile(TmpPath+'TeXgraphServer.cmd'); // permet au client de savoir que sa demande a été traitée
        until quit;
        T.Destroy;
        WriteLog('Fermeture du programme TeXgraphCmd');
        DeleteFile(TmpPath+'TeXgraphServer.On');
   end;

// programme principal
begin
     new(h,init); h^.definir('Init3D()');
     Unite_graphique(96{dpi},1);
     Initialisation; ext:='.non'; src:=false; keep:=false;
     for I := 1 to ParamCount do
     begin
       if ParamStr(I)='-s' then  begin modeServeur; exit end
       else analyseParametre(ParamStr(I));
     end;
     dispose(h,detruire)
end;
{====================}
Initialization
 DecimalSeparator:='.';
 {$IFDEF Windows}
 DefaultTextLineBreakStyle:=tlbsCRLF;
 {$ENDIF}
Finalization
end.

