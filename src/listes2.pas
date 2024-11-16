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


UNIT listes2; {gestion des listes}
{$MODE Delphi}

INTERFACE
uses classes, StringHashList;

CONST
   MaxNom=35; {nombre maximal de caractères des identificateurs}

TYPE
  Tnom=string[MaxNom];              {type des identificateurs}

  PCellule= ^tcellule;
  tcellule= Object                            {ancêtre des éléments d'une liste }
             suivant, precedent: PCellule;

             Constructor init;
             Destructor detruire;virtual;
             end;

    
        PListe= ^type_liste;
    type_liste= Object
                tete, queue: PCellule;      {un pointeur de debut et un pointeur de fin}

                constructor init;
                procedure ajouter_fin(info: PCellule); virtual;      { on peut ajouter plusieurs cellules chainées}
                procedure ajouter_debut(info: PCellule); virtual;
                procedure supprimer(var p:PCellule);virtual;         { supprime une cellule }
                procedure retirer(var p:PCellule);virtual;         { retrait sans destruction }
                procedure inserer(info:PCellule;p:PCellule);virtual; { insère une cellule }
                procedure supprimer_element(numero:word);virtual;
                function chercher_element(numero:word):Pcellule;virtual;
                procedure deplacer(source,but:integer);virtual;         {déplace le cellule n°source à la place de la n°but}
                procedure inverser;virtual;                             //inverse l'ordre des cellules
                destructor detruire;virtual;
                end;

    PNoeud=^TNoeud;                 {ancêtre des constantes, fonctions, commandes, macros, éléments graphiques}
    TNoeud= object(TCellule)
            nom: Tnom;

            constructor init(const Aname: string);
            end;

    PHashList = ^THashList;                           // listes de Pnoeud avec hashage
    THashList = class(TStringHashList)
                constructor create;
                procedure ajouter_fin(elt: PNoeud);
                procedure supprimer(elt: PNoeud);
                destructor clear;
                end;


procedure Kill(var liste:PCellule);  {destruction sans récursivité }



IMPLEMENTATION
{============= TCellule ==========}
CONSTRUCTOR TCellule.init;
begin suivant:=nil;
      precedent:=nil;
end;


Destructor TCellule.detruire;
begin
end;
{=============== Type_Liste ============}
Constructor type_liste.init;
begin
     tete:=nil;
     queue:=nil;
end;
{=======================}
PROCEDURE type_liste.ajouter_fin;
begin
    if info=nil then exit;
     info^.precedent:=queue;
     if queue<>nil then  queue^.suivant:=info
                   else tete:=info;
     queue:=info;
     while queue^.suivant<>nil do queue:=queue^.suivant;
end;
{=======================}
PROCEDURE type_liste.ajouter_debut;
var aux:PCellule;
begin
    if info=nil then exit;
     info^.precedent:=nil;
     aux:=info;
     while aux^.suivant<>nil do aux:=aux^.suivant;
     aux^.suivant:=tete;
     if tete<>nil then tete^.precedent:=aux
               else queue:=aux;
     tete:=info;
end;
{=======================}
PROCEDURE type_liste.inserer;
var endInfo:Pcellule;
begin
     if info=nil then exit;
     if p=nil then ajouter_fin(info)
              else
     begin
       endinfo:=info;
       while endinfo^.suivant<>nil do endinfo:=endinfo^.suivant;
       if p=tete then begin
                         endinfo^.suivant:=tete;
                         info^.precedent:=nil;
                         tete^.precedent:=endinfo;
                         tete:=info
                      end
                 else begin
                         endinfo^.suivant:=p;
                         p^.precedent^.suivant:=info;
                         info^.precedent:=p^.precedent;
                         p^.precedent:=endinfo;
                      end;
     end
end;
{=======================}
PROCEDURE type_liste.retirer;
begin
      if p=nil then exit;
      if p=tete then begin
                           tete:=p^.suivant;
                           if tete=nil then queue:=nil
                                       else tete^.precedent:=nil;
                           end
                      else
      if p=queue then begin
                            queue:=p^.precedent;
                            if queue=nil then tete:=nil
                                         else queue^.suivant:=nil;
                            end
                       else begin
                            p^.precedent^.suivant:=p^.suivant;
                            p^.suivant^.precedent:=p^.precedent;
                            end;
     p^.precedent:=nil;
     p^.suivant:=nil;
end;
{=======================}
PROCEDURE type_liste.supprimer;
var aux:PCellule;
begin
      if p=nil then exit;
      if p=tete then begin
                           tete:=p^.suivant;
                           if tete=nil then queue:=nil
                                       else tete^.precedent:=nil;
                           aux:=tete;
                           end
                      else
      if p=queue then begin
                            queue:=p^.precedent;
                            if queue=nil then tete:=nil
                                         else queue^.suivant:=nil;
                            aux:=nil;
                            end
                       else begin
                            p^.precedent^.suivant:=p^.suivant;
                            p^.suivant^.precedent:=p^.precedent;
                            aux:=p^.suivant
                            end;

      dispose(p,detruire);
      p:=aux
end;
{=======================}
procedure type_liste.supprimer_element(numero:word);
var aux:PCellule;
    compt:word;    
begin
      compt:=1;
      aux:=tete;
      while (aux<>nil) and (compt<>numero) do
            begin inc(compt); aux:=aux^.suivant; end;
      if aux<>nil then begin supprimer(aux); end;
end;

{=======================}
function type_liste.chercher_element(numero:word):Pcellule;
var aux:PCellule;
    compt:word;
begin
      compt:=1;
      aux:=tete;
      while (aux<>nil) and (compt<>numero) do
            begin inc(compt); aux:=aux^.suivant; end;
      chercher_element:=aux;
end;
{=======================}
procedure type_liste.deplacer(source,but:integer);
var aux1,aux2,p:PCellule;
begin
     if (source=but) or (source<=0) or (but<=0) then exit;
      aux1:=chercher_element(source);
      if aux1=nil then exit;
      aux2:= chercher_element(but);
      p:=aux1;
      if p=tete then begin
                           tete:=p^.suivant;
                           if tete=nil then queue:=nil
                                       else tete^.precedent:=nil;
                           end
                      else
      if p=queue then begin
                            queue:=p^.precedent;
                            if queue=nil then tete:=nil
                                         else queue^.suivant:=nil;
                            end
                       else begin
                            p^.precedent^.suivant:=p^.suivant;
                            p^.suivant^.precedent:=p^.precedent;
                            end;
      aux1^.suivant:=nil;
      aux1^.precedent:=nil;
      If but<source then  inserer(aux1,aux2)
                    else  inserer(aux1,aux2^.suivant)
end;
{=======================}
procedure type_liste.inverser;
var aux1,aux:Pcellule;
begin
        if tete=nil then exit;
        aux1:=tete;
        while aux1<>nil do
                begin
                   aux:=aux1^.suivant;
                   aux1^.suivant:=aux1^.precedent;
                   aux1^.precedent:=aux;
                   aux1:=aux
                end;
        aux:=tete;
        tete:=queue;
        queue:=aux;
end;
{=======================}
destructor type_liste.detruire;
begin
     if tete<>nil then Kill(tete);
     queue:=nil
end;

procedure Kill(var liste:PCellule);
var aux:Pcellule;
begin
     while liste<>nil do
           begin
                aux:=liste^.suivant;
                dispose(liste,detruire);
                liste:=aux
           end;
end;
{======================= TNoeud ===========================}
 constructor TNoeud.init(const Aname: string);
 begin
      TCellule.init;
      nom:=Aname;
 end;
{================= THashList ===================}
constructor THashList.create;
begin
    inherited Create(true)
end;

procedure THashList.ajouter_fin(elt: PNoeud);
begin
    add(elt^.nom,elt)
end;

procedure THashList.supprimer(elt: PNoeud);
begin
     Remove(elt^.nom);
     dispose(elt,detruire)
end;

destructor THashList.clear;
var I: longint;
begin
     for I:=0 to Count -1 do
         Dispose(PNoeud(List[I]^.Data),detruire);
     inherited Clear
end;
BEGIN
END.
