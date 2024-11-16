{Copyright (C) 2005-2019 (Patrick FRADIN)
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


UNIT calculs1; {calculs sur les réels}

{$MODE Delphi}
INTERFACE

CONST version='2.0'; //définir aussi la constante version dans command5, et dans le fichier TeXgraph.lpr!
      
      reel_max=1.0E+308;       {fourchette des réels positifs}
      reel_min=1.0E-324;
      ln_max=system.ln(reel_max);
      sqrt_max=system.sqrt(reel_max);

function    ajouter(Const x,y:real):real;      {opérations avec tests d'erreurs}
function soustraire(Const x,y:real):real;
function multiplier(Const x,y:real):real;
function    diviser(Const x,y:real):real;
function  puissance(Const x,y:real):real;

function sqr(Const x:real):real;               {fonctions avec tests d'erreurs}
function sqrt(Const x:real):real;
function exp(Const x:real):real;
function ln(Const x:real):real;
function tan(Const x:real):real;
function arcsin(Const x:real):real;
function arccos(Const x:real):real;
function  sh(Const x:real):real;
function  ch(Const x:real):real;
function  th(Const x:real):real;
function argsh(Const x:real):real;
function argch(Const x:real):real;
function argth(Const x:real):real;
{contribution de Patrick BESSE 29/03/08}
function cot(Const x:real):real;
function argcth(Const x:real):real;
function  cth(Const x:real):real;
function arccot(Const x:real):real;
{=============================}

VAR CalcError:boolean;                {indicateur d'erreur de calcul}

IMPLEMENTATION
USES math;
{================================}
function ajouter(Const x,y:real):real;
begin
     result:=0; if CalcError then exit;
     {if ((x<=0) and (y>=0)) or ((x>=0) and (y<=0)) then ajouter:=x+y
             else
     if abs(x)>reel_max-abs(y) then ajouter:=reel_max//CalcError:=true
             else
     ajouter:=x+y}
     try
       ajouter:=x+y
     Except CalcError:=true
     end;
     if IsNan(result) or IsInfinite(result) then CalcError:=true
end;
{=============================================================================}
function soustraire(Const x,y:real):real;
begin
     //soustraire:=ajouter(x,-y)
     result:=0; if CalcError then exit;
     try
       soustraire:=x-y
     Except CalcError:=true
     end;
     if IsNan(result) or IsInfinite(result) then CalcError:=true
end;
{=============================================================================}
function multiplier(Const x,y:real):real;
begin
     result:=0; if CalcError then exit;
     {if (x=0) or (y=0) then multiplier:=0
             else
     if (abs(x)<=1) or (abs(y)<=1) then multiplier:=x*y
             else
     if abs(x)>(reel_max/abs(y)) then
        if ((x>0) and (y>0)) or ((x<0) and (y<0)) then multiplier:=reel_max
        else multiplier:=-reel_max//CalcError:=true
     else
     multiplier:=x*y; }
     try
       multiplier:=x*y
     Except CalcError:=true
     end;
     if IsNan(result) or IsInfinite(result) then CalcError:=true
end;
{=============================================================================}
function diviser(Const x,y:real):real;
begin
     result:=0; if CalcError then exit;
     {if y=0 then CalcError:=true
             else
     if abs(y)>=1 then diviser:=x/y
             else
     if abs(x)>abs(y)*reel_max then
        if ((x>0) and (y>0)) or ((x<0) and (y<0)) then diviser:=reel_max
        else diviser:=-reel_max//CalcError:=true
             else
     diviser:=x/y}
     try
       result:=x/y
     Except CalcError:=true
     end;
     if IsNan(result) or IsInfinite(result) then CalcError:=true
end;
{=============================================================================}
function puissance_entiere(Const x:real; p:longint):real;
begin
     result:=0; if CalcError then exit;
     if p=0 then
        if x=0 then CalcError:=true else puissance_entiere:=1
            else
     if p>0 then
       if x=0 then puissance_entiere:=0
              else
         if odd(p) then
           puissance_entiere:=multiplier(x,sqr(puissance_entiere(x,(p-1) shr 1)))
                     else
           puissance_entiere:=sqr(puissance_entiere(x, p shr 1))
     else
         if x=0 then CalcError:=true
                else puissance_entiere:=diviser(1,puissance_entiere(x,-p))
end;
{=============================================================================}
function exp(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     {if x<0 then exp:=diviser(1,exp(-x))
            else
     if x>ln_max then exp:=reel_max//CalcError:=true
            else
     exp:=system.exp(x)}
     try
       exp:=system.exp(x)
     Except CalcError:=true
     end;
     if IsNan(result) or IsInfinite(result) then CalcError:=true
end;
{=============================================================================}
function puissance(Const x,y:real):real;
begin
     result:=0; if CalcError then exit;
     if int(y)<>y then if x<=reel_min then CalcError:=true
                               else
     puissance:=exp(multiplier(y,system.ln(x)))
                  else
     puissance:=puissance_entiere(x,Round(y))
end;
{=============================================================================}
function sqr(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     {if abs(x)<=sqrt_max then sqr:=system.sqr(x)
        else sqr:=reel_max//CalcError:=true}
     try
       sqr:=system.sqr(x)
     Except CalcError:=true
     end;
     if IsNan(result) or IsInfinite(result) then CalcError:=true
end;
{=============================================================================}
function sqrt(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     if x<0 then CalcError:=true
             else sqrt:=system.sqrt(x)
end;
{=============================================================================}
function ln(Const x:real):real;
begin
      result:=0; if CalcError then exit;
      if x<=0 then CalcError:=true
             else ln:=system.ln(x)
end;
{=============================================================================}
function tan(Const x:real):real;
begin
     Result:=diviser(sin(x),cos(x));
end;
{=============================================================================}
function arcsin(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     if abs(x)>1 then CalcError:=true
                 else
                     if abs(x)=1 then arcsin:=pi/2*x
                                 else
                                arcsin:=arctan(x/system.sqrt(1-x*x))
end;
{=============================================================================}
function arccos(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     arccos:=pi/2-arcsin(x)
end;
{=============================================================================}
function sh(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     Result:=exp(x);
     Result:=soustraire(Result,diviser(1,Result))/2
end;
{=============================================================================}
function ch(Const x:real):real;
begin
      result:=0; if CalcError then exit;
      Result:=exp(x);
      Result:=ajouter(Result,diviser(1,Result))/2
end;
{=============================================================================}
function th(Const x:real):real;
begin
      result:=0; if CalcError then exit;
      result:=exp(multiplier(2,x));
      th:=diviser(ajouter(-1,result),ajouter(1,result))
end;
{============================================================================}
function argsh(Const x:real):real;
begin
      result:=0; if CalcError then exit;
      result:=ajouter(1,multiplier(x,x));
      if not CalcError then begin
                           result:=ajouter(x,system.sqrt(result));
                           if not CalcError then result:=system.ln(result);
                      end;
end;
{=============================================================================}
function argch(Const x:real):real;
begin
      result:=0; if CalcError then exit;
      if x<1 then CalcError:=true
            else
            begin
                 result:=soustraire(multiplier(x,x),1);
                 if not CalcError then begin
                                       result:=ajouter(x,system.sqrt(result));
                                       if not CalcError then result:=system.ln(result);
                                  end;
           end;
end;
{=============================================================================}
function argth(Const x:real):real;
begin
      result:=0; if CalcError then exit;
      if (x<=-1) or (x>=1) then CalcError:=true
                          else
                          begin
                               result:=diviser(1+x,1-x);
                               if not CalcError then result:=system.ln(result)/2;
                         end;
end;
{=============================================================================}
{contribution de Patrick BESSE 29/03/08}
function cot(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     Result:=diviser(cos(x),sin(x));
end;
{=============================================================================}
function arccot(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     arccot:=pi/2-arctan(x)
end;
{=============================================================================}
function argcth(Const x:real):real;
begin
      result:=0; if CalcError then exit;
      if (abs(x)<=1) then CalcError:=true
                          else
                          begin
                               result:=diviser(x+1,x-1);
                               if not CalcError then result:=system.ln(result)/2;
                         end;
end;
{=============================================================================}
function cth(Const x:real):real;
begin
     result:=0; if CalcError then exit;
     if x=0 then CalcError:=true
                 else begin
                     result:=exp(multiplier(2,x));
                     cth:=diviser(ajouter(1,result),ajouter(-1,result))
                 end;
end;
{=============================================================================}
end.
