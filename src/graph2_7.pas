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


unit graph2_7;

{$MODE Delphi}

 {Définition des éléments graphiques partie 2 }
INTERFACE
Uses Sysutils, classes,
{$IFDEF GUI}
Graphics, BGRAbitmaptypes, BGRABitmap, BGRACanvas, BGRACanvas2D,BGRAPath,// dialogs,
{$ELSE}
UnitLog,
{$ENDIF}

  calculs1{calculs},listes2,complex3,analyse4,command5,command53d,graph1_6;

const
      fileChanged:boolean=false;
      ChangeGraph:boolean=false; {indique si un nouvel élément graphique a été créé}

type
      t_droite=object(t_ligne)    {cat 6}

              constructor init(const UnNom, UneCommande:string);
              procedure recalculer;virtual;
              procedure enregistrer_src4Latex;virtual;
              end;
     Pdroite=^t_droite;


     t_ellipse=object(t_ligne)     {cat 5}
              Xcentre,Ycentre,rX,rY,inclinaison:real;

              constructor init(const UnNom, UneCommande:string); //centre, rX,rY,inclinaison
              procedure recalculer;virtual;
              {$IFDEF GUI}
              procedure toPath(Var first:boolean; var p: TBGRAPath);virtual;
              procedure dessiner; virtual;
              {$ENDIF}
              procedure DoExportLatex; virtual;
              procedure DoExportPst; virtual;
              procedure DoExportEps;virtual;
              procedure enregistrer_src4Latex;virtual;
              procedure DoExportPgf; virtual;
              procedure DoExportSvg; virtual;
              end;
     Pellipse=^t_ellipse;


     t_EllipticArc=object(t_ligne)     {cat 7}
              angleA,angleB,Xcentre,Ycentre,rX,rY:real;
              Sens:integer;

              constructor init(const UnNom, UneCommande:string;LeSens:integer);
              procedure recalculer;virtual;
              {$IFDEF GUI}
              procedure toPath(Var first:boolean; var p: TBGRAPath);virtual;
              procedure dessiner; virtual;
              {$ENDIF}
              procedure DoExportLatex; virtual;
              procedure DoExportPst; virtual;
              procedure enregistrer_src4Latex;virtual;
              procedure DoExportEps;virtual;
              procedure DoExportPgf; virtual;
              procedure DoExportSvg; virtual;
              end;
     PEllipticArc=^t_EllipticArc;

    t_parametree=object(t_Ligne)      {cat 3}
                    minT,maxT:real;
                    division:byte; saut:byte;
                    ParcourtFenetre:boolean;

                    constructor init(const UnNom, UneCommande:string;diviser,discont:byte);
                    procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                    procedure recalculer;virtual;
                    procedure lireAttributs;virtual;
                    procedure fixeAttributs;virtual;

                    procedure clip;virtual;

                    function parametres_teg:string;virtual;
                    procedure enregistrer_src4Latex;virtual;
                    function IsOut(point:Paffixe):boolean;
                    end;
     Pparametree=^t_parametree;

     t_cartesienne=object(t_parametree)


                    constructor init(const UnNom, UneCommande:string;diviser,discont:byte);
                    procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                    procedure enregistrer_src4Latex;virtual;

                    end;
     Pcartesienne=^t_cartesienne;

     t_polaire=object(t_parametree)


                    constructor init(const UnNom, UneCommande:string;diviser,discont:byte);
                    procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                    procedure enregistrer_src4Latex;virtual;

                    end;
     Ppolaire=^t_polaire;

     Pbezier=^t_bezier;
     t_bezier= object(t_parametree)

              control3: boolean;
              compteur:longint;

              constructor init(const UnNom, UneCommande:string);
              procedure recalculer;virtual;
              procedure clip;virtual;
              {$IFDEF GUI}
              procedure toPath(Var first:boolean; var p: TBGRAPath);virtual;
              procedure dessiner; virtual;
              {$ENDIF}
              procedure DoExportPst; virtual;
              procedure DoExportEps;virtual;
              procedure DoExportPgf; virtual;
              procedure DoExportSvg; virtual;
              function parametres_teg:string;virtual;
              procedure enregistrer_src4Latex;virtual;
              end;

     T_Spline= object(t_bezier)

               constructor init(const UnNom, UneCommande:string);
               procedure recalculer;virtual;

               function parametres_teg:string;virtual;
               procedure enregistrer_src4Latex;virtual;
               end;
     PSpline=^T_Spline;

     t_equadif=object(t_parametree)      {cat 3}
                    mode:byte; {0= (x,y), 1=(t,x), 2=(t,y) }

                    constructor init(const UnNom, UneCommande:string;Unmode:byte);
                    procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                    procedure recalculer;virtual;

                    procedure enregistrer_src4Latex;virtual;
                    end;
     PEquaDif=^t_EquaDif;

     t_implicit=object(t_ligne)      {cat 3}
                    //ligne_style:byte;
                    GridX,GRidY:word;

                    constructor init(const UnNom, UneCommande:string);
                    procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                    procedure recalculer;virtual;
                    procedure enregistrer_src4Latex;virtual;
                    end;
     Pimplicit=^t_implicit;


     t_utilisateur= object(t_parametree)
                    enfants:Pliste;
                    style_label,dot_style,size_label:byte;
                    dot_scaleX, dot_scaleY, dot_angle,dot_size1,dot_size2:real;
                    angle_label:real;
                    formule:boolean;
                    //attributsfin:Tattr;

                    constructor init(const UnNom, UneCommande:string;Acode:integer);
                    procedure lireAttributs;virtual;
                    procedure fixeAttributs;virtual;
                    procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                    procedure recalculer;virtual;
                    {$IFDEF GUI}
                    procedure dessiner; virtual;
                    {$ENDIF}
                    procedure enregistrer_latex; virtual;
                    procedure DoExportLatex; virtual;

                    function parametres_pst:string;virtual;
                    procedure enregistrer_pst; virtual;
                    procedure DoExportPst;virtual;

                    procedure enregistrer_eps; virtual;
                    procedure DoExportEps;virtual;

                    procedure enregistrer_pgf; virtual;
                    procedure DoExportPgf; virtual;
                    procedure enregistrer_svg; virtual;
                    procedure DoExportSvg; virtual;
                    function parametres_teg:string;virtual;
                    procedure enregistrer_src4Latex;virtual;
                    procedure enregistrer_userExport; virtual;
                    destructor detruire;virtual;
                    end;
     Putilisateur=^T_utilisateur;

     T_myExport=object(t_utilisateur)
                UserName: Tnom;
                exportation:Pexpression;
                argu:Pliste;
                constructor init(const UnNom, UneCommande, AUserName:string; arg:Pliste);
                procedure ConstruitArbre(Unarbre:Pcorps);virtual;
                procedure Exporter(mode:byte);virtual;

                destructor detruire;virtual;
                end;
     PmyExport=^T_myExport;

     t_Path= object(t_ligne)
                    enfants:type_liste;
                    closelastpath :boolean;  // onlyData permet de n'exporter que les données

                    constructor init(const UnNom, UneCommande:string;Closed:byte);
                    procedure recalculer;virtual;
                    {$IFDEF GUI}
                    procedure toPath(Var first:boolean; var p: TBGRAPath); virtual;
                    procedure dessiner; virtual;
                    {$ENDIF}
                    procedure DoExportPst;virtual;
                    procedure DoExportEps;virtual;
                    procedure DoExportPgf; virtual;
                    procedure DoExportSvg; virtual;

                    destructor detruire;virtual;
                    procedure enregistrer_src4Latex;virtual;
                    function ExportData(mode:byte):string;virtual; // export dans une chaine sans les attributs
                    end;
     PPath=^T_Path;

     PDup=^TDup;
     TDup= object(Tcommande)
                 function executer(arg:PListe):Presult;virtual;
                 end;

IMPLEMENTATION
uses math;
{=======================}
function TDup.executer(arg:PListe):Presult;
// Dup(name, new name <,new matrix>): duplique un élément Utilisateur
var f1:Pcorps;
    aux,aux1:Pelement;
    Anom,newnom:string;
    a,b,c,d,t1,t2:real;
    nouv:Putilisateur;
    T,Tb:Paffixe;
    ok:boolean;
begin
     executer:=nil;
     if arg=nil then exit;
     f1:=Pcorps(arg^.tete);
     if f1=nil then exit;
     if f1^.categorie=cat_constante then Anom:=Pconstante(f1^.contenu)^.nom
                                    else Anom:=MakeString(f1);
     f1:=Pcorps(f1^.suivant);
     if f1^.categorie=cat_constante then newnom:=Pconstante(f1^.contenu)^.nom
                                    else newnom:=MakeString(f1);
     f1:=PCorps(f1^.suivant);

     aux:=Pelement(liste_element.tete);
      while (aux<>nil) And ((aux^.nom<>Anom) Or (aux^.cat<>cat_utilisateur)) do aux:=Pelement(aux^.suivant);
     if aux=nil then exit;

     if not NomValide(newnom,true) then exit;

      a:=1; b:=0; c:=0; d:=1; t1:=0; t2:=0;        //matrice par défaut
      
      T:=nil; Tb:=nil;
      if f1<>nil then begin T:=f1^.evalNum;Tb:=T end;
      if T<>nil then begin t1:=T^.x; t2:=T^.y;
                           T:=Paffixe(T^.suivant);
                      end;
      if T<>nil then begin  a:=T^.x; b:=T^.y;
                            T:=Paffixe(T^.suivant);
                      end;
      if T<>nil then begin  c:=T^.x; d:=T^.y;
                            T:=Paffixe(T^.suivant);
                      end;
      Kill(Pcellule(Tb));

     aux1:=Pelement(liste_element.tete);
     while (aux1<>nil) and (aux1^.nom<>newnom) do aux1:=Pelement(aux1^.suivant);
     ok:=(aux1<>nil); //déjà existant?? si oui l'ancien sera écrasé
     if ok or VariableValide(newnom,false) then   //une variable ne doit pas porter le même nom
        begin
                aux^.lireAttributs;
                DefTransform(a,b,c,d,t1,t2);
                //FoncSpeciales:=false;
                liste_element.inserer(new(Putilisateur,init(newnom,aux^.LigneCommande,aux^.id)),aux1);
                DefaultTransform;
                if ok then liste_element.supprimer(Pcellule(aux1))
                      else ChangeGraph:=true;
                //FoncSpeciales:=true;
                fileChanged:=true;
        end;
end;
{==========================================Type t_courbe ==================}
constructor t_parametree.init(const UnNom, UneCommande:string;diviser,discont:byte);
begin
     division:=diviser; saut:=discont;
     t_Ligne.init(UnNom,UneCommande,0,0);
     cat:=cat_parametree;
end;
{=========================}
procedure t_parametree.ConstruitArbre;
begin
     if Unarbre<>nil
        then
            begin
             new(arbre,init);
             DefCommande:=false;
             arbre^.VarLoc:=LesVarLoc;
             Unarbre^.ConvertLocale('t');
             arbre^.corps:=Unarbre;
        end
        else
            begin
                 if arbre<>nil then dispose(arbre,detruire);
                 new(arbre,init);
                 arbre^.varloc^.ajouter_fin(new(Pconstante,init('t',nil,true)));
                 if not arbre^.definir(LigneCommande)
                    then begin
                           dispose(arbre,detruire);
                           arbre:=nil
                         end;
                 DefCommande:=true;
            end;
end;
{========================}
procedure t_parametree.fixeAttributs;
begin
      t_ligne.fixeAttributs;
      ParcourtFenetre:=ForMinToMax;
      if ParcourtFenetre then
        begin
          MinT:=X_min;
          MaxT:=X_max;
        end
      else
        begin
          MinT:=tMin;
          MaxT:=tMax;
        end;
end;
{========================}
procedure t_parametree.lireAttributs;
begin
     tMin:=MinT;
     tMax:=maxT;
     ForMinToMax:=ParcourtFenetre;
     t_ligne.lireAttributs;
end;
{========================}
function t_parametree.IsOut(point:Paffixe):boolean;
begin
     IsOut:= (point^.x<=X_min) or (point^.y<=Y_min)
             or (point^.y>=Y_max) or (point^.x>=X_max);
end;
{=======================}
procedure t_parametree.clip;
var liste,aux,aux1,aux2:Paffixe;
    compt:integer;
    F:Pexpression;
    A,B,A1,A2,A3,A4:Paffixe;

    procedure clipConnexe(De:Paffixe);
    var aux1,res,T:Paffixe;
        listeAux:type_liste;
        lastOut:Boolean;

    begin
         listeAux.init;
         listeAux.ajouter_fin(De);
         aux:=Paffixe(ListeAux.tete);
         lastOut:=IsOut(aux);
         while aux<>nil do
                    begin
                         if IsOut(aux)
                            then
                              begin
                                   clippee:=true;
                                   if lastOut
                                    then
                                    begin
                                 aux1:=Paffixe(aux^.suivant);
                                 while (aux1<>nil) and (IsOut(aux1)) do
                                       begin
                                            listeAux.supprimer(Pcellule(aux));
                                            aux1:=Paffixe(aux1^.suivant);
                                       end;
                                 if aux1<>nil then begin
                                            T:=new(Paffixe,init(jump^.x,jump^.y));
                                            listeAux.inserer(T,aux);
                                                   A^.x:=aux^.x;A^.y:=aux^.y;
                                                   B^.x:=aux1^.x;B^.y:=aux1^.y;
                                                   res:=F^.evalNum;
                                                   if res<>nil then listeAux.inserer(res,aux1);
                                                   listeAux.supprimer(Pcellule(aux));
                                                   end
                                              else begin
                                                   aux1:=aux;
                                                   aux:=Paffixe(aux1^.precedent);
                                                   listeAux.supprimer(Pcellule(aux1))
                                                   end;
                                 lastOut:=false;
                                    end else begin
                                                  lastOut:=true;
                                                  A^.x:=Paffixe(aux^.precedent)^.x;A^.y:=Paffixe(aux^.precedent)^.y;
                                                  B^.x:=aux^.x;B^.y:=aux^.y;
                                                  res:=F^.evalNum;
                                                  if res<>nil then listeAux.inserer(res,aux);
                                                  aux:=res
                                             end
                                  end
                            else lastOut:=false;

                         if aux<>nil then aux:=Paffixe(aux^.suivant)
                    end;
         liste_points^.ajouter_fin(Paffixe(listeAux.tete));
    end;

begin
     liste:=Paffixe(liste_points^.tete);
     if liste=nil then exit;
     aux2:=liste^.evalNum;
     liste_points^.init;
     new(F,init);
     new(A1,init(X_min,Y_min));
     new(A2,init(X_max,Y_min));
     new(A3,init(X_max,Y_max));
     new(A4,init(X_min,Y_max));
     new(A,init(0,0));
     new(B,init(0,0));
     F^.varloc^.ajouter_fin(new(Pconstante,init('A1',A1,true)));
     F^.varloc^.ajouter_fin(new(Pconstante,init('A2',A2,true)));
     F^.varloc^.ajouter_fin(new(Pconstante,init('A3',A3,true)));
     F^.varloc^.ajouter_fin(new(Pconstante,init('A4',A4,true)));
     F^.varloc^.ajouter_fin(new(Pconstante,init('A',A,true)));
     F^.varloc^.ajouter_fin(new(Pconstante,init('B',B,true)));
     F^.definir('Copy([A,B] InterL [A1,A2,A3,A4,A1],1,1)');
     aux:=liste;
     while aux<>nil do
          begin
               compt:=1;
               aux1:=Paffixe(aux^.suivant);
               while (aux1<>nil) and (not IsJump(aux1)) do begin inc(compt);aux1:=Paffixe(aux1^.suivant) end;
               if compt>1 then begin
                               if aux1<>nil then aux1^.precedent^.suivant:=nil;
                               ClipConnexe(aux^.evalNum);
                               end else dispose(aux,detruire);
               while (aux1<>nil) and (IsJump(aux1)) do begin liste:=Paffixe(aux1^.suivant);
                                                             dispose(aux1,detruire);
                                                             aux1:=liste;
                                                       end;
               aux:=aux1;
               if (aux<>nil) and (not IsJump(Paffixe(liste_points^.queue)))
                  then liste_points^.ajouter_fin(new(Paffixe,init(jump^.x,jump^.y)))
          end;
     dispose(F,detruire);
     if fermee=1 then
        begin
             liste:=Paffixe(liste_points^.tete);
             if liste=nil then exit;
             aux:=liste;
             while aux<>nil do
                   begin
               while (aux<>nil) and IsJump(aux) do aux:=Paffixe(aux^.suivant);
               if aux<>nil
                  then
                      begin
                           aux1:=Paffixe(aux^.suivant);
                           while (aux1<>nil) and (not IsJump(aux1)) do aux1:=Paffixe(aux1^.suivant);
                           liste_points^.inserer(new(Paffixe,init(aux^.x,aux^.y)),aux1);
                           while (aux1<>nil) and (IsJump(aux1)) do aux1:=Paffixe(aux1^.suivant);
                           aux:=aux1;
                      end;
                   end;
        end;
   if clippee then noClipList.ajouter_fin(aux2) else Kill(Pcellule(aux2));
end;
{=======================}
procedure t_parametree.recalculer;
var h,t1:real;
    i:integer;
    T,r,old:Paffixe;
    LastJump:boolean;

    function d(a1,a2:Paffixe):real;
    begin
         d:=abs(a2^.x-a1^.x)+abs(a2^.y-a1^.y);
    end;

procedure midle(t1,t2:real;f1,f2:Paffixe;n:integer);
    var tm,ancien:real;
        fm:Paffixe;
    begin
         if n>division then if saut=1 then liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, jump^.Y))) else
          else begin
         ancien:=T^.x;
         tm:=(t1+t2)/2;
         T^.x:=tm;
         fm:=arbre^.evalNum;
         if (fm<>nil)
          then begin
                    if (f1=nil) or (d(f1,fm)>h) then midle(t1,tm,f1,fm,n+1);
                    liste_points^.ajouter_fin(fm);
                    if (f2=nil) or (d(f2,fm)>h) then midle(tm,t2,fm,f2,n+1);
               end else begin
                             if f1<>nil
                                then midle(t1,tm,f1,fm,n+1)
                                else liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, jump^.Y)));
                             if f2<>nil
                                then midle(tm,t2,fm,f2,n+1)
                                else liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, jump^.Y)));
                        end;
         T^.x:=ancien
               end;
    end;

   { procedure test(t1,t2:real;f1,f2:Paffixe;n:integer);
    var tm,ancien,dx,dy:real;
        fm:Paffixe;
    begin
         if n>division then if saut=1 then liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, jump^.Y))) else
          else
       begin
         ancien:=T^.x;
         tm:=(t1+t2)/2;
         T^.x:=tm;
         fm:=arbre^.evaluer;
         if (fm<>nil)
          then begin
                    if (f1<>nil) and (f2<>nil) then
                       begin
                           dx:=abs(f1^.x-f2^.x);
                           dy:=abs(f1^.y-f2^.y);
                           if (dx>hX) or (dy>hY) then  //norme infinie >=...
                              begin
                                   test(t1,tm,f1,fm,n+1);
                                   liste_points^.ajouter_fin(fm);
                                   test(tm,t2,fm,f2,n+1)
                              end
                              else Kill(Pcellule(fm))
                       end
                    else
                    if (f1=nil) then
                       begin test(t1,tm,f1,fm,n+1);
                             liste_points^.ajouter_fin(fm);
                       end
                    else
                    if (f2=nil) then
                       begin
                            liste_points^.ajouter_fin(fm);
                            test(tm,t2,fm,f2,n+1);
                       end
                    else Kill(Pcellule(fm))
               end else begin //fm=nil
                             if f1<>nil
                                then test(t1,tm,f1,fm,n+1)
                                else liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, jump^.Y)));
                             if f2<>nil
                                then test(tm,t2,fm,f2,n+1)
                                else liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, jump^.Y)));
                        end;
                           //     else if saut=1 then liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, jump^.Y)));
         T^.x:=ancien
       end;
    end;}

begin
     liste_points^.detruire;
     noClipList.detruire;
     X_min:=Xmin; X_max:=Xmax;
     Y_min:=Ymin; Y_max:=Ymax;
     if DefCommande then
        begin
             ConstruitArbre(nil);
             if arbre=nil then exit;
        end
        else if arbre=nil then exit;
     if ParcourtFenetre then
        begin
          MinT:=X_min;
          MaxT:=X_max;
        end;
     T:=new(Paffixe,init(MinT,0));
     arbre^.assigner('t',T);
     //hX:=5*abs((Xmax-Xmin)/(maxX));
     //hY:=5*abs((Ymax-Ymin)/(maxY));
     h:=(MaxT-MinT)/(nb_points-1);
     LastJump:=true;old:=nil;
     if division>0 then
     for i:=1 to nb_points do
           begin
            r:=arbre^.evalNum;
            if (r<>nil) then begin
                                  if ((old<>nil)  and (d(old,r)>h)) or
                                     ((old=nil) and (T^.x>Mint))  then midle(t1,T^.x,old,r,1);
                                  liste_points^.ajouter_fin(r);
                                  LastJump:=false;
                             end
                        else if (old<>nil)
                             then midle(t1,T^.x,old,r,1)
                             else
                             if not LastJump then
                             begin
                             liste_points^.ajouter_fin(new(Paffixe,init(jump^.X,jump^.Y)));
                             LastJump:=true;
                             end;

            {if (r<>nil) then begin
                                  if ((old<>nil)) or
                                     ((old=nil) and (T^.x>Mint))  then test(t1,T^.x,old,r,1);
                                  liste_points^.ajouter_fin(r);
                                  LastJump:=false;
                             end
                        else if (old<>nil) then test(t1,T^.x,old,r,1)
                             else
                              if not LastJump then
                                 begin
                                      liste_points^.ajouter_fin(new(Paffixe,init(jump^.X,jump^.Y)));
                                      LastJump:=true;
                                 end;}
                             
            t1:=T^.x;old:=r;
            {IsIn1:=IsIn2;}
            T^.x += h;
            end
       else
       for i:=1 to nb_points do
           begin
            r:=arbre^.evalNum;
            if (r<>nil) then begin
                                  liste_points^.ajouter_fin(r);
                                  LastJump:=false;
                             end
                        else if not LastJump then
                             begin
                             liste_points^.ajouter_fin(new(Paffixe,init(jump^.X,jump^.Y)));
                             LastJump:=true;
                             end;
            T^.x += h;
            end;
     if transform then transformate;
     clipper;
     if fleche>0 then calcul_fleches;
     arbre^.desassigner('t'); Kill(Pcellule(T));
end;
{======================}
function t_parametree.parametres_teg:string;
var chaine:string;
begin
     chaine:=t_ligne.parametres_teg;
     if ParcourtFenetre<>ForMinToMax then
         begin ForMinToMax:=ParcourtFenetre;
                chaine:=chaine+',ForMinToMax:='+Streel(byte(ParcourtFenetre))
         end;
     if minT<>tmin then
         begin tmin:=minT; chaine:=chaine+',tMin:='+Streel(minT) end;
      if maxT<>tmax then
         begin tmax:=maxT; chaine:=chaine+',tMax:='+Streel(maxT) end;
      parametres_teg:=chaine
end;
{====================}
procedure t_parametree.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     //exportwrite( {'Graph '+nom+'=}#9+'Courbe('+FormatString(LigneCommande,70));
     exportwrite('Courbe('+FormatString(LigneCommande,70));
     if division<>0 then
         begin
              exportwrite(','+InttoStr(division));
              if saut<>0 then exportwrite(','+IntToStr(saut));
         end;
     //exportwriteln('),');
     exportwriteln(');');
end;
{=================================t_droite============================}
constructor t_droite.init(const UnNom, UneCommande:string);
begin
     t_ligne.init(UnNom,UneCommande,0,0);
     cat:=cat_droite;
     //fleche:=0;
end;
{=======================}
function ClipDroite(a,b,c1,MinX,MaxX,MinY,MaxY:real):Paffixe;
var positif:boolean;
    LesPoints:type_liste;
    i:integer;
    C:array[1..5] of Record x,y:real end;
    LeTest,t,Xa,Ya:real;

begin
     LesPoints.init;
     C[1].x:=MinX;C[1].y:=MinY;
     C[2].x:=MaxX;C[2].y:=MinY;
     C[3].x:=MaxX;C[3].y:=MaxY;
     C[4].x:=MinX;C[4].y:=MaxY;
     C[5].x:=MinX;C[5].y:=MinY;
     CalcError:=false;
     positif:=soustraire(ajouter(multiplier(a,C[1].x),multiplier(b,C[1].y)),c1)>0;
     for i:=2 to 5 do
         begin
              CalcError:=false;
              LeTest:=soustraire(ajouter(multiplier(a,C[i].x),multiplier(b,C[i].y)),c1);
              if ((LeTest<=0) and positif) or ((LeTest>0) and (not positif)) then
                                begin
                                     positif:=not positif;
                                     t:= diviser(c1-a*C[i].x-b*C[i].y,
                                         a*(C[i-1].x-C[i].x)+b*(C[i-1].y-C[i].y));
                                     Xa:=t*(C[i-1].x-C[i].x)+C[i].x;
                                     Ya:=t*(C[i-1].y-C[i].y)+C[i].y;
                                     LesPoints.ajouter_fin(new(Paffixe,init(Xa,Ya)));
                                end;
         end;

         if (LesPoints.tete=nil) or (LesPoints.tete^.suivant=nil) or
         ((Paffixe(LesPoints.tete)^.x=Paffixe(LesPoints.tete^.suivant)^.x) and
          (Paffixe(LesPoints.tete)^.y=Paffixe(LesPoints.tete^.suivant)^.y))
          then LesPoints.detruire;
          ClipDroite:=Paffixe(LesPoints.tete);
end;
{============}
procedure t_droite.recalculer;
var  t1,t2,t3:Paffixe;
     res,P1,P2:Paffixe;
     a,b,c:real;
begin
     t_element.recalculer;
     if (liste_points^.tete=nil) then begin exit end;
     t1:=Paffixe(liste_points^.tete);
     t2:=Paffixe(t1^.suivant);
     if (t2=nil) then begin liste_points^.detruire; exit;end;
     t3:=Paffixe(t2^.suivant);
     CalcError:=false;
     if t3<>nil then begin {equation}
                     a:=t1^.x;b:=t2^.x;c:=t3^.x;
                     if transform then
                       begin

                           if b<>0 then begin t1^.x:=0; t1^.y:=diviser(c,b);
                                              t2^.x:=-1; t2^.y:=diviser(ajouter(c,a),b)
                                        end
                                        else
                                        begin t1^.y:=0; t1^.x:=diviser(c,a);
                                              t2^.y:=-1; t2^.x:=diviser(ajouter(c,b),a)
                                        end
                       end;
                     end;
     if (not CalcError) and ((t3=nil) or transform)  then
     begin
         if transform then
                begin transformate;
                      t1:=Paffixe(liste_points^.tete);
                      if t1<>nil then t2:=Paffixe(t1^.suivant) else t2:=nil;
                      if t2=nil then begin liste_points^.detruire; exit end;
                end;
         b:=ajouter(t2^.x,-t1^.x);
         a:=-ajouter(t2^.y,-t1^.y);
         c:=ajouter(multiplier(b,t1^.y),multiplier(a,t1^.x));
     end;
    liste_points^.detruire;
    if not CalcError then
       begin
       {res:=segm(a,b,c,Xmin,Xmax,Ymin,Ymax);}
       res:=Clipdroite(a,b,c,X_min,X_max,Y_min,Y_max);
       if res<>nil then begin liste_points^.ajouter_fin(res)end;
       if fleche>0 then calcul_fleches;
       end;
end;
{========================}
procedure t_droite.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     //exportwriteln( {'Graph '+nom+'=}#9+'Droite('+FormatString(LigneCommande,70)+'),');
     exportwriteln('Droite('+FormatString(LigneCommande,70)+');');
end;
{============================t_ellipse=================================}
constructor t_ellipse.init;
begin
     t_ligne.init(UnNom,UneCommande,1,0);
     cat:=cat_ellipse;
     fleche:=0;
end;
{=====================}
procedure t_ellipse.recalculer;
var t1,t2,t3,t4,T:Paffixe;
    f:Pexpression;
    error:boolean;
    aux:real;
begin
     t_element.recalculer;
     t1:=Paffixe(liste_points^.tete);
     if (t1=nil) or (t1^.suivant=nil) or (t1^.suivant^.suivant=nil) then begin liste_points^.detruire; exit;end;
     t2:=Paffixe(t1^.suivant);
     t3:=Paffixe(t2^.suivant);
     if t3<>nil then t4:=Paffixe(t3^.suivant) else t4:=Nil;
     error:=false;
     if t4<>nil then inclinaison:=t4^.x else inclinaison:=0;
     Xcentre:=t1^.x; Ycentre:=t1^.y;
     rX:=t2^.x; rY:=t3^.x;
     if error then begin liste_points^.detruire; exit; end;
     if rX<rY then
     begin
          aux:=rX; rX:=rY; rY:=aux;
          inclinaison:=inclinaison+90
     end;
     donnees:=Paffixe(liste_points^.tete);
     liste_points^.init;

     new(f,init);
     f^.varLoc^.ajouter_fin(new(Pconstante,init('a',new(Paffixe,init(Xcentre,Ycentre)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('rX',new(Paffixe,init(rX,0)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('rY',new(Paffixe,init(rY,0)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('inclin',new(Paffixe,init(inclinaison,0)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('nbpoints',new(Paffixe,init(nb_points,0)),true)));
     if f^.definir('[if rX>rY then $r:=rX else r:=rY fi, if r>1 then nbpoints:=Ent((nbpoints-1)*r)+2 fi, if nbpoints>200 then nbpoints:=200 fi,'+
                   'Set($pas, 2*pi/(nbpoints-1)),$t:=0,'+
                   '$v:=inclin*pi/180, for $k from 1 to nbpoints do a+exp(i*v)*(rX*cos(t)+i*rY*sin(t)),Inc(t,pas) od]')
     then  T:=f^.evalNum else T:=nil;

    if T<>nil then begin
                          liste_points^.ajouter_fin(T);
                          if transform then transformate;
                          clipper;
                    end;
    dispose(f,detruire);
end;
{==========================================}
{$ifdef GUI}
procedure t_ellipse.toPath(Var first:boolean; var p: TBGRAPath);
 var xcs,ycs,rXs,rYs,inclins :real;
 begin
     xcs:=Xcentre; ycs:=Ycentre; rXs:=rX; rYs:=rY; inclins:=inclinaison;
     //oldXscale:=Xscale; oldYscale:=Yscale; Xscale:=1;Yscale:=oldYscale/oldXscale;
     if transform then begin
        TransformEllipse(matrix,Xcentre,Ycentre,rX,rY,inclinaison*pi/180, xcs,ycs,rXs,rYs,inclins);
     end;
     p.arc(XentierF(xcs),YentierF(ycs),longX(rXs),longY(rYs),-inclins*pi/180,0,2*pi);
     //Xscale:=oldXscale; Yscale:=oldYscale;
end;
{==========================================}
 procedure t_ellipse.dessiner;
 var first : boolean;
     p: TBGRAPAth;
begin
    first:=true; p:= TBGRAPath.Create(); toPAth(first,p);
    Canvas2dDrawPath(self,p)
 end;
 {$endif}
{=============t_ellipse en LaTeX ==========}
procedure t_ellipse.DoExportLatex;
var old:boolean;
    xcs,ycs,rXs,rYs,inclins:real;
begin
     if clippee or (ligne_style<>0) then
      begin
        T_Ligne.DoExportLatex; exit;
      end;
     xcs:=Xcentre; ycs:=Ycentre; rXs:=rX; rYs:=rY; inclins:=inclinaison;
     TransformEllipse(matrix,Xcentre,Ycentre,rX,rY,inclinaison*pi/180, xcs,ycs,rXs,rYs,inclins);
     if fill_style=1
               then
                   begin
                        if fill_Color<>couleur_courante then exportwrite('\color'+StrColor(fill_Color,latex));
                        exportwrite('\put('+streel(Xtex(Xcs))+','+streel(Ytex(Ycs))+'){');
                        if inclins<>0 then exportwrite('\begin{rotate}{'+streel(inclins)+'}');
                        exportwrite('\ellipse*{'+streel(2*rXs)+'}{'+streel(2*rYs)+'}');
                        if inclins<>0 then exportwrite('\end{rotate}');
                        exportwriteln('}%');
                        exportwrite('\color'+StrColor(couleur_courante,latex));
                   end;
     if (fill_style<>1) or (fill_color<>couleur_courante) then
        begin
             exportwrite('\put('+streel(Xtex(Xcs))+','+streel(Ytex(Ycs))+'){');
             if inclins<>0 then exportwrite('\begin{rotate}{'+streel(inclins)+'}');
             exportwrite('\ellipse{'+streel(2*rXs)+'}{'+streel(2*rYs)+'}');
             if inclins<>0 then exportwrite('\end{rotate}');
             exportwriteln('}%');
        end;
end;
{=============t_ellipse en pstricks ==========}
procedure t_ellipse.DoExportPst;
var xcs,ycs,rXs,rYs,inclins:real;
begin
     xcs:=Xcentre; ycs:=Ycentre; rXs:=rX; rYs:=rY; inclins:=inclinaison;
     TransformEllipse(matrix,Xcentre,Ycentre,rX,rY,inclinaison*pi/180, xcs,ycs,rXs,rYs,inclins);
     if OriginalCoord then begin rxs:=rxs/Xscale; rys:=rys/Yscale end;
     if inclins<>0 then
        exportwriteln('\rput{'+streel(inclins)+'}('+streel(Xtex(xcs))+','+streel(Ytex(ycs))+'){'+
                      '\psellipse(0,0)'+'('+streel(rxs)+','+streel(rys)+')}%')
     else
        exportwriteln('\psellipse('+streel(Xtex(xcs))+','+streel(Ytex(ycs))+')('+streel(rxs)+','+streel(rys)+')%');
end;
{=============t_ellipse en eps ==========}
procedure t_ellipse.DoExportEps;
var FillColor:integer;
    StrFill, StrStroke:string;

    procedure trace;
    begin
       exportwrite('/mtrx CM def ');
       if transform then
         begin
         exportwriteln('['+StreelS(Xscale*matrix[1])+' '+StreelS(Yscale*matrix[2])+' '+
                       StreelS(Xscale*matrix[3])+' '+StreelS(Yscale*matrix[4])+
                       ' '+StreelS(Xscale*pica*matrix[5]+Xeps(0))+' '+StreelS(Yscale*pica*matrix[6]+Yeps(0))+'] concat');
         exportwrite(streel(pica*rX)+' '+Streel(pica*rY)+' '+Streel(inclinaison)+' '+Streel(pica*Xcentre)+ ' '+streel(pica*Ycentre));
         end
       else
         begin
            exportwrite(streel((CpicaX*(rX)))+' '+streel((CpicaY*(rY)))+' '+Streel(inclinaison)+' '+
                    //'0.5 currentlinewidth mul dup 4 -1 roll sub neg 3 1 roll sub '
                    Streel((XEps(Xcentre)))+ ' '+streel((YEps(Ycentre))));
         end;
      exportwrite(' translate rotate scale 0 0 1 0 360 arc mtrx setmatrix closepath ')
    end;

begin
     fillColor:=fill_Color;
     if evenoddfill then StrFill:='eofill ' else StrFill:='fill '; StrStroke:='s ';
     //gestion de la transparence remplissage solide
     if (Fill_style=1) and (fill_opacity<1) then
                        StrFill:=Streel(fill_opacity)+' .setopacityalpha '+Strfill;
     //gestion du stroke en cas de transparence ou non
     if (ligne_style=-1) //pas de ligne
        then
            if ((Fill_style=1) or (fill_style=8)) and (fill_opacity<>1)
               then StrStroke:='1 .setopacityalpha s ' //il faut restaurer la non transparence
               else
        else //ligne
            if (stroke_opacity<1) then
                        StrStroke:=Streel(stroke_opacity)+' .setopacityalpha s 1 .setopacityalpha ';
     if (not InPath) and (fill_style=8) then
     begin
        if  (ligne_style<>-1) then exportwriteln('Chem '+StrStroke);
        exit;
     end;
     trace;
     if (ligne_style<>-1)
                      then
                           if fill_style=1
                              then exportwriteln( 'gs '+StrColor(fillColor,eps)+StrFill+'gr '+StrStroke)
                              else exportwriteln( StrStroke)

                      else if fill_style=1
                              then exportwriteln( StrColor(fillColor,eps)+StrFill+StrStroke+
                                                 StrColor(couleur_courante,eps));

end;
{=============t_ellipse en src4Latex ==========}
procedure t_ellipse.enregistrer_src4Latex;
begin
     t_element.enregistrer_src4latex;
     //exportwriteln( {'Graph '+nom+'=}#9+'Ellipse('+FormatString(LigneCommande,70)+'),');
     exportwriteln('Ellipse('+FormatString(LigneCommande,70)+');');
end;
{=============t_ellipse en Pgf ==========}
procedure t_ellipse.DoExportPgf;
var arg:string;
    xcs,ycs,rXs,rYs,inclins,angle,u1,u2,v1,v2:real;
begin
     xcs:=Xcentre; ycs:=Ycentre; rXs:=rX; rYs:=rY; inclins:=inclinaison;
     TransformEllipse(matrix,Xcentre,Ycentre,rX,rY,inclinaison*pi/180, xcs,ycs,rXs,rYs,inclins);
     angle:=inclins*pi/180;
     if OriginalCoord  then
        begin
             u1:=rXs*cos(angle)/Xscale; u2:=rXs*sin(angle)/Yscale;
             v1:= -rYs*sin(angle)/Xscale; v2:= rYs*cos(angle)/Yscale
        end
     else
       begin
             u1:=rXs*cos(angle); u2:= rXs*sin(angle);
             v1:= -rYs*sin(angle); v2:= rYs*cos(angle)
        end ;
     exportwriteln('\pgfellipse{\pgfxy('+Streel(Xtex(xcs))+','+Streel(Ytex(ycs))+')}{'+
                     '\pgfxy('+streel(u1)+','+streel(u2)+')}{\pgfxy('+
                     streel(v1)+','+ streel(v2)+')}%');
     pgffillstroke;
end;
{=============t_ellipse en Svg ==========}
procedure t_ellipse.DoExportSvg;
var a,b,c,d,e,f,     xcs,ycs,rXs,rYs,inclins:real;
begin
     if clippee then ClipExport(svg);
     xcs:=Xcentre; ycs:=Ycentre; rXs:=rX; rYs:=rY; inclins:=inclinaison;
     TransformEllipse(matrix,Xcentre,Ycentre,rX,rY,inclinaison*pi/180, xcs,ycs,rXs,rYs,inclins);
     exportwrite('<ellipse cx="0" cy="0" rx="'+streel(rXs)+'cm" ry="'+streel(rYs)+'cm" transform="');
     a:= Xsvg(xcs); b:=Ysvg(ycs);
     if (a<>0) or (b<>0) then exportwrite('translate('+Streel(a)+' '+Streel(b)+') ');
     if inclins<>0  then exportwrite(' rotate('+Streel(-inclins)+')');
     exportwrite('"');
     if fill_style=1 then exportwrite( ' fill="'+StrColor(fill_Color,svg)+'"');
     if clippee then  exportwrite( ' clip-path="url(#'+SvgClipName+')"');
     exportwriteln( '/>');
end;
{============================ TArc ============================================}
constructor T_EllipticArc.init(const UnNom, UneCommande:string; LeSens:integer);
begin
     if LeSens>0 then sens:=1 else sens:=-1;
     Xcentre:=0; Ycentre:=0; rx:=1; ry:=1; angleA:=0; angleB:=360;
     T_Ligne.init(UnNom,UneCommande,0,0);
     cat:=cat_EllipticArc;
end;
{==============}
procedure T_EllipticArc.recalculer;
var
    f:Pexpression;
    chaine:string;
    T,a,b,c,radX,radY:Paffixe;
    angle_a,angle_b:Pconstante;
begin
     t_element.recalculer;
     if liste_points^.tete=nil then exit;
     Kill(Pcellule(donnees));
     donnees:=Paffixe(liste_points.tete);
     liste_points^.init;
     T:=Paffixe(donnees);
     if (T<>Nil) and (T^.suivant<>nil) and (T^.suivant^.suivant<>nil)
        and (T^.suivant^.suivant^.suivant<>nil) and (T^.suivant^.suivant^.suivant^.suivant<>nil)then
           begin
                b:=T;
                a:=Paffixe(b^.suivant);
                c:=Paffixe(a^.suivant);
                radx:=Paffixe(c^.suivant);
                rady:=Paffixe(radx^.suivant);
                if ((a^.x=b^.x) and (a^.y=b^.y)) or
                   ((a^.x=c^.x) and (a^.y=c^.y))  or (radx^.y<>0) or (rady^.y<>0)
                then begin Kill(Pcellule(donnees)); exit end;
           end else begin Kill(Pcellule(donnees)); exit end;
     Xcentre:=a^.x; Ycentre:=a^.y; rx:=abs(radx^.x); ry:=abs(rady^.x);
     new(f,init);
     angle_A:=new(Pconstante,init('angleb',new(Paffixe,init(0,0)),true));
     angle_B:=new(Pconstante,init('anglec',new(Paffixe,init(0,0)),true));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('a',new(Paffixe,init(a^.x,a^.y)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('b',new(Paffixe,init(b^.x,b^.y)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('c',new(Paffixe,init(c^.x,c^.y)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('rx',new(Paffixe,init(rx,0)),true)));
     f^.varLoc^.ajouter_fin(new(Pconstante,init('ry',new(Paffixe,init(ry,0)),true)));
     f^.varLoc^.ajouter_fin(angle_a);
     f^.varLoc^.ajouter_fin(angle_b);
     f^.varLoc^.ajouter_fin(new(Pconstante,init('nbpoints',new(Paffixe,init(nb_points,0)),true)));
     chaine:='[$u:=(b-a)/abs(b-a), $v:=(c-a)/abs(c-a), $angleb:=Arg(u), $anglec:=Arg(v), $l:=sqr(rx/ry),'+
             'if rx<ry then $r:=ry else r:=rx fi, $tf:=anglec-angleb,'+
             'if abs(tf)<1E-17 then tf:=2*pi fi,';
     if sens=1 then chaine:=chaine+'Si(tf<0,Inc(tf,2*pi)),'
               else chaine:=chaine+'Si( (tf>0) And (tf<>2*pi),Inc(tf,-2*pi)),';
     chaine:=chaine+'Set($n,2+Ent(abs(tf*nbpoints)/(2*pi))),'+
     ' if r>1E17 then  else '+
     'if r>1 then n:=Ent((n-1)*r)+2 fi,  n:=min([n,250]), Set($pas,tf/n),Set($t,angleb),'+
     'for $k from 0 to n-1 do a+rx*exp(i*t)/sqrt( sqr(cos(t))+l*sqr(sin(t))), Inc(t,pas) od fi,'+
     't:=anglec, a+rx*exp(i*t)/sqrt( sqr(cos(t))+l*sqr(sin(t))),'+
     ' angleb:=Arg(Re(u)/rx+i*Im(u)/ry), anglec:=Arg(Re(v)/rx+i*Im(v)/ry)]';   //conversion pour pgf et eps
     if f^.definir(chaine) then  T:=f^.evalNum else T:=nil;
     if T<>nil then begin
                         if (angle_a^.affixe<>nil) and (angle_b^.affixe<>nil) then
                         begin
                           angleA:=angle_a^.affixe^.getx;angleB:=angle_b^.affixe^.getx;
                           if angleA<0 then angleA +=2*pi;
                           if angleB<0 then angleB +=2*pi;
                           if angleA=angleB then
                              begin
                                  angleA:=0; angleB:=360;
                              end else
                              begin
                                   angleA:=angleA*180/pi;
                                   angleB:=angleB*180/pi;
                              end;
                         end else begin liste_points^.detruire; Kill(Pcellule(donnees)); Kill(Pcellule(T));dispose(f,detruire); exit end;
                         liste_points^.ajouter_fin(T);
                         if transform then transformate;
                         clipper;
                         if fleche>0 then calcul_fleches
                    end;
     dispose(f,detruire);
end;
{======================}
{$ifdef GUI}
procedure t_ellipticArc.toPath(Var first:boolean; var p: TBGRAPath);
 var xc,yc,x1,y1,x2,y2,x3,y3,ecart,rXs,rYs, sns:real;
 begin
      if (matrix[2]<>0) or (matrix[3]<>0)  then begin T_ligne.toPath(first,p); exit end;
      rXs:=longX(abs(matrix[1])*Rx); rYs:=longY(abs(matrix[4])*Ry);
      x2:=Paffixe(liste_points^.queue)^.X;y2:=Paffixe(liste_points^.queue)^.Y;
      x1:=Paffixe(liste_points^.tete)^.X;y1:=Paffixe(liste_points^.tete)^.Y;
      if first then p.moveto(XentierF(X1),YentierF(Y1));
      if (angleA=0) and (angleB=360) then  {ellipse entiere}
          begin
               xc:=Xcentre*matrix[1]+matrix[5];yc:=Ycentre*matrix[4]+matrix[6]; //centre transformé
               x3:= 2*xc-x2;y3:=2*yc-y2;
               p.arcto(rXs,rYs,0,true,true,XentierF(x3),YentierF(y3));
               p.arcto(rXs,rYs,0,true,true,XentierF(x2),YentierF(y2));
          end
          else
          begin
          ecart:=angleB-angleA; sns:=sens;
          if matrix[1]*matrix[4]<0 then begin ecart:=-ecart; sns:=-sns end; //déterminant négatif, orientation changée
          while ecart<0 do ecart += 360;
          if  (ecart<=180) then
              if (sns=1) then
                 p.arcto(rXs,rYs,0,false,true,XentierF(x2),YentierF(y2))
              else
                 p.arcto(rXs,rYs,0,true,false,XentierF(x2),YentierF(y2))
          else //ecart>180
              if (sns=1) then
                 p.arcto(rXs,rYs,0,true,true,XentierF(x2),YentierF(y2))
              else
                 p.arcto(rXs,rYs,0,false,false,XentierF(x2),YentierF(y2))
          end;
      first := False
end;
{======================}
 procedure T_EllipticArc.dessiner;
 var first:boolean;
     p:TBGRAPath;
 begin
      if donnees=Nil then exit;
      first:=true; p:= TBGRAPath.Create(); toPAth(first,p);
      Canvas2dDrawPath(self,p)
 end;
{$endif}
{============================================ LaTeX ===========================}
procedure T_EllipticArc.DoExportLatex;
var
    angledep,anglefin,x1,y1,scaleX,scaleY:real;
    old:boolean;
begin
    scaleX:=matrix[1]*Xscale; scaleY:=matrix[4]*Yscale;
    if (matrix[2]<>0) or (matrix[3]<>0) or
       clippee or (Rx*scaleX<>Ry*scaleY) or (ligne_style<>0) then T_ligne.DoExportLaTeX
       else
       begin
            x1:=Xcentre*matrix[1]+matrix[5];y1:=Xcentre*matrix[4]+matrix[6]; //centre transformé
            if sens=1 then begin angledep:=-angleB;anglefin:=-angleA;end
                      else begin angledep:=-angleA;anglefin:=-angleB;end;
            exportwriteln('\put('+streel(Xtex(x1))+','+streel(Ytex(y1))+'){\arc{'+streel(2*Rx*scaleX)+'}{'+
                streel(angleDep*pi/180)+'}{'+streel(angleFin*pi/180)+'}}%');
       end;
end;
{======================================== Pstricks =============================}
procedure T_EllipticArc.DoExportPst;
var    x1,y1,scaleX,scaleY,fac:real;
       angle_a,angle_b,sns:real;
begin
     if (matrix[2]<>0) or (matrix[3]<>0) then T_ligne.DoExportPst
        else
        begin
             if originalCoord then
                begin scaleX:=matrix[1]; scaleY:=matrix[4]; end
                else begin scaleX:=matrix[1]*Xscale; scaleY:=matrix[4]*Yscale; end;
             if scaleX=0 then exit else fac:=scaleY/scaleX;
             x1:=Xtex(Xcentre*matrix[1]+matrix[5]); y1:=Ytex(Ycentre*matrix[4]+matrix[6]); //centre transformé
             if anglea=90 then angle_a:=90 else
             if anglea=270 then angle_a:=270 else
                begin
                   angle_a:=anglea*pi/180;
                   angle_a:=(arctan(fac*ry*tan(angle_a)/rx)+pi*Floor(angle_a/pi+0.5))*180/pi;
                end;
             if angleb=90 then angle_b:=90 else
             if angleb=270 then angle_b:=270 else
                begin
                   angle_b:=angleb*pi/180;
                   angle_b:=(arctan(fac*ry*tan(angle_b)/rx)+pi*Floor(angle_b/pi+0.5))*180/pi;
                end;
             sns:=sens;
             if matrix[1]*matrix[4]<0 then begin sns:=-sns; angle_a:=-angle_a;angle_b:=-angle_b end; //déterminant négatif, orientation changée
             if sns=1 then exportwrite('\psellipticarc') else exportwrite('\psellipticarcn');
             if fleche=1 then exportwrite('{->}') else if fleche=2 then exportwrite('{<->}');
             exportwriteln('('+streel(x1)+','+streel(y1)+')('+streel(abs(Rx*scaleX))+','+streel(abs(Ry*scaleY))+'){'+
                streel(angle_a)+'}{'+streel(angle_b)+'}%');
        end
end;
{========================================= EPS =================================}
procedure T_EllipticArc.DoExportEps;
var    x1,y1,R:real;
       FillColor:integer;
       StrFill, StrStroke:string;

    procedure trace;
    begin
        exportwrite('/mtrx CM def ');
        if transform then
         begin
         exportwriteln('['+Streel(Xscale*matrix[1])+' '+Streel(Yscale*matrix[2])+' '+
                       Streel(Xscale*matrix[3])+' '+Streel(Yscale*matrix[4])+
                       ' '+Streel(Xscale*pica*matrix[5]+Xeps(0))+' '+Streel(Yscale*pica*matrix[6]+Yeps(0))+'] concat');

         exportwrite(Streel(angleA)+' '+Streel(angleB)+' '+streel(pica*Rx)+' '+streel(pica*Ry)+' '+
         //'0.5 currentlinewidth mul dup 4 -1 roll sub neg 3 1 roll sub '+
         Streel(pica*Xcentre)+' '+streel(pica*Ycentre));
         end
       else
         begin
         exportwrite(Streel(angleA)+' '+Streel(angleB)+' '+streel((CpicaX*(Rx)))+' '+streel((CpicaY*(Ry)))+' '+
                 //'0.5 currentlinewidth mul dup 4 -1 roll sub neg 3 1 roll sub '+
                 Streel((XEps(Xcentre)))+' '+streel((YEps(Ycentre))));
         end;
       exportwrite(' translate scale 0 0 1 5 3 roll ');
       if sens=1 then exportwrite('arc ') else exportwrite('arcn ');
       exportwrite('mtrx setmatrix ')
    end;

begin
     fillColor:=fill_Color;
     if evenoddfill then StrFill:='eofill ' else StrFill:='fill '; StrStroke:='s ';
     //gestion de la transparence remplissage solide
     if (Fill_style=1) and (fill_opacity<1) then
                        StrFill:=Streel(fill_opacity)+' .setopacityalpha '+Strfill;
     //gestion du stroke en cas de transparence ou non
     if (ligne_style=-1) //pas de ligne
        then
            if ((Fill_style=1) or (fill_style=8)) and (fill_opacity<>1)
               then StrStroke:='1 .setopacityalpha s ' //il faut restaurer la non transparence
               else
        else //ligne
            if (stroke_opacity<1) then
                        StrStroke:=Streel(stroke_opacity)+' .setopacityalpha s 1 .setopacityalpha ';
     if (not InPath) and (fill_style=8) then
     begin
        if  (ligne_style<>-1) then exportwriteln('Chem '+StrStroke);
        exit;
     end;
     trace;
     if InPath then exit;
     if (ligne_style<>-1)
                      then
                           if fill_style=1
                              then exportwriteln( 'gs '+StrColor(fillColor,eps)+StrFill+'gr '+StrStroke)
                              else exportwriteln( StrStroke)

                      else if fill_style=1
                              then exportwriteln( StrColor(fillColor,eps)+StrFill+StrStroke+
                                                 StrColor(couleur_courante,eps));
end;
{======================================== Pgf =================================}
procedure T_EllipticArc.DoExportPgf;
var fillColor,oldfillcourant:integer;
    x1,y1,xcs,ycs,rXs,rYs,inclins,u1,u2,v1,v2:real;
    deb,fin,radx, rady, scaleX,scaleY, angle:real;
    aux:Paffixe;

begin
     scaleX:=matrix[1]*Xscale; scaleY:=matrix[4]*Yscale;
     if (matrix[2]<>0) or (matrix[3]<>0) then begin T_ligne.DoExportPgf; exit end;
     radx:=Rx*scaleX; rady:=ry*scaleY;
     oldfillcourant:=fillcolor_courant;
     fillColor:=fill_Color;
     deb:=angleA; fin:=angleB;
     if sens=1 then
        if angleA>angleB then deb:=deb-360 else
     else if angleA<angleB then fin:=fin-360;
     if not clippee then
        begin x1:=Paffixe(liste_points^.tete)^.X; y1:=Paffixe(liste_points^.tete)^.Y end
     else begin x1:=Paffixe(noClipList.tete)^.X; y1:=Paffixe(noClipList.tete)^.Y end ;
     //tracé
     if (not InPath) or FirstInPath then
     exportwrite('\pgfpathmoveto{\pgfxy('+Streel(Xtex(X1))+','+Streel(Ytex(Y1))+')}');
     if angleA+360=angleB then
        begin
             xcs:=Xcentre; ycs:=Ycentre;
             if rX>rY then
                begin
                   rXs:=rX; rYs:=rY; inclins:=0;
                   TransformEllipse(matrix,Xcentre,Ycentre,rX,rY,0, xcs,ycs,rXs,rYs,inclins)
                end
             else
                 begin
                    rXs:=rY; rYs:=rX; inclins:=90;
                    TransformEllipse(matrix,Xcentre,Ycentre,rY,rX,pi/2, xcs,ycs,rXs,rYs,inclins);
                 end;
             angle:=inclins*pi/180;
             if OriginalCoord  then
                       begin
                            u1:=rXs*cos(angle)/Xscale; u2:=rXs*sin(angle)/Yscale;
                            v1:= -rYs*sin(angle)/Xscale; v2:= rYs*cos(angle)/Yscale
                       end
             else
                 begin
                      u1:=rXs*cos(angle); u2:= rXs*sin(angle);
                      v1:= -rYs*sin(angle); v2:= rYs*cos(angle)
                 end;
             exportwriteln('\pgfellipse{\pgfxy('+Streel(Xtex(xcs))+','+Streel(Ytex(ycs))+')}{'+
                 '\pgfxy('+streel(u1)+','+streel(u2)+')}{\pgfxy('+
                 streel(v1)+','+ streel(v2)+')}%');
        end
     else
         if radX=radY then
            exportwriteln('\pgfpatharc{'+streel(deb)+'}{'+ streel(fin)+'}{'+streel(radX)+'cm}%')
         else
            exportwriteln('\pgfpatharc{'+streel(deb)+'}{'+ streel(fin)+'}{'+streel(radX)+'cm and '+streel(radY)+'cm}%');
     if not InPath then pgffillstroke;
end;
{========================================= Svg =================================}
procedure T_EllipticArc.DoExportSvg;
var xc,yc,x1,y1,x2,y2,x3,y3,ecart,scaleX,scaleY,sns:real;
begin
     if (matrix[2]<>0) or (matrix[3]<>0)  then begin T_ligne.DoExportSvg;exit end;
     scaleX:=abs(matrix[1]); scaleY:=abs(matrix[4]);
     x2:=Paffixe(liste_points^.queue)^.X;y2:=Paffixe(liste_points^.queue)^.Y;
     x1:=Paffixe(liste_points^.tete)^.X;y1:=Paffixe(liste_points^.tete)^.Y;
     xc:=Xcentre*matrix[1]+matrix[5];yc:=Ycentre*matrix[4]+matrix[6]; //centre transformé
     if clippee then ClipExport(svg);
     if not InPath then exportwrite( '<path d="M');
     if (not InPath) or FirstInPath then exportwrite( Streel(Xsvg(X1))+','+Streel(Ysvg(Y1)));
     exportwrite(' A'+ streel(longX(Rx*scaleX))+','+streel(longY(Ry*scaleY))+' 0');
     if (angleA=0) and (angleB=360) then  {ellipse entiere}
         begin
              x3:= 2*xc-x2;y3:=2*yc-y2;
              exportwrite(' 1,0 '+ Streel(Xsvg(x3))+','+Streel(Ysvg(y3)));
              exportwrite(' A'+ streel(longX(Rx*scaleX))+','+streel(longY(Ry*scaleY))+' 0');
              exportwrite(' 1,0 '+ Streel(Xsvg(x2))+','+Streel(Ysvg(y2)));
         end
         else
         begin
         ecart:=angleB-angleA;
         sns:=sens;
         if matrix[1]*matrix[4]<0 then begin ecart:=-ecart; sns:=-sns end; //déterminant négatif, orientation changée
         while ecart<0 do ecart += 360;
         if  (ecart<=180) then
             if (sns=1) then  exportwrite(' 0,0 ') else exportwrite(' 1,1 ')
         else //ecart>180
             if (sns=1) then  exportwrite(' 1,0 ') else exportwrite(' 0,1 ');
          exportwrite(Streel(Xsvg(X2))+','+Streel(Ysvg(Y2)) );
         end;

     if InPath then exit;

     exportwrite('"');
     if fill_style=1 then exportwrite( ' fill="'+StrColor(fill_Color,svg)+'"');
     if clippee then  exportwrite( ' clip-path="url(#'+SvgClipName+')"');
     exportwriteln( '/>');
end;
{================================ teg ==========================================}
procedure T_EllipticArc.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     exportwriteln('EllipticArc('+FormatString(LigneCommande,70)+','+InttoStr(sens)+');');
end;
{===============================T_Equadif ======================================}
constructor T_EquaDif.init(const UnNom, UneCommande:string;Unmode:byte);
begin
     mode:=Unmode mod 3;
     t_parametree.init(UnNom,UneCommande,0,0);
     cat:=cat_EquaDif;
end;
{=======================}
procedure T_Equadif.ConstruitArbre;
var p:Pcorps;
    aux:Pliste;
begin
     if Unarbre<>nil
        then
            begin
             new(arbre,init);
             DefCommande:=false;
             UnArbre^.ConvertLocale('t');
             arbre^.VarLoc:=LesVarLoc;
             arbre^.corps:=Unarbre;
        end
        else
            begin
                 if arbre<>nil then dispose(arbre,detruire);
                 new(arbre,init);
                 arbre^.varloc^.ajouter_fin(new(Pconstante,init('t',nil,true)));
                 arbre^.varloc^.ajouter_fin(new(Pconstante,init('z',nil,true)));
                 if not arbre^.definir(LigneCommande)
                    then begin
                           dispose(arbre,detruire);
                           arbre:=nil
                         end;
                 DefCommande:=true;
            end;
     if arbre<>nil then
        begin
             aux:=LesVarLoc; LesVarLoc:=arbre^.VarLoc;
             p:=DefCorps('Re($z)'); arbre^.corps^.composer('x',p); dispose(p,detruire);
             p:=DefCorps('Im($z)'); arbre^.corps^.composer('y',p); dispose(p,detruire);
             arbre^.VarLoc:=LesVarLoc; LesVarLoc:=aux;
        end;
end;
{=======================}
procedure T_EquaDif.recalculer;
var h,t0,Zx,Zy:real;
    j,k,N:integer;
    aux:Paffixe;
    T,Z,y0,k1,k2,k3,k4,Zaux:Paffixe;
    f1,f2,f3:Pcorps;
begin
     liste_points^.detruire;
     noClipList.detruire;
     X_min:=Xmin; X_max:=Xmax;
     Y_min:=Ymin; Y_max:=Ymax;
     if DefCommande then
        begin
             ConstruitArbre(nil);
             if arbre=nil then exit;
        end
        else if arbre=nil then exit;
     if ParcourtFenetre then
        begin
          MinT:=X_min;
          MaxT:=X_max;
        end;

     f1:=Pcorps(arbre^.corps);
     if (f1=nil) or (f1^.categorie<>cat_commande) or  (Pcommande(f1^.contenu)^.nom<>'Liste') then exit;
     {détermination de f1,f2,f3,t0,y0}
     f1:=Pcorps(f1^.arguments^.tete);
     f2:=Pcorps(f1^.suivant);
     if f2=nil then exit;
     f3:=Pcorps(f2^.suivant);
     if f3=nil then exit;
     T:=f2^.evalNum;
     if T=nil then exit;
     t0:=T^.x; Kill(Pcellule(T));

     //if (t0<MinT) or (t0>MaxT) then exit;
     y0:=f3^.evalNum;
     if y0=nil then exit;

     {on assigne f1(t,z)}
     T:=new(Paffixe,init(t0,0));
     Z:=new(Paffixe,init(y0^.x,y0^.y));
     arbre^.assigner('t',T);
     arbre^.assigner('z',Z);
     Zaux:=nil;k1:=nil;k2:=nil;k3:=nil;k4:=nil;
     {calcul des points}
     if mode=0 then new(aux,init(y0^.x,y0^.y))
               else
     if mode=1 then new(aux,init(t0,y0^.x))
               else new(aux,init(t0,y0^.y));
     liste_points^.ajouter_fin(aux);
     for j:=1 to 2 do
     begin
     T^.x:=t0;
     Z^.x:=y0^.x;Z^.y:=y0^.y;
     CalcError:=false;
     if j=1 then begin
                N:=Trunc((nbpoints-1)*(maxT-t0)/(maxT-minT)); //nb points après t0
                if N>0 then h:=(MaxT-t0)/N else h:=0
                end
            else begin
                N:=nbpoints-N-1; //nb points avant t0
                if N>0 then h:=(MinT-t0)/N else h:=0
                end;
     k:=0;
     while (k<N)  and (not CalcError) do //Runge-Kutta 4
           begin
            k1:=f1^.evalNum;
            if k1=nil then CalcError:=true
               else
               begin
            T^.x += h/2;
            Zaux:=Z^.evalNum;
            Z^.x:= ajouter(Z^.x,multiplier(h/2,k1^.x));
            Z^.y:= ajouter(Z^.y,multiplier(h/2,k1^.y));
            k2:=f1^.evalNum;
            if k2=nil then CalcError:=true
               else
               begin
            Z^.x:= ajouter(Zaux^.x,multiplier(h/2,k2^.x));
            Z^.y:= ajouter(Zaux^.y,multiplier(h/2,k2^.y));
            k3:=f1^.evalNum;
            if k3=nil then CalcError:=true
               else
               begin
            T^.x += h/2;
            Z^.x:= ajouter(Zaux^.x,multiplier(h,k3^.x));
            Z^.y:= ajouter(Zaux^.y,multiplier(h,k3^.y));
            k4:=f1^.evalNum;
            if k4=nil then CalcError:=true
               else
               begin
            Z^.x:= ajouter(Zaux^.x,
                  multiplier(h/6,
                  ajouter(k1^.x,ajouter(multiplier(2,k2^.x),
                  ajouter(multiplier(2,k3^.x),k4^.x)))));
            Z^.y:=ajouter(Zaux^.y,
                  multiplier(h/6,
                  ajouter(k1^.y,ajouter(multiplier(2,k2^.y),
                  ajouter(multiplier(2,k3^.y),k4^.y)))));
            if not CalcError
               then
            begin
            if mode=1 then begin Zy:=Z^.x;Zx:=T^.x end
                      else
            if mode=2 then begin Zx:=T^.x;Zy:=Z^.y end
                      else begin Zx:=Z^.x;Zy:=Z^.y end;
            if j=1 then liste_points^.ajouter_fin(new(Paffixe,init(Zx,Zy)))
                   else liste_points^.inserer(new(Paffixe,init(Zx,Zy)),liste_points^.tete);
               end
               end;{k4}
               end;{k3}
               end;{k2}
               end;{k1}
            Kill(Pcellule(Zaux));Kill(Pcellule(k1));Kill(Pcellule(k2));Kill(Pcellule(k3));
            Kill(Pcellule(k4));
            Inc(k,1)
            end;
     end;
     Kill(Pcellule(y0));
     if transform then transformate;
     clipper;
     if fleche>0 then calcul_fleches;
     arbre^.desassigner('t'); Kill(Pcellule(T));
     arbre^.desassigner('z'); Kill(Pcellule(Z));
end;
{===============}
procedure T_EquaDif.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     //exportwriteln( #9+'EquaDif('+FormatString(LigneCommande,70)+','+IntToStr(mode)+'),');
     exportwriteln('EquaDif('+FormatString(LigneCommande,70)+','+IntToStr(mode)+');');
end;
{======================================================================}
constructor T_implicit.init(const UnNom, UneCommande:string);
begin
     t_ligne.init(UnNom,UneCommande,0,0);
     cat:=cat_implicit;
     //fill_style:=0;
     //fleche:=0;
end;
{=========================================}
procedure T_implicit.ConstruitArbre;
var p:Pexpression;
    f1,f2,f3:Pcorps;
    aux1:Pliste;
    T:Paffixe;
begin
     if Unarbre<>nil
        then
            begin
             new(arbre,init);
             DefCommande:=false;
             Unarbre^.ConvertLocale('x');
             Unarbre^.ConvertLocale('y');
             arbre^.VarLoc:=LesVarLoc;
             arbre^.corps:=Unarbre;
        end
        else
            begin
                 if arbre<>nil then dispose(arbre,detruire);
                 new(arbre,init);
                 arbre^.varloc^.ajouter_fin(new(Pconstante,init('x',nil,true)));
                 arbre^.varloc^.ajouter_fin(new(Pconstante,init('y',nil,true)));
                 if not arbre^.definir(LigneCommande)
                    then begin
                           dispose(arbre,detruire);
                           arbre:=nil
                         end;
                 DefCommande:=true;
            end;
     if arbre<>nil then
        begin
             GridX:=50;GridY:=50;
             if (arbre^.corps^.categorie=cat_commande) and
                (Pcommande(arbre^.corps^.contenu)^.nom='Liste')
                then
                begin

                     if (arbre^.corps^.arguments=nil) then exit;
                     f1:=Pcorps(arbre^.corps^.arguments^.tete);
                     f2:=Pcorps(f1^.suivant);
                     if f2<> nil then
                        begin
                             CalcError:=false;
                             T:=f2^.evalNum;
                             if CalcError or (T=nil) or (T^.x<0)  then else GridX:=Round(T^.x);
                             Kill(Pcellule(T));
                             f3:=Pcorps(f2^.suivant);
                             if f3<>nil then
                                    begin
                                    CalcError:=false;
                                    T:=f3^.evalNum;
                                    if CalcError or (T=nil) or (T^.x<0)  then else GridY:=Round(T^.x);
                                    Kill(Pcellule(T));
                                    end;
                        end;
                     new(p,init);
                     p^.corps:=f1^.dupliquer;
                     if DefCommande then
                        begin
                                aux1:=LesVarLoc;
                                LesVarLoc:=p^.VarLoc;
                        end else p^.VarLoc:= LesVarLoc;
                     p^.corps^.brancherLocales;
                     if DefCommande then LesVarLoc:=aux1;
                     if DefCommande then dispose(arbre,detruire) else dispose(arbre);
                     arbre:=p;
                end;
        end;

end;
{===========================}
procedure T_implicit.recalculer;
type tarray=array[0..1] of Paffixe;
     Tcase=array[1..4] of Paffixe;
var Y,X, aux:Paffixe;
    pasX,pasY:real;
    i,j,k:longint;
    T:^tarray;
    horiz,vertic:^tarray;
    TheCase:Tcase;
    ok1,ok2,ok3,ok4: boolean;

    function sgn(x:real):integer;
    begin
        if x>0 then sgn:=1
        else if x<0 then sgn:=-1 else sgn:=0;
    end;

    function index(u,v:integer):longint;
    begin
        index:=u*(1+gridX)+v
    end;

    function dichoto(x1,y1,pas,val1,val2:real; lettre:char):Paffixe;
    const niv=5;
    var u,v,m:real;
        i:integer;
        res:Paffixe;
    begin
          if lettre='x' then
                begin
                        Y^.x:=y1; u:=x1; v:=x1+pas;
                        for i:=1 to niv do
                                begin
                                        m:=(u+v)/2;
                                        X^.x:=m;
                                        res:=arbre^.evalNum;
                                        if res<>nil then
                                           if val1*res^.x<=0 then begin val2:=res^.x; v:=m end
                                                             else begin val1:=res^.x; u:=m; end;
                                        Kill(Pcellule(res))
                                end;
                        dichoto:=New(Paffixe,init((u+v)/2,y1));
                end
                else
                begin
                        X^.x:=x1; u:=y1; v:=y1+pas;
                        for i:=1 to niv do
                                begin
                                        m:=(u+v)/2;
                                        Y^.x:=m;
                                        res:=arbre^.evalNum;
                                        if res<>nil then
                                           if val1*res^.x<=0 then begin val2:=res^.x; v:=m end
                                                             else begin val1:=res^.x; u:=m; end;
                                        Kill(Pcellule(res))
                                end;
                        dichoto:=New(Paffixe,init(x1,(u+v)/2));
                end;
    end;

begin
     liste_points^.detruire;
     noClipList.detruire;
     X_min:=Xmin; X_max:=Xmax;
     Y_min:=Ymin; Y_max:=Ymax;
     if DefCommande then
        begin
             ConstruitArbre(nil);
             if arbre=nil then exit;
        end
        else if arbre=nil then exit;

     Y:=new(Paffixe,init(Y_max,0));
     X:=new(Paffixe,init(X_min,0));
     GetMem(T,(1+gridX)*(1+gridY)*Sizeof(Paffixe));
     GetMem(horiz,(1+gridX)*(1+gridY)*Sizeof(Paffixe));
     GetMem(vertic,(1+gridX)*(1+gridY)*Sizeof(Paffixe));

     for i:=0 to (1+gridX)*(1+gridY)-1 do
        begin
                horiz^[i]:=nil;
                vertic^[i]:=nil;
        end;

     arbre^.assigner('y',Y);
     arbre^.assigner('x',X);
     pasX:=(X_max-X_min)/gridX; pasY:=(Y_min-Y_max)/gridY;

     for i:=0 to gridY do
      begin
       X^.x:=X_min;
       for j:=0 to gridX do
         begin
          T^[index(i,j)]:=arbre^.evalNum;
          X^.x:=X^.x+pasX;
         end;
        Y^.x:=Y^.x+pasY;
       end;

      for i:=0 to gridY do
       for j:=0 to gridX-1 do
         begin //examen des cas sur bords horiz
             if ((T^[index(i,j)]<>nil) and (T^[index(i,j+1)]<>nil)
                 and (sgn(T^[index(i,j)]^.x)*sgn(T^[index(i,j+1)]^.x)<=0))
             then
       horiz^[index(i,j)]:=dichoto(X_min+j*pasX, Y_max+i*pasY, pasX, T^[index(i,j)]^.x,T^[index(i,j+1)]^.x,'x');
         end;

       for i:=0 to gridY-1 do
       for j:=0 to gridX do
         begin //examen des cas sur bords vertic
             if ((T^[index(i,j)]<>nil) and (T^[index(i+1,j)]<>nil)
                 and (sgn(T^[index(i,j)]^.x)*sgn(T^[index(i+1,j)]^.x)<=0))
             then
       vertic^[index(i,j)]:=dichoto(X_min+j*pasX, Y_max+i*pasY, pasY, T^[index(i,j)]^.x,T^[index(i+1,j)]^.x,'y');
         end;

       for i:=1 to gridY do
       for j:=1 to gridX do
         begin //ajouts des points
             ok1:= (horiz^[index(i-1,j-1)]<>nil);
             ok2:= (vertic^[index(i-1,j-1)]<>nil);
             ok3:=  (horiz^[index(i,j-1)]<>nil);
             ok4:= (vertic^[index(i-1,j)]<>nil);
             if ok1 and ok2  //1 2
              then
                begin
                        if ((T^[index(i-1,j-1)]<>nil) and (T^[index(i,j)]<>nil)
                                and (sgn(T^[index(i,j)]^.x)*sgn(T^[index(i-1,j-1)]^.x)<=0))
                        then
                        begin
                        aux:=horiz^[index(i-1,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        aux:= vertic^[index(i-1,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        Liste_points^.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                        end
                end;
              //else
             if ok1 and ok3  //1 3
              then
                begin
                        if (ok2 and ok4) or ( (not ok2) and ( not ok4)) or
                        ( (T^[index(i-1,j-1)]<>nil) and
                           (T^[index(i,j)]<>nil)    and
                           (sgn(T^[index(i,j)]^.x)*sgn(T^[index(i-1,j-1)]^.x)<=0)
                        )
                        then
                        begin
                        aux:=horiz^[index(i-1,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        aux:=horiz^[index(i,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        Liste_points^.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                        end
                end;
              //else
             if ok1 and ok4  //1 4
              then
                begin
                        if ((T^[index(i-1,j)]<>nil) and (T^[index(i,j-1)]<>nil)
                                and (sgn(T^[index(i-1,j)]^.x)*sgn(T^[index(i,j-1)]^.x)<=0))
                        then
                        begin
                        aux:=horiz^[index(i-1,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        aux:=vertic^[index(i-1,j)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        Liste_points^.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                        end
                end;
              //else
             if ok2 and ok3  //2 3
              then
                begin
                        if ((T^[index(i-1,j)]<>nil) and (T^[index(i,j-1)]<>nil)
                                and (sgn(T^[index(i-1,j)]^.x)*sgn(T^[index(i,j-1)]^.x)<=0))
                        then
                        begin
                        aux:=vertic^[index(i-1,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        aux:=horiz^[index(i,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        Liste_points^.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                        end
                end;
              //else
             if ok2 and ok4  //2 4
              then
                begin
                        if (ok1 and ok3) or ( (not ok1) and (not ok3)) or
                          ((T^[index(i-1,j)]<>nil) and (T^[index(i,j-1)]<>nil)
                                and (sgn(T^[index(i-1,j)]^.x)*sgn(T^[index(i,j-1)]^.x)<=0))
                        then
                        begin
                        aux:=vertic^[index(i-1,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        aux:=vertic^[index(i-1,j)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        Liste_points^.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                        end
                end;
              //else
             if ok3 and ok4 //(vertic^[index(i-1,j)]<>nil) and (horiz^[index(i,j-1)]<>nil)  //4 3
              then
                begin
                        if ((T^[index(i-1,j-1)]<>nil) and (T^[index(i,j)]<>nil)
                                and (sgn(T^[index(i,j)]^.x)*sgn(T^[index(i-1,j-1)]^.x)<=0))
                        then
                        begin
                        aux:=vertic^[index(i-1,j)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        aux:=horiz^[index(i,j-1)];
                        Liste_points^.ajouter_fin(New(Paffixe,init(aux^.x,aux^.y)));
                        Liste_points^.ajouter_fin(New(Paffixe,init(jump^.x,jump^.y)));
                        end
                end;

             //liste_points^.ajouter_fin(new(Paffixe,init(jump^.x, 0)));
         end;


     for i:=0 to (1+gridX)*(1+gridY)-1 do Kill(Pcellule(T^[i]));
     for i:=0 to (1+gridX)*(1+gridY)-1 do Kill(Pcellule(horiz^[i]));
     for i:=0 to (1+gridX)*(1+gridY)-1 do Kill(Pcellule(vertic^[i]));

     FreeMem(T,(1+gridX)*(1+gridY)*Sizeof(Paffixe));
     FreeMem(horiz,(1+gridX)*(1+gridY)*Sizeof(Paffixe));
     FreeMem(vertic,(1+gridX)*(1+gridY)*Sizeof(Paffixe));

     arbre^.desassigner('x');
     arbre^.desassigner('y');
     Kill(Pcellule(Y));Kill(Pcellule(X));
     aux:=Paffixe(Liste_points^.tete); Liste_points^.init;
     liste_points^.ajouter_fin(Merge(aux));
     if transform then transformate;
     if fleche>0 then calcul_fleches;
end;
{========================}
procedure T_Implicit.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     //exportwriteln( {'Graph '+nom+'=}#9+'Implicit('+FormatString(LigneCommande,70)+'),');
     exportwriteln('Implicit('+FormatString(LigneCommande,70)+');');
end;
{====================================== T_Bezier ===============================}
constructor T_Bezier.init(const UnNom, UneCommande:string);
begin
     T_parametree.init(UnNom,UneCommande,5,0);
     cat:=cat_bezier;
end;
{==========================}
procedure T_Bezier.clip;
begin
    t_ligne.clip
end;
{==========================}
procedure T_Bezier.recalculer;
var h:real;
    i:integer;
    a,c,d,b,u,v,w:Paffixe;
    t0:real;
begin
     liste_points^.detruire;
     Kill(Pcellule(donnees));
     t_element.recalculer;
     if transform then transformate;
     if liste_points^.tete=nil then exit;
     donnees:=Paffixe(liste_points.tete);
     liste_points^.init;
     a:=donnees; control3:=false; compteur:=0;
     u:=nil; v:=nil; w:=nil;
     h:=1/(nb_points-1);
   while a<>nil do
     begin
        b:=Paffixe(a^.suivant);
        if b<>nil then
                begin
                 c:=Paffixe(b^.suivant);
                 Inc(compteur);
                end else c:=nil;
        if (b<>nil) and IsJump(b) then d:=c
                else
        if c<>nil then d:=Paffixe(c^.suivant) else d:=nil;
        if d<>nil then
        begin  {4 pts de controles}
          if a=donnees then Liste_points^.ajouter_fin(new(Paffixe,init(a^.x,a^.y)));
          t0:=h;
          if IsJump(b) then  Liste_points^.ajouter_fin(new(Paffixe,init(d^.x,d^.y)))
           else
           begin
          u:=kFoisC(3, soustraireC(b,a));
          v:=kFoisC(3,ajouterC(c,soustraireC(a,kFoisC(2,b))));
          w:=ajouterC(soustraireC(d,a),kFoisC(3,soustraireC(b,c)));
          if (u<>nil) and (v<>nil) and (w<>nil)
            then
                for i:=2 to nb_points do
                begin
            Liste_points^.ajouter_fin(new(Paffixe,init(a^.x+t0*(u^.x+t0*(v^.x+t0*w^.x)),a^.y+t0*(u^.y+t0*(v^.y+t0*w^.y)))));
            t0 += h;
                end;
           Kill(Pcellule(u));Kill(Pcellule(v)); Kill(Pcellule(w));
            end
        end
         else  {d=nil}
               if a=donnees
               then begin {3pts de controles}
                          if (b=nil) or (c=nil) then begin kill(Pcellule(donnees)); exit end;
                          control3:=true;t0:=0;
                          u:=kFoisC(2, soustraireC(b,a));
                          v:=ajouterC(c,soustraireC(a,kFoisC(2,b)));
                          if (u<>nil) and (v<>nil) then
                          for i:=1 to nb_points do
                                begin
            Liste_points^.ajouter_fin(new(Paffixe,init(a^.x+t0*(u^.x+t0*v^.x),a^.y+t0*(u^.y+t0*v^.y))));
            t0 += h;
                                end;
                          Kill(Pcellule(u));Kill(Pcellule(v));

                    end
               else begin  {on détruit les points en trop}
                           a^.suivant:=nil;
                           Kill(Pcellule(b))
                     end;
        a:=d
     end;
     if Liste_points^.tete<>nil then
       begin
        clipper;
        if fleche>0 then calcul_fleches;
       end else Kill(Pcellule(donnees));
end;
{===================}
{$ifdef GUI}
procedure t_bezier.toPath(var first:boolean; var p: TBGRAPath); // appelée par l'instruction Path
var aux1,aux2,aux3,aux4:Paffixe;
begin
     aux1:=Paffixe(donnees);
     if first then p.moveto(XentierF(aux1^.X),+YentierF(aux1^.Y));
     if control3 then //un seul point de contrôle, bézier quadratique
        begin
              aux2:=Paffixe(aux1^.suivant);
              aux3:=Paffixe(aux2^.suivant);
              p.quadraticCurveTo( XentierF(aux2^.X),YentierF(aux2^.Y),
                                  XentierF(aux3^.X),YentierF(aux3^.Y));
        end
     else
     while aux1<>nil do
        begin
          aux2:=Paffixe(aux1^.suivant);
          if aux2<>nil then aux3:=Paffixe(aux2^.suivant) else aux3:=nil;
          if IsJump(aux2) then aux4:=aux3
                else
          if aux3<>nil then aux4:=Paffixe(aux3^.suivant) else aux4:=nil;
          if aux4<> nil then
             if IsJump(aux2) then
              p.lineto(XentierF(aux4^.x),YentierF(aux4^.y))
              else
              p.bezierCurveTo(
                 XentierF(aux2^.x),YentierF(aux2^.y),
                 XentierF(aux3^.x),YentierF(aux3^.y),
                 XentierF(aux4^.x),YentierF(aux4^.y));
          aux1:=aux4;
        end;
     first := False
end;
{===================}
procedure t_bezier.dessiner;
var first:boolean;
    p:TBGRAPAth;
begin
    if donnees=Nil then exit;
    first:=true; p:= TBGRAPath.Create(); toPAth(first,p);
    Canvas2dDrawPath(self,p)
end;
{$endif}
{======================================= Pstricks ==============================}
procedure T_Bezier.DoExportPst;
var a,b,c,d:Paffixe;
    first:boolean;
begin
     //if (arbre=nil) or (donnees=nil) then exit;
     if control3 then begin T_parametree.DoExportPst; exit end;
     a:=donnees; first:=true;
     if (not InPath) and (compteur>1) then exportwriteln('\pscustom{%');
     while a<>nil do
     begin
        b:=Paffixe(a^.suivant);
        if b<>nil then c:=Paffixe(b^.suivant) else c:=nil;
        if IsJump(b) then d:=c
                else
        if c<>nil then d:=Paffixe(c^.suivant) else d:=nil;
        if d<>nil then
          begin
                if IsJump(b) then exportwrite('\psline') else exportwrite('\psbezier');
                if fleche=1 then
                   if d^.suivant=nil then exportwrite('{->}') else
                            else
                if fleche=2 then
                   if (a^.precedent=nil)
                        then
                        if  (d^.suivant=nil) then exportwrite('{<->}')
                                              else exportwrite('{<-}')
                        else
                        if  (d^.suivant=nil) then exportwrite('{->}');
                if first and ((not InPath) or FirstInPath) then
                     exportwrite('('+Streel(Xtex(a^.x))+','+streel(Ytex(a^.y))+')');
                first:=false;
                if not IsJump(b) then
                 exportwrite('('+Streel(Xtex(b^.x))+','+streel(Ytex(b^.y))+')('+
                           Streel(Xtex(c^.x))+','+streel(Ytex(c^.y))+')');
                 exportwriteln('('+Streel(Xtex(d^.x))+','+streel(Ytex(d^.y))+')%');
          end;
        a:=d
     end;
     if (not InPath) and (compteur>1) then exportwriteln('}%');
end;
{======================================= EPS ==================================}
procedure T_Bezier.DoExportEps;
var aux1,aux2,aux3,aux4:Paffixe;
    FillColor:integer;
    StrFill, StrStroke:string;

begin
     if control3 then begin T_parametree.DoExportEps; exit end;
     
     aux1:=Paffixe(donnees);
     if aux1=nil then exit;
     fillColor:=fill_Color;
     if evenoddfill then StrFill:='eofill ' else StrFill:='fill '; StrStroke:='s ';
     //gestion de la transparence remplissage solide
     if (Fill_style=1) and (fill_opacity<1) then
                        StrFill:=Streel(fill_opacity)+' .setopacityalpha '+Strfill;
     //gestion du stroke en cas de transparence ou non
     if (ligne_style=-1) //pas de ligne
        then
            if ((Fill_style=1) or (fill_style=8)) and (fill_opacity<>1)
               then StrStroke:='1 .setopacityalpha s ' //il faut restaurer la non transparence
               else
        else //ligne
            if (stroke_opacity<1) then
                        StrStroke:=Streel(stroke_opacity)+' .setopacityalpha s 1 .setopacityalpha ';
     if (not InPath) and (fill_style=8) then
     begin
        if  (ligne_style<>-1) then exportwriteln('Chem '+StrStroke);
        exit;
     end;
     if (not InPath) or FirstInPath then
     exportwriteln(Streel((XEps(aux1^.x)))+' '+streel((YEps(aux1^.y)))+' m ');

     while aux1<>nil do
        begin
          aux2:=Paffixe(aux1^.suivant);
          if aux2<>nil then aux3:=Paffixe(aux2^.suivant) else aux3:=nil;
          if IsJump(aux2) then aux4:=aux3
                else
          if aux3<>nil then aux4:=Paffixe(aux3^.suivant) else aux4:=nil;
          if aux4<> nil then
               if IsJump(aux2) then
                exportwriteln(Streel((XEps(aux4^.x)))+' '+streel((YEps(aux4^.y)))+' lineto')
                else
               exportwriteln(Streel((XEps(aux2^.x)))+' '+streel((YEps(aux2^.y)))+' '+
                 Streel((XEps(aux3^.x)))+' '+streel((YEps(aux3^.y)))+' '+
                 Streel((XEps(aux4^.x)))+' '+streel((YEps(aux4^.y)))+' curveto');
          aux1:=aux4;
        end;
        if InPath  then exit;
        if (ligne_style<>-1)
                      then
                           if fill_style=1
                              then exportwriteln( 'gs '+StrColor(fillColor,eps)+StrFill+'gr '+StrStroke)
                              else exportwriteln( StrStroke)

                      else if fill_style=1
                              then exportwriteln( StrColor(fillColor,eps)+StrFill+StrStroke+
                                                 StrColor(couleur_courante,eps));
end;
{=========================================== Pgf ===============================}
procedure T_Bezier.DoExportPgf;
var aux1,aux2,aux3,aux4:Paffixe;
begin
     if control3 then begin T_parametree.DoExportPgf; exit end;
     aux1:=Paffixe(donnees);
     if aux1=nil then exit;
     if (not InPath) or FirstInPath then
        exportwriteln('\pgfpathmoveto{\pgfxy('+Streel(Xtex(aux1^.x))+','+streel(Ytex(aux1^.y))+')}%');
     while aux1<>nil do
        begin
          aux2:=Paffixe(aux1^.suivant);
          if aux2<>nil then aux3:=Paffixe(aux2^.suivant) else aux3:=nil;
          if IsJump(aux2) then aux4:=aux3
                else
          if aux3<>nil then aux4:=Paffixe(aux3^.suivant) else aux4:=nil;
          if aux4<> nil then
             if IsJump(aux2) then
              exportwriteln('\pgfpathlineto{\pgfxy('+Streel(Xtex(aux4^.x))+','+streel(Ytex(aux4^.y))+')}%')
              else
              exportwriteln('\pgfpathcurveto{\pgfxy('+
                 Streel(Xtex(aux2^.x))+','+streel(Ytex(aux2^.y))+')}{\pgfxy('+
                 Streel(Xtex(aux3^.x))+','+streel(Ytex(aux3^.y))+')}{\pgfxy('+
                 Streel(Xtex(aux4^.x))+','+streel(Ytex(aux4^.y))+')}%');
          aux1:=aux4;
        end;
       if not InPath then pgffillstroke;
end;
{================================================= Svg =========================}
procedure T_Bezier.DoExportSvg;
var aux1,aux2,aux3,aux4:Paffixe;
begin
     //if (arbre=nil) or (donnees=nil) then exit;
     aux1:=Paffixe(donnees);
     if clippee then ClipExport(svg);
     if not inPath then  exportwrite( '<path d="M');
     if (not InPath) or FirstInPath then exportwrite( Streel(Xsvg(aux1^.X))+','+Streel(Ysvg(aux1^.Y)));
     if control3 then
        begin
              aux2:=Paffixe(aux1^.suivant);
              aux3:=Paffixe(aux2^.suivant);
              exportwrite( ' Q'+Streel(Xsvg(aux2^.X))+','+Streel(Ysvg(aux2^.Y))+' '+
                Streel(Xsvg(aux3^.X))+','+Streel(Ysvg(aux3^.Y)));
        end
     else
     while aux1<>nil do
        begin
          aux2:=Paffixe(aux1^.suivant);
          if aux2<>nil then aux3:=Paffixe(aux2^.suivant) else aux3:=nil;
          if IsJump(aux2) then aux4:=aux3
                else
          if aux3<>nil then aux4:=Paffixe(aux3^.suivant) else aux4:=nil;
          if aux4<> nil then
             if IsJump(aux2) then
              exportwrite(' L'+Streel(Xsvg(aux4^.x))+','+streel(Ysvg(aux4^.y)))
              else
              exportwrite(' C'+
                 Streel(Xsvg(aux2^.x))+','+streel(Ysvg(aux2^.y))+' '+
                 Streel(Xsvg(aux3^.x))+','+streel(Ysvg(aux3^.y))+' '+
                 Streel(Xsvg(aux4^.x))+','+streel(Ysvg(aux4^.y)));
          aux1:=aux4;
        end;
     if InPath then exit;
     exportwrite('"');
     if fill_style=1 then exportwrite( ' fill="'+StrColor(fill_Color,svg)+'"');
     if clippee then  exportwrite( ' clip-path="url(#'+SvgClipName+')"');
     exportwriteln( '/>');

end;
{============================================== teg ============================}
function t_bezier.parametres_teg:string;
begin
        parametres_teg:=t_ligne.parametres_teg
end;
{========================}
procedure t_bezier.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     //exportwriteln( {'Graph '+nom+'=}#9+'Bezier('+FormatString(LigneCommande,70)+'),');
     exportwriteln('Bezier('+FormatString(LigneCommande,70)+');');
end;
{============================}
function splineCubique(Points,v1,v2:Paffixe):Paffixe;
type Treel=array[1..2] of real;
     Preel=^Treel;
     TlisteComplex=array[1..2] of Paffixe;
var  d1,d2,d3,res1,res2,res3:Paffixe;
     n,k:word;
     a,b,c:Preel;
     d:^TlisteComplex;
     liste:type_liste;
     u:real;

begin
     splineCubique:=nil;
     n:=0;
     d1:=Points;
     while d1<>nil do
           begin
            inc(n);d1:=Paffixe(d1^.suivant)
           end;
     if n<=1 then begin exit;end;
     CalcError:=false;
     liste.init;
     n:=2*n-2;
     getmem(a,(n-1)*Sizeof(real));
     getmem(c,(n-1)*Sizeof(real));
     getmem(b,n*Sizeof(real));
     getmem(d,n*Sizeof(Paffixe));
     b^[1]:=1;if v1=nil then b^[n]:=0 else b^[n]:=1;
     for k:=1 to ((n-2) div 2) do begin b^[2*k]:=3;b^[2*k+1]:=2 end;
     if v2=nil then c^[1]:=3 else c^[1]:=2;
     for k:=1 to ((n-2) div 2) do begin c^[2*k]:=1;c^[2*k+1]:=5 end;
     a^[n-1]:=1;
     for k:=1 to ((n-2) div 2) do begin a^[2*k-1]:=5;a^[2*k]:=1 end;
     d1:=Paffixe(Points);
     d2:=Paffixe(d1^.suivant);
     d3:=Paffixe(d2^.suivant);
     k:=n-1;
     if v1=nil then d^[n]:=new(Paffixe,init(0,0)) else
        begin
             res1:=soustraireC(d2,d1);
             res2:=soustraireC(res1,v1);
             if res2<>nil then d^[n]:=res2 else begin CalcError:=true; d^[n]:=new(Paffixe,init(0,0)) end;
             Kill(Pcellule(res1));
        end;
     while d3<>nil do
     begin
          res1:=soustraireC(d3,d2);
          res2:=soustraireC(d2,d1);
          res3:=soustraireC(res1,res2);
          Kill(Pcellule(res1));Kill(Pcellule(res2));
          if res3<>nil then
          begin
          d^[k]:=res3^.evalNum;
          res3^.x:=multiplier(res3^.x,3);
          res3^.y:=multiplier(res3^.y,3);
          d^[k-1]:=res3;
          end
          else
          begin CalcError:=true;
          d^[k]:=new(Paffixe,init(0,0));
          d^[k-1]:=new(Paffixe,init(0,0));
          end;
          dec(k,2);
          d1:=d2;d2:=d3;d3:=Paffixe(d3^.suivant)
     end;
     if v2=nil then d^[1]:=new(Paffixe,init(0,0)) else
        begin
             res1:=soustraireC(d2,d1);
             res2:=soustraireC(v2,res1);
             if res2<>nil then d^[1]:=res2 else begin CalcError:=true; d^[1]:=new(Paffixe,init(0,0)) end;
             Kill(Pcellule(res1));
        end;
     for k:=1 to n-1 do
         begin
              u:=diviser(a^[k],b^[k]);
              b^[k+1]:=soustraire(b^[k+1],multiplier(u,c^[k]));
              d^[k+1]^.x:=soustraire(d^[k+1]^.x,multiplier(u,d^[k]^.x));
              d^[k+1]^.y:=soustraire(d^[k+1]^.y,multiplier(u,d^[k]^.y));
         end;
     
     d^[n]^.x:=diviser(d^[n]^.x,b^[n]);
     d^[n]^.y:=diviser(d^[n]^.y,b^[n]);
     for k:=(n-1) downto 1 do
      begin
      d^[k]^.x:=diviser(soustraire(d^[k]^.x,multiplier(c^[k],d^[k+1]^.x)),b^[k]);
      d^[k]^.y:=diviser(soustraire(d^[k]^.y,multiplier(c^[k],d^[k+1]^.y)),b^[k]);
      end;
     freemem(a,(n-1)*Sizeof(real));
     freemem(c,(n-1)*Sizeof(real));
     freemem(b,n*Sizeof(real));
     if CalcError then begin for k:=1 to n do Kill(Pcellule(d^[k])) end
               else for k:=n downto 1 do liste.ajouter_fin(d^[k]);
     freemem(d,n*Sizeof(Paffixe));
     SplineCubique:=Paffixe(liste.tete)
end;
{==========================================Type t_spline ==================}
constructor t_spline.init(const UnNom, UneCommande:string);
begin
     t_parametree.init(UnNom,UneCommande,5,0);
     cat:=cat_spline;
end;
{=======================}
procedure t_spline.recalculer;
var h:real;
    i,PointsParSeg:integer;
    r1,v1,v2,res,a,b,A1,A2,C1,C2,u:Paffixe;
    points,liste:type_liste;
    t0:real;
begin
     liste_points^.detruire;
     noClipList.detruire;
     X_min:=Xmin; X_max:=Xmax;
     Y_min:=Ymin; Y_max:=Ymax;
     Kill(Pcellule(donnees));
     compteur:=0;
     if DefCommande then
        begin
             ConstruitArbre(nil);
             if arbre=nil then exit;
        end
        else if arbre=nil then exit;
     r1:=arbre^.evalNum;
     if r1=nil then begin exit end;
     if (r1^.suivant=nil) or (r1^.suivant^.suivant=nil) then begin Kill(Pcellule(r1));exit end;
     v1:=r1;i:=0;
     liste.init;
     v2:=Paffixe(v1^.suivant);
     while v2^.suivant<>nil do
           begin
                liste.ajouter_fin(new(Paffixe,init(v2^.x,v2^.y)));inc(i);
                v2:=Paffixe(v2^.suivant);
           end;
     if i<=1 then begin
             Kill(Pcellule(r1));
             liste.detruire;
             exit;
        end;
     PointsParSeg:=2+(nb_points div (i-1));
     if (v1^.x=0) and (v1^.y=0) then v1:=nil;
     if (v2^.x=0) and (v2^.y=0) then v2:=nil;
     res:=SplineCubique(Paffixe(liste.tete),v1,v2);
     if res=nil then
        begin
             Kill(Pcellule(r1));
             liste.detruire;
             exit;
        end;
     a:=res;
     b:=Paffixe(a^.suivant);
     h:=1/(pointsParSeg-1);
     A1:=Paffixe(liste.tete);
     A2:=Paffixe(A1^.suivant);
     points.init;
     while A2<>nil do
     begin
          t0:=0;
          u:=soustraireC(A2,ajouterC(A1,ajouterC(b,a)));
          if u<>nil then
          for i:=1 to PointsParSeg do
           begin
            liste_points^.ajouter_fin(new(Paffixe,init(A1^.x+t0*(u^.x+t0*(b^.x+t0*a^.x)),A1^.y+t0*(u^.y+t0*(b^.y+t0*a^.y)))));
            t0 += h;
           end;
          points.ajouter_fin(new(Paffixe,init(A1^.x, A1^.y)));
          C1:=ajouterC(kfoisC(1/3,u),A1);
          C2:=ajouterC(kfoisC(1/3,b),soustraireC(kfoisC(2,C1),A1));
          points.ajouter_fin(C1);//new(Paffixe,init(C1^.x, C1^.y)));
          points.ajouter_fin(C2);//(new(Paffixe,init(C2^.x, C2^.y)));
          Inc(compteur);
          a:=Paffixe(b^.suivant);
          if a<>nil then begin b:=Paffixe(a^.suivant); end;
          A1:=A2;A2:=Paffixe(A2^.suivant);
          Kill(Pcellule(u));
     end;
     points.ajouter_fin(new(Paffixe,init(A1^.x, A1^.y)));
     if transform then //on transforme les points de controle
        begin
             A1:=Paffixe(liste_points^.tete);
             liste_points^.tete:=points.tete;
             transformate;
             points.init; points.ajouter_fin(liste_points^.tete);
             liste_points^.init;
             liste_points^.ajouter_fin(A1);
        end;
     donnees:=Paffixe(points.tete); points.init;
     if transform then transformate; //on transforme les points de la courbe
     clipper;
     if fleche>0 then calcul_fleches;
     Kill(Pcellule(r1));Kill(Pcellule(res));//Kill(Pcellule(C1)); Kill(Pcellule(C2));
     liste.detruire;
end;
{===============================================================}
function t_spline.parametres_teg:string;
begin
        parametres_teg:=t_ligne.parametres_teg
end;
{========================}
procedure t_spline.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     exportwriteln('Spline('+FormatString(LigneCommande,70)+');');
end;
{=========================================T_myexport =========}
constructor T_myexport.init(const UnNom, UneCommande, AUserName: string; arg:Pliste);
begin
     UserName:=AUserName; argu:=arg; exportation:=nil;
     T_utilisateur.init(UnNom,UneCommande,0);
     cat:=cat_myExport;
end;
{=========================}
procedure T_myexport.ConstruitArbre;
var m:pmacros;
    p:pexpression;
begin
     DefCommande:=false;
     if arbre<>nil then dispose(arbre,detruire);
     if exportation<>nil then dispose(exportation);
     m:=macros('Draw'+username);
     if m=Nil then exit;
     new(p,init);
     p^.corps:=new(Pcorps,init(cat_macro,new(PPmac,init('Draw'+username, m))));
     //p^.varloc:=LesVarLoc;
     p^.corps^.arguments:=argu;
     arbre:=p^.dupliquer;
     arbre^.corps^.arguments^.supprimer_element(1);
     dispose(p^.corps); dispose(p);
     m:=macros('Export'+username);
     if m<>nil then
     begin
          new(exportation,init);
          exportation^.corps:=new(Pcorps,init(cat_macro,new(PPmac,init('Export'+username, m))));
          exportation^.varloc:=arbre^.VarLoc;
          exportation^.corps^.arguments:=arbre^.corps^.arguments;
      end
     else exportation:=Nil;
end;
{========================================== Exporter ===========================}
procedure T_myexport.Exporter(mode:byte);
var res:Paffixe;
    ok:boolean;
begin   if (mode<>teg) and (mode<>src4Latex)
           then
                begin
                if (exportation=nil) then ok:=false
                   else
                   begin
                        SaveAttr;
                        LireAttributs;
                        res:=exportation^.evalNum;
                        ok:= (res=Nil) Or (res^.x<>0); Kill(Pcellule(res));
                        RestoreAttr;
                   end;
                end else  ok:=false;
        if not ok then T_element.Exporter(mode);
end;
{=========================}
destructor T_myexport.detruire;
begin
     if arbre<>Nil then begin dispose(arbre,detruire); arbre:=nil end;
     if exportation<>Nil then dispose(exportation);//,detruire);
     T_utilisateur.detruire
end;

{=========================================T_utilisateur =======================}
constructor T_utilisateur.init(const UnNom, UneCommande:string; Acode:integer);
begin
     enfants:=nil; //DefAttr(attributsfin);
     t_parametree.init(UnNom,UneCommande,0,0);
     cat:=cat_utilisateur;
     if Acode<>-1 then id:=Acode;
end;
{==================================}
procedure t_utilisateur.fixeAttributs;
begin
     t_parametree.fixeAttributs;
     dot_style:=DotStyle;
     dot_angle:=dotangle;
     style_label:=LabelStyle;
     size_label:=LabelSize;
     angle_label:=LabelAngle;
     formule:=TeXLabel;
     dot_scaleX:=DotScale^.x;
     if DotScale^.y=0 then dot_scaleY:=dot_scaleX
                      else dot_scaleY:=DotScale^.y;
      dot_size1:=Dotsize^.x;
      dot_size2:=Dotsize^.y;
end;
{===================================}
procedure t_utilisateur.lireAttributs;
begin
      DotStyle:=dot_style;
      dotangle:=dot_angle;
      LabelStyle:=style_label;
      LabelSize:=size_label;
      LabelAngle:=angle_label;
      TeXLabel:=formule;
      Kill(Pcellule(Dotscale));
      DotScale:=New(Paffixe,init(dot_scaleX,dot_scaleY));
      Kill(Pcellule(DotSize));
      DotSize:=New(Paffixe,init(dot_size1,dot_size2));
      t_parametree.lireAttributs;
end;
{=========================}
procedure t_utilisateur.ConstruitArbre;
begin
     t_element.ConstruitArbre(UnArbre);
end;
{===================================}
procedure T_utilisateur.recalculer;
var res:Presult;//Paffixe;
    oldPenMode:longint;
    oldliste:Pliste;
    oldcontexte,oldsetattr:boolean;
    oldmatrix:Tmatrix;
begin
      if enfants<>nil then dispose(enfants,detruire);
      X_min:=Xmin; X_max:=Xmax;
      Y_min:=Ymin; Y_max:=Ymax;
      if DefCommande then
        begin
             ConstruitArbre(nil);
             if arbre=nil then exit;
        end
        else if arbre=nil then exit;
{$IFDEF GUI}
      if PPenMode^.affixe<>nil then
      PenMode:=round(PPenMode^.affixe^.getx) mod 2 else PenMode:=0;
      oldPenMode:=PenMode;
      PenMode:=byte(pen_mode=PenMode1);
{$ENDIF}
      lireAttributs;
      oldcontexte:=ContexteUtilisateur;
      ContexteUtilisateur:=true;
      oldmatrix:=Currentmatrix;
      Currentmatrix:=matrix;
      oldsetattr:=SetAttr;
      liste_points^.detruire;
      liste_points^.init;
      oldliste:=liste_enfant;
      New(liste_enfant,init);
      res:=arbre^.evaluer;
      enfants:=liste_enfant;
      liste_enfant:=oldliste;
      if SetAttr then    // appel à SetAttr() ?
         begin          // si oui on règle les attributs
           restoreAttr; // de l'élément aux valeurs sauvegardées
           fixeAttributs // lors de l'appel à SetAttr()
         end else lireAttributs;
{$IFDEF GUI}
      PenMode:=oldPenMode;
      PPenMode^.affixe^.setx(PenMode);
{$ENDIF}
      ContexteUtilisateur:=oldcontexte;
      Currentmatrix:=oldmatrix;
      SetAttr:=oldsetattr;
      if res<>nil then Kill(Pcellule(res));
end;
{==============================}
{$IFDEF GUI}
procedure T_utilisateur.dessiner;
var aux:type_liste;
begin
     if enfants=nil then exit;
     aux.tete:=liste_element.tete;
     aux.queue:=liste_element.queue;
     liste_element.tete:=enfants.tete;
     liste_element.queue:=enfants.queue;
     draw_elements;
     liste_element.tete:=aux.tete;
     liste_element.queue:=aux.queue;
end;
{$ENDIF}
{============================================ LaTeX ===========================}
procedure T_utilisateur.enregistrer_latex;
begin
       if enfants=nil then exit;
       T_element.enregistrer_latex;
end;
{====================}
procedure T_utilisateur.DoExportLatex;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(latex) else aux^.enregistrer_latex;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
{========================================= Pstricks ===========================}
function t_utilisateur.parametres_pst;
begin
     parametres_pst:='';
end;
{=========================}
procedure T_utilisateur.enregistrer_pst;
begin
       if enfants=nil then exit;
       T_element.enregistrer_pst;
end;
{====================}
procedure T_utilisateur.DoExportPst;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(pstricks) else aux^.enregistrer_pst;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
 {==================================== userExport ====================================}
procedure T_utilisateur.enregistrer_userExport;
var aux:Pelement;
begin
     aux:=Pelement(enfants.tete);
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then aux^.exporter(userExport);
                aux:=Pelement(aux^.suivant)
           end;
end;
 {==================================== EPS ====================================}
procedure T_utilisateur.enregistrer_Eps;
begin
        if enfants=nil then exit;
        t_element.BeginExportEps;
        DoExportEps;
end;
{=================}
procedure T_utilisateur.DoExportEps;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(eps) else aux^.enregistrer_eps;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
{======================================= Pgf ==================================}
procedure T_utilisateur.enregistrer_Pgf;
begin
        if enfants=nil then exit;
        t_element.BeginExportPgf;
        DoExportPgf
end;
{=================}
procedure T_utilisateur.DoExportPgf;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(pgf) else aux^.enregistrer_pgf;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
{========================================= Svg ================================}
procedure T_utilisateur.enregistrer_Svg;
begin
        if enfants=nil then exit;
        t_element.BeginExportSvg;
        DoExportSvg
end;
{=================}
procedure T_utilisateur.DoExportSvg;
var aux:Pelement;
    comment:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     while aux<>nil do
           begin
                if aux^.cat=cat_myExport then
                   aux^.exporter(svg) else aux^.enregistrer_svg;
                aux:=Pelement(aux^.suivant)
           end;
     inclure_commentaires:=comment;
end;
 {============================================== teg ==========================}
function t_utilisateur.parametres_teg:string;
var chaine:string;
    res:Paffixe;
begin
     chaine:=t_parametree.parametres_teg;
     if dot_style<>DotStyle then
         begin DotStyle:=dot_style; chaine:=chaine+',DotStyle:='+Streel(dot_style);end;
     if dot_angle<>DotAngle then
         begin DotAngle:=dot_angle; chaine:=chaine+',DotAngle:='+Streel(dot_angle);end;
     if (dot_scaleX<>DotScale^.x) or  (dot_scaleY<>DotScale^.Y) then
         begin res:=New(Paffixe,init(dot_scaleX,dot_scaleY));
               Kill(Pcellule(DotScale));
               DotScale:=res; chaine:=chaine+',DotScale:='+res^.en_chaine;
         end;
     if (dot_size1<>DotSize^.x) or  (dot_size2<>DotSize^.Y) then
         begin res:=New(Paffixe,init(dot_size1,dot_size2));
               Kill(Pcellule(DotSize));
               DotSize:=res; chaine:=chaine+',DotSize:='+res^.en_chaine;
         end;
     if style_label<>LabelStyle then
         begin LabelStyle:=style_label; chaine:=chaine+',LabelStyle:='+Streel(style_label);end;
     if size_label<>LabelSize then
         begin LabelSize:=size_label; chaine:=chaine+',LabelSize:='+Streel(size_label);end;
     if angle_label<>LabelAngle then
         begin LabelAngle:=angle_label; chaine:=chaine+',LabelAngle:='+Streel(angle_label);end;
     if TeXLabel<>formule then
         begin TeXLabel:=formule; chaine:=chaine+',TeXLabel:='+Streel(byte(formule));end;
     parametres_teg:=chaine
end;
{=========================}
procedure t_utilisateur.enregistrer_src4latex;
var aux:string;
begin
     t_element.enregistrer_src4latex;
     if Lignecommande='' then aux:='Nil' else aux:=TabuleString(LigneCommande);
     exportwriteln(aux+';');
end;
{=========================}
destructor T_utilisateur.detruire;
begin
     if enfants<>nil then dispose(enfants,detruire);
     //CleanAttr(attributsfin);
     T_parametree.detruire
end;

{===============================================================================}
constructor t_cartesienne.init(const UnNom, UneCommande:string;diviser,discont:byte);
begin
        t_parametree.init( UnNom, UneCommande,diviser,discont);
        cat:=cat_cartesienne
end;
{================}
procedure t_cartesienne.ConstruitArbre(Unarbre:Pcorps);
var aux:PConstante;
begin
     if Unarbre<>nil
        then
            begin
             new(arbre,init);
             DefCommande:=false;
             arbre^.VarLoc:=LesVarLoc;
             arbre^.corps:=Unarbre;
        end
        else
            begin
                 if arbre<>nil then dispose(arbre,detruire);
                 new(arbre,init);
                 aux:= new(Pconstante,init('x',nil,true));
                 arbre^.varloc^.ajouter_fin(aux);
                 if not arbre^.definir('x+i*('+LigneCommande+')')
                    then begin dispose(arbre,detruire); arbre:=nil end
                    else aux^.nom:='t';
                 DefCommande:=true;
            end;
end;
{========================}
procedure t_cartesienne.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     exportwrite('Cartesienne('+FormatString(LigneCommande,70));
     if division<>0 then
         begin
              exportwrite(','+IntToStr(division));
              if saut<>0 then exportwrite(','+IntToStr(saut));
         end;
     exportwriteln(');');
end;
{===============================================================================}
constructor t_polaire.init(const UnNom, UneCommande:string;diviser,discont:byte);
begin
        t_parametree.init( UnNom, UneCommande,diviser,discont);
        cat:=cat_polaire
end;
{================}
procedure t_polaire.ConstruitArbre(Unarbre:Pcorps);
var aux:PConstante;
begin
     if Unarbre<>nil
        then
            begin
             new(arbre,init);
             DefCommande:=false;
             arbre^.VarLoc:=LesVarLoc;
             arbre^.corps:=Unarbre;
        end
        else
            begin
                 if arbre<>nil then dispose(arbre,detruire);
                 new(arbre,init);
                 aux:= new(Pconstante,init('t',nil,true));
                 arbre^.varloc^.ajouter_fin(aux);
                 if not arbre^.definir('('+LigneCommande+')*exp(i*t)')
                    then begin dispose(arbre,detruire); arbre:=nil end;
                 DefCommande:=true;
            end;
end;
{========================}
procedure t_polaire.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     exportwrite('Polaire('+FormatString(LigneCommande,70));
     if division<>0 then
         begin
              exportwrite(','+IntToStr(division));
              if saut<>0 then exportwrite(','+IntToStr(saut));
         end;
     exportwriteln(');');
end;
{================================ t_Path =====================================}
 constructor T_path.init(const UnNom, UneCommande:string;Closed:byte);
 begin
        enfants.init;
        closelastpath:=(closed=1);
        t_ligne.init(UnNom, UneCommande, 0,0);
        cat:=cat_path;
 end;
{=============}
procedure T_path.recalculer;
var aux:Pelement;
    FXY:Pexpression;
    oldcontext, oldClipping:boolean;
    aux1:PLigne;
    oldliste:Pliste;
    oldmatrix:Tmatrix;
    aux2:Paffixe;
    oldPenMode:longint;
begin
     liste_points^.detruire;
     noClipList.detruire;
     X_min:=Xmin; X_max:=Xmax;
     Y_min:=Ymin; Y_max:=Ymax;
     Kill(Pcellule(donnees));
     liste_points^.init;
     enfants.detruire;

     if DefCommande then
        begin
             ConstruitArbre(nil);
             if arbre=nil then exit;
        end
        else if arbre=nil then exit;

     liste_points^.ajouter_fin(arbre^.evaluer);
     if liste_points^.tete=nil then exit;
     if closelastpath then liste_points^.ajouter_fin(New(Paffixe,init(jump^.X, 10)));
     donnees:=Paffixe(liste_points^.tete);
     liste_points^.init;
     new(FXY,init);
     FXY^.varloc^.ajouter_fin(new(Pconstante,init('chemin',donnees^.evaluer,true)));
{$IFDEF GUI}
     if PPenMode^.affixe<>nil then
      PenMode:=round(PPenMode^.affixe^.getx) mod 2 else PenMode:=0;
      oldPenMode:=PenMode;
      PenMode:=byte(pen_mode=PenMode1);
{$ENDIF}
     lireAttributs;
     SaveAttr;
     oldmatrix:=Currentmatrix;
     Currentmatrix:=matrix;
     oldcontext:=ContexteUtilisateur;
     ContexteUtilisateur:=true;
     oldClipping:=Clipping;
     Clipping:=false;
     oldliste:=liste_enfant;
     New(liste_enfant,init);
     if FXY^.definir('path(chemin)') then FXY^.evaluer;
     ContexteUtilisateur:=oldcontext;
     Clipping:=oldClipping;
     restoreAttr;
     Currentmatrix:=oldmatrix;
     dispose(FXY,detruire);
     enfants.tete:=liste_enfant.tete;
     enfants.queue:=liste_enfant.queue;
     liste_enfant:=oldliste;
{$IFDEF GUI}
     PenMode:=oldPenMode;
     PPenMode^.affixe^.setx(PenMode);
{$ENDIF}
     aux:=Pelement(enfants.tete);
     while aux<>nil do
         begin
               aux2:= Paffixe(Pelement(aux)^.Liste_points^.tete);
               if aux2<>nil then liste_points^.ajouter_fin(aux2^.evaluer);
               aux:=Pelement(aux^.suivant)
         end;
     if liste_points^.tete=nil then begin enfants.detruire;  exit end;
     aux1:=PLigne(enfants.tete);
     if (fleche in [2,3]) And (aux1<>nil) then aux1^.fleche:=3;  //fleche en tete
     aux1:=PLigne(enfants.queue);
     if (fleche in [2,1]) And (aux1<>nil) then aux1^.fleche:=1;  //fleche en fin
     clipper;
     if fleche>0 then calcul_fleches;
end;
{================================ Pstricks ==================================}
procedure T_path.DoExportPst;
var aux:Pelement;
    comment, oldPath:boolean;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     oldPath:=InPath;
     if not InPath then
        begin
             exportwriteln('\pscustom{%');
             InPath:=true;FirstInPath:=true;
        end;

     while aux<>nil do
           begin
                Pligne(aux)^.clippee:=false;
                aux^.DoExportPst;
                aux:=Pelement(aux^.suivant);
                FirstInPath:=false;
           end;
     InPath:=oldPath;
     inclure_commentaires:=comment;
     if InPath Or onlyData then exit;
     FirstInPath:=false;
     exportwriteln('}%'); //fin de pscustom
end;
{=============}
procedure T_path.DoExportEps;
var aux:Pelement;
    comment, oldPath, oldFirst :boolean;
    fillColor:integer;
    StrFill, StrStroke:string;
begin
     fillColor:=fill_Color;
     if evenoddfill then StrFill:='eofill ' else StrFill:='fill '; StrStroke:='s ';
     //gestion de la transparence remplissage solide
     if (Fill_style=1) and (fill_opacity<1) then
                        StrFill:=Streel(fill_opacity)+' .setopacityalpha '+Strfill;
     //gestion du stroke en cas de transparence ou non
     if (ligne_style=-1) //pas de ligne
        then
            if ((Fill_style=1) or (fill_style=8)) and (fill_opacity<>1)
               then StrStroke:='1 .setopacityalpha s ' //il faut restaurer la non transparence
               else
        else //ligne
            if (stroke_opacity<1) then
                        StrStroke:=Streel(stroke_opacity)+' .setopacityalpha s 1 .setopacityalpha ';
     if (not InPath) and (fill_style=8) then
     begin
       if  (ligne_style<>-1) then exportwriteln('Chem '+StrStroke);
       exit;
     end;
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     oldPath:=InPath; oldFirst:=FirstInPath;
     aux:=Pelement(enfants.tete);
     if not InPath then
        begin
             InPath:=true;FirstInPath:=true;
        end;
     while aux<>nil do
           begin
                Pligne(aux)^.clippee:=false;
                aux^.DoExportEps;
                aux:=Pelement(aux^.suivant);
                FirstInPath:=false;
           end;
     InPath:=oldPath;
     FirstInPath:=oldFirst;
     inclure_commentaires:=comment;
     if InPath Or onlyData then exit;
     //FirstInPath:=false;
     if (ligne_style<>-1)
                      then
                           if fill_style=1
                              then exportwriteln( 'gs '+StrColor(fillColor,eps)+StrFill+'gr '+StrStroke)
                              else exportwriteln( StrStroke)

                      else if fill_style=1
                              then exportwriteln( StrColor(fillColor,eps)+StrFill+StrStroke+
                                              StrColor(couleur_courante,eps));

end;
{=============}
procedure T_path.DoExportPgf;
var aux:Pelement;
    comment, oldPath:boolean;
    fillColor,oldfillcourant:integer;
begin
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     oldPath:=InPath;
     if not InPath then
        begin
             InPath:=true;FirstInPath:=true;
        end;
     while aux<>nil do
           begin
                Pligne(aux)^.clippee:=false;
                aux^.DoExportPgf;
                aux:=Pelement(aux^.suivant);
                FirstInPath:=false;
           end;
     InPath:=oldPath;
     inclure_commentaires:=comment;
     if InPath Or onlyData then exit;
     FirstInPath:=false;
     pgffillstroke;
end;
{$IFDEF GUI}
{=============}
procedure T_path.toPath(var first:boolean; var p: TBGRAPath);
var aux:Pelement;
begin
     aux:=Pelement(enfants.tete);
     if aux = Nil then exit;
     while aux <> Nil do
        begin
            Pelement(aux)^.toPath(first,p);
            aux := Pelement(aux^.suivant)
        end;
end;
{=============}
procedure T_path.dessiner;
var first:boolean;
    p:TBGRAPAth;
begin
     first:=true; p:= TBGRAPath.Create(); toPAth(first,p);
     Canvas2dDrawPath(self,p)
end;
{$ENDIF}
{=============}
procedure T_path.DoExportSvg;
var aux:Pelement;
    comment, oldPath:boolean;
    fillColor:integer;
begin
     fillColor:=fill_Color;
     if clippee and (not onlyData) then ClipExport(svg);
     aux:=Pelement(enfants.tete);
     comment:=inclure_commentaires;
     inclure_commentaires:=false;
     oldPath:=InPath;
     if not InPath then
        begin
             if onlyData then exportwrite('"M') else exportwrite('<path d="M');
             InPath:=true;FirstInPath:=true;
        end;
     while aux<>nil do
           begin
                Pligne(aux)^.clippee:=false;
                aux^.DoExportSvg;
                aux:=Pelement(aux^.suivant);
                FirstInPath:=false;
           end;
     InPath:=oldPath;
     inclure_commentaires:=comment;
     if InPath then exit;
     FirstInPath:=false;
     exportwrite('"');
     if onlyData then exit;
     if fill_style=1 then exportwrite( ' fill="'+StrColor(fill_Color,svg)+'"');
     if clippee then  exportwrite( ' clip-path="url(#'+SvgClipName+')"');
     exportwriteln( '/>');
end;
{=============}
destructor T_path.detruire;
begin
     enfants.detruire;
     T_Ligne.detruire
end;
{=========================}
procedure T_path.enregistrer_src4latex;
begin
     t_element.enregistrer_src4latex;
     exportwriteln('Path('+FormatString(LigneCommande,70)+');')
end;
{=========================}
function T_path.ExportData(mode:byte):string;
begin
     StrExport:='';
     onlyData:=true;
     case mode of
     latex:    DoExportLatex;
     pstricks: DoExportpst;
     pgf:      DoExportPgf;
     eps:      DoExportEps;
     svg:      DoExportSvg;
     end;
     onlyData:=false;
     ExportData:=StrExport
end;

{=========================}
Initialization
 LesCommandes.ajouter_fin(new(PDup,init('Dup')));
End.
