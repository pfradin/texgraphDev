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


unit update13;//uniquement dans la version GUI

{$mode delphi}

interface

uses
  Classes, SysUtils, listes2, complex3, analyse4,untres;

Type

    PUpdateLocalDatabase=^TUpdateLocalDatabase;
    TUpdateLocalDatabase= object(Tcommande)
            function executer(arg:PListe):Presult;virtual;
            end;


implementation
uses graph1_6,command10;
var
  f,g: textfile;
  aux:string;
{================= version ================================}
 function LireVersion:string;
 var stop:boolean;
    dep:longint;
    c:string;
 begin
      c:='?';
      stop:=eof(g);
      while not stop do
            begin
                 readln(g,aux);
                 dep:=pos('Version=',aux);
                 if dep<>0 then
                    begin c:=aux; delete(c,1,dep+7); stop:=true;
                          while c[1]=' ' do delete(c,1,1);
                          while c[length(c)]=' ' do delete(c,length(c),1);
                    end
                 else stop:=eof(g);
            end;
      result:='"'+c+'"';
 end;
{================= TrouverFile ================================}
  Procedure ListerModeles(const dossier: string);
  //TrouverFichier( nom du fichier sans chemin, chemin terminé par sep) renvoie le nom complet ou une chaine vide
  //recherche récursive dans les sous-dossiers
  Var
    S : TSearchRec;
    stop:boolean;
    c:string;
  begin
    stop:=FindFirst(dossier+'*.mac', faArchive, S)<>0;//FileExists(dossier+nom);
    while not stop do
    begin
        aux:=ChangeFileExt(dossier+S.Name,'.txt');
        if FileExists(aux) then
           begin
             assignFile(g,aux); reset(g); c:=LireVersion; closeFile(g)
           end
        else c:='"?"';
        writeln(f,'"'+ChangeFileExt(S.Name,'')+'" '+c);
        stop:= (FindNext(S)<>0)
    end;
    FindClose(S);                   { Clôture la recherche }
    stop:= (FindFirst(dossier+'*',faDirectory,S)<>0);  {Recherche de sous-dossiers}
    while not stop do                          { Tant qu'il n'y a pas d'erreurs... }
               begin
                    If ((S.Attr and faDirectory) = faDirectory)
                       and (S.Name<>'.') and ( S.Name<>'..') then
                       ListerModeles(dossier+S.Name+sep);
                    stop:=(FindNext(S)<>0);            { Recherche de la prochaine occurence }
               end;
    FindClose(S);                   { Clôture la recherche }
  end;
{================= commande ================================}
function TUpdateLocalDatabase.executer(arg:Pliste):Presult;
begin
     executer:=Nil;
     if  UserMacPath='' then AfficheMessage('TeXgraphMac: '+TgEnvironmentVariableNotDef)
     else
     begin
       assignFile(f,UserMacPath+'LocalDatabase.txt');
       rewrite(f);
       ListerModeles(UserMacPath);
       closefile(f)
     end
end;

Initialization

LesCommandes.ajouter_fin(new(PUpdateLocalDatabase,init('UpdateLocalDatabase')));//1.96

end.

