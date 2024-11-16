{Copyright (C) 2005-2011 (Patrick FRADIN)
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
unit command53d;

{$MODE Delphi}

interface
USES Sysutils,
 

calculs1,Classes,listes2,complex3, analyse4, command5 {, dialogs};

Const
     centrale:boolean=false; {projection centrale ou non}
     Dcamera:real=15; {position caméra=Dcamera*\n}


type Tpt3d= record
                x,y,z:real;
            end;
     Ppt3d=^Tpt3d;
     
     Tmatrix3d=Array[1..4,1..4] of real;
     Pmatrix3d=^Tmatrix3d;

VAR
        Ptheta, Pphi: Pconstante; //angles pour la 3D
        theta,phi:real;
        
        N:Tpt3D; //vecteur normal au plan de projection
        Light: Tpt3D;

        Matrix3D:PMatrix3D;  //matrice de transformation courante de l'espace
        
        posCam:Tpt3d; {position caméra}
        
        sceneCMD: PListe; // argument de Build3D
        

function projeter(var x,y,z:real):Paffixe; //projection sur le plan normal à N passant par O
function deplaceCam(M:Tpt3d):boolean; // déplace la caméra en M
procedure CalculerN; //déterminer le vecteur normal au plan de projection
function PaintVertex(Const facettes:Paffixe;Const couleur:Tcolor): Paffixe;
function getFillcolor(rcolor, gcolor,bcolor:longint; coef:real): Tcolor;//couleur de remplissage
function pscal3d(Const A,B:Tpt3d):real;
function Normalize(Const A:Tpt3d): Tpt3d;


implementation
Uses math,graph1_6;
CONST GouraudShading:boolean=false;

TYPE

      PReadObj= ^TReadObj;
      TReadObj= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
           end;

        PFvisible=^TFvisible;
        TFvisible= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PModelView= ^TModelView;
         TModelView= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PPosCam= ^TPosCam;
         TPosCam= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
               
         PDistCam= ^TDistCam;
         TDistCam= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
        PSortFacet=^TSortFacet;
        TSortFacet= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;

        PClipFacet=^TClipFacet;
        TClipFacet= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;

        PClip3DLine=^TClip3DLine;
        TClip3Dline= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;

        PGet3D=^TGet3D;
        TGet3D= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;


        Pbuild3d=^Tbuild3d;
        Tbuild3d= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               

        PDisplay3D=^TDisplay3D;
        TDisplay3D= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;

         Pproj3D= ^Tproj3D;
         Tproj3D= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
               
         Pprodvec= ^Tprodvec;//produit vectoriel
         Tprodvec= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         Pprodscal= ^Tprodscal;//produit scalaire
         Tprodscal= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PNorme= ^TNorme;//norme
         TNorme= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PNormal= ^TNormal;//vecteur normal au plan de projection
         TNormal= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;


         PGetSurface= ^TGetSurface;
         TGetSurface= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PSetMatrix3d= ^TSetMatrix3d;
         TSetMatrix3d= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;

         PMtransform3d= ^TMtransform3d;
         TMtransform3d= object(Tcommande)

                     function executer(arg:PListe):Presult;virtual;
                     end;
               
         PComposeMatrix3d= ^TComposeMatrix3d;
         TComposeMatrix3d= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PGetMatrix3d= ^TGetMatrix3d;
         TGetMatrix3d= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PIdMatrix3d= ^TIdMatrix3d;
         TIdMatrix3d= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
{ commandes liées aux polyèdres et facettes}
               
         PInserer3d= ^TInserer3d;
         TInserer3d= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PSommets= ^TSommets;
         TSommets= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PAretes= ^TAretes;
         TAretes= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
         PBord= ^TBord;
         TBord= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PMakePoly= ^TMakePoly;
         TMakePoly= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;

         PPaintVertex= ^TPaintVertex;
         TPaintVertex= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PPaintFacet= ^TPaintFacet;
         TPaintFacet= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
               
         PConvertToObjN= ^TConvertToObjN;
         TConvertToObjN= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;

         PConvertToObj= ^TConvertToObj;
         TConvertToObj= object(Tcommande)

               function executer(arg:PListe):Presult;virtual;
               end;
var pscalLightN, coefEclairage: real;


{=============================}
function getFillcolor(rcolor, gcolor,bcolor:longint;coef:real): Tcolor;//couleur de remplissage
var tr,tg,tb:longint;
    coef2:real;
begin
     if coef>=2 then //coef est dejà une couleur (augmentée de 2)
      begin
        result:=round(coef)-2;
      end
     else //coef est un indice avec lequel on multiplie la couleur courante
     begin
          if coef<0 then
             begin
                  coef:=-coef;
                  rcolor:= 127+(rcolor div 2);
                  gcolor:= 127+(gcolor div 2);
                  bcolor:= 127+(bcolor div 2);
             end;
          if Gouraudshading then
              begin
                   coef2:=max(2*sqr(coef)-1,0);

                   if coef2>0 then  coef2:=0.5*exp(25*ln(coef2))*255;
                   if coef>0 then coef:=exp(ln(coef)/2.5);
                   coef:=coef+0.15;
                   tr:=Round( (coef)*rcolor+ coef2);
                   if tr>255 then tr:=255;
                   tg:=Round( (coef)*gcolor+coef2);
                   if tg>255 then tg:=255;
                   tb:=Round( (coef)*bcolor+coef2);
                   if tb>255 then tb:=255;
                   result:=Rgb(tr,tg,tb);
              end
              else result:=Rgb(Round(coef*rcolor),Round(coef*gcolor),Round(coef*bcolor));
     end;
end;

{=============================}
procedure CalculerN; //déterminer le vecteur normal au plan de projection
begin
  if Ptheta^.affixe=nil
     then
         begin
              theta:=pi/6;
              Ptheta^.affixe:=New(Paffixe,init(theta,0));
         end
     else theta:=Ptheta^.Affixe^.getx;
     if Pphi^.affixe=nil
     then
         begin
              phi:=pi/3;
              Pphi^.affixe:=New(Paffixe,init(phi,0));
         end
     else phi:=Pphi^.Affixe^.getx;
  //vecteur normal
  N.x:=sin(phi)*cos(theta); N.y:=sin(phi)*sin(theta); N.z:=cos(phi);
  //vecteur lumière
  Light.x:=-cos(phi)*cos(theta)/2+sin(theta)/3+N.x;
  Light.y:=-cos(phi)*sin(theta)/2-cos(theta)/3+N.y;
  Light.z:=sin(phi)/2+N.z;
  Light:=Normalize(Light);
  
  pscalLightN:=pscal3D(Light,N);
  if centrale then
     begin
          posCam.x:=Dcamera*N.x; posCam.y:=Dcamera*N.y; posCam.z:=Dcamera*N.z;
     end;
end;

function TNormal.executer(arg: Pliste):Presult;
var res:type_liste;
begin
    executer:=nil;
    CalculerN;
    res.init; res.ajouter_fin(new(Paffixe,init(N.x,N.y)));res.ajouter_fin(new(Paffixe,init(N.z,0)));
    executer:=Paffixe(res.tete)
end;
{===============}
function projeter(var x,y,z:real):Paffixe;
// projection sur l'écran qui est le plan normal au vecteur N passant par (0,0,0)
var den:real;
begin
     if centrale then
        begin {projection centrale sur le plan}
              den:= x*N.x+y*N.y+z*N.z-Dcamera;
              if abs(den)<1E-17 then
                 begin
                    projeter:=New(Paffixe,init(jump^.x,jump^.y));
                    exit;
                 end
              else
                  begin
                       x:=posCam.x-Dcamera*(x-posCam.x)/den;
                       y:=posCam.y-Dcamera*(y-posCam.y)/den;
                       z:=posCam.z-Dcamera*(z-posCam.z)/den;
                  end
        end;
     {conversion en coordonnées écran}
    projeter:=new(Paffixe,init(ajouter(cos(theta)*y,-sin(theta)*x),
     ajouter(-cos(phi)*cos(theta)*x,ajouter(-cos(phi)*sin(theta)*y,sin(phi)*z))));
   end;
{=================================}
function Mtransform3D(Const M:Tpt3d):Tpt3d;
//transforme le point M par la matrice courante
var S:Tpt3d;
begin
     if Matrix3D=Nil then begin result:=M; exit end;
     S.x:= ajouter( multiplier(Matrix3d^[1,1],M.x),
            ajouter(multiplier(Matrix3d^[1,2],M.y),
                    ajouter(multiplier(Matrix3d^[1,3],M.z), Matrix3d^[1,4] ) ) );
     S.y:=ajouter( multiplier(Matrix3d^[2,1],M.x),
            ajouter(multiplier(Matrix3d^[2,2],M.y),
                    ajouter(multiplier(Matrix3d^[2,3],M.z), Matrix3d^[2,4] ) ) );
     S.z:=ajouter( multiplier(Matrix3d^[3,1],M.x),
            ajouter(multiplier(Matrix3d^[3,2],M.y),
                    ajouter(multiplier(Matrix3d^[3,3],M.z), Matrix3d^[3,4] ) ) );
     result:=S
end;
{=================================}
function Vtransform3D(Const V:Tpt3d):Tpt3d;
//transforme le vecteur V par la matrice courante
var S:Tpt3d;
begin
     if Matrix3D=Nil then begin result:=V; exit end;
     S.x:= ajouter( multiplier(Matrix3d^[1,1],V.x),
                     ajouter( multiplier(Matrix3d^[1,2],V.y),
                              multiplier(Matrix3d^[1,3],V.z) ) );
     S.y:=ajouter( multiplier(Matrix3d^[2,1],V.x),
                    ajouter( multiplier(Matrix3d^[2,2],V.y),
                             multiplier(Matrix3d^[2,3],V.z) ) );
     S.z:=ajouter( multiplier(Matrix3d^[3,1],V.x),
                    ajouter( multiplier(Matrix3d^[3,2],V.y),
                             multiplier(Matrix3d^[3,3],V.z) ) );
     result:=S
end;
{=================================}
procedure ApplyMatrix3d(var liste:Paffixe);
//applique la matrice 3d à la liste
var index,aux:Paffixe;
    res:type_liste;
    M:Tpt3d;
begin
    if Matrix3d=Nil then exit;
    res.init;
    index:=liste;
    while index<>Nil do
          begin
               if IsJump(index)
                  then res.ajouter_fin(new(Paffixe,init(jump^.x,index^.y)))
               else
                   begin
                        M.x:=index^.x; M.y:=index^.y;
                        aux:=Paffixe(index^.suivant);
                        if (aux<>nil) and (not Isjump(aux))
                           then
                               begin
                                    index:=aux; M.z:=index^.x;
                                    CalcError:=false;
                                    M:=Mtransform3d(M);
                                    if not CalcError then
                                       begin
                                    res.ajouter_fin(new(Paffixe,init(M.x,M.y)));
                                    res.ajouter_fin(new(Paffixe,init(M.z,0)));
                                       end
                               end
                   end;
               index:=Paffixe(index^.suivant)
          end;
    Kill(Pcellule(liste));
    liste:=Paffixe(res.tete)
end;
{=================================}
function pscal3d(Const A,B:Tpt3d):real;
var r:real;
begin
        r:=ajouter( multiplier(A.x,B.x), ajouter( multiplier(A.y,B.y), multiplier(A.z,B.z)));
        if abs(r)<1E-10 then r:=0;
        result:=r;
end;

function Tprodscal.executer(arg: Pliste):Presult;
var f1:Pcorps;
    U:Paffixe;
    a,b,c:Tpt3d;
    res:real;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=Pcorps(arg^.tete);
    if f1=nil then exit;
    u:=Paffixe(f1^.evaluer);
    if (u=nil) or (u^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    a.x:=u^.x;a.y:=u^.y; a.z:=Paffixe(u^.suivant)^.x;
    Kill(Pcellule(u));
    f1:=Pcorps(f1^.suivant);
    if f1=nil then exit;
    u:=f1^.evalNum;
    if (u=nil) or (u^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    b.x:=u^.x; b.y:=u^.y; b.z:=Paffixe(u^.suivant)^.x;
    Kill(Pcellule(u));
    CalcError:=false;
    res:=ajouter( multiplier(A.x,B.x), ajouter( multiplier(A.y,B.y), multiplier(A.z,B.z)));
    if Calcerror then exit;
    if abs(res)<1E-17 then res:=0;
    executer:=new(Paffixe,init(res,0))
end;
{=================================}
function Norm(Const M:Tpt3d):real;
begin
     result:=sqrt(ajouter(ajouter(sqr(M.x),sqr(M.y)), sqr(M.z)));
     if result<1E-17 then result:=0;
end;


function distance3d(Const A,B:Tpt3d):real;
begin
    result:=sqrt(ajouter(ajouter(sqr(soustraire(A.x,B.x)),sqr(soustraire(A.y,B.y))), sqr(soustraire(A.z,B.z))));
    if result<1E-17 then result:=0;
end;


function Normalize(Const A:Tpt3d): Tpt3d;
var res:Tpt3d;
    norme:real;
begin

    norme:=Norm(A);
    if (norme<>0) and (not CalcError) then
    begin
    res.x:=diviser(A.x,norme);
    res.y:=diviser(A.y,norme);
    res.z:=diviser(A.z,norme);
    end else CalcError:=true;
    result:=res
end;

function TNorme.executer(arg: Pliste):Presult;
var f1:Pcorps;
    U:Paffixe;
    x,y,z,res:real;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=Pcorps(arg^.tete);
    if f1=nil then exit;
    u:=f1^.evalNum;
    if (u=nil) or (u^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    x:=u^.x;y:=u^.y; z:=Paffixe(u^.suivant)^.x;

    CalcError:=false;
    res:=sqrt(ajouter(ajouter(sqr(x),sqr(y)), sqr(z)));
    if Calcerror then exit;
    if res<1E-17 then res:=0;
    executer:=new(Paffixe,init(res,0))
end;
{=================================}
function pvect(Const A,B:Tpt3d): Tpt3d;
var res:Tpt3d;
begin
    res.x:=ajouter(multiplier(A.y,B.z),-multiplier(A.z,B.y));
    res.y:=ajouter(-multiplier(A.x,B.z),multiplier(A.z,B.x));
    res.z:=ajouter(multiplier(A.x,B.y),-multiplier(A.y,B.x));
    result:=res
end;

function FaceVisible(Const A,B,C:Tpt3d):boolean;
//renvoie true si la facette passant par A,B,C est visible,
var TA,TB,TC,V1,V2,V3,G,aux:Tpt3d;
begin
     CalculerN;
     CalcError:=false;
     TA:=Mtransform3d(A); {il faut tenir de la matrice courante Matrix3d}
     TB:=Mtransform3d(B);TC:=Mtransform3d(C);

     V1.x:=soustraire(TB.x,TA.x);V1.y:=soustraire(TB.y,TA.y);V1.z:=soustraire(TB.z,TA.z);
     V2.x:=soustraire(TC.x,TA.x);V2.y:=soustraire(TC.y,TA.y);V2.z:=soustraire(TC.z,TA.z);
     V3:=pvect(V1,V2);
     if centrale {perpective centrale}
        then begin {la camera est en Dcamera*N}
                G.x:=ajouter(TA.x,ajouter(TB.x,TC.x))/3;
                G.y:=ajouter(TA.y,ajouter(TB.y,TC.y))/3;
                G.z:=ajouter(TA.z,ajouter(TB.z,TC.z))/3; {centre de gravité}
                if CalcError then begin Result:=false; exit end;
                aux.x:=ajouter(posCam.x,-G.x);
                aux.y:=ajouter(posCam.y,-G.y);
                aux.z:=ajouter(posCam.z,-G.z);
                result:=pscal3d(V3,aux)>=0
             end
        else {projection orthographique}
             begin
                  if CalcError then begin Result:=false; exit end;
                  result:=pscal3d(V3,N)>=0
             end;
end;

function TFvisible.executer(arg: Pliste):Presult;
// Fvisible( liste de 3 points 3D) renvoie 1 si la facette est visible
var f1:Pcorps;
    u,v,w:Paffixe;
    A,B,C:Tpt3d;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=Pcorps(arg^.tete);
    if f1=nil then exit;
    u:=f1^.evalNum;
    
    if (u=nil) or (u^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    A.x:=u^.x; A.y:=u^.y; A.z:=Paffixe(u^.suivant)^.x;
    v:=Paffixe(u^.suivant^.suivant);
    
    if (v=nil) or (v^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    B.x:=v^.x; B.y:=v^.y; B.z:=Paffixe(v^.suivant)^.x;
    w:=Paffixe(v^.suivant^.suivant);
    
    if (w=nil) or (w^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    C.x:=w^.x; C.y:=w^.y; C.z:=Paffixe(w^.suivant)^.x;
    
    Kill(Pcellule(u));

    if facevisible(A,B,C) then executer:=new(Paffixe,init(1,0))
                          else executer:=new(Paffixe,init(0,0))
end;
{================================}
function Tprodvec.executer(arg: Pliste):Presult;
// prodvec(u,v)
var f1:Pcorps;
    U:Paffixe;
    a,b,c:Tpt3d;
    res:type_liste;
begin
    executer:=nil;
    if arg=nil then exit;
    f1:=Pcorps(arg^.tete);
    if f1=nil then exit;
    u:=f1^.evalNum;
    if (u=nil) or (u^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    a.x:=u^.x;a.y:=u^.y; a.z:=Paffixe(u^.suivant)^.x;
    Kill(Pcellule(u));
    f1:=Pcorps(f1^.suivant);
    if f1=nil then exit;
    u:=f1^.evalNum;
    if (u=nil) or (u^.suivant=nil) then begin Kill(Pcellule(u)); exit end;
    b.x:=u^.x; b.y:=u^.y; b.z:=Paffixe(u^.suivant)^.x;
    Kill(Pcellule(u));
    CalcError:=false;
    c:=pvect(a,b);
    if Calcerror then exit;
    res.init; res.ajouter_fin(new(Paffixe,init(c.x,c.y))); res.ajouter_fin(new(Paffixe,init(c.z,0)));
    executer:=Paffixe(res.tete)
end;
{================================}
function det3d(Const U,V,W:Tpt3d):real;
begin
 result:=pscal3d(pvect(U,V),W)
end;
{================================}
function InterDP(Const A,u,B,n:Tpt3d;Const indice1,indice2:real): Paffixe;//intersection droite (A,u) et plan (B,n)
//indice 1 est l'indice lumineux de A et indice2 celui de A+u
var t:real;
    C:Tpt3d;
    sortie:type_liste;
    res:Paffixe;
    c1,c2,couleur:longint;
begin
     result:=nil;
     CalcError:=false;
     C.x:=soustraire(B.x,A.x); C.y:=soustraire(B.y,A.y); C.z:=soustraire(B.z,A.z);
     if CalcError then exit;
     t:=diviser(pscal3d(C,n),pscal3d(u,n));
     if CalcError then exit;
     C.x:=ajouter(A.x,multiplier(t,u.x)); C.y:=ajouter(A.y,multiplier(t,u.y));
     C.z:=ajouter(A.z,multiplier(t,u.z));
     if CalcError then exit;
     sortie.init;
     if (indice1<>0) or (indice2<>0) then
        begin
        c1:=Round(indice1-2); c2:=round(indice2-2);
        if (c1>0) and (c2>0) then
        couleur:=2+Rgb( Round( (1-t)*GetRvalue(c1)+t*GetRvalue(c2)),
                      Round( (1-t)*GetGvalue(c1)+t*GetGvalue(c2)),
                      Round( (1-t)*GetBvalue(c1)+t*GetBvalue(c2))
                    )
        else couleur:=0
        end
       else couleur:=0;
     sortie.ajouter_fin(New(Paffixe,init(C.x,C.y)));
     sortie.ajouter_fin(New(Paffixe,init(C.z,couleur)));
     res:=Paffixe(sortie.tete);
     result:=res
end;
{=======================}
procedure Clip3DLine(ligne, plan:Paffixe; closed: boolean; var devant:Paffixe);
var A,u:Tpt3d; {point du plan et vecteur normal}
    last,M, vecAM, v:Tpt3d; {dernier point et point courant}
    first,first3d, finish:boolean;
    dev:type_liste;
    index, res:Paffixe;
    pscal:real;
    lastPos:integer; {0=out 1=on 2=in}

begin
      devant:=nil; dev.init; lastPos:=2; finish:=false;
      index:=plan; if index=nil then exit;
      A.x:=index^.x; A.y:=index^.y;
      index:=Paffixe(index^.suivant); if index=nil then exit;
      A.z:= index^.x;
      index:=Paffixe(index^.suivant); if index=nil then exit;
      u.x:=index^.x; u.y:=index^.y;
      index:=Paffixe(index^.suivant); if index=nil then exit;
      u.z:=index^.x;
      index:=ligne; first3d:=true; first:=true;
      while index<>nil do
        begin
             if first then begin M.x:=index^.x; M.y:=index^.y; first:=false end
                      else
                       begin
                         M.z:= index^.x; first:=true;  {on a un point}
                         CalcError:=false;
                         vecAM.x:=soustraire(M.x,A.x); vecAM.y:=soustraire(M.y,A.y);
                         vecAM.z:=soustraire(M.z,A.z);
                         pscal:=pscal3d(vecAM,u);
                         if not CalcError then
                         if (pscal=0) then // segment  dans le plan
                           if not finish then
                           begin
                                dev.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                dev.ajouter_fin(New(Paffixe,init(M.z,0)));
                                lastPos:=1;
                           end else
                           else
                            if pscal>0 then {M est du bon coté}
                              begin
                                 if lastPos=0 then
                                        begin
                                                if not first3d then
                                                 begin
                                                   CalcError:=false;
                                                   v.x:=soustraire(M.x,last.x);
                                                   v.y:=soustraire(M.y,last.y);
                                                   v.z:=soustraire(M.z,last.z);
                                                   if not CalcError then
                                                        begin
                                                                res:=interDP(last,v,A,u,0,0);
                                                                if res<>nil then
                                                                 begin
                                                                  dev.ajouter_fin(res);
                                                                 end;
                                                        end;
                                                 end;
                                        end;
                                 lastPos:=2;
                                 if not finish then
                                  begin
                                        dev.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                        dev.ajouter_fin(New(Paffixe,init(M.z,0)));
                                  end;
                              end
                              else {M est du mauvais coté}
                                begin
                                 if lastPos=2 then
                                   begin
                                      if not first3d then
                                                 begin
                                                   CalcError:=false;
                                                   v.x:=soustraire(M.x,last.x);
                                                   v.y:=soustraire(M.y,last.y);
                                                   v.z:=soustraire(M.z,last.z);
                                                   if not CalcError then
                                                        begin
                                                                res:=interDP(last,v,A,u,0,0);
                                                                if res<>nil then
                                                                 begin
                                                                  dev.ajouter_fin(res);
                                                                 end;
                                                        end;
                                                 end;
                                   end;
                                   lastPos:=2;
                                end;
                         last:=M; first3d:=false;
                       end; {fin de if first}
        if finish and first then index:=nil else
                begin
                        index:=Paffixe(index^.suivant);
                        if (index=nil) and closed then
                         begin
                             index:=ligne;
                             finish:=true;
                         end
                end;
        end;
      devant:=Paffixe(dev.tete);
end;
{================================}
procedure splitSeg(seg:Paffixe;Const A,u:Tpt3D;var devant, derriere:Paffixe; faceinversee:boolean);
var B,C,vecAB,vecAC,v:Tpt3d;
    index,res:Paffixe;
    dev,der:type_liste;
    pscal,indice1,indice2:real; {pour le Gouraud Shading}
    PosB, PosC:integer; {0=derriere u 1=sur le plan 2=du cote de u}
begin
     index:=seg; dev.init; der.init; devant:=nil; derriere:=nil;
     B.x:=index^.x; B.y:=index^.y;
     index:=Paffixe(index^.suivant); if index=nil then exit;
     B.z:=index^.x; indice1:=index^.y;
     index:=Paffixe(index^.suivant); if index=nil then exit;
     C.x:=index^.x; C.y:=index^.y;
     index:=Paffixe(index^.suivant); if index=nil then exit;
     C.z:=index^.x; indice2:=index^.y;

     CalcError:=false;
     vecAB.x:=soustraire(B.x,A.x); vecAB.y:=soustraire(B.y,A.y); vecAB.z:=soustraire(B.z,A.z);
     pscal:=pscal3d(vecAB,u);
     if CalcError then exit;
     if pscal=0 then PosB:=1
     else if pscal>0 then posB:=2 else posB:=0;
     vecAC.x:=soustraire(C.x,A.x); vecAC.y:=soustraire(C.y,A.y); vecAC.z:=soustraire(C.z,A.z);
     pscal:=pscal3d(vecAC,u);
     if CalcError then exit;
     if pscal=0 then PosC:=1
     else if pscal>0 then posC:=2 else posC:=0;
      
     if ( (posB=1) and (posC=1) and (not faceinversee)) //tous les deux devant
              or ( (posB=1) and (posC=2)) or ( (posB=2) and (posC=1)) or ( (posB=2) and (posC=2))
              then
                  dev.ajouter_fin(seg^.evaluer)
              else
     if ( (posB=1) and (posC=1) and faceinversee) //tous les deux derriere
              or ( (posB=1) and (posC=0)) or ( (posB=0) and (posC=1)) or ( (posB=0) and (posC=0))
              then
                  der.ajouter_fin(seg^.evaluer)
     else //ils sont de part et d'autre du plan
           begin
                CalcError:=false;
                v.x:=soustraire(C.x,B.x);
                v.y:=soustraire(C.y,B.y);
                v.z:=soustraire(C.z,B.z);
                if not CalcError then
                   begin
                   res:=interDP(B,v,A,u,indice1,indice2);
                   if res<>nil then
                      begin
                           if posB=0 then
                              begin
                                   der.ajouter_fin(New(Paffixe,init(B.x,B.y)));
                                   der.ajouter_fin(New(Paffixe,init(B.z,indice1)));
                              end
                              else
                              begin
                                   dev.ajouter_fin(New(Paffixe,init(B.x,B.y)));
                                   dev.ajouter_fin(New(Paffixe,init(B.z,indice1)));
                              end;
                           if posC=0 then
                              begin
                                   der.ajouter_fin(New(Paffixe,init(C.x,C.y)));
                                   der.ajouter_fin(New(Paffixe,init(C.z,indice2)));
                              end
                              else
                              begin
                                   dev.ajouter_fin(New(Paffixe,init(C.x,C.y)));
                                   dev.ajouter_fin(New(Paffixe,init(C.z,indice2)));
                              end;
                           der.ajouter_fin(res);
                           dev.ajouter_fin(res^.evaluer);
                      end;
                   end else exit;
           end;
    devant:=Paffixe(dev.tete);
    derriere:=Paffixe(der.tete);
end;
{================================}
procedure splitFacette(facette:Paffixe;Const A,u:Tpt3D;var devant, derriere, intersec:Paffixe;closed:boolean);
var
    last,M, vecAM, v:Tpt3d; {dernier point et point courant}
    first,first3d,finish, devok, derok:boolean;
    dev,der,inter:type_liste;
    index, res:Paffixe;
    pscal:real;
    indice1,indice2:real; {pour le Gouraud Shading}
    comptdev, comptder:longint;
    lastPos:integer; {0=out 1=on 2=in}

begin
      devant:=nil; derriere:=nil; intersec:=nil; dev.init; der.init; inter.init;
      lastPos:=2; finish:=false;
      devok:=false; derok:=false;comptdev:=0; comptder:=0;
      index:=facette; first3d:=true; first:=true;
      while index<>nil do
        begin
             if first then begin M.x:=index^.x; M.y:=index^.y; first:=false end
                      else
              begin
                         M.z:= index^.x; first:=true;  {on a un point}
                         CalcError:=false; indice2:=index^.y;
                         vecAM.x:=soustraire(M.x,A.x); vecAM.y:=soustraire(M.y,A.y);
                         vecAM.z:=soustraire(M.z,A.z);
                         pscal:=pscal3d(vecAM,u);
                         if not CalcError then
                         if (pscal=0) then // point dans le plan
                           if not finish then
                           begin
                                der.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                der.ajouter_fin(New(Paffixe,init(M.z,indice2)));
                                Inc(comptder);
                                dev.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                dev.ajouter_fin(New(Paffixe,init(M.z,indice2)));
                                inter.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                inter.ajouter_fin(New(Paffixe,init(M.z,indice2)));
                                Inc(comptdev);
                                lastPos:=1;
                           end else
                           else

                         if pscal>0 then {M est du bon coté}
                              begin
                                 if lastPos=0 then
                                        begin
                                                if not first3d then
                                                 begin
                                                   CalcError:=false;
                                                   v.x:=soustraire(M.x,last.x);
                                                   v.y:=soustraire(M.y,last.y);
                                                   v.z:=soustraire(M.z,last.z);
                                                   if not CalcError then
                                                        begin
                                                                res:=interDP(last,v,A,u,indice1,indice2);
                                                                if res<>nil then
                                                                 begin
                                                                  der.ajouter_fin(res);
                                                                  dev.ajouter_fin(res^.evaluer);
                                                                  inter.ajouter_fin(res^.evaluer);
                                                                  Inc(comptder);Inc(comptdev);
                                                                 end;
                                                        end;
                                                 end;
                                        end;
                                 lastPos:=2;
                                 if not finish then
                                  begin
                                        dev.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                        dev.ajouter_fin(New(Paffixe,init(M.z,indice2)));
                                        devok:=true; Inc(comptdev);
                                  end;
                              end  //fin bon coté
                              else {M est du mauvais coté}
                                begin
                                 if lastPos=2 then
                                   begin
                                      if not first3d then
                                                 begin
                                                   CalcError:=false;
                                                   v.x:=soustraire(M.x,last.x); v.y:=soustraire(M.y,last.y);
                                                   v.z:=soustraire(M.z,last.z);
                                                   if not CalcError then
                                                        begin
                                                                res:=interDP(last,v,A,u,indice1,indice2);
                                                                if res<>nil then
                                                                 begin
                                                                  der.ajouter_fin(res);
                                                                  dev.ajouter_fin(res^.evaluer);
                                                                  inter.ajouter_fin(res^.evaluer);
                                                                  Inc(comptdev);Inc(comptder);
                                                                 end;
                                                        end;
                                                 end;
                                   end;
                                 lastPos:=0;
                                 if not finish then
                                  begin
                                        der.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                        der.ajouter_fin(New(Paffixe,init(M.z,indice2)));
                                        derok:=true; Inc(comptder);
                                  end;
                                end; //fin mauvais coté
                         last:=M; indice1:=indice2; first3d:=false;
              end; {fin du else de if first}
        if finish and first then index:=nil else
                begin
                        index:=Paffixe(index^.suivant);
                        if (index=nil) and closed then
                         begin
                             index:=facette;
                             finish:=true;
                         end
                end;
        end;
      if (devok or (not derok)) And (comptdev>1)  then devant:=Paffixe(dev.tete) else dev.detruire;
      if derok And (comptder>1) then derriere:=Paffixe(der.tete) else der.detruire;
      intersec:=Paffixe(inter.tete)
end;
{================================}
procedure splitLine(facette:Paffixe;Const A,u:Tpt3D;var devant, derriere:Paffixe;closed:boolean);
var
    last,M, vecAM, v:Tpt3d; {dernier point et point courant}
    first,first3d,lastout, finish, devok, derok:boolean;
    dev,der:type_liste;
    index, res,aux:Paffixe;
    pscal:real;
    comptdev, comptder:longint;
    
    procedure addJump(var liste:type_liste);
    begin
         if (liste.tete<>nil) and (not Isjump(Paffixe(liste.queue))) then
         liste.ajouter_fin(New(Paffixe,init(jump^.x,0)))
    end;

begin
      devant:=nil; derriere:=nil; dev.init; der.init; lastOut:=false; finish:=false;
      devok:=false; derok:=false;comptdev:=0; comptder:=0;
      index:=facette; first3d:=true; first:=true;
      while index<>nil do
       if Isjump(index) then begin
                           AddJump(der); AddJump(dev);
                           index:=Paffixe(index^.suivant);
                           end
                      else
        begin
             if first then begin M.x:=index^.x; M.y:=index^.y; first:=false end
                      else
                       begin
                         M.z:= index^.x; first:=true;  {on a un point}
                         CalcError:=false;
                         vecAM.x:=soustraire(M.x,A.x); vecAM.y:=soustraire(M.y,A.y);
                         vecAM.z:=soustraire(M.z,A.z);
                         pscal:=pscal3d(vecAM,u);
                         if not CalcError then
                            if pscal>=0 then {M est du bon coté (devant)}
                              begin
                                 if lastOut then
                                        begin
                                                lastOut:=false;
                                                if not first3d then
                                                 begin
                                                   CalcError:=false;
                                                   v.x:=soustraire(M.x,last.x);
                                                   v.y:=soustraire(M.y,last.y);
                                                   v.z:=soustraire(M.z,last.z);
                                                   if not CalcError then
                                                        begin
                                                                res:=interDP(last,v,A,u,0,0);
                                                                if res<>nil then
                                                                 begin
                                                                  der.ajouter_fin(res);
                                                                  dev.ajouter_fin(res^.evaluer);
                                                                  AddJump(der);
                                                                  Inc(comptder);Inc(comptdev);
                                                                 end;
                                                        end;
                                                 end;
                                        end;
                                 if not finish then
                                  begin
                                        dev.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                        dev.ajouter_fin(New(Paffixe,init(M.z,0)));
                                        devok:=true; Inc(comptdev);
                                  end;
                              end
                              else {M est du mauvais coté}
                                begin
                                 if not lastout then
                                   begin
                                      lastOut:=true;
                                      if not first3d then
                                                 begin
                                                   CalcError:=false;
                                                   v.x:=soustraire(M.x,last.x);
                                                   v.y:=soustraire(M.y,last.y);
                                                   v.z:=soustraire(M.z,last.z);
                                                   if not CalcError then
                                                        begin
                                                                res:=interDP(last,v,A,u,0,0);
                                                                if res<>nil then
                                                                 begin
                                                                  der.ajouter_fin(res);
                                                                  dev.ajouter_fin(res^.evaluer);
                                                                  AddJump(dev);
                                                                  Inc(comptdev);Inc(comptder);
                                                                 end;
                                                        end;
                                                 end;
                                   end;
                                 if not finish then
                                  begin
                                        der.ajouter_fin(New(Paffixe,init(M.x,M.y)));
                                        der.ajouter_fin(New(Paffixe,init(M.z,0)));
                                        derok:=true; Inc(comptder);
                                  end;
                                end;
                         last:=M; first3d:=false;
                       end; {fin de if first}
        if finish and first then index:=nil else
                begin
                        index:=Paffixe(index^.suivant);
                        if (index=nil) and closed then
                         begin
                             index:=facette;
                             finish:=true;
                         end
                end;
        end;
      aux:=Paffixe(dev.queue);
      if IsJump(aux) then dev.supprimer(aux);
      aux:=Paffixe(der.queue);
      if IsJump(aux) then der.supprimer(aux);
      if (devok or (not derok)) And (comptdev>1)  then
      devant:=Paffixe(dev.tete) else dev.detruire;
      if derok And (comptder>1) then
      derriere:=Paffixe(der.tete) else der.detruire;
end;
{=================================}
{commande TClip3DLine}
function TClip3DLine.executer(arg: Pliste):Presult;
//Clip3DLine( ligne, plan, closed, var derriere)
var f1,f2,f3,f4:Pcorps;
    ligne, plan, devant,derriere,aux,T,facette:Paffixe;
    closed,Deline,sortieder:boolean;
    A,u:Tpt3d;
    res,der:type_liste;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3<>nil then f4:=Pcorps(f3^.suivant) else f4:=nil;
     if (f4<>nil) and
        (f4^.categorie=cat_constante) and (not Pconstante(f4^.contenu)^.predefinie)
        then
            begin
                 sortieder:=true;
                 Kill(Pcellule(Pconstante(f4^.contenu)^.affixe));
            end
        else sortieder:=false;

     if (f1^.categorie=cat_constante) then
        begin Deline:=false; ligne:=Paffixe(Pconstante(f1^.contenu)^.affixe)
        end
        else begin Deline:=true; ligne:=f1^.evalNum end;
     if (ligne=nil) or (ligne^.suivant=nil) then
        begin if Deline then Kill(Pcellule(ligne)); exit; end;
     aux:=f2^.evalNum;
     if (aux=nil) or (aux^.suivant=nil) then
        begin if Deline then Kill(Pcellule(ligne)); Kill(Pcellule(aux));exit end;
     plan:=aux;
     A.x:=plan^.x; A.y:=plan^.y;plan:=Paffixe(plan^.suivant);A.z:= plan^.x;
     plan:=Paffixe(plan^.suivant);
     u.x:=plan^.x; u.y:=plan^.y;plan:=Paffixe(plan^.suivant);u.z:=plan^.x;
     f3:=Pcorps(f2^.suivant);
     closed:=false;
     if f3<>nil then
        begin T:=f3^.evalNum;
              if T<>nil then closed:= (Round(T^.x) mod 2)=1;
              Kill(pcellule(T))
        end;

     facette:=ligne; res.init; der.init;
     // adaption de clipfacet
     while (facette<>nil) and Isjump(facette) do facette:=Paffixe(facette^.suivant);
     while facette<>nil do
           begin
                aux:=facette;
                while (aux<>nil) and (not Isjump(aux)) do aux:=Paffixe(aux^.suivant);
                if IsJump(aux) then aux^.precedent^.suivant:=nil; {on décroche la facette du reste}
                splitLine(facette, A,u, devant, derriere,closed);
                if devant<>nil then
                   begin
                       res.ajouter_fin(devant);
                       if aux<>nil then
                          res.ajouter_fin(new(Paffixe,init(jump^.x,aux^.y)));
                   end;
                if (sortieder) and (derriere<>nil) then
                   begin
                       der.ajouter_fin(derriere);
                       if aux<>nil then
                       der.ajouter_fin(new(Paffixe,init(jump^.x,aux^.y)));
                   end
                   else Kill(Pcellule(derriere));

                if IsJump(aux) then aux^.precedent^.suivant:=aux;{on raccroche la facette au reste}
                facette:=aux;
                while Isjump(facette) do facette:=Paffixe(facette^.suivant);
           end;
     //fin adaptation
        
     if Deline then Kill(Pcellule(ligne));
     Kill(Pcellule(aux));
     if sortieder then  Pconstante(f4^.contenu)^.affixe:=Paffixe(der.tete)
                  else  der.detruire;
     executer:= Paffixe(res.tete);
end;
{====================}
{commande TClipFacet}
function TClipFacet.executer(arg: Pliste):Presult;
//ClipFacette( facette(s), plan, derriere, intersec) derriere est une variable facultative permettant
// de récuperer l'autre partie des facettes, intersec est une variable facultative permettant
// de récuperer les intersections
var f1,f2,f3,f4:Pcorps;
    liste,facette,plan,devant,derriere,intersec,aux:Paffixe;
    A,u:Tpt3D;
    res,der,inter:type_liste;
    sortieder,sortieInter,delface:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if (f3<>nil) and
        (f3^.categorie=cat_constante) and (not Pconstante(f3^.contenu)^.predefinie)
        then
            begin
                 sortieder:=true;
                 Kill(Pcellule(Pconstante(f3^.contenu)^.affixe));
            end
        else sortieder:=false;
     if f3<>nil then f4:=Pcorps(f3^.suivant) else f4:=nil;
     
     if (f4<>nil) and
        (f4^.categorie=cat_constante) and (not Pconstante(f4^.contenu)^.predefinie)
        then
            begin
                 sortieInter:=true;
                 Kill(Pcellule(Pconstante(f4^.contenu)^.affixe));
            end
        else sortieInter:=false;
        
     if (f1^.categorie=cat_constante) then
        begin Delface:=false; liste:=Paffixe(Pconstante(f1^.contenu)^.affixe)
        end
        else begin Delface:=true; liste:=f1^.evalNum end;
     if (liste=nil) or (liste^.suivant=nil) then begin Kill(Pcellule(liste)); exit; end;
     plan:=f2^.evalNum;
     if (plan=nil) or (plan^.suivant=nil) or (plan^.suivant^.suivant=nil)
       or (plan^.suivant^.suivant^.suivant=nil)then
          begin Kill(Pcellule(facette)); Kill(Pcellule(plan));exit end;
          
     A.x:=plan^.x; A.y:=plan^.y; A.z:=Paffixe(plan^.suivant)^.x; aux:=Paffixe(plan^.suivant^.suivant);
     u.x:=aux^.x; u.y:=aux^.y; u.z:=Paffixe(aux^.suivant)^.x;

     facette:=liste; res.init; der.init; inter.init;
     
     while (facette<>nil) and Isjump(facette) do facette:=Paffixe(facette^.suivant);
     while facette<>nil do
           begin
                aux:=facette;
                while (aux<>nil) and (not Isjump(aux)) do aux:=Paffixe(aux^.suivant);
                if IsJump(aux) then aux^.precedent^.suivant:=nil; {on décroche la facette du reste}
                splitFacette(facette, A, u, devant, derriere,intersec,true);
                if devant<>nil then
                   begin
                       res.ajouter_fin(devant);
                       if aux<>nil then
                          res.ajouter_fin(new(Paffixe,init(jump^.x,aux^.y)));
                   end;
                if derriere<>nil then
                   begin
                       der.ajouter_fin(derriere);
                       if aux<>nil then
                       der.ajouter_fin(new(Paffixe,init(jump^.x,aux^.y)));
                   end;
                if intersec<>nil then
                   begin
                       inter.ajouter_fin(intersec);
                       inter.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)));
                   end;
                if IsJump(aux) then aux^.precedent^.suivant:=aux;{on raccroche la facette au reste}
                facette:=aux;
                while Isjump(facette) do facette:=Paffixe(facette^.suivant);
           end;
     Kill(Pcellule(plan));
     if delface then Kill(Pcellule(liste));
     if sortieder then  Pconstante(f3^.contenu)^.affixe:=Paffixe(der.tete)
                  else der.detruire;
     if sortieInter then  Pconstante(f4^.contenu)^.affixe:=Paffixe(inter.tete)
                    else inter.detruire;
     executer:= Paffixe(res.tete);
end;
{=================================}
procedure colorier( var facettes: Paffixe;Const couleur:Tcolor;Const backculling:boolean;Const contrast:real;
                    Const nobehind:boolean);
var
   index1,index2,aux:Paffixe;
   U,V,W,G,camera,lum:Tpt3d;
   i,nbsommets,first:integer;
   eclairage,Ncamera:real;
   visible,sgneg:boolean;
   eclairer:boolean;
   rcolor,gcolor,bcolor:longint;
   l:type_liste;
   

  begin
  rcolor:=GetRvalue(couleur);
  gcolor:=GetGvalue(couleur);
  bcolor:=GetBvalue(couleur);
  CalculerN;
  if GouraudShading then lum:=Light else lum:=N;
  l.init; l.ajouter_fin(facettes);
  index1:=facettes; eclairer:=(contrast>0);
  while index1<>nil do
   begin
        index2:=index1; nbsommets:=0; first:=0; G.x:=0; G.y:=0; G.z:=0; {centre de gravité}
        while (index1<>nil) and (not IsJump(index1)) do
          begin {on extrait la facette, calcule son centre, sa cote}
               Inc(first);
               if first=1 then
                        begin G.x:=G.x+index1^.x; G.y:=G.y+index1^.y;
                              case nbsommets of
                              0: begin U.x:= -index1^.x; U.y:=-index1^.y;
                                       V.x:= -index1^.x; V.y:=-index1^.y
                                 end;
                              1: begin U.x:= index1^.x+U.x; U.y:=index1^.y+U.y end;
                              2: begin V.x:= index1^.x+V.x; V.y:=index1^.y+V.y end;
                              end;
                        end
                        else begin G.z:=G.z+index1^.x; first:=0;
                                   case nbsommets of
                                   0: begin U.z:= -index1^.x; V.z:=-index1^.x;
                                      end;
                                   1: U.z:= index1^.x+U.z;
                                   2: V.z:= index1^.x+V.z;
                                   end;
                                   inc(nbsommets);
                             end;

               index1:=Paffixe(index1^.suivant)
          end;
        if nbsommets<>0 then
                begin
                        G.x:=G.x/nbsommets; G.y:=G.y/nbsommets; G.z:=G.z/nbsommets;
                        G:=Mtransform3D(G);  {le tri se fait sur les points transformés}
                        CalcError:=false;
                        W:=Normalize(pvect(Vtransform3D(U),Vtransform3D(V)));
                        //if nobehind then eclairage:=abs(pscal3d(W,Light))
                        //            else eclairage:=pscal3d(W,Light);
                        if centrale then
                           begin
                                camera.x:=ajouter(posCam.x,-G.x);
                                camera.y:=ajouter(posCam.y,-G.y);
                                camera.z:=ajouter(posCam.z,-G.z);
                                Ncamera:=Norm(camera);
                                visible:=pscal3d(W,camera)/Ncamera>0;
                           end
                        else visible:=pscal3d(W,N)>0;//eclairage>0;
                        if visible or (nobehind) then eclairage:=abs(pscal3d(W,lum))//N))
                                   else
                                   eclairage:=-abs(pscal3d(W,lum));//N))
                        if not CalcError then
                              begin
                                   if eclairer and (eclairage<>0) then
                                      begin
                                           sgneg:=eclairage<0;
                                           eclairage:=exp(ln(abs(eclairage))/2.5*contrast); //2.5*thefacet^.theNuance
                                           if sgneg then eclairage:=-eclairage
                                      end;
                              end
                              else begin eclairage:=Jump^.y; visible:=true end;
                        if index1=nil //il manque le jump final
                          then
                                begin
                                        aux:=index2;
                                        while aux^.suivant<>nil do
                                                aux:=Paffixe(aux^.suivant);
                                        if eclairer then
                                                l.ajouter_fin(New(Paffixe,init(Jump^.x, 2+getFillColor(rcolor,gcolor,bcolor,eclairage))))
                                                //la couleur est augmentée de 2
                                                    else
                                                l.ajouter_fin(New(Paffixe,init(Jump^.x, 2+getFillColor(rcolor,gcolor,bcolor,1))));
                                        //aux^.suivant^.precedent:=aux;
                                        aux:=nil;
                                end
                          else begin
                                        if eclairer then index1^.y:=2+getFillColor(rcolor,gcolor,bcolor,eclairage)
                                                    else index1^.y:=2+getFillColor(rcolor,gcolor,bcolor,1);
                                        aux:=Paffixe(index1^.suivant);
                                        //if aux<>nil then aux^.precedent:=nil;
                                        //index1^.suivant:=nil;
                               end;
                        if backculling and (not visible) then //on elimine la facette
                           begin
                                while index2<>aux do l.supprimer(index2);
                                //Kill(PCellule(index2));
                           end;
                        index1:=aux
                end else if index1<>nil then index1:=Paffixe(index1^.suivant);
   end;
   facettes:=Paffixe(l.tete)
end;

function TPaintFacet.executer(arg: Pliste):Presult;
//PaintFacet( variable(=liste Facettes), couleur,backculling(=0/1)+i*contrast(=1 par defaut)): renvoie la liste des facettes
// après avoir inserer la couleur dans le jump de chaque facette, pas de tri.
var f1, f2,f3:Pcorps;
    T1,T:Paffixe;
    contrast:real;
    couleur:longint;
    backculling,nobehind:boolean;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
     T1:=f1^.evalNum;
     if T1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;     //on attend une couleur
     T:=f2^.evalNum;
     if (T=Nil) then begin Kill(Pcellule(T1)); exit end;
     //T pointe sur une couleur
     couleur:=Round(abs(T^.x));
     nobehind:=(Round(abs(T^.y)) mod 2)=1;
     Kill(Pcellule(T));
     f3:=Pcorps(f2^.suivant);
     backculling:=false;contrast:=1;
     if f3<>Nil then
                   begin
                        T:=f3^.evalNum;
                        if T<>Nil then
                           begin contrast:=T^.y;
                                 backculling:=(T^.x=1)
                           end;
                        Kill(Pcellule(T));
                   end;
     //on a le contrast
     colorier(T1,couleur,backculling,contrast, nobehind);
     executer:=T1
end;
{=================================}
type Tfacette=record
               cote:real;
               sommets:Paffixe;
               end;

     Pfacette=^Tfacette;

function Trier(Item1, Item2: Pointer): Integer;
    var x:real;
    begin
         CalcError:=False;
         x:= soustraire(Pfacette(Item1).cote , Pfacette(Item2).cote);
         if CalcError then result:=0
         else
         if x<0 then result:=-1
                else if x>0 then result:=1
                            else result:=0;
    end;

procedure TraiterFacettes(Var Entree:Paffixe;Const faireTri, gerercacher:boolean;Const contrast:real;
                           Const nobehind:boolean; const tree:boolean);
var
   table:TList;
   index1,index2,aux:Paffixe;
   facette:Pfacette;
   U,V,W,G,camera,lum:Tpt3d;
   i,nbsommets,first:integer;
   res:type_liste;
   eclairage,Ncamera:real;
   visible,sgneg:boolean;
   Comparer:TlistSortCompare;
   eclairer,SameJump:boolean;

   procedure ranger (const i,j:longint);
   var k: longint;
   begin
        if i>j then exit;
        k:= (i+j) div 2;
        res.ajouter_fin(PFacette(table.Items[k])^.sommets);
        dispose(Pfacette(table.Items[k]));
        ranger(i,k-1); ranger(k+1,j)
   end;

  begin  {trierfacette}
  CalculerN;
  if GouraudShading then lum:=Light else lum:=N;
  table:=Tlist.create;
  index1:=Entree; eclairer:=(contrast>0);
  SameJump:=(contrast=-1);
  while index1<>nil do
   begin
        index2:=index1; nbsommets:=0; first:=0; G.x:=0; G.y:=0; G.z:=0; {centre de gravité}
        while (index1<>nil) and (not IsJump(index1)) do
          begin {on extrait la facette, calcule son centre, sa cote}
               Inc(first);
               if first=1 then
                        begin G.x:=G.x+index1^.x; G.y:=G.y+index1^.y;
                              case nbsommets of
                              0: begin U.x:= -index1^.x; U.y:=-index1^.y;
                                       V.x:= -index1^.x; V.y:=-index1^.y
                                 end;
                              1: begin U.x:= index1^.x+U.x; U.y:=index1^.y+U.y end;
                              2: begin V.x:= index1^.x+V.x; V.y:=index1^.y+V.y end;
                              end;
                        end
                        else begin G.z:=G.z+index1^.x; first:=0;
                                   case nbsommets of
                                   0: begin U.z:= -index1^.x; V.z:=-index1^.x;
                                      end;
                                   1: U.z:= index1^.x+U.z;
                                   2: V.z:= index1^.x+V.z;
                                   end;
                                   inc(nbsommets);
                             end;

               index1:=Paffixe(index1^.suivant)
          end;
        if nbsommets<>0 then
                begin
                        G.x:=G.x/nbsommets; G.y:=G.y/nbsommets; G.z:=G.z/nbsommets;
                        G:=Mtransform3D(G);  {le tri se fait sur les points transformés}
                        CalcError:=false;
                        W:=Normalize(pvect(Vtransform3D(U),Vtransform3D(V)));

                        if centrale then
                           begin
                                camera.x:=ajouter(posCam.x,-G.x);
                                camera.y:=ajouter(posCam.y,-G.y);
                                camera.z:=ajouter(posCam.z,-G.z);
                                Ncamera:=Norm(camera);
                                visible:=pscal3d(W,camera)/Ncamera>0;
                           end
                        else visible:=pscal3d(W,N)>0;
                        
                        if visible or (nobehind) then eclairage:=abs(pscal3d(W,lum))//N))
                                   else
                                   eclairage:=-abs(pscal3d(W,lum));//N))
                                  
                        if not CalcError   then
                              begin
                                   if eclairer and (eclairage<>0) then
                                      begin
                                           sgneg:=eclairage<0;
                                           eclairage:=exp(ln(abs(eclairage))/2.5*contrast); //2.5*thefacet^.theNuance
                                           if sgneg then eclairage:=-eclairage
                                      end;
                              end
                              else begin eclairage:=Jump^.y; visible:=true end;
                        New(Facette);
                        if centrale then
                           Facette.cote:=-Ncamera
                         else Facette.cote:=pscal3d(G,N);
                        if index1=nil //il manque le jump final
                          then
                                begin
                                        aux:=index2;
                                        while aux^.suivant<>nil do
                                                aux:=Paffixe(aux^.suivant);
                                        if eclairer then
                                                aux^.suivant:= New(Paffixe,init(Jump^.x, eclairage))
                                                    else
                                                aux^.suivant:= New(Paffixe,init(Jump^.x, Jump^.y));
                                        aux^.suivant^.precedent:=aux;
                                        aux:=nil;
                                end
                          else begin
                                        if eclairer then index1^.y:=eclairage
                                                    else {if Not SameJump then index1^.y:=jump^.y};
                                                    // sinon les jump ne sont pas modifies si contrast=-1
                                        aux:=Paffixe(index1^.suivant);
                                        if aux<>nil then aux^.precedent:=nil;
                                        index1^.suivant:=nil;
                               end;
                        Facette.sommets:=index2;
                        if ((not gerercacher) or visible) then table.add(Facette)
                                                          else dispose(Facette);
                        index1:=aux
                end else if index1<>nil then index1:=Paffixe(index1^.suivant);
   end;
   if faireTri Or tree then
      begin
           comparer:=@trier;
           table.Sort(comparer);
      end;
   res.init;
   if tree then ranger(0, table.count-1)
   else
   for i:=0 to table.count-1 do
       begin
            res.ajouter_fin(PFacette(table.Items[i])^.sommets);
            dispose(Pfacette(table.Items[i]));
       end;
   table.free;
   Entree:=Paffixe(res.tete);
end;
{=======================}
{commande TSortFacet}
function TSortFacet.executer(arg: Pliste):Presult;
//SortFacet( liste facettes, backculling(0/1)+i*contrast)
// contrast=0: pas de contraste couleur unie, constrast=1: normal, contrast=-1 (defaut): la constante
// jump des facettes n'est pas modifiée
var f1,f2:Pcorps;
    T,aux:Paffixe;
    cacher:boolean;
    contrast:real;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if (f1=nil)  then exit;
     T:=f1^.evalNum;
     if T=nil then exit;
     cacher:=false; contrast:=-1;
     f2:=Pcorps(f1^.suivant);
     if f2<>nil then aux:=f2^.evalNum else aux:=nil;
     if aux<>nil then
        begin
                cacher:= (Round(aux^.x) mod 2)=1;
                contrast:= aux^.y;
                Kill(Pcellule(aux));
        end;
    TraiterFacettes(T,true,cacher,contrast,false,false); // true signifie avec tri
    executer:=T;
end;
{=======================}
type Tfacet=record  //cat=1 ou 0 (cloison non affichée) ou -1 (méthode de Gouraud)
               sommets:Paffixe; // liste des sommets, ne se termine pas par jump
               point:Tpt3D ; //point  du plan
               vect: Tpt3D; //vecteur normal au plan de la facette
               couleur: longint;
               opacity:real;
               theNuance:real;//faire varier ou non la couleur en fonction du vecteur N
               eclair:real; //pour régler l'intensité de l'éclairage
               devder:shortint;// -1: pas visible, 0 ou 1: indique si on distingue devant/derriere
               Gouraud:boolean; // méthode de Gouraud?
               inverse:boolean;//indique si le vecteur normal est vers l'observateur(false) ou non
              end;
    Pfacet=^Tfacet;

    TLine3d=record //cat=2
               sommets:Paffixe; // ne se termine pas par jump
               couleur: longint;
               opacity:real;
               width:real;
               linestyle:integer;
              end;
    PLine3d=^TLine3d;
    
    TDot3d=record //cat=3 point ou label
               sommets:Paffixe; // ne se termine pas par jump
               couleur: longint;
               opacity:real;
               width:real;
               linestyle:integer;
               Islabel:byte;//0=point 1=label 2=TexLabel
              end;
    PDot3d=^TDot3d;
    
    

    objet3D=^Tobjet3D;
    Tobjet3D= record
                 cat: byte; //1=facette   2=seg
                 donnees: pointer; //facette ou seg
                 devant, derriere:objet3D;
                 //equilibre:integer;
               end;

var scene:objet3D;

function DotDevantDot(Const dot1,dot2:Paffixe):boolean;
//determine si dot1 est devant dot2
var a,b,O:Tpt3D;
    aux:Paffixe;
    d1,d2:real;
begin
     aux:=dot1; a.x:=aux^.x; a.y:=aux^.y; aux:=Paffixe(aux^.suivant);a.z:=aux^.x;
     aux:=dot2;
     b.x:=aux^.x; b.y:=aux^.y; aux:=Paffixe(aux^.suivant);b.z:=aux^.x;
     a:=Mtransform3d(a);b:=Mtransform3d(b);
     CalcError:=false;
     if centrale then
        begin
             O.x:=Dcamera*N.x; O.y:=Dcamera*N.y; O.z:=Dcamera*N.z;
             a.x:=soustraire(a.x,O.x);
             a.y:=soustraire(a.y,O.y);
             a.z:=soustraire(a.z,O.z);
             b.x:=soustraire(b.x,O.x);
             b.y:=soustraire(b.y,O.y);
             b.z:=soustraire(b.z,O.z);
             d1:=Norm(a); d2:=Norm(b);
        end
     else
         begin
            d2:=pscal3d(a,N);
            d1:=pscal3d(b,N);
         end;
     if CalcError then begin result:= random(2)=1 end
                  else
                       result:= d1<=d2
end;

function DotDevantSeg(Const dot,seg:Paffixe):boolean;
//determine si dot est devant seg
var a,b,c,V,W:Tpt3D;
    aux:Paffixe;
    H,OH,oa:Tpt3d;
    delta:real;
begin
     aux:=dot; a.x:=aux^.x; a.y:=aux^.y; aux:=Paffixe(aux^.suivant);a.z:=aux^.x;
     aux:=seg;
     b.x:=aux^.x-a.x; b.y:=aux^.y-a.y; aux:=Paffixe(aux^.suivant);b.z:=aux^.x-a.z;
     aux:=Paffixe(aux^.suivant);
     c.x:=aux^.x-a.x; c.y:=aux^.y-a.y; aux:=Paffixe(aux^.suivant);c.z:=aux^.x-a.z;
     CalcError:=false;
     a:=Mtransform3d(a);b:=Vtransform3d(b);c:=Vtransform3d(c);
     if CalcError then begin result:=false; exit end;
     V.x:=c.x-b.x; V.y:=c.y-b.y; V.z:=c.z-b.z;
     if centrale then
        begin

             OA.x:=a.x-posCam.x; OA.y:=a.y-posCam.y; OA.z:=a.z-posCam.z;
        end
        else OA:=N;
     if abs(det3d(OA,b,c))<1E-6 then {droites (BC) et (OA) coplanaires}
        begin
             CalcError:=false;
             W:=pvect(OA,V);
             delta:=diviser(det3d(b,V,W),pscal3d(W,W));
             H.x:=ajouter(a.x, multiplier(delta,OA.x));
             H.y:=ajouter(a.y, multiplier(delta,OA.y));
             H.z:=ajouter(a.z, multiplier(delta,OA.z));
             if centrale then
               begin
                    OH.x:=soustraire(H.x,posCam.x);
                    OH.y:=soustraire(H.y,posCam.y);
                    OH.z:=soustraire(H.z,posCam.z);
               end;

             if CalcError then result:=true
                else
                    if centrale then result:= Norm(OA)<=Norm(OH)
                                else result:= pscal3d(A,N)>=pscal3d(H,N)
        end
     else result:=true {point devant par convention}
end;

function SegDevantCentrale(Const seg1,seg2:Paffixe):boolean;
//determine si seg1 est devant seg2 dans le cas de la projection centrale
var a,b,c,d:Tpt3D;
    aux:Paffixe;
    H1,H2,O,oc,oa:Tpt3d;
    delta,t1,t2:real;
begin
     {on cherche une sécante commune à seg1=(AB) et seg2=(CD) passant par O centre de la projection,
      si elle existe, elle coupe (AB) en H1 et (CD) en H2, si d(H1,O) est supérieur à d(H2,O),
      alors la droite (AB) est devant la droite (CD).
      Si elle n'existe pas alors les deux projections ne se coupent pas}

     //seg1=AB seg2=CD on calcule les vecteurs b=AB d=CD avec c=C avec a=A

     aux:=seg1; a.x:=aux^.x; a.y:=aux^.y; aux:=Paffixe(aux^.suivant);a.z:=aux^.x;
     aux:=Paffixe(aux^.suivant);
     b.x:=aux^.x-a.x; b.y:=aux^.y-a.y; aux:=Paffixe(aux^.suivant);b.z:=aux^.x-a.z;
     aux:=seg2;
     c.x:=aux^.x; c.y:=aux^.y; aux:=Paffixe(aux^.suivant);c.z:=aux^.x;
     aux:=Paffixe(aux^.suivant);
     d.x:=aux^.x-c.x; d.y:=aux^.y-c.y; aux:=Paffixe(aux^.suivant);d.z:=aux^.x-c.z;
     a:=Mtransform3d(a);b:=Vtransform3d(b);c:=Mtransform3d(c);d:=Vtransform3d(d);
     O.x:=Dcamera*N.x; O.y:=Dcamera*N.y; O.z:=Dcamera*N.z;
     OC.x:=c.x-O.x; OC.y:=c.y-O.y; OC.z:=c.z-O.z;
     OA.x:=a.x-O.x; OA.y:=a.y-O.y; OA.z:=a.z-O.z;
     CalcError:=false;
     t1:=-diviser(det3d(OA,OC,d), det3d(b,OC,d)); t2:=-diviser( det3d(OC,OA,b), det3d(d,OA,b));
     H1.x:= ajouter(OA.x, multiplier(t1,b.x));
     H1.y:= ajouter(OA.y, multiplier(t1,b.y));
     H1.z:= ajouter(OA.z, multiplier(t1,b.z));
     H2.x:= ajouter(OC.x, multiplier(t2,d.x));
     H2.y:= ajouter(OC.y, multiplier(t2,d.y));
     H2.z:= ajouter(OC.z, multiplier(t2,d.z));
     if CalcError then begin result:= random(2)=1 end
                  else
                       result:= Norm(H1)<=Norm(H2)
end;

function SegDevant(Const seg1,seg2:Paffixe):boolean;
//determine si seg1 est devant seg2 dans le cas de la projection orthographique
var a,b,c,d:Tpt3D;
    aux:Paffixe;
    H1,H2:Tpt3d;
    delta,t1,t2:real;
begin

     if centrale then begin result:=SegDevantCentrale(seg1,seg2); exit end;
     {on cherche une sécante commune à seg1=(AB) et seg2=(CD) de direction N,
      si elle existe, elle coupe (AB) en H1 et (CD) en H2, si <H1|N> est supérieur à <H2|N>,
      alors la droite (AB) est devant le droite (CD).
      Si elle n'existe pas alors les deux droites sont parallèles}
      
     //seg1=AB seg2=CD on calcule les vecteurs b=AB d=CD et c=AC avec a=A

     aux:=seg1; a.x:=aux^.x; a.y:=aux^.y; aux:=Paffixe(aux^.suivant);a.z:=aux^.x;
     aux:=Paffixe(aux^.suivant);
     b.x:=aux^.x-a.x; b.y:=aux^.y-a.y; aux:=Paffixe(aux^.suivant);b.z:=aux^.x-a.z;
     aux:=seg2;
     c.x:=aux^.x-a.x; c.y:=aux^.y-a.y; aux:=Paffixe(aux^.suivant);c.z:=aux^.x-a.z;
     aux:=Paffixe(aux^.suivant);
     d.x:=aux^.x-c.x-a.x; d.y:=aux^.y-c.y-a.y; aux:=Paffixe(aux^.suivant);d.z:=aux^.x-c.z-a.z;
     CalcError:=false;
     a:=Mtransform3d(a);b:=Vtransform3d(b);c:=Vtransform3d(c);d:=Vtransform3d(d);
     delta:=det3d(b,d,N);
     t2:=-diviser(det3d(a,c,N), delta); t1:=-diviser( det3d(d,c,N), delta);
     H1.x:= ajouter(a.x, multiplier(t1,b.x));
     H1.y:= ajouter(a.y, multiplier(t1,b.y));
     H1.z:= ajouter(a.z, multiplier(t1,b.z));
     H2.x:= ajouter(ajouter(c.x,a.x), multiplier(t2,d.x));
     H2.y:= ajouter(ajouter(c.y,a.y), multiplier(t2,d.y));
     H2.z:= ajouter(ajouter(c.z,a.z), multiplier(t2,d.z));
     if CalcError then begin result:= random(2)=1 end
                  else
                       result:= pscal3d(H1,N)>=pscal3d(H2,N)
end;
(*================
boolean equilibreD ( NoeudAVL r, NoeudAVL p, boolean g){
   // r est le fils gauche de p si g vaut true, r est le fils droit de p si g vaut false
   // retourne true si après équilibrage l'arbre a grandi
  NoeudAVL r1, r2;
  switch(r.equilibre){
      case -1 : r.equilibre = 0; return false;
      case  0 : r.equilibre = 1; return true;
      case  1 :
      default : r1 = r.droit;
	        if(r1.equilibre == 1){
		   r.droit = r1.gauche; r1.gauche = r;
		   r.equilibre = 0;
		   r = r1 ;
		}else{
		   r2 = r1.gauche; r1.gauche = r2.droit;
		   r2.droit = r1;
		   r.droit = r2.gauche; r2.gauche = r;
		   if(r2.equilibre == 1) r.equilibre = -1;
		   else                  r.equilibre = 0;
		   if(r2.equilibre == -1) r1.equilibre = 1;
		   else                   r1.equilibre = 0;
		   r = r2;
		}
		// refaire le chaînage avec le père
		if(p==null) racine = r;
		else if( g ) p.gauche = r ;
		     else p.droit = r ;
		r.equilibre = 0;
		return false;
   }
}

function equilibreD(var r,p:objet3D; devant :boolean): boolean;
{ équilibrage droit de r qui  est un des fils de p}
var r1,r2:objet3D;
begin
   case r.equilibre of
      -1 : begin r.equilibre:=0; Result:=false end;
       0 : begin r.equilibre:=1; Result:=true end;
       1 : begin r1:=r.derriere;
	         if (r1.equilibre=1) then
                   begin
		        r.derriere:= r1.devant; r1.devant:=r;
		        r.equilibre:=0; r:=r1;
                   end
                 else
                   begin
		     r2:=r1.devant; r1.devant:=r2.derriere;
		     r2.derriere:= r1;
		     r.derriere:= r2.devant; r2.devant:= r;
		     if (r2.equilibre=1) then r.equilibre:=-1  else r.equilibre:= 0;
		     if (r2.equilibre=-1) then r1.equilibre:=1  else r1.equilibre:=0;
		     r:=r2;
		  end;
		// refaire le chaînage avec le père
		if (p=nil) then scene:=r
		else  if devant then p.devant:=r  else p.derriere:=r;
		r.equilibre:=0;
		result:=false;
           end;
   end;
end;

(*boolean equilibreG (NoeudAVL r, NoeudAVL p, boolean g){
     // r est le fils gauche de p si g vaut  true, r est le fils droit de p si g vaut false
     // retourne true si après équilibrage l'arbre a grandi
     NoeudAVL r1, r2;
     switch (r.equilibre){
         case 1 : r.equilibre=0; return false;
         case 0 : r.equilibre = -1; return true;
         case -1 :
         default : r1 = r.gauche;
	     if(r1.equilibre==-1){
	        r.gauche = r1.droit; r1.droi t= r;
	        r.equilibre = 0; r = r1;
	     }else{
	        r2 = r1.droit; r1.droit = r2.gauche; r2.gauche=r1;
	        r.gauche=r2.droit; r2.droit = r;
	        if(r2.equilibre == -1) r.equilibre = 1;
	        else               r.equilibre = 0;
	        if(r2.equilibre == 1) r1.equilibre =-1;
	        else               r1.equilibre = 0;
	        r=r2;
	   }
	   // refaire le chaînage avec le père
	   if (p == null) racine = r;
	   else if( g ) p.gauche = r ;
	        else     p.droit = r ;
	   r.equilibre = 0;
	   return false;
   }
function equilibreG(var r,p:objet3D; devant :boolean): boolean;
{ équilibrage gauche de r qui  est un des fils de p}
var r1,r2:objet3D;
begin
      // r est le fils gauche de p si g vaut  true, r est le fils droit de p si g vaut false
     // retourne true si après équilibrage l'arbre a grandi
     case r.equilibre of
     1 : begin r.equilibre:=0; Result:= false end;
     0 : begin r.equilibre:=-1; Result:=true end;
    -1 : begin
             r1:=r.devant;
	     if (r1.equilibre=-1) then
               begin
	        r.devant:=r1.derriere; r1.derriere:=r;
	        r.equilibre:=0; r:=r1;
               end
              else
               begin
	        r2:=r1.derriere; r1.derriere:=r2.devant; r2.devant:=r1;
	        r.devant:=r2.derriere; r2.derriere:=r;
	        if (r2.equilibre=-1) then r.equilibre:=1 else r.equilibre:=0;
	        if (r2.equilibre=1) then r1.equilibre:=-1 else r1.equilibre:=0;
	        r:=r2;
              end;
	     // refaire le chaînage avec le père
	     if (p=nil) then scene:=r
	        else if devant then p.devant:=r else p.derriere:=r;
	     r.equilibre:=0;
	     result:=false;
          end;
     end;
end;

(*void ajouter ( Comparable x){
    ajoutAVL( racine, null, true, x);
}

boolean ajoutAVL(NoeudAVL r, NoeudAVL p, boolean g, Comparable e){
   if(r == null) {
       r = new NoeudAVL(e, null, null);
       if (p == null) racine  = r
       else if(g) p.gauche = r;
            else  p.droit = r;
       return true;
   }else{
      int a = e.compareTo(r.element);
      if (a==0) return false;// a déjà présent dans l'arbre
      if (a<0)
          if(ajoutAVL(r.gauche, r, true, e)) return equilibreG(r, p, g);
          else return false;
      else
          if(ajoutAVL(r.droit, r, false, e)) return equilibreD(r, p, g);
          else return false;
   }
}
============================*)

procedure insererF(Const facette:Pfacet;var TheScene:objet3D);  //inserer facette
   var dev, der,inter,aux:Paffixe;
       face1, face2:Pfacet;
       code1:longint;
       ok1,ok2,ok3:boolean;
   begin
         ok1:=false;ok2:=false;
         if TheScene=nil then
                        begin
                                TheScene:=new(objet3D);
                                TheScene^.donnees:=facette;
                                TheScene^.cat:=1;
                                TheScene^.devant:=nil;
                                TheScene^.derriere:=nil;
                                //TheScene^.equilibre:=0;
                        end
                       else
            begin
                   splitFacette(facette^.sommets,
                         Pfacet(TheScene^.donnees)^.point,
                         Pfacet(TheScene^.donnees)^.vect,dev,der,inter,true);
                         if Pfacet(TheScene^.donnees)^.inverse then
                            begin
                                 aux:=der; der:=dev; dev:=aux
                            end;
                   if dev<>nil then
                    begin
                         face1:=new(Pfacet);
                         face1^.sommets:=dev;
                         face1^.point:=facette^.point;
                         face1^.vect:=facette^.vect;
                         face1^.couleur:=facette^.couleur;
                         face1^.opacity:=facette^.opacity;
                         face1^.theNuance:=facette^.theNuance;
                         face1^.devder:=facette^.devder;
                         face1^.gouraud:=facette^.gouraud;
                         face1.inverse:=facette.inverse;
                         face1.eclair:=facette.eclair;
                         insererF(face1, TheScene^.devant);
                    end;
                   if der<>nil then
                    begin
                         face2:=new(Pfacet);
                         face2^.sommets:=der;
                         face2^.point:=facette^.point;
                         face2^.vect:=facette^.vect;
                         face2^.couleur:=facette^.couleur;
                         face2^.opacity:=facette^.opacity;
                         face2^.theNuance:=facette^.theNuance;
                         face2^.devder:=facette^.devder;
                         face2^.gouraud:=facette^.gouraud;
                         face2.inverse:=facette.inverse;
                         face2.eclair:=facette.eclair;
                         insererF(face2, TheScene^.derriere);
                    end;
                    Kill(Pcellule(facette^.sommets));
                    Kill(Pcellule(inter));
                    dispose(facette);
                    //ok3:=ok1 and ok2;
                    //if ok1 and (not ok2) then ok3:=equilibreG(TheScene, pere,devant);
                    //if ok2 and (not ok1) then ok3:=equilibreD(TheScene, pere,devant);
                    //result:=ok3
           end;
   end;

   procedure insererS(Const seg:PLine3d;var TheScene:objet3D);  //inserer segment
   var dev, der, aux:Paffixe;
       seg1, seg2:PLine3d;
   begin
         if TheScene=nil then
                        begin
                                TheScene:=new(objet3D);
                                TheScene^.cat:=2; TheScene^.donnees:=seg;
                                TheScene^.devant:=nil; TheScene^.derriere:=nil;
                        end
                         else
             begin
          if TheScene^.cat=1
             then
                 begin
                   splitSeg(seg^.sommets,
                         Pfacet(TheScene^.donnees)^.point,
                         Pfacet(TheScene^.donnees)^.vect,dev,der,
                         Pfacet(TheScene^.donnees)^.inverse);
                   if Pfacet(TheScene^.donnees)^.inverse then
                            begin
                                 aux:=der; der:=dev; dev:=aux
                            end;
                   if dev<>nil then
                    begin
                         seg1:=new(PLine3D); seg1^.sommets:=dev;
                         seg1^.couleur:=seg^.couleur;
                         seg1^.opacity:=seg^.opacity;
                         seg1^.width:=seg^.width;
                         seg1^.linestyle:=seg^.linestyle;
                         insererS(seg1, TheScene^.devant)
                    end;
                    if der<>nil then
                    begin
                         seg2:=new(PLine3D); seg2^.sommets:=der;
                         seg2^.couleur:=seg^.couleur;
                         seg2^.opacity:=seg^.opacity;
                         seg2^.width:=seg^.width;
                         seg2^.linestyle:=seg^.linestyle;
                         insererS(seg2, TheScene^.derriere)
                    end;
                    Kill(Pcellule(seg^.sommets));
                    dispose(seg);
                  end
             else
                 if SegDevant(seg^.sommets, Pline3D(TheScene^.donnees)^.sommets) then
                      insererS(seg, TheScene^.devant)
                else
                   insererS(seg, TheScene^.derriere)
             end

   end;
   
   procedure insererD(Const dot:PDot3d;var TheScene:objet3D);  //inserer points
   var dot1:PDot3d;
       T,aux:Paffixe;
       A,B,V:Tpt3d;
       res:real;
       inverse:boolean;
   begin
         if TheScene=nil then
                        begin
                                TheScene:=new(objet3D);
                                TheScene^.cat:=3; TheScene^.donnees:=dot;
                                TheScene^.devant:=nil; TheScene^.derriere:=nil;
                        end
                         else
             begin
          if TheScene^.cat=1 //facettes
             then
                 begin
                      B:=Pfacet(TheScene^.donnees)^.point;
                      A.x:=dot^.sommets^.x-B.x;
                      A.y:=dot^.sommets^.y-B.y;
                      A.z:=Paffixe(dot^.sommets^.suivant)^.x-B.z;
                      V:=Pfacet(TheScene^.donnees)^.vect;
                      res:=pscal3d(A,V);
                      inverse:=Pfacet(TheScene^.donnees)^.inverse;
                      if (res>=0) then
                         if not inverse then insererD(dot, TheScene^.devant)
                                        else insererD(dot, TheScene^.derriere);
                      if (res<0) then
                         if inverse then insererD(dot, TheScene^.devant)
                                    else insererD(dot, TheScene^.derriere);
                end
             else
          if TheScene^.cat=2 then //segments
                 if DotDevantSeg(dot^.sommets, PDot3D(TheScene^.donnees)^.sommets) then
                      insererD(dot, TheScene^.devant)
                else
                   insererD(dot, TheScene^.derriere)
             else
          if TheScene^.cat=3 then //points
                 if DotDevantDot(dot^.sommets, PDot3D(TheScene^.donnees)^.sommets) then
                   insererD(dot, TheScene^.devant)
                else
                   insererD(dot, TheScene^.derriere)
             end

   end;
{=======================================}
procedure detruire3D(var TheScene:objet3D);
var i:integer;
   begin
        if TheScene=nil then exit;
        detruire3D(TheScene^.devant); detruire3D(TheScene^.derriere);
        case theScene^.cat of
        1: begin Kill(Pcellule(Pfacet(TheScene^.donnees)^.sommets));
                 dispose(Pfacet(TheScene^.donnees));
           end;
        2: begin Kill(Pcellule(PLine3d(TheScene^.donnees)^.sommets));
                 dispose(PLine3d(TheScene^.donnees));
           end;
        3: begin Kill(Pcellule(PDot3d(TheScene^.donnees)^.sommets));
                 dispose(PDot3d(TheScene^.donnees));
           end;
        end;
        dispose(TheScene);
        TheScene:=nil;
end;
{========================================}
procedure build3d(Const elem3d:Tlist); //liste de: couleurs+sommets+jump
var
   index1,index2,aux,Entree:Paffixe;
   facette:Pfacet;
   line3d:PLine3d;
   dot3d:PDot3d;
   U,V,W,W2,M,camera:Tpt3d;
   nbsommets,first:integer;
   x,y,z:real;
   listefaces, listeSeg, listeDot:Tlist;
   i:longint;
   couleur,nummac:longint;
   opacity:real;
   epaisseur,theNuance:real;
   ligneStyle:integer;
   seg,dot:type_liste;
   Thedevder:shortint; //indique si la face a un devant/derriere
   typeObjet:longint;
   BackCulling:boolean;
   IsALabel:byte;
   Comparer:TlistSortCompare;

   procedure rangerF(Const i, j:longint);
   var k:longint;
       face:Pfacet;
   begin
        for k:=i to j do
            begin
                 face:=Pfacet(listeFaces.items[k]);
                 insererF(face,scene);
            end;
        //rangerF(i,k-1);
        //rangerF(k+1,j);
   end;

   procedure rangerS(Const i,j:longint);
   var k:longint;
       seg:PLine3d;
   begin
        //if i>j then exit;
        //k:=i;//+Random(j-i+1);
        for k:=i to j do
        begin
             seg:=PLine3d(listeSeg.items[k]);
             insererS(seg,scene);
        end;
        //rangerS(i,k-1);
        //rangerS(k+1,j);
   end;
   
   procedure rangerD(Const i,j:longint);
   var k:longint;
       dot:PDot3d;
   begin
        //if i>j then exit;
        //k:=i;//+Random(j-i+1);
        for k:=i to j do
        begin
             dot:=Pdot3d(listeDot.items[k]);
             insererD(dot,scene);
        end;
        //rangerS(i,k-1);
        //rangerD(k+1,j);
   end;

begin
      //build3d:=nil;
      if elem3d.count=0 then exit;
      CalculerN;
      listeFaces:=Tlist.Create;listeSeg:=Tlist.Create;listeDot:=Tlist.Create;

  //lecture facettes  et segments
  for i:=0 to elem3d.count-1 do
  
begin
  Entree:=Paffixe(elem3d.items[i]);
  index1:=Paffixe(Entree);
  
  typeObjet:=Round(index1^.x); //on attend
  //<0: facettes exportées avec l'algorithme de Gouraud (DrawSmooth)
  //0=cloison ou 1=facettes ou 2=segments ou 3=points/labels

  theNuance:= 1+index1^.y;    // contrast, defaut=0, -1=pas de nuance
  if (typeObjet=3) then  IsALabel:=Round(index1^.y) //0=point 1=label 2=TexLabel
  else IsALabel:=0;
  index1:=Paffixe(index1^.suivant); //couleur+opacité
  couleur:=Round(index1^.x);
  backCulling:=couleur<0;   // couleur<0 => élimination des facettes cachées
  couleur:=abs(couleur);

  opacity:=index1^.y;  //Fillopacity ou StrokeOpacity ou numero de macro contenant le texte pour les labels
  
  if (opacity=0) and (IsALabel=0) then opacity:=1; //1 par défaut
  
  if (typeobjet<>0) {autre que cloison}
      then
          if (opacity<0)
             then begin opacity:=-opacity; Thedevder:=0 end //pas de distinction devant/derriere
             else ThedevDer:=1 //on distingue devant/derriere
      else Thedevder:=-1 ; //cloison=facette non visible

  index1:=Paffixe(index1^.suivant);
  
  if (index1<>nil) and (typeObjet>=2) then //segments(2) ou points(3) ou label(3+i)  ou TexLabel(3-i)
     begin
         epaisseur:=abs(index1^.x); {labelSize pour les labels}
         ligneStyle:=Round(index1^.y); {labelSyle pour les labels}
         index1:=Paffixe(index1^.suivant);
     end;

  while (index1<>nil) and IsJump(index1) do index1:=Paffixe(index1^.suivant);
  if index1<>nil then begin
        index1^.precedent^.suivant:=nil;
        index1^.precedent:=nil;
        end;

  if (typeObjet=-1) {facettes lissées}
     then
         begin
              if TheNuance<=0 then TheNuance:=2.5 //une couleur unie n'a pas vraiment de sens ici
                              else TheNuance:=2.5*TheNuance;
              GouraudShading:=true; //méthode Gouraud
              TraiterFacettes(index1,true,backculling,TheNuance,(TheDevder=0),true);//calcul des indices de chaque facette
              GouraudShading:=false;
              aux:=PaintVertex(index1,couleur);//calcul de la couleur de chaque sommet
              Kill(Pcellule(index1));
              index1:=aux
         end;
  if (typeObjet=1) or (typeObjet=0) then TraiterFacettes(index1,true,backculling,0,(TheDevder=0),true);//tri arboré
  while index1<>nil do //parcourt de la liste
   begin
        index2:=index1; nbsommets:=0; first:=0;
        if typeObjet<=1 then //facette ou cloison
         while (index1<>nil) and (not IsJump(index1)) do
          begin {on extrait la facette, calcule son vecteur normal}
               Inc(first);
               if first=1 then
                        begin
                              x:=index1^.x; y:=index1^.y;
                              case nbsommets of
                              0: begin U.x:= -x; U.y:=-y;
                                       V.x:= -x; V.y:=-y
                                 end;
                              1: begin U.x:= x+U.x; U.y:=y+U.y; end;
                              2: begin V.x:= x+V.x; V.y:=y+V.y;  end;
                              end;
                        end
                        else begin first:=0;z:=index1^.x;
                                   case nbsommets of
                                   0: begin U.z:= -z; V.z:=-z; end;
                                   1: begin U.z:= z+U.z; end;
                                   2: begin V.z:= z+V.z; end
                                   end;
                                   inc(nbsommets);
                             end;

               index1:=Paffixe(index1^.suivant)
           end
           
          else //segment ou points, on compte les points
          
          while (index1<>nil) and (not IsJump(index1)) do
           begin
               Inc(first);
               if first=2 then
                         begin first:=0;
                               inc(nbsommets);
                         end;

               index1:=Paffixe(index1^.suivant)
           end;

        if index1<>nil // le jump final
                          then begin    if index1^.precedent<>nil then
                                           index1^.precedent^.suivant:=nil;
                                        aux:=index1;
                                        while (aux<>nil) and IsJump(aux) do
                                         aux:=Paffixe(aux^.suivant);

                                         if aux<>nil then
                                           begin
                                             aux^.precedent^.suivant:=nil;
                                             aux^.precedent:=nil;
                                           end;

                                         Kill(Pcellule(index1)); //destruction des jump
                                         index1:=aux;
                               end;
        if (nbsommets>2) and (typeObjet<=1) then  //facette
                begin
                        CalcError:=false; 
                        W:=pvect(U,V);
                        W2:=Normalize(pvect(Vtransform3d(U),Vtransform3d(V)));
                        if not CalcError then
                        begin
                        Facette:=New(Pfacet);
                        Facette.sommets:=index2;
                        Facette.Point.x:=index2^.x;
                        Facette.Point.y:=index2^.y;
                        Facette.Point.z:=Paffixe(index2^.suivant)^.x;
                        Facette.vect:=W;
                        //Facette.vect2:=W2;
                        if typeObjet=-1 then begin
                                             Facette.Gouraud:=true;
                                             Facette.eclair:=pscal3d(W2,Light);//N);
                                             end
                                        else begin
                                             Facette.Gouraud:=false;
                                             Facette.eclair:=pscal3d(W2,N);//N);
                                             end;
                        Facette.couleur:=couleur;
                        Facette.opacity:=opacity;
                        Facette.theNuance:=theNuance;
                        Facette.devder:=TheDevDer;
                        if centrale then
                            begin
                                 M:=Mtransform3d(Facette.Point);
                                 camera.x:=posCam.x-M.x;
                                 camera.y:=posCam.y-M.y;
                                 camera.z:=posCam.z-M.z;
                                 Facette.inverse:=pscal3d(Normalize(camera),W2)<0;
                            end
                            else begin
                                      Facette.inverse:=pscal3d(N,W2)<0;
                                 end;
                            
                        if (not facette.inverse) or (TheDevDer=0)
                                   then Facette.eclair:=abs(Facette.eclair)//N))
                                   else Facette.eclair:=-abs(Facette.eclair);//N))
                            
                        if (not backculling) or (not facette.inverse)
                           then listeFaces.add(Facette)
                           else
                               begin
                                    Kill(Pcellule(index2));//destruction de la facette cachee
                                    dispose(Facette)
                               end;
                        end;
                end else
                if (nbsommets>1) and (typeObjet=2) then //segments
                 begin
                        aux:=index2; first:=0;
                        U.x:=aux^.x; U.y:=aux^.y;
                        U.z:=Paffixe(aux^.suivant)^.x;
                        aux:=Paffixe(aux^.suivant^.suivant);
                        while aux<>nil do
                        begin
                             inc(first);
                             if first=1 then
                                begin
                                 V.x:=aux^.x; V.y:=aux^.y;
                                end
                             else begin
                                  V.z:=aux^.x; first:=0;
                                  seg.init;
                                  seg.ajouter_fin(new(Paffixe,init(U.x,U.y)));
                                  seg.ajouter_fin(new(Paffixe,init(U.z,0)));
                                  seg.ajouter_fin(new(Paffixe,init(V.x,V.y)));
                                  seg.ajouter_fin(new(Paffixe,init(V.z,0)));
                                  line3d:=New(PLine3d);
                                  line3d.sommets:=Paffixe(seg.tete);
                                  line3d.couleur:=couleur;
                                  line3d.width:=epaisseur;
                                  line3d.opacity:=opacity;
                                  line3d.linestyle:=ligneStyle;
                                  listeSeg.add(line3d);
                                  U.x:=V.x; U.y:=V.y; U.z:=V.z;
                                end;
                             aux:=Paffixe(aux^.suivant);
                        end;
                        Kill(Pcellule(index2))
                 end else
                if (nbsommets>0) and (typeObjet=3) then //points ou label
                 if IsALabel>0 then
                    begin {label, on a un point3D et une direction: [affixe,distance]}
                       dot3d:=New(Pdot3d);
                       dot3d.Islabel:=IsALabel;
                       dot3d.sommets:=index2;
                       dot3d.couleur:=couleur;
                       dot3d.width:=epaisseur; {labelstyle}
                       dot3d.linestyle:=ligneStyle; {LabelStyle}
                       dot3d.opacity:=opacity; {numero de macro contenant le texte}
                       listeDot.add(dot3d);
                    end
                    else  {point}
                 begin
                        aux:=index2; first:=0;
                        while aux<>nil do
                        begin
                             inc(first);
                             if first=1 then
                                begin
                                 U.x:=aux^.x; U.y:=aux^.y;
                                end
                             else begin
                                  U.z:=aux^.x; first:=0;
                                  dot.init;
                                  dot.ajouter_fin(new(Paffixe,init(U.x,U.y)));
                                  dot.ajouter_fin(new(Paffixe,init(U.z,0)));
                                  dot3d:=New(Pdot3d);
                                  dot3d.Islabel:=0;
                                  dot3d.sommets:=Paffixe(dot.tete);
                                  dot3d.couleur:=couleur;
                                  dot3d.width:=epaisseur; {labelstyle}
                                  dot3d.linestyle:=ligneStyle; {LabelStyle}
                                  dot3d.opacity:=opacity; {numero de macro contenant le texte}
                                  listeDot.add(dot3d);
                                end;
                             aux:=Paffixe(aux^.suivant);
                        end;
                        Kill(Pcellule(index2))
                 end
                 
                 else Kill(Pcellule(index2));
   end; //fin du classement
end;
   if listeFaces.Count>0 then begin
                                   rangerF(0,listeFaces.count-1);
                              end;
   if listeSeg.Count>0 then rangerS(0,listeSeg.count-1);
   if listeDot.Count>0 then rangerD(0,listeDot.count-1);
   listeFaces.free; listeSeg.free; listeDot.free;
end;
{=======================================}
function Tbuild3d.executer(arg: Pliste):Presult;
var f:Pcorps;
    T,index1,aux:Paffixe;
    //P:Tlist;
begin
     executer:=nil;
     sceneCMD^.detruire;
     PcomptLabel3d^.affixe^.setx(0); //mise à zéro du compteur de labels
     f:=(new(Pcorps,init(cat_string,new(Pstring,init(''))))); //le premier element est un nom de fichier vide ici
     sceneCMD^.ajouter_fin(f);
     if arg=nil then exit;
     f:=Pcorps(arg^.tete);
     if f=nil then exit;
     //P:=Tlist.Create;
     while f<>nil do
      begin
        T:=f^.evalNum;   {f est dupliqué car il y aura des modifications}
        while T<>nil do   {la liste peut comporter plusieurs objets, ils sont séparés par Re(jump)-i}
           begin
              index1:=T;
               while (index1<>nil) and not(Isjump(index1) and (index1^.y=-1))
                     do index1:=Paffixe(index1^.suivant);
              if index1<>nil then
                 begin
                      if index1^.precedent<>Nil then index1^.precedent^.suivant:=nil;
                      aux:=index1;index1:=Paffixe(index1^.suivant);
                      if index1<>Nil then index1^.precedent:=Nil;
                      aux^.suivant:=nil;
                      if T=aux then T:=Nil;
                      Kill(Pcellule(aux));
                 end;
               if (T<>nil) and (T^.suivant<>nil) then
                           begin
                                sceneCMD.ajouter_fin(new(Pcorps,init(cat_affixe,T^.evaluer)));
                           end else Kill(Pcellule(T));
              T:=index1;
           end;
        f:=Pcorps(f^.suivant);
      end;
     //executer:= build3d(P);
 end;
{=======================================}
function get3d:Presult;
var res:type_liste;

   procedure lire(Const TheScene:objet3D);
   var eclair:real;
       coul:longint;
       thefacet:Pfacet;
       theline:PLine3d;
       theDot:Pdot3d;
   begin
        if TheScene=nil then exit;
        //res.ajouter_fin(new(Paffixe,init(Pfacet(TheScene^.donnees)^.couleur,0)));
        case TheScene^.cat of
       1: begin
                thefacet:=Pfacet(TheScene^.donnees);
                lire(TheScene^.derriere);
                eclair:=thefacet^.eclair;
                coul:=thefacet^.couleur;
                if eclair<0 then
                        begin
                if thefacet^.devder=1 then //on distingue devant/derriere
                   coul:=Rgb(127+(GetRvalue(coul) div 2),127+(GetGvalue(coul) div 2),
                                       127+(GetBvalue(coul) div 2));
                eclair:=-eclair
                        end;

                if eclair<>0 then  //[1+i*theNuance, couleur+i*opacity, facette]
                   begin
                        //CalcError := false;
                        eclair:=system.exp(system.ln(eclair)/2.5*thefacet^.theNuance);

                   end;
                if thefacet^.devder>-1 then { facette affichée}
                   begin
                        if thefacet^.Gouraud then
                           begin
                                res.ajouter_fin(new(Paffixe,init(-1,0)));
                                res.ajouter_fin(new(Paffixe,init(coul,thefacet^.opacity)));
                           end
                        else
                            begin
                                 res.ajouter_fin(new(Paffixe,init(1,0)));
                                 res.ajouter_fin(new(Paffixe,init(getFillColor(GetRvalue(coul),GetGvalue(coul),
                                                                               GetBvalue(coul),eclair)
                                                                  ,thefacet^.opacity)));
                           end;
                        res.ajouter_fin(thefacet^.sommets^.evaluer);
                        if thefacet^.Gouraud then
                           begin
                                GouraudShading:=true;
                                res.ajouter_fin(new(Paffixe,init(jump^.x,2+
                                                                 getFillColor(GetRvalue(coul),GetGvalue(coul),
                                                                               GetBvalue(coul),eclair))));
                                GouraudShading:=false;
                           end else res.ajouter_fin( new(Paffixe,init(jump^.x,jump^.y)));
                   end;
                lire(TheScene^.devant);
            end;
        2: begin //[2, couleur+i*opacity,width+i*linestyle, segment]
                lire(TheScene^.derriere);
                theline:=PLine3d(TheScene^.donnees);
                res.ajouter_fin(new(Paffixe,init(2,0)));
                res.ajouter_fin(new(Paffixe,init(theline^.couleur,theline^.opacity)));
                res.ajouter_fin(new(Paffixe,init(theline^.width,theline^.linestyle)));
                res.ajouter_fin(theline^.sommets^.evaluer);
                res.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)));
                lire(TheScene^.devant);
           end;
        3: begin //[3+i*Islabel, couleur+i*opacity,width (ou LabelSize)+i*linestyle (ou LabelStyle), [point, dir] ]
                lire(TheScene^.derriere);
                thedot:=PDot3d(TheScene^.donnees);
                res.ajouter_fin(new(Paffixe,init(3,thedot^.Islabel)));
                res.ajouter_fin(new(Paffixe,init(thedot^.couleur,thedot^.opacity)));
                res.ajouter_fin(new(Paffixe,init(thedot^.width,thedot^.linestyle)));
                res.ajouter_fin(thedot^.sommets^.evaluer);
                res.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)));
                lire(TheScene^.devant);
           end;
        end;

   end;
begin
   get3d:=nil;
   if Scene=nil then exit;
   CalculerN;
  //initialisation
   res.init;
   lire(scene);
   get3d:=Presult(res.tete);
end;
{=======================================}
function TGet3D.executer(arg: Pliste):Presult;
begin
     executer:= get3d;
 end;
{=======================================}
function TDisplay3D.executer(arg: Pliste):Presult;
var P:Tlist;
    index:Pcellule;
    res:Paffixe;
    macdisplay : PMacros;
begin
     executer:= nil;
     if not ContexteUtilisateur then exit;
     detruire3D(scene);
     P:=Tlist.Create;

     index:=sceneCMD^.tete;
     while index<>nil do
       begin
         res:=Pcorps(index)^.evalNum;
         if res<>Nil then P.add(res);
         index:=index^.suivant
       end;
     build3d(P); //calcul de la scene
     macdisplay := macros('disp3d');
     if macdisplay<>Nil then macDisplay^.executer(nil);  //affichage
     P.free;
end;
{=======================================}
function Tproj3D.executer(arg: Pliste):Presult;
// Proj3D( <liste points 3D> )
var f:Pcorps;
    P1:Paffixe;
    res:type_liste;
    saut,del:boolean;
    jumpY,x,y,z,den:real;
begin
     executer:=nil;
     if arg=nil then exit;
     f:=Pcorps(arg^.tete);
     if f=nil then exit;
     CalculerN;
     res.init;
     //if f^.categorie=cat_constante
       // then
            //begin
                // del:=false;       {si f est une constante on ne la duplique pas}
                // P1:=Pconstante(f^.contenu)^.affixe;
           // end
       // else
            begin
                 del:=true;P1:=f^.evalNum;   {f est dupliqué}
            end;
     ApplyMatrix3d(P1);
     while P1<>nil do
           begin
                saut:=IsJump(P1);
                if saut then jumpY:=P1^.y else jumpY:=jump^.y;
                if saut or (P1^.suivant=nil) or Isjump(Paffixe(P1^.suivant))
                   then res.ajouter_fin(New(Paffixe,init(jump^.x,jumpY)))
                   else
                       begin
                            res.ajouter_fin(projeter(P1^.x,P1^.y,Paffixe(P1^.suivant)^.x));
                       end;
                P1:=Paffixe(P1^.suivant);
                if (P1<>nil) and (not saut) then P1:=Paffixe(P1^.suivant);
           end;
     if del then Kill(Pcellule(P1));
     executer:=Paffixe(res.tete);
 end;
{=======================================}
function GetSurface(Const f:Pcorps;Const uMin,uMax,vMin,vMax:real;Const uNbLg,vNbLg:longint):Paffixe;
var  U,V,res:Paffixe;
     A1:Ppt3D;
     grille,facette:type_liste;
     i,j,compt,indice:longint;
     table: array of Ppt3D;
     Upas,Vpas:real;
     error:boolean;
     x1,y1,z1:real;
     Cu,Cv:Pconstante;

     procedure add;
     var x:real;
     begin
        CalcError:=false;
        x:= sqrt( ajouter(sqr(soustraire(x1,A1^.x)),
                               ajouter(sqr(soustraire(y1,A1^.y)),
                                       sqr(soustraire(z1,A1^.z)))));
        if (compt=0) or ((not CalcError) and (x>1E-17))
                        then
                        begin
                                inc(compt);
                                facette.ajouter_fin(new(Paffixe,init(A1^.x, A1^.y)));
                                facette.ajouter_fin(new(Paffixe,init(A1^.z, 0)));
                                x1:=A1^.x; y1:=A1^.y; z1:=A1^.z;
                        end;
     end;

begin

  //getmem(table,uNbLg*vNbLg*Sizeof(Ppt3D)); //calcul de la grille de points
try
  SetLength(table,uNbLg*vNbLg);
  U:=New(Paffixe,init(0,0));
  V:=New(Paffixe,init(0,0));
  cu:=VarLocale('u');
  cv:=VarLocale('v');
  cu^.affixe:=U;
  cv^.affixe:=V;
  U^.x:=uMin; Upas:=(uMax-uMin)/(uNbLg-1); Vpas:=(vMax-vMin)/(vNbLg-1);

  for i:=1 to uNbLg do
      begin
           V^.x:=vMin;indice:=vNbLg*(i-1);
           for j:=1 to vNbLg do
               begin
                    inc(indice);
                    res:=f^.evalNum;
                    error:= (res=nil) or (res^.suivant=nil);
                    if error
                       then begin table[indice-1]:=nil
                            end
                       else
                           begin
                                 New(A1);
                                 A1^.x:=res^.x; A1^.y:=res^.y; A1^.z:=Paffixe(res^.suivant)^.x;
                                 table[indice-1]:=A1;
                                 Kill(Pcellule(res));
                           end;
                    V^.x += Vpas;
               end;
           U^.x += Upas;
      end;
      {f^.desassigner('u'); f^.desassigner('v');
      Kill(Pcellule(U)); Kill(Pcellule(V));}
      Kill(Pcellule(cu^.affixe));Kill(Pcellule(cv^.affixe));
      grille.init;

      for i:=1 to uNbLg-1 do
        for j:=1 to vNbLg-1 do
           begin
                facette.init; compt:=0;
                A1:=table[vNbLg*(i-1)+j-1];
                if A1<>nil then add;

                A1:=table[vNbLg*i+j-1];
                if A1<>nil then add;

                A1:=table[vNbLg*i+j+1-1];
                if A1<>nil then add ;

                A1:=table[vNbLg*(i-1)+j+1-1];
                if A1<>nil then add;

                if compt>2 then
                        begin
                                grille.ajouter_fin(facette.tete);
                                grille.ajouter_fin(new(Paffixe,init(jump^.x, jump^.y)));
                        end else begin facette.detruire;
                                 end

           end;
 finally
      for i:=0 to uNbLg*vNbLg-1
      do  If table[i]<>nil then dispose(table[i]);
      finalize(table);
      result:= Paffixe(grille.tete)
 end;
end;
function TGetSurface.executer(arg: Pliste):Presult;
// GetSurface( [x(u,v)+iy(u,v), z(u,v)], uMin+i*uMax, vMin+i*vMax, uNbLg+i*vNbLg)
var f:Pexpression;
    f1,f2,f3,f4:Pcorps;
    U,V,Lg:Paffixe;
    aux:Pliste;
   uMin, uMax, vMin, vMax: real;
   uNbLg, vNbLg:longint;
begin
    executer:=nil;
    if arg=nil then exit;
     CalculerN;
     f1:=Pcorps(arg^.tete);
     if (f1=nil)   then exit;
     uMin:=-5; uMax:=5;
     vMin:=-5; vMax:=5;
     uNbLg:=25; vNbLg:=25;

     f1^.ConvertLocale('u');
     f1^.ConvertLocale('v');
     {new(f,init);
     f^.corps:=f1;
     f^.varloc:=LesVarLoc;
     f1^.ConvertLocale('u');
     f1^.ConvertLocale('v');}

     {f^.corps:=f1^.dupliquer;
     aux:=LesVarLoc;
     LesVarLoc:=f^.VarLoc;
     f^.corps^.brancherLocales;}

     f2:=Pcorps(f1^.suivant);
     if f2<>nil
        then
            begin
                 U:=f2^.evalNum;
                 if (U<>nil)
                    then
                        begin
                             if (U^.x<U^.y)
                                then
                                    begin
                                         uMin:=U^.x; uMax:=U^.y;
                                    end;
                             Kill(Pcellule(U));
                        end;
                  f3:=Pcorps(f2^.suivant);
                  if f3<>nil
                     then
                         begin
                              V:=f3^.evalNum;
                              if (V<>nil)
                                 then
                                     begin
                                          if (V^.x<V^.y)
                                             then
                                                 begin
                                                      vMin:=V^.x; vMax:=V^.y;
                                                 end;
                                          Kill(Pcellule(V));
                                     end;
                              f4:=Pcorps(f3^.suivant);
                              if f4<>nil
                                 then
                                     begin
                                          Lg:=f4^.evalNum;
                                          if (Lg<>nil)
                                             then
                                                 begin
                                                      uNbLg:=abs(Round(Lg^.x));
                                                      vNbLg:=abs(Round(Lg^.y));
                                                      if uNbLg<2 then uNbLg:=2;
                                                      if vNbLg<2 then vNbLg:=2;
                                                 end;
                                          Kill(Pcellule(Lg));
                                     end;

                         end;
            end;
     executer:=Getsurface(f1,uMin,uMax,vMin,vMax,uNbLg,vNbLg);
     //dispose(f);
end;

{=======================================}
function TIdMatrix3d.executer(arg: Pliste):Presult;
// IdMatrix3d()
begin
     executer:=Nil;
     Dispose(Matrix3d);
     matrix3d:=Nil
end;
{===============================}
function TGetMatrix3d.executer(arg: Pliste):Presult;
// GetMatrix3d() renvoie la matrice courante
var res: type_liste;

begin
     executer:=Nil;
     res.init;
     if matrix3d=Nil then
        begin
             res.ajouter_fin(new(Paffixe,init(0,0)));
             res.ajouter_fin(new(Paffixe,init(0,0)));
             
             res.ajouter_fin(new(Paffixe,init(1,0)));
             res.ajouter_fin(new(Paffixe,init(0,0)));
             
             res.ajouter_fin(new(Paffixe,init(0,1)));
             res.ajouter_fin(new(Paffixe,init(0,0)));
             
             res.ajouter_fin(new(Paffixe,init(0,0)));
             res.ajouter_fin(new(Paffixe,init(1,0)));
        end
        else
        begin
             res.ajouter_fin(new(Paffixe,init(Matrix3d^[1,4],Matrix3d^[2,4])));
             res.ajouter_fin(new(Paffixe,init(Matrix3d^[3,4],0)));

             res.ajouter_fin(new(Paffixe,init(Matrix3d^[1,1],Matrix3d^[2,1])));
             res.ajouter_fin(new(Paffixe,init(Matrix3d^[3,1],0)));

             res.ajouter_fin(new(Paffixe,init(Matrix3d^[1,2],Matrix3d^[2,2])));
             res.ajouter_fin(new(Paffixe,init(Matrix3d^[3,2],0)));

             res.ajouter_fin(new(Paffixe,init(Matrix3d^[1,3],Matrix3d^[2,3])));
             res.ajouter_fin(new(Paffixe,init(Matrix3d^[3,3],0)));
        end;
      executer:=Paffixe(res.tete)
end;
{===============================}
function TSetMatrix3d.executer(arg: Pliste):Presult;
// SetMatrix3d([f(0),Lf(vecI),Lf(vecJ),Lf(vecK)]) redéfinit la matrice courante
var f:Pcorps;
    aux,M:Paffixe;
    m1,m2:Tmatrix3d;
    i,j,k:byte;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f:= Pcorps(arg^.tete);
     M:=f^.evalNum;
     if M=nil then exit;
     aux:=M;
     m1[1,4]:=M^.x; m1[2,4]:=M^.y; M:=Paffixe(M^.suivant); m1[3,4]:=M^.x; m1[4,4]:=1;
     M:=Paffixe(M^.suivant);
     for i:=1 to 3 do
         begin
          m1[1,i]:=M^.x; m1[2,i]:=M^.y; M:=Paffixe(M^.suivant); m1[3,i]:=M^.x; m1[4,i]:=0;
          M:=Paffixe(M^.suivant);
         end;
     if Matrix3d<>nil then dispose(Matrix3d);
     Matrix3D:=new(Pmatrix3d);
     Matrix3d^:=m1;
     Kill(Pcellule(aux))
end;
{===============================}
function TComposeMatrix3d.executer(arg: Pliste):Presult;
// ComposeMatrix3d([f(0),Lf(vecI),Lf(vecJ),Lf(vecK)]) compose avec la matrice courante
var f:Pcorps;
    aux,M:Paffixe;
    m1,m2:Tmatrix3d;
    i,j,k:byte;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f:= Pcorps(arg^.tete);
     M:=f^.evalNum;
     if (M=nil) then exit;
     if (M^.suivant=nil) or (M^.suivant^.suivant=nil) or (M^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant^.suivant^.suivant^.suivant=nil)
                  then begin Kill(Pcellule(M)); exit end;
     aux:=M;
     m1[1,4]:=M^.x; m1[2,4]:=M^.y; M:=Paffixe(M^.suivant); m1[3,4]:=M^.x; m1[4,4]:=1;
     M:=Paffixe(M^.suivant);
     for i:=1 to 3 do
         begin
          m1[1,i]:=M^.x; m1[2,i]:=M^.y; M:=Paffixe(M^.suivant); m1[3,i]:=M^.x; m1[4,i]:=0;
          M:=Paffixe(M^.suivant);
         end;
     if Matrix3d=nil then begin Matrix3D:=new(Pmatrix3d); Matrix3d^:=m1 end
                     else
        begin
            for i:=1 to 4 do
                for j:=1 to 4 do
                 begin
                      m2[i,j]:=0;
                      for k:=1 to 4 do
                          m2[i,j]:=m2[i,j]+Matrix3d^[i,k]*m1[k,j]
                 end;
            dispose(Matrix3d);
            Matrix3D:=new(Pmatrix3d);
            Matrix3d^:=m2
        end;
     Kill(Pcellule(aux));
end;
{=================================}
function TMtransform3D.executer(arg:Pliste): Presult;
var f1,f2:Pcorps;
    aux,M,Maux,liste,index:Paffixe;
    m1:Tmatrix3d;
    m2:Pmatrix3d;
    i,j,k:byte;
    Del1:boolean;
    res:type_liste;
    A:Tpt3d;
begin
     executer:=Nil;
     if (arg=nil) then exit;
     f1:= Pcorps(arg^.tete); if f1=Nil then exit;
     if (f1^.categorie=cat_constante) then begin Del1:=false; liste:=Paffixe(Pconstante(f1^.contenu)^.affixe) end
                                      else begin Del1:=true;  liste:=f1^.evalNum end;
     f2:=Pcorps(f1^.suivant);
     if f2<>Nil then M:=f2^.evalNum else M:=Nil;
     Maux:=M; m2:=Matrix3D;
     if (M<>nil) then
      begin
      if (M^.suivant=nil) or (M^.suivant^.suivant=nil) or (M^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant^.suivant^.suivant=nil) or
        (M^.suivant^.suivant^.suivant^.suivant^.suivant^.suivant^.suivant=nil)
      then begin Kill(Pcellule(M)); exit end;

      m1[1,4]:=M^.x; m1[2,4]:=M^.y; M:=Paffixe(M^.suivant); m1[3,4]:=M^.x; m1[4,4]:=1;
      M:=Paffixe(M^.suivant);
      for i:=1 to 3 do
         begin
          m1[1,i]:=M^.x; m1[2,i]:=M^.y; M:=Paffixe(M^.suivant); m1[3,i]:=M^.x; m1[4,i]:=0;
          M:=Paffixe(M^.suivant);
         end;
      Matrix3D:=@m1;
      end;
     //maintenant on applique la matrice3D à la liste
    if Matrix3d<>Nil then
    begin
      res.init;
      index:=liste;
      while index<>Nil do
          begin
               if IsJump(index)
                  then res.ajouter_fin(new(Paffixe,init(jump^.x,index^.y)))
               else
                   begin
                        A.x:=index^.x; A.y:=index^.y;
                        aux:=Paffixe(index^.suivant);
                        if (aux<>nil) and (not Isjump(aux))
                           then
                               begin
                                    index:=aux; A.z:=index^.x;
                                    CalcError:=false;
                                    A:=Mtransform3d(A);
                                    if not CalcError then
                                       begin
                                    res.ajouter_fin(new(Paffixe,init(A.x,A.y)));
                                    res.ajouter_fin(new(Paffixe,init(A.z,0)));
                                       end
                               end
                   end;
               index:=Paffixe(index^.suivant)
          end;
      if Del1 then Kill(Pcellule(liste));
      executer:=Paffixe(res.tete)
    end
    else //Matrix3d est l'identité
        if Del1 then executer:=liste
                else if (liste<>Nil) then executer:=liste^.evaluer;
    Matrix3d:=m2;
    Kill(Pcellule(Maux))
end;
{===============================}
function TDistCam.executer(arg: Pliste):Presult;
// Distcam() renvoie la distance camera-origine, DistCam(distance) règle la distance camera-origine (variable Dcamera)
var f:Pcorps;
    T:Paffixe;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then executer:=New(Paffixe,init(Dcamera,0))
     else
         begin
              f:= Pcorps(arg^.tete);
              T:=f^.evalNum;
              if T<>nil then Dcamera:=abs(T^.x);
              Kill(Pcellule(T));
         end;
end;
{===============================}
function TModelView.executer(arg: Pliste):Presult;
// ModelView(ortho/central) passe en projection orthographique ou centrale
var f:Pcorps;
    T:Paffixe;
begin
     executer:=nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then
        begin
        executer:=New(paffixe,init(byte(centrale),0));
        exit;
        end;
     f:= Pcorps(arg^.tete);
     T:=f^.evalNum;
     if (T=Nil) then exit;
     if T^.x=0 then centrale:=false       //ortho
     else if T^.x=1 then centrale:=true;  //central
     Kill(Pcellule(T))
end;
{===============================}
function deplaceCam(M:Tpt3d):boolean;
begin
     CalcError:=false;
     Dcamera:=Norm(M);
     if CalcError or (Dcamera=0) then result:=false
     else
     begin
          result:=true;
          M.x:=M.x/Dcamera;M.y:=M.y/Dcamera;M.z:=M.z/Dcamera;
          if (M.x=0) and (M.y=0) //M=vecK
          then
          begin
              theta:=pi/6;
              Ptheta^.affixe:=New(Paffixe,init(theta,0));
              phi:=0;
              Pphi^.affixe:=New(Paffixe,init(phi,0));
         end
         else begin
               phi:=arccos(M.z);
               Pphi^.affixe:=New(Paffixe,init(phi,0));
               if M.y>0 then theta:=arccos(M.x/sin(phi))
               else if M.y<0 then theta:=-arccos(M.x/sin(phi))
               else theta:=0;
               Ptheta^.affixe:=New(Paffixe,init(theta,0));
               end;
         //vecteur normal
         N.x:=sin(phi)*cos(theta); N.y:=sin(phi)*sin(theta); N.z:=cos(phi);
         posCam.x:=Dcamera*N.x;posCam.y:=Dcamera*N.y;posCam.z:=Dcamera*N.z;
     end;
end;

function TPosCam.executer(arg: Pliste):Presult;
// posCam([x+i*y,z]) place la caméra en M(x,y,z) celle-ci est dirigée vers (0,0,0),
// cela change N et Dcamera (Dcamera= distance camera-origine), si l'argument est vide
// on renvoie la position de la caméra.
var f:Pcorps;
    T:Paffixe;
    M:Tpt3d;
    resMove:byte;
    res:type_liste;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then
        begin
             if centrale then
             begin
             CalculerN;
             res.init;
             res.ajouter_fin(New(paffixe,init(poscam.x,poscam.y)));
             res.ajouter_fin(New(paffixe,init(poscam.z,0)));
             executer:=Paffixe(res.tete)
             end;
             exit;
        end;
     f:= Pcorps(arg^.tete);
     T:=f^.evalNum;
     if (T=Nil) or (T^.suivant=Nil) then exit;
     M.x:=T^.x; M.y:=T^.y; M.z:=Paffixe(T^.suivant)^.x;
     Kill(Pcellule(T));
     resMove:=byte(deplaceCam(M));
     executer:=New(Paffixe,init(resMove,0));
end;
{===============================}
function makepoly(Const sommets, facettes:Paffixe):Paffixe;
// sommets est une liste de points 3D
// facettes une liste de facettes avec le numéro des sommets
// renvoie la liste des facettes avec coordonnées réelles
var indice:Paffixe;
    Lfaces:type_liste;
    
    function sommet(i:longint):Paffixe;
    var k,num:longint; nb:byte; aux:Paffixe; stop:boolean;
        l:type_liste;
    begin
         k:=1; aux:=sommets; num:=2*i-1; stop:=(aux=Nil) or (k=num); l.init;
         while not stop do
               begin
                    aux:=Paffixe(aux^.suivant);Inc(k,1);
                    if aux<>Nil then begin Inc(k,1); aux:=Paffixe(aux^.suivant) end;
                    stop:=(aux=Nil) or (k=num);
               end;
        if (aux<>Nil) and (Paffixe(aux^.suivant)<>Nil) then
           begin
                l.ajouter_fin(new(Paffixe,init(aux^.x,aux^.y)));
                l.ajouter_fin(new(Paffixe,init(Paffixe(aux^.suivant)^.x,Paffixe(aux^.suivant)^.y)));
           end;
        result:=Paffixe(l.tete)
    end;
    
begin
     Lfaces.init; indice:=facettes;
     while indice<>Nil do
           begin
             if IsJump(indice) then Lfaces.ajouter_fin(new(Paffixe,init(jump^.x,indice^.y)))
                               else Lfaces.ajouter_fin(sommet(round(indice^.x)));
             indice:=Paffixe(indice^.suivant)
           end;
    result:=Paffixe(Lfaces.tete)
end;

function TMakepoly.executer(arg: Pliste):Presult;
//MakePoly(sommets, facettes (avec n° sommets)): renvoie la liste des facettes avec coordonnées réelles
var f1,f2:Pcorps;
    rep,T2,T1:Paffixe;
    del1,del2:boolean;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
     f2:=Pcorps(f1^.suivant);
     if f2=Nil then exit;
     if f1^.categorie=cat_constante
        then
            begin
                 del1:=false;       {si f1 est une constante/variable on ne la duplique pas}
                 T1:=Paffixe(Pconstante(f1^.contenu)^.affixe);
            end
        else
            begin
                 del1:=true;T1:=f1^.evalNum;   {f1 est dupliqué}
            end;
     if T1=nil then exit;
     if f2^.categorie=cat_constante
        then
            begin
                 del2:=false;       {si f2 est une constante/variable on ne la duplique pas}
                 T2:=Paffixe(Pconstante(f2^.contenu)^.affixe);
            end
        else
            begin
                 del2:=true;T2:=f2^.evalNum;   {f2 est dupliqué}
            end;
     if T2=nil then begin if del1 then Kill(Pcellule(T1)); exit end;
     rep:= Makepoly(T1,T2);
     if del1 then Kill(Pcellule(T1)); if del2 then Kill(Pcellule(T2));
     executer:=rep
end;
{===============================}
function MergeAretes(Const T:Paffixe;Const epsilon:real):Paffixe;
// T est une liste de facettes et la fonction renvoie la liste des aretes avec le caractère visible
// ou non (1/0) dans la partie imaginaire du jump. T ne sera pas modifiée
type taretes=record
              N1,n2:Tpt3d;
              visible:boolean
              end;
    paretes=^taretes;
    
var A,B,C:Tpt3d;
    aux,index,face:Paffixe;
    visible:boolean;
    nb,nb2:byte;
    liste:Tlist;
    l:type_liste;
    arete:Paretes;
    i:longint;
    
    procedure classerA(M1,M2:Tpt3d); {classer une arete dans l}
    var U1,U2:Tpt3d;
        stop,trouve:boolean;
    begin
         i:=0;
         stop:= (i>=liste.Count); trouve:=false;
         while not stop do
               begin
                    U1:=Paretes(liste.items[i]).N1;
                    U2:=Paretes(liste.items[i]).N2;
                    trouve:= ((distance3d(U1,M1)<=epsilon) and (distance3d(U2,M2)<=epsilon))
                             or
                             ((distance3d(U1,M2)<=epsilon) and (distance3d(U2,M1)<=epsilon));
                    Inc(i);
                    stop:= trouve or (i>=liste.Count)
               end;
         if trouve then  Paretes(liste.items[i-1]).visible:=Paretes(liste.items[i-1]).visible Or visible
            else
            begin
                 arete:=new(Paretes);
                 arete^.N1:=M1; arete^.N2:=M2; arete^.visible:=visible;
                 liste.add(arete)
            end
    end;
    
begin
    index:=T; nb:=1; l.init; face:=index; liste:=Tlist.Create;
    while index<>nil do
          begin
               if Isjump(index)
                  then //fin de facette
                       begin
                         if nb>6 then //il faut au moins 3 points pour une facette
                          begin
                            visible:=facevisible(A,B,C);
                            classerA(A,B);classerA(B,C);
                            nb2:=1;
                            while aux<>index do
                                  begin
                                       if nb2=1 then
                                          begin
                                               B.x:=aux^.x; B.y:=aux^.y;
                                          end
                                       else if nb2=2 then
                                            begin
                                                 B.z:=aux^.x;
                                                 classerA(C,B);
                                                 C:=B
                                            end;
                                       nb2:=3-nb2;
                                       aux:=Paffixe(aux^.suivant)
                                  end;
                            classerA(C,A); //on relie le dernier point au premier
                          end;
                          index:=Paffixe(index^.suivant);
                          face:=index; nb:=1; //pour la face suivante;
                       end
                  else
                      begin
                           if nb=1 then //mémorisation du premier point de la face
                              begin
                                   A.x:=index^.x; A.y:=index^.y
                              end
                           else if nb=2 then A.z:=index^.x
                           else if nb=3 then //mémorisation du deuxième point de la face
                              begin
                                   B.x:=index^.x; B.y:=index^.y
                              end
                           else if nb=4 then B.z:=index^.x
                           else if nb=5 then //mémorisation du troisième point de la face
                              begin
                                   C.x:=index^.x; C.y:=index^.y
                              end
                           else if nb=6 then
                                begin
                                     C.z:=index^.x;
                                     aux:=Paffixe(index^.suivant) //pointe sur le point suivant
                                end;
                           Inc(nb);
                           index:=Paffixe(index^.suivant);
                      end;

          end;
    for i:=0 to liste.Count-1 do
        begin
             A:=Paretes(liste.items[i]).N1; B:=Paretes(liste.items[i]).N2;
             visible:=Paretes(liste.items[i]).visible;
             dispose(Paretes(liste.items[i]));
             l.ajouter_fin(new(Paffixe,init(A.x,A.y)));
             l.ajouter_fin(new(Paffixe,init(A.z,0)));
             l.ajouter_fin(new(Paffixe,init(B.x,B.y)));
             l.ajouter_fin(new(Paffixe,init(B.z,0)));
             l.ajouter_fin(new(Paffixe,init(jump^.x,byte(visible))));
        end;
    liste.free;
    Result:=Paffixe(l.tete)
end;

function TAretes.executer(arg: Pliste):Presult;
//Aretes(liste facettes): renvoie la liste des aretes avec le caractère visible ou non dans Im(jump)
var f1:Pcorps;
    rep,T:Paffixe;
    del:boolean;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
     if f1^.categorie=cat_constante
        then
            begin
                 del:=false;       {si f1 est une constante/variable on ne la duplique pas}
                 T:=Paffixe(Pconstante(f1^.contenu)^.affixe);
            end
        else
            begin
                 del:=true;T:=f1^.evalNum;   {f1 est dupliqué}
            end;
     if T=nil then exit;
     rep:= MergeAretes(T,1e-10);
     if del then Kill(Pcellule(T));
     executer:=rep
end;
{===============================}
function CalcBord(Const T:Paffixe;Const epsilon:real):Paffixe;
// T est une liste de facettes et la fonction renvoie la liste des aretes formant le bord avec le caractère visible
// ou non (1/0) dans la partie imaginaire du jump. T ne sera pas modifiée
type taretes=record
              N1,n2:Tpt3d;
              visible:boolean;
              nb:longint
              end;
    paretes=^taretes;

var A,B,C:Tpt3d;
    aux,index,face:Paffixe;
    visible,okbord:boolean;
    nb,nb2:byte;
    liste:Tlist;
    l:type_liste;
    arete:Paretes;
    i:longint;

    procedure classerA(Const M1,M2:Tpt3d); {classer une arete dans l}
    var U1,U2:Tpt3d;
        stop,trouve:boolean;
    begin
         i:=0;
         stop:= (i>=liste.Count); trouve:=false;
         while not stop do
               begin
                    U1:=Paretes(liste.items[i]).N1;
                    U2:=Paretes(liste.items[i]).N2;
                    trouve:= ((distance3d(U1,M1)<=epsilon) and (distance3d(U2,M2)<=epsilon))
                             or
                             ((distance3d(U1,M2)<=epsilon) and (distance3d(U2,M1)<=epsilon));
                    Inc(i);
                    stop:= trouve or (i>=liste.Count)
               end;
         if trouve then
            begin
                 Paretes(liste.items[i-1]).visible:=Paretes(liste.items[i-1]).visible Or visible;
                 Inc(Paretes(liste.items[i-1]).nb)
            end
            else
            begin
                 arete:=new(Paretes);
                 arete^.N1:=M1; arete^.N2:=M2; arete^.visible:=visible; arete^.nb:=1;
                 liste.add(arete)
            end
    end;

begin
    index:=T; nb:=1; l.init; face:=index; liste:=Tlist.Create;
    while index<>nil do
          begin
               if Isjump(index)
                  then //fin de facette
                       begin
                         if nb>6 then //il faut au moins 3 points pour une facette
                          begin
                            visible:=facevisible(A,B,C);
                            classerA(A,B);classerA(B,C);
                            nb2:=1;
                            while aux<>index do
                                  begin
                                       if nb2=1 then
                                          begin
                                               B.x:=aux^.x; B.y:=aux^.y;
                                          end
                                       else if nb2=2 then
                                            begin
                                                 B.z:=aux^.x;
                                                 classerA(C,B);
                                                 C:=B
                                            end;
                                       nb2:=3-nb2;
                                       aux:=Paffixe(aux^.suivant)
                                  end;
                            classerA(C,A); //on relie le dernier point au premier
                          end;
                          index:=Paffixe(index^.suivant);
                          face:=index; nb:=1; //pour la face suivante;
                       end
                  else
                      begin
                           if nb=1 then //mémorisation du premier point de la face
                              begin
                                   A.x:=index^.x; A.y:=index^.y
                              end
                           else if nb=2 then A.z:=index^.x
                           else if nb=3 then //mémorisation du deuxième point de la face
                              begin
                                   B.x:=index^.x; B.y:=index^.y
                              end
                           else if nb=4 then B.z:=index^.x
                           else if nb=5 then //mémorisation du troisième point de la face
                              begin
                                   C.x:=index^.x; C.y:=index^.y
                              end
                           else if nb=6 then
                                begin
                                     C.z:=index^.x;
                                     aux:=Paffixe(index^.suivant) //pointe sur le point suivant
                                end;
                           Inc(nb);
                           index:=Paffixe(index^.suivant);
                      end;

          end;
    for i:=0 to liste.Count-1 do
        begin
             A:=Paretes(liste.items[i]).N1; B:=Paretes(liste.items[i]).N2;
             visible:=Paretes(liste.items[i]).visible;
             okbord:= (Paretes(liste.items[i]).nb=1);
             dispose(Paretes(liste.items[i]));
             if okbord then
                begin
                     l.ajouter_fin(new(Paffixe,init(A.x,A.y)));
                     l.ajouter_fin(new(Paffixe,init(A.z,0)));
                     l.ajouter_fin(new(Paffixe,init(B.x,B.y)));
                     l.ajouter_fin(new(Paffixe,init(B.z,0)));
                     l.ajouter_fin(new(Paffixe,init(jump^.x,byte(visible))));
                end;
        end;
    liste.free;
    Result:=Paffixe(l.tete)
end;
function TBord.executer(arg: Pliste):Presult;
//Bord(liste facettes): renvoie la liste des aretes formant le bord (ie aretes comptées une seule fois)
var f1,f2:Pcorps;
    rep,T:Paffixe;
    del:boolean;
    tolerance:real;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
     if f1^.categorie=cat_constante
        then
            begin
                 del:=false;       {si f1 est une constante/variable on ne la duplique pas}
                 T:=Paffixe(Pconstante(f1^.contenu)^.affixe);
            end
        else
            begin
                 del:=true;T:=f1^.evalNum;   {f1 est dupliqué}
            end;
     if T=nil then exit;
     f2:=Pcorps(f1^.suivant);
     tolerance:= 1e-10;
     if f2<>Nil then
        begin
             rep:=f2^.evalNum;
             if rep<>Nil then  tolerance:=abs(rep^.x);
             Kill(Pcellule(rep))
        end;
     rep:= CalcBord(T,tolerance);
     if del then Kill(Pcellule(T));
     executer:=rep
end;
{===============================}
function MergePt3d(Const T:Paffixe;Const tolerance:real;Const saveplace:boolean):Paffixe;
//T est une liste de facettes et la fonction renvoie la liste des sommets sans doublons
// T ne sera pas modifiée
var M,A:Tpt3d;
    index,index2:Paffixe;
    stop,trouve:boolean;
    nb,nb2:byte;
    aux:real;
    l:type_liste;
    place: longint;
begin
  index2:=T; nb2:=1; l.init;
  while index2<>nil do
  begin
   if Isjump(index2) then  nb2:=1 //fin de facette
                     else
    begin
      if nb2=1 then
               begin  //abscisse et ordonnée du point A à ranger
                    A.x:=index2^.x; A.y:=index2^.y;
                    nb2:=2;
               end
               else
               begin  //cote du point  A et parcourt de la liste l
                    A.z:=index2^.x; aux:=index2^.y; nb2:=1; place:=0;
                    index:=Paffixe(l.tete); stop:=(index=Nil); nb:=1; trouve:=false;
                    while not stop do
                    begin
                         if nb=1 then
                            begin    //abscisse et ordonnée du point M à tester
                                 M.x:=index^.x; M.y:=index^.y;
                            end else
                                begin //cote du point M
                                     M.z:=index^.x;
                                     Inc(place);
                                     trouve:=(distance3d(A,M)<=tolerance)
                                end;
                         index:=Paffixe(index^.suivant);
                         stop:=trouve or (index=Nil);
                         nb:=3-nb
                    end;
                    if not trouve then
                       begin
                            Inc(place);
                            l.ajouter_fin(new(Paffixe,init(A.x,A.y)));
                            if saveplace then
                                   l.ajouter_fin(new(Paffixe,init(A.z,place)))
                               else
                                   l.ajouter_fin(new(Paffixe,init(A.z,aux)));
                       end;
               end;
     end;
     index2:=Paffixe(index2^.suivant);
    end;
    Result:=Paffixe(l.tete)
end;

function TSommets.executer(arg: Pliste):Presult;
//Sommets(liste facettes): renvoie la liste des sommet sans doublons
var f1:Pcorps;
    rep,T:Paffixe;
    del:boolean;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
     if f1^.categorie=cat_constante
        then
            begin
                 del:=false;       {si f1 est une constante/variable on ne la duplique pas}
                 T:=Paffixe(Pconstante(f1^.contenu)^.affixe);
            end
        else
            begin
                 del:=true;T:=f1^.evalNum;   {f1 est dupliqué}
            end;
     if T=nil then exit;
     rep:= MergePt3d(T, 1e-10,false);
     if del then Kill(Pcellule(T));
     executer:=rep
end;

var nbsommets:longint;
{===============================}
function inserer3d(var l:type_liste;Const x,y,z,tolerance:real):longint;
var M,A:Tpt3d;
    index,a1,a2:Paffixe;
    stop,trouve:boolean;
    nb,place:longint;
begin
     A.x:=x; A.y:=y; A.z:=z;
    index:=Paffixe(l.tete); stop:=(index=Nil); place:=0; nb:=1; trouve:=false;
    while not stop do
          begin
               if nb=1 then
                  begin
                       M.x:=index^.x; M.y:=index^.y;
                  end else
                  begin
                       M.z:=index^.x;
                       Inc(place);
                       trouve:=(distance3d(A,M)<=tolerance)
                  end;
               index:=Paffixe(index^.suivant);
               stop:=trouve or (index=Nil);
               nb:=3-nb
          end;
    if not trouve then
       begin
            Inc(place); a1:=New(paffixe,init(x,y)); a2:=New(paffixe,init(z,0));
            a1^.suivant:=a2; a2^.precedent:=a1;
            l.ajouter_fin(a1);
            Inc(nbsommets);
       end;// else Kill(Pcellule(T));
    Result:=place;
end;

function TInserer3D.executer(arg: Pliste):Presult;
//Inserer3D( liste3D, point3D <,tolerance>): insere un point dans la liste sans doublon et renvoie la position
var f1, f2,f3:Pcorps;
    T,T1:Paffixe;
    tolerance:real;
    l:type_liste;
    rep:longint;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
     if (f1^.categorie<>cat_constante) or (Pconstante(f1^.contenu)^.predefinie) then exit;
     f2:=Pcorps(f1^.suivant); //f1 pointe sur une variable
     if f2=nil then exit;
     T:=f2^.evalNum;
     if (T=Nil) or (T^.suivant=Nil) then begin Kill(Pcellule(T)); exit end;
     //T pointe sur un point3D
     T1:=Paffixe(T^.suivant^.suivant); Kill(Pcellule(T1)); T^.suivant^.suivant:=Nil;
     f3:=Pcorps(f2^.suivant);
     if f3=Nil then tolerance:=0
               else
                   begin
                        T1:=f3^.evalNum;
                        if T1=Nil then tolerance:=0
                                  else tolerance:=abs(T1^.x);
                        Kill(Pcellule(T1));
                   end;
     //on a la tolerance
     l.init;l.ajouter_fin(Pconstante(f1^.contenu)^.affixe);
     rep:= inserer3d(l, T^.x, T^.y, Paffixe(T^.suivant)^.x, tolerance);
     Kill(Pcellule(T));
     Pconstante(f1^.contenu)^.affixe:=Paffixe(l.tete);
     if not Pconstante(f1^.contenu)^.locale then
     restoreVarG(Pconstante(f1^.contenu)^.nom,Paffixe(l.tete));
     
     executer:= new(Paffixe,init(rep, 0));
end;
{===============================}
function TConvertToObj.executer(arg: Pliste):Presult;
//ConvertToObj( liste3D, out sommets, out faces/lignes): renvoie nb_sommets+i*nb_faces/lignes]
var f1, f2,f3,f4:Pcorps;
    T, index1,aux:Paffixe;
    x,y:real;
    sommets,facettes:type_liste;
    nb,rep,nbfaces, firstindice, secondindice, nb2:longint;
    trianguler,del: boolean;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
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
     if T=nil then exit;
     f2:= Pcorps(f1^.suivant);
     if (f2=Nil) or (f2^.categorie<>cat_constante) or (Pconstante(f2^.contenu)^.predefinie) then exit;
     Kill(Pcellule(Pconstante(f2^.contenu)^.affixe));
     //f2 pointe sur une variable
     f3:= Pcorps(f2^.suivant);
     if (f3=Nil) or (f3^.categorie<>cat_constante) or (Pconstante(f3^.contenu)^.predefinie) then exit;
     Kill(Pcellule(Pconstante(f3^.contenu)^.affixe));
     //f3 pointe sur une variable
     trianguler:=false;
     f4:=Pcorps(f3^.suivant);
     if f4<>Nil then begin aux:=f4^.evalNum; if aux<>Nil then trianguler:=(aux^.x=1); Kill(Pcellule(aux)) end;
     sommets.init;facettes.init;nbsommets:=0; nbfaces:=0;
     index1:=T; nb:=1;
     while IsJump(index1) do  index1:=Paffixe(index1^.suivant);
     while index1<>Nil do
           begin
                nb2:=0;
                while (index1<>Nil) And (not IsJump(index1)) do
                    begin
                      if nb=2  then
                         begin
                              nb:=0;
                              //aux:=Paffixe(index1^.suivant);
                              //index1^.suivant:=Nil;
                              //if aux<>nil then aux^.precedent:=Nil;
                              //index1:=aux;
                              rep:=Inserer3d(sommets,x,y,index1^.x,1e-10);
                              //index:=index1;
                              if trianguler then
                              begin
                                   if nb2=2 then
                                      begin
                                           facettes.ajouter_fin(New(paffixe,init(firstindice,0)));
                                           facettes.ajouter_fin(New(paffixe,init(secondindice,0)));
                                           facettes.ajouter_fin(New(paffixe,init(rep,0)));
                                           facettes.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                                           secondindice:=rep; Inc(nbfaces)
                                      end
                                      else if nb2=1 then begin secondindice:=rep; nb2:=2 end
                                      else begin firstindice:=rep; nb2:=1 end;
                              end else facettes.ajouter_fin(New(Paffixe,init(rep,0)));
                         end else begin x:=index1^.x; y:=index1^.y end;
                         Inc(nb); index1:=Paffixe(index1^.suivant);
                    end;
                if not trianguler then
                   begin
                        inc(nbfaces);
                        facettes.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                   end;
                while IsJump(index1) do index1:=Paffixe(index1^.suivant);
                nb:=1;
           end;
     Pconstante(f2^.contenu)^.affixe:=Paffixe(sommets.tete);
     Pconstante(f3^.contenu)^.affixe:=Paffixe(facettes.tete);
     if del then Kill(pcellule(T));
     executer:= New(Paffixe,init(nbsommets,nbfaces));
end;
{===============================}
type TvertexN=record
               V,Vn:Tpt3d;
               nb:longint;
              end;
     PvertexN=^TvertexN;

function MoyennerNormal(var L:Tlist;Const T:Paffixe;Const Normal:Tpt3d;Const trianguler:boolean; var nbf:longint):Paffixe;
//T est une facette (sans jump) et la fonction renvoie dans la liste des sommets sans doublons
// en faisant la moyenne des indices des sommets avec le nouvel indice de couleur
// la fonction retourne la facette sous forme d'une liste de numeros de sommets éventuellement triangulée
var M,A:Tpt3d;
    index,index2,position:Paffixe;
    stop,trouve:boolean;
    nb,nb2,nb3:byte;
    nombre,oldindice,newindice,firstindice,secondindice:longint;
    place:longint;
    sortie:type_liste;
    S:PvertexN;
begin
  index2:=T; nb2:=1; sortie.init; nb3:=0; if not trianguler then Inc(nbf);
  while index2<>nil do
  begin
      if nb2=1 then
               begin  //abscisse et ordonnée du point A à ranger
                    A.x:=index2^.x; A.y:=index2^.y;
                    nb2:=2;
               end
      else
               begin  //cote du point  A et parcourt de la liste l
                    A.z:=index2^.x; nb2:=1; place:=0; trouve:=false;
                    stop:=(place=L.Count);
                    while not stop do
                    begin
                         M:=PVertexN(L.Items[place])^.V;
                         trouve:=(distance3d(A,M)<=1e-10);
                         stop:=trouve or (place=L.Count-1);
                         Inc(place);
                    end;
                    if not trouve then
                       begin
                            New(S); S.V:=A; S.Vn:=Normal; S.nb:=1;
                            L.add(S);
                            Inc(nbsommets)
                       end
                    else
                        begin
                             dec(place);
                             S:=PvertexN(L.Items[place]);
                             S.Vn.x:=ajouter(S.Vn.x,Normal.x);
                             S.Vn.y:=ajouter(S.Vn.y,Normal.y);
                             S.Vn.z:=ajouter(S.Vn.z,Normal.z);
                             inc(S.nb)
                        end;
                    if trianguler then
                       begin
                            if nb3=2 then
                               begin
                                    sortie.ajouter_fin(New(paffixe,init(firstindice,0)));
                                    sortie.ajouter_fin(New(paffixe,init(secondindice,0)));
                                    sortie.ajouter_fin(New(paffixe,init(place+1,0)));
                                    sortie.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                                    secondindice:=place+1;Inc(nbf)
                               end
                            else if nb3=1 then begin secondindice:=place+1; nb3:=2 end
                            else begin firstindice:=place+1; nb3:=1; end;
                       end
                    else  sortie.ajouter_fin(New(paffixe,init(place+1,0)));
               end;
    index2:=Paffixe(index2^.suivant);
    end;
    result:=Paffixe(sortie.tete)
end;

function ConvertToObjN(Const facettes:Paffixe; var sommets, faces:Paffixe;Const trianguler:boolean): Paffixe;
// facettes est une liste de facettes, la fonction renvoie [nbsommets+i*nbfaces], la variable sommets contiendra
// la liste des sommets avec un vecteur normal et faces la liste des facettes avec numéros de sommets
var face:Paffixe;
    index:Paffixe;
    sommetsNormalises,facetteNumerotes,res:type_liste;
    nb,nbfaces,i:longint;
    L:Tlist;
    A,B,C,Vn:Tpt3d; //3 points de la facettes et le vecteur normal unitaire;
    S:PVertexN;
begin
    nbsommets:=0; nbfaces:=0;
    L:=Tlist.Create;
    index:=facettes; facetteNumerotes.init; sommetsNormalises.init; nb:=1;
    while IsJump(index) do index:=Paffixe(index^.suivant);
    face:=index;
    while index<>nil do
          begin
               if IsJump(index) then
                  begin
                       if (nb>5) and (not CalcError) then
                       begin
                         Vn:=Normalize(pvect(B,C));
                         index^.precedent^.suivant:=Nil; //on decroche la facette
                         facetteNumerotes.ajouter_fin(MoyennerNormal(L, face, Vn,trianguler,nbfaces));
                         if not trianguler then facetteNumerotes.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)));
                         index^.precedent^.suivant:=index; //on raccroche la face
                       end;
                       while IsJump(index) do index:=Paffixe(index^.suivant);
                       face:=index; nb:=1; CalcError:=false;
                  end else
                      begin
                           if nb=1 then begin A.x:=index^.x; A.y:=index^.y end
                           else
                           if nb=2 then A.z:=index^.x
                           else if nb=3 then begin B.x:=soustraire(index^.x,A.x);
                                                   B.y:=soustraire(index^.y,A.y) end
                           else if nb=4 then B.z:=soustraire(index^.x,A.z)
                           else if nb=5 then begin C.x:=soustraire(index^.x,A.x);
                                                   C.y:=soustraire(index^.y,A.y) end
                           else if nb=6 then C.z:=soustraire(index^.x,A.z);
                           Inc(nb);
                           index:=Paffixe(index^.suivant)
                      end;
          end;

// il faut maintenant faire la moyenne pour chaque sommet
   for i:=0 to L.count-1 do
       begin
            S:=PvertexN(L.Items[i]);
            S.Vn.x:=diviser(S.Vn.x,S.nb); S.Vn.y:=diviser(S.Vn.y,S.nb); S.Vn.z:=diviser(S.Vn.z,S.nb);
            S.Vn:=Normalize(S.Vn);
            sommetsNormalises.ajouter_fin(New(Paffixe,init(S.V.x,S.V.y)));
            sommetsNormalises.ajouter_fin(New(Paffixe,init(S.V.z,0)));
            sommetsNormalises.ajouter_fin(New(Paffixe,init(S.Vn.x,S.Vn.y)));
            sommetsNormalises.ajouter_fin(New(Paffixe,init(S.Vn.z,0)));
            Dispose(S);
       end;
   L.free;
   res.init; res.ajouter_fin(New(Paffixe,init(nbsommets,nbfaces)));
   result:=Paffixe(res.tete);
   sommets:=Paffixe(sommetsNormalises.tete);
   faces:=Paffixe(facetteNumerotes.tete);
end;

function TConvertToObjN.executer(arg: Pliste):Presult;
// ConvertToObjN(facettes, out: sommets, out: faces avec n° de sommet): renvoie [nb sommets, nb faces/lignes]
// chaque sommet est suivi de son vecteur normal unitaire,
var f1,f2,f3,f4:Pcorps;
    T,sommets,faces:Paffixe;
    cacher:boolean;
    contrast:real;
    couleur:longint;
    del,trianguler:boolean;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:=Pcorps(arg^.tete);

     f2:= Pcorps(f1^.suivant);
     if (f2=Nil) or (f2^.categorie<>cat_constante) or (Pconstante(f2^.contenu)^.predefinie) then exit;
     Kill(Pcellule(Pconstante(f2^.contenu)^.affixe));
     //f2 pointe sur une variable
     f3:= Pcorps(f2^.suivant);
     if (f3=Nil) or (f3^.categorie<>cat_constante) or (Pconstante(f3^.contenu)^.predefinie) then exit;
     Kill(Pcellule(Pconstante(f3^.contenu)^.affixe));
     //f3 pointe sur une variable
     trianguler:=false;
     f4:=Pcorps(f3^.suivant); if f4<>Nil then begin T:=f4^.evalNum; if T<>Nil then trianguler:=(T^.x=1); Kill(Pcellule(T)) end;
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
     if T=nil then exit;

     executer:=ConvertToObjN(T,sommets,faces, trianguler);
     Pconstante(f2^.contenu)^.affixe:=sommets;
     Pconstante(f3^.contenu)^.affixe:=faces;
     if del then Kill(Pcellule(T));
end;
{===============================}
function MoyennerPt3d(var l:type_liste;Const T:Paffixe;Const indice:real):Paffixe;
//T est une facette (sans jump) et la fonction met à jour la liste des sommets sans doublons
// en faisant la moyenne des indices des sommets avec le nouvel indice de couleur (dans la partie imaginaire de la cote)
// la fonction retourne la facette sous forme d'une liste de numeros de sommets
var M,A:Tpt3d;
    index,index2,position:Paffixe;
    stop,trouve:boolean;
    nb,nb2:byte;
    nombre,oldindice,newindice:real;
    place:longint;
    sortie:type_liste;
begin
  index2:=T; nb2:=1; sortie.init;
  while index2<>nil do
  begin
      if nb2=1 then
               begin  //abscisse et ordonnée du point A à ranger
                    A.x:=index2^.x; A.y:=index2^.y;
                    nb2:=2;
               end
               else
               begin  //cote du point  A et parcourt de la liste l
                    A.z:=index2^.x; nb2:=1;
                    index:=Paffixe(l.tete); stop:=(index=Nil); nb:=1; place:=0; trouve:=false;
                    while not stop do
                    begin
                         if nb=1 then
                            begin    //abscisse et ordonnée du point M à tester
                                 M.x:=index^.x; M.y:=index^.y;
                            end else
                                begin //cote du point M
                                     M.z:=index^.x;
                                     Inc(place); position:=index;
                                     trouve:=(distance3d(A,M)<=1e-10)
                                end;
                         index:=Paffixe(index^.suivant);
                         stop:=trouve or (index=Nil);
                         nb:=3-nb
                    end;
                    if not trouve then
                       begin
                            Inc(place);
                            l.ajouter_fin(new(Paffixe,init(A.x,A.y)));
                            if indice<0 then
                               l.ajouter_fin(new(Paffixe,init(A.z,indice-1)))
                            else
                               l.ajouter_fin(new(Paffixe,init(A.z,indice+1)))
                       end
                    else
                        begin {calcul du nouvel indice celui-ci est de la forme:
                               nbvisite (partie entiere)+indice (entre 0 et 1)
                              nombre est le nombre de fois que ce sommet a ete visite
                               le veritable indice est la partie fractionnaire}
                              oldindice:=position^.y;
                              if oldindice<0 then
                                 begin
                                      nombre:=-Int(oldindice);
                                      oldindice:=oldindice+nombre //partie fractionnaire dans oldindice
                                 end
                              else begin
                                        nombre:=Int(oldindice);
                                        oldindice:=oldindice-nombre //partie fractionnaire dans oldindice
                                   end;
                              nombre:=nombre+1;
                              newindice:=(indice+(nombre-1)*oldindice)/nombre; //nouvel indice
                              if newindice<0 then newindice:=newindice-nombre
                                             else newindice:=newindice+nombre;
                              position^.y:=newindice;
                        end;
                    sortie.ajouter_fin(New(paffixe,init(place,0)));
               end;
    index2:=Paffixe(index2^.suivant);
    end;
    result:=Paffixe(sortie.tete)
end;

function PaintVertex(Const facettes:Paffixe;Const couleur:Tcolor): Paffixe;
// facettes est une liste de facettes, la fonction renvoie la liste des facettes avec un indice de couleur
// dans la partie imaginaire de la cote de chaque sommet pour l'algorithme de Gouraud
var face:Paffixe;
    index:Paffixe;
    l:type_liste;
    facetteNumerote:type_liste;
    nb:longint;
    rcolor,gcolor,bcolor:longint;


begin
    GouraudShading:=true;
    rcolor:=GetRvalue(couleur);
    gcolor:=GetGvalue(couleur);
    bcolor:=GetBvalue(couleur);

    index:=facettes; l.init;  facetteNumerote.init;
    while IsJump(index) do index:=Paffixe(index^.suivant);
    face:=index;
    while index<>nil do
          begin
               if IsJump(index) then
                  begin
                       index^.precedent^.suivant:=Nil; //on decroche la facette
                       facetteNumerote.ajouter_fin(MoyennerPt3d(l, face, index^.y));
                       facetteNumerote.ajouter_fin(new(Paffixe,init(jump^.x,
                                                                         2+getfillcolor(rcolor,gcolor,bcolor,index^.y))));
                       index^.precedent^.suivant:=index; //on raccroche la face
                       while IsJump(index) do index:=Paffixe(index^.suivant);
                       face:=index;
                  end else index:=Paffixe(index^.suivant)
          end;
          
// il faut maintenant enlever la partie entiere de l'indice de chaque sommet et calculer sa couleur
    index:=Paffixe(l.tete); nb:=1;
    while index<>nil do
          begin
               if nb=2 then index^.y:=2+getfillcolor(rcolor,gcolor,bcolor,index^.y-Int(index^.y));//code couleur+2
               nb:=3-nb;
               index:=Paffixe(index^.suivant)
          end;
// on reconstruit le polyedre
    result:= makepoly(Paffixe(l.tete), Paffixe(facetteNumerote.tete));
    l.detruire; facetteNumerote.detruire;
    GouraudShading:=false;
end;

function TPaintVertex.executer(arg: Pliste):Presult;
//PaintVertex(liste facettes, couleur+i*(behind 0/1), backculling(0/1)+i*contrast): renvoie les facettes avec les indices de
//couleurs à chaque sommet
var f1,f2,f3:Pcorps;
    T,aux:Paffixe;
    cacher,nobehind:boolean; //eliminer ou non les parties cachées, distinguer ou non le dos du devant
    contrast:real;
    couleur:longint;
begin
     executer:=Nil;
     if (arg=nil) or (Pcorps(arg^.tete)=nil) then exit;
     f1:= Pcorps(arg^.tete);
     T:=f1^.evalNum;   {f1 est dupliqué}
     if T=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;     //on attend une couleur
     aux:=f2^.evalNum;
     if (aux=Nil) then begin Kill(Pcellule(T)); exit end;
     //T pointe sur une couleur
     couleur:=Round(abs(aux^.x));
     nobehind:=(Round(abs(aux^.y)) mod 2)=1;
     Kill(Pcellule(aux));
     cacher:=false; contrast:=1;
     f3:=Pcorps(f2^.suivant);
     if f3<> nil then aux:=f3^.evalNum else aux:=nil;
     if aux<>nil then
        begin
                cacher:= (Round(aux^.x) mod 2)=1;
                contrast:= aux^.y;
                Kill(Pcellule(aux));
        end;

     //on a le contrast
    if contrast<=0 then contrast:=2.5 //une couleur unie avec Gouraud n'a pas vraiment de sens.
                   else contrast:=2.5*contrast;
    GouraudShading:=true;
    TraiterFacettes(T,false,cacher,contrast,nobehind,false); //false signifie: pas de tri
    GouraudShading:=false;
    executer:= PaintVertex(T,couleur);
    Kill(Pcellule(T));
end;
{===============================}
function TReadObj.executer;
//ReadObj(fichier,sortie: facettes construites, sortie:  lignes contruites, sortie: liste sommets,
//        sortie: facettes avec numéro de sommet, sortie: lignes avec numéro de sommet,)
var f1,f2,f3,f4,f5,f6:Pcorps;
    source:text;
    ListSommets, ListFaces, ListLignes:type_liste;
    car:char;
    mot:string;
    fichier:string;
    A:Tpt3d;
    P:Ppt3d;
    entier,i: longint;
    okSortieSommets, okSortieFaces, okSortieLignes:boolean;

    signaleError,endface:boolean;
    sommets:TList;
    facettes,lignes:type_liste;
    
    procedure liremot;
    begin
         mot:='';
         repeat
               read(source,car)
         until (car in ['a'..'z']) or eof(source);
         if not eof(source) then
            begin
                 repeat
                       mot:=mot+car;
                       read(source,car)
                 until (car in [' ',#10,#13]) or eof(source);
            end else mot:=car;
    end;
    
    procedure lireentier;
    var fini:boolean;
        erreur:integer;
    begin
         mot:=''; fini:=false;car:=#0;
         repeat
               read(source,car)
         until (car in ['0'..'9']) or eoln(source);
         mot:=car;
         endface:=eoln(source);
         if not endface then
                begin
                 repeat
                       read(source,car);
                       if (not fini) and (car in ['0'..'9']) then mot:=mot+car;
                       fini:= fini or (car='/');
                 until (car in [' ']) or eoln(source);
                 endface:=eoln(source);
                end;
         val(mot,entier,erreur);
         signaleError:=(erreur<>0);
    end;
         

begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) or (Pconstante(f2^.contenu)^.predefinie) then exit;
     f3:=Pcorps(f2^.suivant);
     if f3<>nil then
        if (f3^.categorie<>cat_constante) or (Pconstante(f3^.contenu)^.predefinie) then exit;
     Kill(Pcellule(Pconstante(f2^.contenu)^.affixe));
     if f3<>nil then  Kill(Pcellule(Pconstante(f2^.contenu)^.affixe));
     fichier:=MakeString(f1);
     if not FileExists(fichier) then
        begin
             executer:=New(Paffixe,init(0,0));
             exit;
        end;
      assign(source,fichier);
         {$I-}
      system.reset(source);
         {$I+}
     if eof(source) then begin close(source);exit;end;
     
     f4:=Nil; f5:=Nil; f6:=Nil;
     if f3<>Nil then f4:=Pcorps(f3^.suivant);
     if f4<>Nil then f5:=Pcorps(f4^.suivant);
     if f5<>Nil then f6:=Pcorps(f5^.suivant);
     
     okSortieSommets:=(f4<>nil) and (f4^.categorie=cat_constante) and (not Pconstante(f4^.contenu)^.predefinie);
     okSortieFaces:=(f5<>nil) and (f5^.categorie=cat_constante) and (not Pconstante(f5^.contenu)^.predefinie);
     okSortieLignes:=(f6<>nil) and (f6^.categorie=cat_constante) and (not Pconstante(f6^.contenu)^.predefinie);


     if okSortieSommets then  Kill(Pcellule(Pconstante(f4^.contenu)^.affixe));
     if okSortieFaces then  Kill(Pcellule(Pconstante(f5^.contenu)^.affixe));
     if okSortieLignes then  Kill(Pcellule(Pconstante(f6^.contenu)^.affixe));
     
     sommets:=TList.Create;
     signaleError:=false; facettes.init; lignes.init; ListSommets.init; ListFaces.init; ListLignes.init;

     while not (signaleError or eof(source)) do
           begin
                liremot;
                if mot='v' then
                           begin
                                 P:=new(Ppt3d);
                                 {$I-}
                                 readln(source,P^.x,P^.y,P^.z);
                                 {$I+}
                                 if IOresult<>0
                                    then begin signaleError:=true; dispose(P);end
                                    else sommets.Add(P);
                                 if okSortieSommets then
                                    begin
                                       ListSommets.ajouter_fin(New(Paffixe,init(P^.x,P^.y)));
                                       ListSommets.ajouter_fin(New(Paffixe,init(P^.z,0)));
                                    end
                          end
                else if mot='f' then
                     begin
                        endface:=false;
                        while not (signaleError or endface) do
                              begin
                                   lireentier;
                                   if not signaleError then
                                     begin
                                          if entier> sommets.Count then signaleError:=true;
                                          if not signaleError then
                                             begin
                                                  A:=Ppt3d( sommets.Items[entier-1])^;
                                                  facettes.ajouter_fin(New(Paffixe,init(A.x,A.y)));
                                                  facettes.ajouter_fin(New(Paffixe,init(A.z,0)));
                                                  if okSortieFaces then
                                                     ListFaces.ajouter_fin(New(Paffixe,init(entier,0)));
                                             end;
                                     end;
                              end;
                        facettes.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                        if okSortieFaces then
                           ListFaces.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                     end
                else if mot='l' then
                     begin
                          endface:=false;
                          while not (signaleError or endface) do
                                begin
                                     lireentier;
                                     if not signaleError then
                                     begin
                                          if entier> sommets.Count then signaleError:=true;
                                          if not signaleError then
                                             begin
                                                  A:=Ppt3d( sommets.Items[entier-1])^;
                                                  lignes.ajouter_fin(New(Paffixe,init(A.x,A.y)));
                                                  lignes.ajouter_fin(New(Paffixe,init(A.z,0)));
                                                  if okSortieLignes then
                                                     ListLignes.ajouter_fin(New(Paffixe,init(entier,0)));
                                             end;
                                          end;
                                     end;
                          lignes.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                          if okSortieLignes then
                           ListLignes.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                     end
                else if mot='#' then readln(source);
           end;
     close(source);
     for i:=0 to sommets.Count-1 do dispose(Ppt3d(sommets.Items[i]));
     sommets.free;
     if signaleError then
        begin
             executer:=New(Paffixe,init(0,0));
             facettes.detruire; lignes.detruire;ListSommets.detruire;ListFaces.detruire;Listlignes.detruire;
        end
     else
         begin
              executer:=New(Paffixe,init(1,0));
              Pconstante(f2^.contenu)^.affixe:=Paffixe(facettes.tete);
              if f3<>nil then Pconstante(f3^.contenu)^.affixe:=Paffixe(lignes.tete)
                         else lignes.detruire;
              if okSortieSommets then Pconstante(f4^.contenu)^.affixe:=Paffixe(ListSommets.tete);
              if okSortieFaces then Pconstante(f5^.contenu)^.affixe:=Paffixe(ListFaces.tete);
              if okSortieLignes then Pconstante(f6^.contenu)^.affixe:=Paffixe(ListLignes.tete);
         end;
end;
{==========================================}
Initialization

     Ptheta:=New(Pconstante,init('theta',New(Paffixe,init(pi/6,0)),false));
     Pphi:=New(Pconstante,init('phi',New(Paffixe,init(pi/3,0)),false));
     LesConstantes.ajouter_fin(Ptheta);
     LesConstantes.ajouter_fin(Pphi);   //pour la 3D

 LesCommandes.ajouter_fin(New(PSortFacet,init('SortFacet')));
 //SortFacet( liste facette, backculling(0/1)+i*contrast( entre 0 et 1)) contrast=0 par defaut
 LesCommandes.ajouter_fin(New(PClipFacet,init('ClipFacet')));
  //ClipFacet( facette(s), plan, out: derriere, out: intersection)
 LesCommandes.ajouter_fin(New(PGet3D,init('Get3D')));
 LesCommandes.ajouter_fin(New(PDisplay3D,init('Display3D')));
 LesCommandes.ajouter_fin(New(PModelView,init('ModelView')));
 // permet de changer ou de renvoyer le type de projection
 LesCommandes.ajouter_fin(New(PposCam,init('PosCam')));
 //change la postion ou renvoie la postion  de la camera si on est en projection centrale
 LesCommandes.ajouter_fin(New(PDistCam,init('DistCam')));
 //règle la distance caméra - origine, ou renvoie la cette distance  si on est en projection centrale

 LesCommandes.ajouter_fin(New(Pbuild3d,init('Build3D')));
 // Build3D(
 // [0, coul, facettes], (cloison)
 // [+/-1,+/-coul+/-i*opacité, facettes],
 // [2,coul+i*opacite, width+i*linestyle, segments],
 // [3, coul+i*opacite,width+i*linestyle, dots],
 // [3+i, coul+i*numMac, labelsize+i*labelstyle, [pos,dir]],...)  label
 // [3-i, coul+i*numMac, labelsize+i*labelstyle, [pos,dir]],...)  TexLabel

 LesCommandes.ajouter_fin(New(PGetSurface,init('GetSurface')));
 // GetSurface(f(u,v),umin+i*uMax, vMin+i*Vmax, uNbLg+i*vNbLg)

 LesCommandes.ajouter_fin(New(PClip3Dline,init('Clip3DLine')));
 // Clip3DLine( ligne, plan, closed, out: derriere)
 
 LesCommandes.ajouter_fin(New(PProj3D,init('Proj3D')));  //projeté sur le plan de projection, tient compte de la matrice
 LesCommandes.ajouter_fin(New(Pprodvec,init('Prodvec')));//produit vectoriel: Prodvec(u,v)
 LesCommandes.ajouter_fin(New(Pprodscal,init('Prodscal')));//produit scalaire: Prodscal(u,v)
 LesCommandes.ajouter_fin(New(PNorme,init('Norm')));//norme: Norm(u)
 LesCommandes.ajouter_fin(New(PNormal,init('Normal')));//vecteur normal
 
 LesCommandes.ajouter_fin(New(PSetMatrix3d,init('SetMatrix3D')));//Définir une matrice 3d
 LesCommandes.ajouter_fin(New(PComposeMatrix3d,init('ComposeMatrix3D')));//(composition avec la matrice courante)
 LesCommandes.ajouter_fin(New(PMtransform3d,init('Mtransform3D')));     // version 1.95
 //Mtransform3D( liste points 3D <,matrice3d> ) applique la matrice3d sur la liste (matrice courante par défaut)
 LesCommandes.ajouter_fin(New(PGetMatrix3d,init('GetMatrix3D')));//renvoie la matrice 3d courante
 LesCommandes.ajouter_fin(New(PFvisible,init('Fvisible')));// Fvisible(facette) renvoie 1 si la facette est visible
 LesCommandes.ajouter_fin(New(PIdMatrix3d,init('IdMatrix3D')));//Revenir à la matrice par défaut
 LesCommandes.ajouter_fin(new(PReadObj,init('ReadObj')));
//ReadObj(fichier (avec extension), sortie: facettes construites, sortie:  lignes construites, sortie: liste sommets,
//        sortie: facettes avec numéros de sommet, sortie: lignes avec numéros de sommet), renvoie Nil

 LesCommandes.ajouter_fin(new(PConvertToObj,init('ConvertToObj')));
// ConvertToObj(facettes, out: sommets, out: faces/lignes avec n° de sommet, trianguler(0/1)): renvoie nb sommets+i*(nb faces/lignes)

 LesCommandes.ajouter_fin(New(PConvertToObjN,init('ConvertToObjN')));
// ConvertToObjN(facettes, out: sommets, out: faces avec n° de sommet, trianguler(0/1)): renvoie sommets+i*(nb faces/lignes)
// chaque sommet est suivi de son vecteur normal unitaire, pour un export en geom (geomview).
 
{ commandes liées aux polyèdres et listes de facettes }

 LesCommandes.ajouter_fin(New(PInserer3D,init('Inserer3D')));
 //Inserer3D( liste3D, point3D <,tolerance>): insere un point dans la liste sans doublon et renvoie la position
  LesCommandes.ajouter_fin(New(PInserer3D,init('Insert3D')));//english version

 LesCommandes.ajouter_fin(New(PSommets,init('Sommets')));
  // Sommets( liste de facettes):  renvoie la liste des sommets sans doublons
 LesCommandes.ajouter_fin(New(PSommets,init('Vertices')));// english version
 
 LesCommandes.ajouter_fin(New(PAretes,init('Aretes')));
 // Aretes( liste de facettes):  renvoie la liste des aretes avec le caractere visible ou non dans Im(jump)
 LesCommandes.ajouter_fin(New(PAretes,init('Edges'))); //english version
 
 LesCommandes.ajouter_fin(New(PBord,init('Bord')));
 // Bord(liste de facettes, <tolerance>):  renvoie la liste des aretes formant le bord avec le caractere visible ou non dans Im(jump)
 LesCommandes.ajouter_fin(New(PBord,init('Outline')));//english version

 LesCommandes.ajouter_fin(New(PMakePoly,init('MakePoly')));
 // MakePoly(sommets, facettes (avec n°sommets)):  renvoie la liste des facettes avec coordonnées des sommets
 
 LesCommandes.ajouter_fin(New(PPaintFacet,init('PaintFacet')));
//PaintFacet( liste Facettes,couleur+i*(annuler orientation =0/1),backculling(0/1)+i*contrast): renvoie la liste des facettes après avoir inserer
// la couleur dans le jump de chaque facette

 LesCommandes.ajouter_fin(New(PPaintVertex,init('PaintVertex')));
 // PaintVertex(facettes,  couleur+i*(annuler orientation =0/1), backculling(0/1)+i*contrast):  renvoie la liste des facettes avec pour
 // chaque sommet sa couleur, pour un export en Gouraud Shading (macro DrawSmooth).


 scene:=nil;
 sceneCMD:=New(Pliste,init);
 Matrix3D:=Nil;
 centrale:=False;
 Dcamera:=15;
 CalculerN;
Finalization
  detruire3D(scene);
  dispose(sceneCMD,detruire);
  dispose(Matrix3D);

end.

