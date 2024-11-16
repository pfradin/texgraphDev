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

Unit complex3; {calculs sur les complexes}
{$MODE Delphi}

INTERFACE

USES Sysutils, calculs1 {réels}, listes2 {listes};

CONST 
       digits:byte=4;  {nombre de décimales dans les exportations}

TYPE

    Paffixe=^Taffixe; {pointeur sur un complexe}
    Pchaine=^Tchaine; {pointeur sur une chaine}
    Presult=^Tresult;
    Tresult=Object(TCellule)  {pointeur sur resultat: affixe ou chaine}
              cat: byte;      {0=affixe, 1=chaine}
              constructor init(categorie:byte);
              function en_chaine:string;virtual;  { conversion en chaine lisible par TeXgraph }
              function StrEval:string;virtual;    { résultat en une chaine Pascal}
              function StrConcat:string;          { concatenation des éléments la liste en une seule chaine}
              function evaluer:Presult;virtual;   { résultat dupliqué }
              function evalNum:Paffixe;virtual;   { résultat numérique }
              function dup:Presult;virtual;       { duplication à l'unité }
              function getX:real; virtual;
              function getY:real; virtual;
              procedure setX(Const a:real); virtual;
              procedure setY(Const b:real); virtual;
              procedure setXY(Const a:real; Const b:real); virtual;
              procedure setChaine(const c: string); virtual;
              function getchaine: string; virtual;
              function majusculer:Presult; virtual;
              function minusculer:Presult; virtual;
            end;

    Taffixe=Object(Tresult)
             x,y :real;
             constructor init(Const x1,y1:real);
             function dup:Presult;virtual;       { duplication à l'unité }
             function getX:real; virtual;
             function getY:real; virtual;
             procedure setX(Const a:real); virtual;
             procedure setY(Const b:real); virtual;
             end;


    Tchaine=Object(Tresult)
             chaine: string;
             constructor init(Const str: string);
             function dup:Presult;virtual;       { duplication à l'unité }
             procedure setChaine(const c: string); virtual;
             function getchaine: string; virtual;
             function texgraphChaine:string;virtual;
             end;


Var jump,sep:Paffixe;            {constante de saut}
    ND: Pchaine;                 {constante pour valeur non définie}


function multiplierC(Const c1,c2:Paffixe):Paffixe;      {calcule c1*c2}
function ajouterC(Const c1,c2:Paffixe):Paffixe;         {        c1+c2}
function soustraireC(Const c1,c2:Paffixe):Paffixe;      {        c1-c2}
function diviserC(Const arg1,arg2:Paffixe):Paffixe;     {        c1/c2}
function puissanceC(Const c:Paffixe;Const p:longint):Paffixe; {        c1^p}
function kFoisC(Const k:real;Const c:Paffixe):Paffixe;        {         k*c}

function det(Const A,B:Paffixe):real;                   {déterminant des vecteurs A et B}
function scal(Const A,B:Paffixe):real;                  {produit scalaire des vecteurs A et B}

function streel(Const x:real): string;                 {conversion d'un réel sans format scientifique}
function streelS(Const x:real): string;                {conversion d'un réel avec éventuellement format scientifique}


function IsJump(Const X:Presult):boolean;
function CompResult(Const a1,a2:Presult):boolean;

IMPLEMENTATION
{======================}
constructor Tresult.init(categorie: byte);
begin
     Tcellule.init;
     cat:=categorie;
end;
{======================}
function Tresult.getX:real;
begin
end;
{======================}
function Tresult.getY:real;
begin
end;
{======================}
procedure Tresult.setX(Const a:real);
begin
end;
{======================}
procedure Tresult.setY(Const b:real);
begin
end;
{======================}
procedure Tresult.setXY(Const a:real; Const b:real);
begin
     setX(a); setY(b)
end;
{======================}
procedure Tresult.setChaine(const c: string);
begin
end;
{======================}
function Tresult.getchaine: string;
begin
     result:=''
end;
{======================}
function result_en_chaine(UnResult:Presult):string;
var  r:string;                  {cette chaine contiendra le résultat final, par ex: [0, 1+i, "toto", -2*i] }
     Stx,Sty:string;
     signe:string[1];
     x,y:real;
     index:Presult;            {la variable index parcourt les liste des résultats}
     i:byte;                    {la variable i sert à tester s'il faut un crochet à la fin}
 begin
       index:=UnResult;
       if (index<>nil) and (index^.suivant<>nil)  {s'il y a 2 résultats ou plus, il faut des crochets}
       then
          begin
               r:='[';
               i:=2
          end
       else
           begin
                r:='';
                i:=1
           end;
      while index<>nil do
      begin
      case index^.cat of
      0: begin
            x:=Paffixe(index)^.x; y:=Paffixe(index)^.y;
            if (x=Jump^.x) And (y=Jump^.y) then r:=r+'jump'
               else
               begin
            Stx:=StreelS(abs(x)); Sty:=StreelS(abs(y));
            if (Stx='0') and (Sty='0')                    {on traite le problème des signes et de la valeur 0}
               then r:=r+'0'
               else
                   begin
                        if (Stx<>'0') then
                                          begin
                                               r:=r+StreelS(x);
                                               signe:='+'
                                          end
                                      else signe:='';
                        if (Sty<>'0') then
                                           if y>0 then
                                                      if Sty<>'1' then
                                                                           r:=r+signe+StreelS(y)+'*i'
                                                                  else
                                                                           r:=r+signe+'i'
                                                 else
                                                     if Sty<>'1' then
                                                                          r:=r+StreelS(y)+'*i'
                                                                 else
                                                                          r:=r+'-i';
                   end;
               end;
         end;
      1: r:=r+PChaine(index)^.texgraphChaine
      end;
      if index^.suivant<>nil then r:=r+',';
      index:=Presult(index^.suivant);
      end;
      if i=2 then r:=r+']';
      result_en_chaine:=r;
 end;
{=================}
function result_StrEval(UnResult:Presult):string;
var  r:string;                  { cette chaine contiendra le résultat final en une chaine: [1,2, toto, 3] }
     Stx,Sty:string;
     signe:string[1];
     x,y:real;
     index:Presult;            {la variable index parcourt les liste des résultats}
     i:byte;                    {la variable i sert à tester s'il faut un crochet à la fin}
 begin
       index:=UnResult;
       r:='';
       if (index<>nil) and (index^.suivant<>nil)  {s'il y a 2 résultats ou plus, il faut des crochets}
        then
          begin
               r:='[';
               i:=2
          end
       else
           begin
                r:='';
                i:=1
           end;
      while index<>nil do
      begin
      case index^.cat of
      0: begin
            x:=Paffixe(index)^.x; y:=Paffixe(index)^.y;
            if (x=Jump^.x) And (y=Jump^.y) then r:=r+'jump'
               else
               begin
            Stx:=StreelS(abs(x)); Sty:=StreelS(abs(y));
            if (Stx='0') and (Sty='0')                    {on traite le problème des signes et de la valeur 0}
               then r += '0'
               else
                   begin
                        if (Stx<>'0') then
                                          begin
                                               r += StreelS(x);
                                               signe:='+'
                                          end
                                      else signe:='';
                        if (Sty<>'0') then
                                           if y>0 then
                                                      if Sty<>'1' then
                                                                           r += signe+StreelS(y)+'*i'
                                                                  else
                                                                           r += signe+'i'
                                                 else
                                                     if Sty<>'1' then
                                                                          r += StreelS(y)+'*i'
                                                                 else
                                                                          r += '-i';
                   end;
               end;
         end;
      1: if i=1 then r += PChaine(index)^.Chaine else r += PChaine(index)^.texgraphchaine;//on double les guillemets si liste
      end;
      if index^.suivant<>nil then r += ',';
      index:=Presult(index^.suivant);
      end;
      if i=2 then r += ']';
      result_StrEval:=r;
 end;
{=================}
function result_StrConcat(UnResult:Presult):string;
var  r:string;                  {cette chaine contiendra le résultat final concaténé }
     Stx,Sty:string;
     signe:string[1];
     x,y:real;
     index:Presult;            {la variable index parcourt les liste des résultats}
 begin
       index:=UnResult;
       r:='';
      while index<>nil do
      begin
      case index^.cat of
      0: begin
            x:=Paffixe(index)^.x; y:=Paffixe(index)^.y;
            if (x=Jump^.x) And (y=Jump^.y) then r:=r+'jump'
               else
               begin
            Stx:=StreelS(abs(x)); Sty:=StreelS(abs(y));
            if (Stx='0') and (Sty='0')                    {on traite le problème des signes et de la valeur 0}
               then r += '0'
               else
                   begin
                        if (Stx<>'0') then
                                          begin
                                               r += StreelS(x);
                                               signe:='+'
                                          end
                                      else signe:='';
                        if (Sty<>'0') then
                                           if y>0 then
                                                      if Sty<>'1' then
                                                                           r += signe+StreelS(y)+'*i'
                                                                  else
                                                                           r += signe+'i'
                                                 else
                                                     if Sty<>'1' then
                                                                          r += StreelS(y)+'*i'
                                                                 else
                                                                          r += '-i';
                   end;
               end;
         end;
      1: r += PChaine(index)^.Chaine
      end;
      //if index^.suivant<>nil then r:=r+',';
      index:=Presult(index^.suivant);
      end;
      //if i=2 then r:=r+']';
      result_StrConcat:=r;
 end;
{=================}
function Tresult.en_chaine: string;
begin
     Result:=Result_en_chaine(@self);
end;
{======================}
function Tresult.StrEval: string;
begin
     Result:=Result_StrEval(@self);
end;
{======================}
function Tresult.StrConcat: string;
begin
     Result:=Result_StrConcat(@self);
end;
{======================}
function Tresult.evaluer: Presult;
 var index:Presult;
     liste:Type_liste;
begin
     liste.init;
     index:=@self;
     while index<>nil do
           begin
                liste.ajouter_fin(index^.dup);
                index:=Presult(index^.suivant);
           end; {La liste est maintenant dupliquée dans la variable liste}
     evaluer:=Presult(liste.tete);  {on renvoie le contenu de la variable liste}
end;
{======================}
function Tresult.majusculer: Presult;
 var index:Presult;
     liste:Type_liste;
begin
     liste.init;
     index:=@self;
     while index<>nil do
           begin
                if index^.cat=0 then liste.ajouter_fin(index^.dup)
                else liste.ajouter_fin(new(Pchaine,init(UpperCase(Pchaine(index)^.chaine))));
                index:=Presult(index^.suivant);
           end;
     majusculer:=Presult(liste.tete);  {on renvoie le contenu de la variable liste}
end;
{======================}
function Tresult.minusculer: Presult;
 var index:Presult;
     liste:Type_liste;
begin
     liste.init;
     index:=@self;
     while index<>nil do
           begin
                if index^.cat=0 then liste.ajouter_fin(index^.dup)
                else liste.ajouter_fin(new(pchaine,init(LowerCase(Pchaine(index)^.chaine))));
                index:=Presult(index^.suivant);
           end;
     minusculer:=Presult(liste.tete);  {on renvoie le contenu de la variable liste}
end;
{======================}
function Tresult.Dup:Presult;
begin
     result:=Nil
end;
{======================}
function Tresult.evalNum: Paffixe;
 var index:Presult;
     liste:Type_liste;
begin
     liste.init;
     index:=@self;
     while index<>nil do
           begin
                if index^.cat=0 then liste.ajouter_fin(index^.dup);
                index:=Presult(index^.suivant);
           end; {La liste est maintenant dupliquée dans la variable liste}
     evalNum:=Paffixe(liste.tete);  {on renvoie le contenu de la variable liste}
end;
{======================}
constructor Taffixe.init(Const x1,y1:real);
begin
     Tresult.init(0);
     x:=x1; y:=y1
end;
{======================}
function Taffixe.Dup:Presult;
begin
     result:=New(Paffixe,init(x,y));
end;
{======================}
function Taffixe.getX:real;
begin
     result:=x
end;
{======================}
function Taffixe.getY:real;
begin
     result:=y
end;
{======================}
procedure Taffixe.setX(Const a:real);
begin
     x:=a
end;
{======================}
procedure Taffixe.setY(Const b:real);
begin
     y:=b
end;
{======================}
constructor Tchaine.init(const str: string);
begin
     Tresult.init(1);
     chaine:=str
end;
{======================}
function Tchaine.Dup:Presult;
begin
     result:=New(Pchaine,init(chaine));
end;
{======================}
procedure Tchaine.setChaine(const c: string);
begin
     chaine:=c
end;
{======================}
function Tchaine.getchaine: string;
begin
     result:=chaine
end;
{======================}
function Tchaine.texgraphChaine: string;
begin
     result:='"'+ StringReplace(chaine,'"','""',[rfReplaceAll, rfIgnoreCase])+'"';
end;
{======================}
function IsJump(Const X:Presult):boolean;
begin IsJump:=(X<>nil) and (X^.cat=0) And (Paffixe(X)^.x=jump^.x){and (X^.y=jump^.y)}
end;
{===============}
function streel(Const x:real): string;
var c:byte;
    aux:string;
begin
     aux:='0.'; for c:=1 to digits do aux += '#';
     streel:=FormatFloat(aux,x);
end;
{===============}
function streelS(Const x:real): string;
begin
     StreelS:=FloatToStr(x)
end;
{=================== opérations===================}
function ajouterC(Const c1,c2:Paffixe):Paffixe;
var r:Paffixe;
begin
     ajouterC:=nil;
     if (c1=nil) or (c2=nil) then exit;
     CalcError:=false;
     r:=new(Paffixe,init(ajouter(c1^.x,c2^.x),ajouter(c1^.y,c2^.y)));
     if CalcError then Kill(Pcellule(r));
     ajouterC:=r;
end;
{=================}
function soustraireC(Const c1,c2:Paffixe):Paffixe;
var r:Paffixe;
begin
     soustraireC:=nil;
     if (c1=nil) or (c2=nil) then exit;
     CalcError:=false;
     r:=new(Paffixe,init(ajouter(c1^.x,-c2^.x),ajouter(c1^.y,-c2^.y)));
     if CalcError then Kill(Pcellule(r));
     soustraireC:=r;
end;
{=================}
function multiplierC(Const c1,c2:Paffixe):Paffixe;
var r:Paffixe;
begin
     multiplierC:=nil;
     if (c1=nil) or (c2=nil) then exit;
     CalcError:=false;
           r:=new(Paffixe,init(ajouter(multiplier(c1^.x,c2^.x),-multiplier(c1^.y,c2^.y)),
                               ajouter(multiplier(c1^.x,c2^.y),multiplier(c2^.x,c1^.y))));
     if CalcError then Kill(Pcellule(r));
     multiplierC:=r;
end;
{=================}
function kFoisC(Const k:real;Const c:Paffixe):Paffixe;
var r:Paffixe;
begin
     kFoisC:=nil;
     if (c=nil) then exit;
     CalcError:=false;
           r:=new(Paffixe,init(multiplier(k,c^.x),multiplier(k,c^.y) ));
     if CalcError then Kill(Pcellule(r));
     kFoisC:=r;
end;
{=================}
function diviserC(Const arg1,arg2:Paffixe):Paffixe;
var r:Paffixe;
    x:real;
begin
     diviserC:=nil;
     if (arg1=nil) or (arg2=nil) then exit;
     CalcError:=false;
     x:=ajouter(sqr(arg2^.x),sqr(arg2^.y));
     if CalcError then exit;
     r:=new(Paffixe,init(
             diviser(ajouter(multiplier(arg1^.x,arg2^.x),multiplier(arg1^.y,arg2^.y)),x),
             diviser(ajouter(-multiplier(arg1^.x,arg2^.y),multiplier(arg2^.x,arg1^.y)),x)));
     if CalcError then Kill(Pcellule(r));
     diviserC:=r
end;
{=================}
function puissanceC(Const c:Paffixe;Const p:longint):Paffixe;
var r,r1:Paffixe;
    u:real;
begin
     r:=nil;
     CalcError:=false;
     if p=0 then if (c^.x=0) and (c^.y=0) then
                           else r:=new(Paffixe,init(1,0))
            else
    if p>0 then if (c^.x=0) and (c^.y=0) then r:=new(Paffixe,init(0,0))
                          else
                if odd(p) then begin r1:=puissanceC(c,p-1);
                                     if r1<>nil then begin
                                                          r:=multiplierC(c,r1);
                                                          Kill(Pcellule(r1))
                                                     end
                               end
                          else begin r1:=puissanceC(c,p div 2);
                                     if r1<>nil then begin
                                                          r:=multiplierC(r1,r1);
                                                          Kill(Pcellule(r1))
                                                     end
                               end
           else
     if (c^.x=0) and (c^.y=0) then
               else begin r1:= puissanceC(c,-p);
                          if r1<>nil then begin
                                          u:=ajouter(sqr(r1^.x),sqr(r1^.y));
                                          if not CalcError then
                                          r:=new(Paffixe,init(diviser(r1^.x,u),diviser(-r1^.y,u)));
                                          if CalcError then begin Kill(Pcellule(r)); r:=nil end;
                                          Kill(Pcellule(r1))
                                          end;
                    end;
     puissanceC:=r;
end;
{=================}
function det(Const A,B:Paffixe):real;
begin
      if (A=nil) or (B=nil) then CalcError:=true
                            else
      det:=ajouter(multiplier(A^.x,B^.y),-multiplier(A^.y,B^.x));
end;
{=================}
function scal(Const A,B:Paffixe):real;
 begin
      if (A=nil) or (B=nil) then CalcError:=true
                            else
      scal:=ajouter(multiplier(A^.x,B^.x),multiplier(A^.y,B^.y));
 end;
{=================}
function CompResult(Const a1,a2:Presult):boolean;
var index1,index2:Presult;
    ok:boolean;
begin
     ok :=true; index1:=a1; index2:=a2;
     while ok and (index1<>Nil) and (index2<>Nil) do
           begin
                if (index1^.cat=0) and (index2^.cat=0)
                   then ok:= (Paffixe(index1)^.x=Paffixe(index2)^.x) And (Paffixe(index1)^.y=Paffixe(index2)^.y)
                   else
                if (index1^.cat=1) and (index2^.cat=1)
                   then ok:=Pchaine(index1)^.chaine=Pchaine(index2)^.chaine
                   else ok:=false;
                index1:=Paffixe(index1^.suivant);
                index2:=Paffixe(index2^.suivant);
           end;
     ok:= ok and (index1=Nil) and (index2=Nil);
     result:=ok
end;

END.


