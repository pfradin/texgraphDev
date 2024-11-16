{Copyright (C) 2008 (Patrick FRADIN)
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


Unit saisies;

{$MODE Delphi}

 {saisies de réels et d'entiers avec Tedit}

INTERFACE
uses  stdCtrls, Dialogs;

function validReal(Const edit: Tedit; const min,max:real;var value:real):boolean;
function validInteger(Const edit:Tedit; const min,max:real;var value:longint):boolean;

IMPLEMENTATION
uses command5;

function validReal(Const edit: Tedit; const min,max:real;var value:real):boolean;
var x:real;
begin
     if (definir_reel(edit.text,x) and ((x>=min) and (x<=max)))
        then begin
                  validReal:=true;
                  value:=x
             end
        else
            begin
                 validReal:=false;
                 Messagedlg(edit.text+' : saisie numérique réelle non valide',mtWarning,[mbok],0);
                 edit.SelectAll;
                 edit.SetFocus
            end
end;

function validInteger(Const edit:Tedit; const min,max:real;var value:longint):boolean;
var x:real;
begin
     if (definir_reel(edit.text,x) and (x=Trunc(x)) and ((x>=min) and (x<=max)))
        then begin
                  validInteger:=true;
                  value:=Round(x)
             end
        else begin
                 validInteger:=false;
                 Messagedlg(edit.text+' : saisie numérique entière non valide',mtWarning,[mbok],0);
                 edit.SelectAll;
                 edit.SetFocus
            end
end;

end.
