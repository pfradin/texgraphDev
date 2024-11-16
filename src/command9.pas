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


Unit command9; {définition de commandes graphiques}
{$MODE Delphi}
INTERFACE
uses SysUtils,listes2,complex3,analyse4,command5,command53d,graph1_6,graph2_7,Untres;

IMPLEMENTATION

type

      PPolyg= ^TPolyg;
      TPolyg= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      PCourbe= ^TCourbe;
      TCourbe= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;
           
      PCartesienne2= ^TCartesienne2;
      TCartesienne2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

     
      PPolaire2= ^TPolaire2;
      TPolaire2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      PDroite2= ^TDroite2;
      TDroite2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      Pellipse2= ^Tellipse2;
      Tellipse2= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

      PNuage= ^TNuage;
      TNuage= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      PTangent= ^TTangent;
      TTangent= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;
          
      PEllipticArc2= ^TEllipticArc2;
      TEllipticArc2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;
     
      PEquaDif2= ^TEquaDif2;
      TEquaDif2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      PImplicit2= ^TImplicit2;
      TImplicit2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      Pbezier2= ^Tbezier2;
      Tbezier2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;
      
      Putilisateur2=^Tutilisateur2;
      Tutilisateur2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      Plabel2= ^Tlabel2;
      Tlabel2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      Pspline2= ^Tspline2;
      Tspline2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

     PGetspline= ^TGetspline;
     TGetspline= object(Tcommande)
                function executer(arg:PListe):Presult;virtual;
                end;


      PPath2= ^TPath2;
      TPath2= object(Tcommande)
           function executer(arg:PListe):Presult;virtual;
           end;

      PExportPathData= ^TExportPathData;
      TExportPathData= object(Tcommande) //export des données d'un path sans les attributs
           function executer(arg:PListe):Presult;virtual;
           end;

       Pwind=^Twind;
       Twind= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

       PMarges=^TMarges;
       TMarges= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

       PEval=^TEval;
       TEval= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

       PStrEval=^TStrEval;
       TStrEval= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

       PGet=^TGet;
       TGet= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

       PExportObject=^TExportObject;
       TExportObject= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

       PMyExport2=^TMyExport2;
       TMyExport2= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;
              
       PSaut2=^TSaut2;
       TSaut2= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;

       PClose2=^TClose2;
       TClose2= object(Tcommande)
                     function executer(arg:PListe):Presult;virtual;
              end;


var MakeListe: Pcorps; {arbre contenant la fonction Liste}

function NomStandard: string;
begin
        if ContexteUtilisateur then result:=''
          else
                begin
                        PcomptGraph^.affixe^.setx(PcomptGraph^.affixe^.getx+1);
                        Result:=TgObject+Streel(PcomptGraph^.affixe^.getx);
                end;
end;

{TLigne}
function TPolyg.executer(arg:PListe):Presult;
var f1,f2,f3:PCorps;
    closed:byte;
    Unrayon:real;
    aux1,aux2:Paffixe;
    res:Pligne;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     Unrayon:=0;closed:=0;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=PCorps(f1^.suivant);
     if f2=nil then begin closed:=0; f3:=Nil end
     else begin
          f3:=Pcorps(f2^.suivant);
          aux1:=f2^.evalNum;
          if aux1<>nil then begin closed:=round(aux1^.x);Kill(Pcellule(aux1)) end;
     end;
     if f3<>nil then begin aux2:=f3^.evalNum end
                else begin aux2:=nil;end;
     if aux2<>nil then begin Unrayon:=aux2^.x;Kill(Pcellule(aux2)) end;
     //aux:=f1^.en_chaine;
     res:=new(PLigne,init('','',closed,Unrayon));
     res^.ConstruitArbre(f1);
     res^.Recalculer;
     liste_enfant^.ajouter_fin(res)
end;

{Tpath2}
function TPath2.executer(arg:PListe):Presult;
var f1,f2:PCorps;
    closed:byte;
    aux1:Paffixe;
    res:PPath;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     closed:=0;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=PCorps(f1^.suivant);
     if f2<>nil then aux1:=f2^.evalNum else aux1:=nil;
     if aux1<>nil then begin closed:=round(aux1^.x);Kill(Pcellule(aux1)) end;
     res:=new(PPath,init('','',closed));
     res^.ConstruitArbre(f1);
     res^.Recalculer;
     liste_enfant^.ajouter_fin(res)
end;


{TExportPathData}
function TExportPathData.executer(arg:PListe):Presult;
var f1,f2:PCorps;
    mode:byte;
    aux1:Paffixe;
    res:PPath;
    strRes:string ;
begin
     executer:=nil;
     mode:=0;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=PCorps(f1^.suivant);
     if f2=nil then exit;
     aux1:=f1^.evalNum;
     if aux1<>nil then begin mode:=round(aux1^.x);Kill(Pcellule(aux1)) end;
     res:=new(PPath,init('','',0));
     res^.ConstruitArbre(f2);
     res^.Recalculer;
     StrRes:=res^.ExportData(mode);
     dispose(res,detruire);
     if (WriteMode Or OpenFile) then exit;
     executer:=New(Pchaine,init(StrRes))
end;


{Commande TImplicit2}
function TImplicit2.executer(arg:PListe):Presult;
var p,f1:PCorps;
    //chaine:string;
    res:PImplicit;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(PImplicit,init('',''));
     res^.ConstruitArbre(p);
     res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande TSaut2}
function TSaut2.executer(arg:PListe):Presult;
var p,f1:PCorps;
    res:PSaut;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(PSaut,init('',''));
     res^.ConstruitArbre(p);
     res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande TClose2}
function TClose2.executer(arg:PListe):Presult;
var p,f1:PCorps;
    res:PClose;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(PClose,init('',''));
     res^.ConstruitArbre(p);
     res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande TMyExport2}
function TMyExport2.executer(arg:PListe):Presult;
var f1:PCorps;
    username:string;
    res:PMyExport;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     username:=MakeString(f1);
     if username='' then exit;
     res:= new(Pmyexport,init('','',username, arg));
     res^.construitArbre(Nil); res^.recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande TCourbe}
function TCourbe.executer(arg:PListe):Presult;
var f1,f2,f3:PCorps;
    T:Paffixe;
    diviser,saut:byte;
    res:Pparametree;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2<>nil then f3:=Pcorps(f2^.suivant);
     diviser:=5; saut:=0;
     if f2<>nil then
        begin
             T:=f2^.evalNum;
             if T<>nil then begin diviser:=Round(T^.x) mod 256; Kill(Pcellule(T)) end;
             if f3<>nil then
                begin
                     T:=f3^.evalNum;
                     if T<>nil then begin saut:=Round(T^.x) mod 2; Kill(Pcellule(T)) end;
                end;
        end;
     res:=new(Pparametree,init('','',diviser,saut));
     res^.ConstruitArbre(f1);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande TCartsienne2}
function TCartesienne2.executer(arg:PListe):Presult;
var f1,f2,f3:PCorps;
    T:Paffixe;
    diviser,saut:byte;
    //chaine:string;
    res:PCartesienne;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2<>nil then f3:=Pcorps(f2^.suivant);
     diviser:=5; saut:=0;
     if f2<>nil then
        begin
             T:=f2^.evalNum;
             if T<>nil then begin diviser:=Round(T^.x) mod 256; Kill(Pcellule(T)) end;
             if f3<>nil then
                begin
                     T:=f3^.evalNum;
                     if T<>nil then begin saut:=Round(T^.x) mod 2; Kill(Pcellule(T)) end;
                end;
        end;
     res:=new(PCartesienne,init('',f1^.en_chaine,diviser,saut));
     //res^.ConstruitArbre(f1);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande TPolaire2}
function TPolaire2.executer(arg:PListe):Presult;
var f1,f2,f3:PCorps;
    T:Paffixe;
    diviser,saut:byte;
    //chaine:string;
    res:Ppolaire;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if f2<>nil then f3:=Pcorps(f2^.suivant);
     diviser:=5; saut:=0;
     if f2<>nil then
        begin
             T:=f2^.evalNum;
             if T<>nil then begin diviser:=Round(T^.x) mod 256; Kill(Pcellule(T)) end;
             if f3<>nil then
                begin
                     T:=f3^.evalNum;
                     if T<>nil then begin saut:=Round(T^.x) mod 2; Kill(Pcellule(T)) end;
                end;
        end;
     res:=new(PPolaire,init('',f1^.en_chaine,diviser,saut));
     //res^.ConstruitArbre(f1);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;


{Commande TDroite2}
function TDroite2.executer(arg:PListe):Presult;
var p,f1,f2:PCorps;
    //chaine:string;
    res:Pdroite;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     //f2:=Pcorps(f1^.suivant);
     //if f2=nil then exit;
     //f3:=Pcorps(f2^.suivant);
     p:=MakeListe;
     p^.arguments:=arg;
     //chaine:='['+f1^.en_chaine+','+f2^.en_chaine;
     //if f3<>nil then chaine:=chaine+','+f3^.en_chaine+']' else chaine:=chaine+']';
     res:= new(Pdroite,init('',''));
     res^.ConstruitArbre(p);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande TEllipse2}
function TEllipse2.executer(arg:PListe):Presult;
var p,f1,f2:PCorps;
    res:PEllipse;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(PEllipse,init('',''));
     res^.ConstruitArbre(p);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;


{Commande TNuage}
function TNuage.executer(arg:PListe):Presult;
var p,f1:PCorps;
    //chaine:string;
    res:Pdot;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(Pdot,init('',''));
     res^.ConstruitArbre(p);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;


{Commande TTangent}
function TTangent.executer(arg:PListe):Presult;
var f1,f2,f3,f4:PCorps;
    T,aux,aux1,res:Paffixe;
    l:type_liste;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=PCorps(f1^.suivant);
     if (f2=nil) or (f2^.categorie<>cat_constante) or (Pconstante(f2^.contenu)^.predefinie) then exit;
     f3:=PCorps(f2^.suivant);
     if f3=nil then exit;
     aux:=f3^.evalNum;
     if (aux=nil) then exit;
     f4:=f1^.deriver(Pconstante(f2^.contenu)^.nom);
     if f4=nil then begin Kill(Pcellule(aux)); exit end;
     T:=new(Paffixe,init(0,0));
     f4^.assigner(Pconstante(f2^.contenu)^.nom,T);
     aux1:=Paffixe(aux);
     l.init;
     while aux1<>nil do
           begin
                T^.x:=aux1^.x;T^.y:=aux1^.y;
                res:=f4^.evalNum;
                if res<>nil then l.ajouter_fin(res);
                aux1:=Paffixe(aux1^.suivant)
           end;
     executer:=Paffixe(l.tete);
     Kill(Pcellule(aux));
     f4^.desassigner(Pconstante(f2^.contenu)^.nom);
     Kill(Pcellule(T));
     dispose(f4,detruire);
end;

{Commande TEllipticArc2}
function TEllipticArc2.executer(arg:PListe):Presult;
var p,f1,f2:PCorps;
    a:Paffixe;
    sens:integer;
    //chaine:string;
    res:PEllipticArc;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f1:=Pcorps(f1^.suivant);
     if f1=nil then sens:=1 // on a [B,A,C,Rx,Ry]
        else
            begin
                 f2:=Pcorps(f1^.suivant);
                 if f2<>nil then //on a 4 arguments ou plus: B,A,C,Rx,Ry <,sens>
                  begin
                       f1:=Pcorps(f2^.suivant);
                       if f1=nil then exit; //Rx obligatoire
                       f1:=Pcorps(f1^.suivant);
                       if f1=nil then exit; //Ry obligatoire
                       f1:=Pcorps(f1^.suivant);
                  end;
                 if f1=nil then sens:=1
                    else
                        begin
                             a:=f1^.evalNum;
                             if a<>nil then if a^.x>0 then sens:=1 else sens:=-1;
                             Kill(Pcellule(a));
                        end;
          end;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(PEllipticArc,init('','',sens));
     res^.ConstruitArbre(p);
     res^.Recalculer;
     if res^.liste_points^.tete<>Nil then
        liste_enfant^.ajouter_fin(res)
     else dispose(res,detruire);
end;

{Commande TEquaDif2}
function TEquaDif2.executer(arg:PListe):Presult;
var p,f1:PCorps;
    i,mode:byte;
    //chaine:string;
    aux:Paffixe;
    res:PEquaDif;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit; //on attend [f(t,x,y), t0, x0+iy0] <,mode>  cas 1)
                          //ou bien f(t,x,y), t0, x0+iy0 <,mode>      cas 2)
     aux:=nil;
     i:=1;
     while f1^.suivant<>nil do begin inc(i); f1:=Pcorps(f1^.suivant) end;
     if (i=2) or (i=4) then aux:=Pcorps(f1)^.evalNum;
     if aux=nil then mode:=0
                else
                        begin mode:=Round(aux^.x) mod 3;
                              Kill(Pcellule(aux));
                        end;
     p:=MakeListe;
     if i<=2 then p^.arguments:=PCorps(arg^.tete)^.arguments // on est dans le cas 1)
        else p^.arguments:=arg;
     res:= new(PEquaDif,init('','',mode));
     res^.ConstruitArbre(p);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;


{Commande Tbezier2}
function Tbezier2.executer(arg:PListe):Presult;
var p,f1:PCorps;
    //chaine:string;
    res:PBezier;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(PBezier,init('',''));
     res^.ConstruitArbre(p);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);
end;

{Commande Tspline2}
function Tspline2.executer(arg:PListe):Presult;
var p,f1:PCorps;
    //chaine:string;
    res:PSpline;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     res:= new(PSpline,init('',''));
     res^.ConstruitArbre(p);res^.Recalculer;
     liste_enfant^.ajouter_fin(res);

end;

{Commande TGetSpline}
function TGetSpline.executer(arg:PListe):Presult;
var p,f1:PCorps;
    //chaine:string;
    res:PSpline;
    oldmatrix:Tmatrix;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     p:=MakeListe;
     p^.arguments:=arg;
     oldmatrix:=CurrentMatrix;
     CurrentMatrix:=DefaultMatrix;
     res:= new(PSpline,init('',''));
     res^.ConstruitArbre(p);res^.Recalculer;
     executer:=res^.donnees;
     res^.donnees:=Nil;
     CurrentMatrix:=oldmatrix;
     dispose(res,detruire)
end;


{Commande Tutilisateur2}
function Tutilisateur2.executer(arg:PListe):Presult;
var f1,f2,f3,f4:PCorps;
    aux,chaine2,usertype:string; //string
    chaine1:Tnom;
    aux1:Pelement;
    ok:boolean;
    code:integer;
    res:Paffixe;
begin
     executer:=nil;code:=-1;usertype:='default';
     //If Not FoncSpeciales then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if (f1=nil) then exit;
     f2:=Pcorps(f1^.suivant);
     if f2=nil
        then
            begin //nom standard
                  chaine1:=NomStandard;
                  f2:=f1 //corps de la commande
            end
        else
        begin
               //f1 contient le nom
              if f1^.categorie=cat_constante then chaine1:=Pconstante(f1^.contenu)^.nom
                                    else chaine1:=MakeString(f1);
              f3:=Pcorps(f2^.suivant);
              if f3<>nil then
                begin
                        res:=f3^.evalNum;
                        if res<>nil then
                                begin
                                        code:=round(res^.x);
                                        Kill(Pcellule(res))
                                end;
                        f4:=Pcorps(f3^.suivant);
                        if f4<>nil then usertype:=MakeString(f4);
                end
        end;
     if not NomValide(chaine1,true) then exit;
     aux1:=Pelement(liste_element.tete);
     while (aux1<>nil) and (aux1^.nom<>chaine1) do aux1:=Pelement(aux1^.suivant);
     ok:=(aux1<>nil); //déjà existant?? si oui l'ancien sera écrasé
     if ok or VariableValide(chaine1,false) then   //une variable ne doit pas porter le même nom
        begin
     aux:=MakeString(f2);
     chaine2:=FormatString(aux,80);
     //FoncSpeciales:=false;
     liste_element.inserer(new(Putilisateur,init(chaine1,chaine2,code)),aux1);
     if ok then liste_element.supprimer(Pcellule(aux1))
           else ChangeGraph:=true;
     //FoncSpeciales:=true;
     fileChanged:=true;
       end;
end;

{Commande Tlabel2 }
function Tlabel2.executer(arg:PListe):Presult;
var f1,f2:PCorps;
    chaine2:string;
    res:Plabel;
begin
     executer:=nil;
     If Not ContexteUtilisateur then exit;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     while (f2<>nil) do
     begin
     chaine2:=MakeString(f2);
     if chaine2<>'' then
        begin
             res:=new(Plabel,init('','',chaine2));
             res^.ConstruitArbre(f1);res^.Recalculer;
             liste_enfant^.ajouter_fin(res)
        end;
     f2:=Pcorps(f1^.suivant);
     f1:=Pcorps(f2^.suivant);
     if f1<>nil then f2:=Pcorps(f1^.suivant) else f2:=nil;
     end;
end;

{Commande Tget}
procedure DotsGet(index:Pelement; var liste:type_liste);
var index2:Pelement;
    rep:Paffixe;
begin
     if (index^.cat<>cat_utilisateur) then
        if index^.liste_points^.tete<>nil
           then begin
                     if liste.tete<>Nil then  liste.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)));
                     liste.ajouter_fin(Paffixe(index^.liste_points^.tete)^.evaluer)
                end
        else
     else
     begin
          if Putilisateur(index)^.enfants=nil then index2:=nil
          else  index2:=Pelement(Putilisateur(index)^.enfants.tete);
          while index2<>nil do
           begin
                DotsGet(index2,liste);
                index2:=Pelement(index2^.suivant);
           end;
    end;
end;
{======}
function TGet.executer(arg:PListe):Presult;
var f1,f2,f3:PCorps;
    chaine:string;
    aux2:Putilisateur;
    index,index2:Pelement;
    res:type_liste;
    oldNomVide, oldClipping:boolean;
    name:Tnom;
    clip:boolean; T:Paffixe;
    oldmatrix:Tmatrix;
    all,usematrix:boolean;
begin
     executer:=nil; clip:=true;usematrix:=false;
     all:= arg=nil;// then exit;
     if not all then
     begin
     f1:=PCorps(arg^.tete);
     all:=(f1=nil); //exit;
     f2:=PCorps(f1^.suivant);
     if f2<>nil then
       begin
           T:=f2^.evalNum;
           if T<>nil then clip:= (round(T^.x) mod 2)=1;
           Kill(Pcellule(T));
           f3:=PCorps(f2^.suivant);
           if f3<>nil then
             begin
                  T:=f3^.evalNum;
                  if T<>nil then usematrix:= (round(T^.x) mod 2)=1;
                  Kill(Pcellule(T));
             end
       end;
     end;
     res.init;
     if all or (f1^.categorie=cat_constante) then
        begin
             if not all then name:=Pconstante(f1^.contenu)^.nom;
             index:=Pelement(liste_element.tete);
             while index<>nil do
                   begin
                        if (all and index^.visible) or ((not all) and (index^.nom=name)) then
                                     DotsGet(index,res);
                        index:=Pelement(index^.suivant);
                   end
        end else
        begin
     oldNomVide:=ContexteUtilisateur;
     ContexteUtilisateur:=true;
     oldClipping:=Clipping;
     Clipping:=clip;
     oldmatrix:=CurrentMatrix;
     if not usematrix then CurrentMatrix:=DefaultMatrix;
     aux2:=new(Putilisateur,init('','',0));
     aux2^.ConstruitArbre(f1);aux2^.Recalculer;
     Clipping:=oldClipping;
     DotsGet(aux2,res);
     dispose(aux2,detruire);
     ContexteUtilisateur:=OldNomVide;
     CurrentMatrix:=oldMatrix;
        end;
     if res.tete<>nil then executer:=Paffixe(res.tete);
 end;
{======}
function TExportObject.executer(arg:PListe):Presult;
var f1,f2:PCorps;
    chaine:string;
    aux2:Putilisateur;
    index:Pelement;
    oldNomVide,all:boolean;
    name:Tnom;
    mode:integer;
    T:Paffixe;
begin
     executer:=nil;
     if not (WriteMode Or OpenFile) then exit;
     mode:=Round(PExportMode^.affixe^.getx);
     all:= arg=nil;// then exit;
     if not all then
     begin
     f1:=PCorps(arg^.tete);
     all:=(f1=nil); //exit;
     f2:=Pcorps(f1^.suivant);
     if f2<>Nil then  //mode imposé
        begin
            T:=f2^.evalNum;
            if T<>Nil then mode:=Round(T^.x);
            Kill(Pcellule(T))
        end;
     end;
     if all or (f1^.categorie=cat_constante) then
        begin
             if not all then name:=Pconstante(f1^.contenu)^.nom;
             index:=Pelement(liste_element.tete);
             while index<>nil do
                   begin
                        if (all and index^.visible) or ((not all) and (index^.nom=name)) then
                                     index^.Exporter(mode);
                        index:=Pelement(index^.suivant);
                   end
        end else
        begin
     oldNomVide:=ContexteUtilisateur;
     ContexteUtilisateur:=true;
     aux2:=new(Putilisateur,init('','',0));
     aux2^.ConstruitArbre(f1);
     //showMessage(f1^.en_chaine);
     aux2^.Recalculer;
     aux2^.Exporter(mode);
     dispose(aux2,detruire);
     ContexteUtilisateur:=OldNomVide;
        end;
 end;

{commande TWind}
function TWind.executer(arg:PListe):Presult;
var f1,f2,f3:PCorps;
    T:Paffixe;
    x1,x2,y1,y2,ex,ey,aux:real;
begin
     executer:=nil;
     {if Not FoncSpeciales then exit;}
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     f3:=Pcorps(f2^.suivant);
     T:=f1^.evalNum;
     if T<>nil then begin x1:=T^.x;y2:=T^.y;Kill(Pcellule(T)) end else exit;
     T:=f2^.evalNum;
     if T<>nil then begin x2:=T^.x;y1:=T^.y;Kill(Pcellule(T)) end else exit;
     ex:=Xscale;ey:=Yscale;
     if f3<>nil then
        begin
             T:=f3^.evalNum;
             if T<>nil then begin ex:=T^.x;ey:=T^.y;Kill(Pcellule(T)) end else exit;
        end;
     if y1>y2 then begin aux:=y2; y2:=y1; y1:=aux end;
     if x1>x2 then begin aux:=x2; x2:=x1; x1:=aux end;
     if (x1<x2) and (y1<y2) and (ex>0) and (ey>0)
        then fenetre(x1,y1,x2,y2,ex,ey);
end;

{commande TMarges}
function TMarges.executer(arg:PListe):Presult;
var f1,f2,f3,f4:PCorps;
    T:Paffixe;
    x1,x2,y1,y2:real;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     f2:=Pcorps(f1^.suivant);
     if (f2=nil) then exit;
     f3:=Pcorps(f2^.suivant);
     if (f3=nil) then exit;
     f4:=Pcorps(f3^.suivant);
     if (f4=nil) then exit;
     T:=f1^.evalNum;
     if T<>nil then begin x1:=T^.x; Kill(Pcellule(T)) end else exit;
     T:=f2^.evalNum;
     if T<>nil then begin x2:=T^.x; Kill(Pcellule(T)) end else exit;
     T:=f3^.evalNum;
     if T<>nil then begin y1:=T^.x; Kill(Pcellule(T)) end else exit;
     T:=f4^.evalNum;
     if T<>nil then begin y2:=T^.x; Kill(Pcellule(T)) end else exit;

     if (x1>=0) and (y1>=0) and (x2>=0) and (y2>=0)
        then marges(x1,x2,y1,y2);
end;


{commande TEval}
function TEval.executer(arg:PListe):Presult;
var f1:PCorps;
    T:Presult;
    corps:Pcorps;
    aux:string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     aux:=MakeString(f1);
     if aux='' then exit;
     T:=nil;
     corps:=DefCorps(aux);
     if corps<>nil  then
        begin T:=corps^.evaluer;
              dispose(corps,detruire)
        end;
     executer:=T
end;
{=================}
{commande TStrEval}
function TStrEval.executer(arg:PListe):Presult;
var f1:PCorps;
    aux:string;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=PCorps(arg^.tete);
     if f1=nil then exit;
     aux:=MakeString(f1);
     executer:=new(Pchaine,init(aux))
end;
{=================}
var h:pexpression;
    mac:Pmacros;

Initialization

     LesCommandes.ajouter_fin(new(PPolyg,init('Ligne')));
     LesCommandes.ajouter_fin(new(PPolyg,init('Line')));//english version
     LesCommandes.ajouter_fin(new(PCourbe,init('Courbe')));
     LesCommandes.ajouter_fin(new(PCourbe,init('Parametric')));//english version
     LesCommandes.ajouter_fin(new(PCartesienne2,init('Cartesienne')));
     LesCommandes.ajouter_fin(new(PCartesienne2,init('Cartesian')));//english version
     LesCommandes.ajouter_fin(new(Ppolaire2,init('Polaire')));
     LesCommandes.ajouter_fin(new(Ppolaire2,init('Polar')));//english version
     LesCommandes.ajouter_fin(new(PDroite2,init('Droite')));
     LesCommandes.ajouter_fin(new(PDroite2,init('StraightL')));//english version
     LesCommandes.ajouter_fin(new(Pellipse2,init('Ellipse')));  //version 1.95,
     //Ellipse(centre, rx, ry, inclinaison en degrés)
     LesCommandes.ajouter_fin(new(PNuage,init('Point')));
     LesCommandes.ajouter_fin(new(PNuage,init('Dot')));//english version
     LesCommandes.ajouter_fin(new(PTangent,init('Der')));
     LesCommandes.ajouter_fin(new(PEllipticArc2,init('EllipticArc')));
     LesCommandes.ajouter_fin(new(PEquaDif2,init('EquaDif')));
     LesCommandes.ajouter_fin(new(PEquaDif2,init('Odeint')));//english version
     LesCommandes.ajouter_fin(new(PImplicit2,init('Implicit')));
     LesCommandes.ajouter_fin(new(PBezier2,init('Bezier')));
     LesCommandes.ajouter_fin(new(PSpline2,init('Spline')));
     LesCommandes.ajouter_fin(new(PPath2,init('Path')));
     LesCommandes.ajouter_fin(new(PExportPathData,init('ExportPathData'))); //version 1.95,
     //ExportData( <type export>, <arguments d'un Path> ): écrit dans le fichier de sortie les données du Path sans les attributs
     LesCommandes.ajouter_fin(new(PGetSpline,init('GetSpline')));           //version 1.95
     //GetSpline( <arguments d'un Spline> ): renvoie la liste des points de contrôles correspondant à la spline

     LesCommandes.ajouter_fin(new(Putilisateur2,init('Creer')));
     LesCommandes.ajouter_fin(new(Putilisateur2,init('NewGraph')));
     LesCommandes.ajouter_fin(new(PLabel2,init('Label')));

     LesCommandes.ajouter_fin(new(PWind,init('Fenetre')));
     LesCommandes.ajouter_fin(new(PWind,init('Window')));//english version
     LesCommandes.ajouter_fin(new(PMarges,init('Marges')));
     LesCommandes.ajouter_fin(new(PMarges,init('Margin')));//english version
     LesCommandes.ajouter_fin(new(PEval,init('Eval')));
     LesCommandes.ajouter_fin(new(PStrEval,init('StrEval'))); //version 1.962

     LesCommandes.ajouter_fin(new(PGet,init('Get')));
     //Get( <commande graphique>, [clipping 0/1 (1)], [matrice courante 0/1 (0)] )
     LesCommandes.ajouter_fin(new(PExportObject,init('ExportObject')));//version 1.95,
     //ExportObject(nom) ou ExportObject(commande graphique) comme Get mais pour exporter
     LesCommandes.ajouter_fin(new(Pmyexport2,init('MyExport')));
     LesCommandes.ajouter_fin(new(Pmyexport2,init('draw')));
     LesCommandes.ajouter_fin(new(PSaut2,init('Saut')));
     LesCommandes.ajouter_fin(new(PClose2,init('Close')));

     MakeListe:=new(Pcorps, init(cat_commande, commande('Liste')));

//definition macro path:
new(h,init);
h^.definir('[$L:=Nil,$first:=Nil,$nb:=0,'+
'for $z in %1 do'+
'      if Re(z)=Re(jump) then'+
'         if z=arc then'+
'                  if (nb>3) And (nb<6) then'+
'                       $a:=L[1],$b:=L[2],$c:=L[3],$d:=abs(L[4]),$f:=(L[5]>0),'+
'                       if  (abs(a-b)<>0) And (abs(b-c)<>0) then'+
'                           if f=Nil then f:=1 fi,'+
'                           $x:=b+d*(a-b)/abs(a-b), if Abs(a-x)>0.01 then Ligne([a,x],0) fi,'+
'                           if first=Nil then first:=x fi,'+
'                           EllipticArc(a,b,c,d,d,f), L:=b+d*(c-b)/abs(c-b)'+
'                       else L:=L[1] fi'+
'                  else L:=L[1] fi'+
'         elif z=ellipticArc then'+
'              if (nb>4) And (nb<8) then'+
'                 $a:=L[1],$b:=L[2],$c:=L[3],$d:=L[4],$f:=L[5], $g:=L[6],$h:=L[7],'+
'                 if g=Nil then g:=1 fi, if h=Nil then h:=0 fi,'+
'                 $x:=ellipticArcEnds(a,b,c,d,f,g,h),'+ //extremites de l'arc
'                 if x<>Nil then'+
'                    if Abs(a-x[1])>0.01 then Ligne([a,x[1]],0) fi,'+
'                    ellipticArc(a,b,c,d,f,g,h), if first=Nil then first:=x[1] fi,'+
'                    L:=x[0]'+
'                 else L:=L[1] fi'+
'              else L:=L[1] fi'+
'           elif z=line then Ligne(L,0), if first=Nil then first:=L[1] fi, L:=L[0]'+
'           elif z=circle then'+
'                if (nb>1) And (nb<4) then'+
'                   $a:=L[1], $b:=L[2], $c:=L[3],'+
'                   if c=Nil then $r:=abs(b-a), $o:=b'+
'                   else $o:=med(a,b) Inter med(b,c), $r:=abs(a-o) fi,'+
'                   EllipticArc(a,o,a,r,r,1),'+
'                   if first=Nil then first:=a fi, L:=a'+
'                else L:=L[1] fi'+
'           elif z=ellipse then'+
'                if (nb>3) And (nb<6) then'+
'                   $a:=L[1], $b:=L[2], $Rx:=L[3], $Ry:=L[4], $inclin:=L[5],'+
'                   $x:=Copy(ellipticArcEnds(a,b,a,Rx,Ry,1,inclin),1),'+ //extremite 1
'                   if x<>Nil then'+
'                      if Abs(a-x)>0.01 then Ligne([a,x],0) fi,'+
'                      if first=Nil then first:=x fi,'+
'                      ellipticArc(a,b,a,Rx,Ry,1,inclin), L:=x'+
'                   else L:=L[1] fi'+
'                else L:=L[1] fi'+
'           elif z=bezier then $a:=L[1], Bezier(L), if first=Nil then first:=a fi,L:=L[0]'+
'           elif z=curve then Spline(0,L,0), if first=Nil then first:=L[1] fi,L:=L[0]'+
'           elif z=linearc then $r:=L[0], Del(L,0,1), path(roundLine(L,r)), if first=Nil then '+
'                first:=L[1] fi, L:=L[0]'+
'           elif z=clinearc then $r:=L[0], Del(L,0,1), path(roundLine(L,r,1)), if first=Nil then '+
'                first:=L[1] fi, L:=L[0]'+
'           elif z=move then Saut(L[0]),first:=L[0],L:=first'+ //on ne garde que le point courant
'           elif z=closepath then Close([L[0],first]), L:=first'+
'           else L:=L[1] '+// on ignore ces points
'         fi,'+
'         nb:=1'+
'      else Inc(nb,1), Insert(L,z)'+
'      fi'+
'  od]');
MacroStatut:=2;
mac:=new(PMacros,init('path',h));
ajouter_macros(mac);
MacroStatut:=userMac;

Finalization
        dispose(MakeListe)    
end.
