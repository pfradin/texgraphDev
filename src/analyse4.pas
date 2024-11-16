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

unit analyse4; {analyseur syntaxique, convertit une chaine en arbre }

{$MODE Delphi}


INTERFACE
uses SysUtils, Classes, calculs1, listes2, complex3, untres, math;
const
         cat_parametre=0;     {catégories reconnues pour un noeud de l'arbre}
         cat_constante=1;
         cat_affixe=2;
         cat_operateur=3;
         cat_fonction=4;
         cat_commande=5;
         cat_macro=6;
         cat_string=7;
         sortieTabulee:boolean=false; //sortie tabulee pour inclusion LaTeX
         
         KeepVarLocName:boolean=false; //pour la fonction en_chaine, indique si on garde le nom des variables locales
                                       // ou si on le remplace par la valeur.
         ExitBloc:boolean=false;       {indique si un bloc (suite d'instructions) doit être interrompue}
         StopAll:boolean=false;       {indique si le recalcul golbal doit être interronpu}

         usermac=0; //définie par l'utlisateur
         tempmac=1;  //chargée par InputMac() et temporaire
         predefmac=2;  //chargée au démarrage

         MacroStatut:byte=0;     {0=ordinaire, 1=temporaire, 2=prédéfinie Une macro prédéfinie ne sera pas modifiable}
         Constpredefinie: boolean=false;   {Une constante prédéfinie ne sera pas modifiable}
         ChangeVarG: boolean=false;       {indique si une variable globale a été recalculée}

         set_nom:set of char=['a'..'z','A'..'Z','0'..'9','''','_'];   {caractères autorisés pour un identificateur}
         initial_car1:set of char=['a'..'z','A'..'Z'];                 {caractères autorisés pour l'initiale d'un identificateur}
         initial_car2:set of char=['a'..'z','A'..'Z','_']; {caractères autorisés pour l'initiale d'un identificateur chargé au démarrage}
         set_num:set of char=['0'..'9','.','E','-','+',#10,#13,#9];          {caractères autorisés pour une valeur numérique}
         
         Nargs:longint=0; {nombre de paramètres pour les macros}
         
         {parseur}
         Tnum=0; Tope=1; TPo=2; Tid=3; Tmess=4; Tparam=5; Tvarloc=6; Tmac=7; TmacString=12; Tpf=8; Tsep=9; //virgule
         Trubrique=10; Tend=11; //pour le mode Inline (LaTeX)
      
type Ttoken= packed Record
             code:integer;
             contenu:string;
             val:real;
             index,lg:longint;
             end;
     Ptoken=^Ttoken;

         Pcorps=^Tcorps;                   { pointeur sur Tcorps qui est le type de l'arbre construit }
         Pmacros= ^Tmacros;                  {définition du type macro}

         PString=^Tstring;                 { chaine de caractères }
         Tstring= object(TCellule)
                  chaine:string;

                  constructor init(const UneChaine:string);
                  destructor detruire;virtual;
                  end;
         
         Pparametre= ^Tparametre;         {paramètres pour les macros}
         Tparametre= object(TCellule)
                     num:word;
                     
                     constructor init(UnNum:byte);
                     end;

         Pconstante= ^Tconstante;         {constante ou variable, predéfinie ou non, locale ou globale}
         Tconstante= object(TNoeud)
                     affixe: Presult;
                     predefinie:boolean;
                     locale:boolean;

                     constructor init(const Aname:string;UneValeur:Presult;loc:boolean);
                     destructor detruire;virtual;
                 end;

          PPMac=^TPmac;
          TPmac= object(TNoeud)
                 mac:Pmacros;
                 constructor init(const Aname:string; Amac: Pmacros);
                 end;

          PVarGlob=^TVarGlob;                 {Une variable globale= une constante + une definition (ou commande), il faut conserver l'ordre}
          TVarGlob= object(TCellule)
                    variable:Pconstante;
                    statut:byte;              {0=ordinaire, 1=variables chargées dans mac (menu) 2=variables chargées au démarrage}
                    commande:string;

                    constructor init(const UnNom,UneCommande:string);
                    procedure recalculer;virtual;
                    destructor detruire;virtual;
                    end;

         Pfonction=^Tfonction;           {fonction mathématique d'une variable complexe, l'argument est évalué avant l'appel}
         Tfonction= object(TNoeud)

                     function evaluer(arg:Paffixe):Paffixe;virtual;
                     //function StrEval(arg:Paffixe):String;virtual;
                     function deriver(arg:Pliste;variable:string):Pcorps;virtual;
                     end;

         PCommande=^TCommande;         {fonction d'une ou plusieurs variables, c'est elle qui évalue (ou non) ses arguments}
         TCommande= object(TNoeud)

                     function executer(arg:PListe):Presult;virtual;
                     //function StrEval(arg:Pliste):String;virtual;
                     function deriver(arg:Pliste;variable:string):Pcorps;virtual;
                     end;


         Poperation= ^Toperation;         {type opérateur, les arguments sont évalués avant l'appel}
         Toperation= object(TNoeud)
                     priorite:integer;

                     constructor init(const Aname:string;prior:integer);
                     function evaluer(arg1,arg2:Paffixe):Paffixe;virtual;
                     //function StrEval(arg1,arg2:Paffixe):String;virtual;
                     function simplifier(arg:Pliste):Pcorps;virtual;
                     function deriver(arg:Pliste;const variable:string):Pcorps;virtual;
                     end;

         Tcorps= Object(TCellule)          {noeud de l'arbre}
                  categorie:integer;
                  contenu:pointer;
                  arguments: Pliste;

                  constructor init(Acat:integer; Acontenu:pointer);
                  procedure ajouter_arg(arg:pointer);virtual;
                  procedure substituer(const variable,par:string);virtual;             {remplace une variable par une autre}
                  procedure subsParam(parametre:word;par:Pcorps);virtual;       {remplace un paramètre par un arbre}
                  procedure composer(const variable:string; par:Pcorps); virtual;      {remplace une variable par un arbre}
                  function assigner(const variable:string; valeur: Presult):boolean;virtual; {assigne une valeur à une variable}
                  function desassigner(const variable: string):boolean;virtual;              {met une variable à Nil}
                  function evaluer:Presult;virtual;
                  function evalNum:Paffixe; virtual;
                  function StrEval:String;virtual;
                  function en_chaine:string;virtual;
                  function dupliquer:Pcorps;virtual;
                  procedure brancherLocales;virtual;      {branche les variables locales sur la liste des variables locales}
                  procedure ConvertLocale(const variable: string);virtual; {convertir une variable en locale}
                  function deriver(const variable:string):Pcorps;virtual;
                  function free:boolean;virtual;          {indique la présence ou non de variable dans l'arbre}
                  function dependDe(const variable:string):boolean;virtual; {indique si l'arbre dépend de la variable}
                  function simplifier:Pcorps; virtual;               {simplifications élémentaires}
                 
                  destructor detruire;virtual;
                  end;

         Pexpression= ^Texpression;         {une commande de TeXgraph est une expression}
         Texpression= object
                      VarLoc: Pliste;       {variables locales de l'expression}
                      corps: Pcorps;        {l'expression en elle-même, c'est un arbre}

                      constructor init;
                      function definir(const chaine:string):boolean;virtual;  {construit l'arbre à partir d'une chaine et
                                                                        renvoie True si tout se passe bien}
                      procedure assigner(const variable:string; valeur: Paffixe);virtual;
                      procedure desassigner(const variable: string);virtual;
                      function evaluer: Presult;virtual;
                      function evalNum:Paffixe; virtual;
                      //function StrEval:String;virtual;
                      function deriver(const variable:string):Pexpression;virtual;
                      function dupliquer:Pexpression;virtual;
                      procedure simplifier; virtual;
                      destructor detruire;virtual;
                      end;


         Tmacros= object(TNoeud)
                  contenu:Pexpression;
                  statut: byte;              //0: ordinaire, 1:temporaire 2:prédéfinie
                  commande:string;            {C'est la commande saisie par l'utilisateur}

                  constructor init(const Aname:string;Uncontenu:Pexpression);
                  procedure SetCommande(const UneCommande:string);virtual;  {initialisation du champ commande}
                  function executer(arg:PListe):Presult;virtual;     {l'argument n'est pas évalué avant l'appel}
                  //function StrEval(arg:PListe):string;virtual;       {evalution alphanumérique du contenu}
                  function dupliquer:Pmacros;virtual;
                  procedure Recompiler;virtual;                  {détruit puis reconstruit le contenu à
                                                                  partir de la commande}
                  function deriver(arg:Pliste;const variable:string):Pcorps;virtual;
                  destructor detruire;virtual;
                  end;


function Trouver(const Aname:string; Uneliste:PListe):PNoeud;       //cherche dans une PListe
function Trouver2(const Aname:string; Uneliste:THashList):PNoeud;   //cherche dans une hash list

function operation(const nom:string):Poperation; {renvoie un pointeur sur l'opération appelée nom si elle existe, ou bien Nil}
function constante(const nom:string):Pconstante; {renvoie un pointeur sur la constante appelée nom si elle existe, ou bien Nil}
function VarLocale(const nom:string):Pconstante; {renvoie un pointeur sur la variable locale appelée nom si elle existe, ou bien Nil}
function VarGlob(const nom:string):PVarGlob;     {renvoie un pointeur sur la variable globale appelée nom si elle existe, ou bien Nil}
function fonction(const nom:string):Pfonction;   {renvoie un pointeur sur la fonction appelée nom si elle existe, ou bien Nil}
function commande(const nom:string):Pcommande;   {renvoie un pointeur sur la commande appelée nom si elle existe, ou bien Nil}
function macros(const nom:string):Pmacros;       {renvoie un pointeur sur la macro appelée nom si elle existe, ou bien Nil}

function ajouter_macros(UneMacro:Pmacros):boolean;
procedure detruireMacNonPredef;
function DefCorps(Const UneChaine:string):Pcorps;

function CleanString(Const Unechaine:string):string;                  //enlève espaces et retours chariots de début et fin
function TabuleString(Const Unechaine:string):string;                 //ajoute une tabulation à chaque changement de ligne
function FormatString(Const Unechaine:string;long:word):string;      //formate la chaine à la longueur voulue, des retours chariots+tabulation sont insérés.
function MakeString(f: Pcorps): string;

procedure decoupage(LToken:Tlist; Const Unechaine:string; IsFile:boolean); {tokenisation d'une chaine}
procedure analyser(Ltoken:Tlist;debut,fin:longint;var p: Pcorps);          {transformation d'une liste de token en arbre}

var  LesVarLoc, VariablesGlobales, ExitMacros: PListe; //liste non ordonnée pour les variables locales et macros de sortie
     LesCommandes, LesConstantes, LesFonctions, LesOperations, LesMacros: THashList;  //listes des commandes, constantes, fonctions, opérations, macros,
     
     Args:Pliste;
     AnalyseError:boolean;                     {initalisée à False en debut d'analyse, elle permet de stopper en cas d'erreur}
     ErrorMessage: string;                     {contient les messages d'erreurs éventuelles}
     ErrorPos, ErrorLg:longint;
     initial_car : set of char;

IMPLEMENTATION

{=============== traitement chaines ===================}
function CleanString(Const Unechaine:string):string;
//enlève espaces et retours chariots de début et fin
var i,len:longint;
    break,str:string;
begin
     break:=slinebreak+#9+' ';
     str:=UneChaine;
     len:=length(str);
     i:=len;
     while (i>0) and (pos(str[i],break)>0) do dec(i);
     Delete(str,i+1,len-i);
     len:=length(str);
     i:=1;
     while (i<len) and (pos(str[i],break)>0) do inc(i);
     Delete(str,1,i-1);
     result:=str;
end;
{========================}
function FormatString(Const Unechaine:string;long:word):string;
//formate la chaine à la longueur voulue, des retours chariots+tabulation sont insérés.
var Str,break:string;
    len,i:longint;
begin
       Stringreplace(Unechaine,#10+#13,#10,[rfReplaceAll]);
       Stringreplace(Unechaine,#13,#10,[rfReplaceAll]);
       Stringreplace(Unechaine,#10,slinebreak,[rfReplaceAll]);
       if SortieTabulee then
          break:=slinebreak+#9
       else
           break:=slinebreak;
       Str:=WrapText(Unechaine,Break, [' ', ',', ')', ']'],long);
       FormatString:=CleanString(Str)
end;
{========================}
function TabuleString(Const Unechaine:string):string;
var str:string;
begin
     str:=stringreplace(Unechaine, slineBreak,slineBreak+#9,[rfReplaceAll]);
     result:=CleanString(str)
end;

{===================================================================================================================}
{== Première partie: implémentation de l'analyse syntaxique d'une chaine et transformation en arbre (type Pcorps) ==}
{===================================================================================================================}

 var
        indice:longint;    {variable qui permet de parcourir la chaine}
        lg:longint;        {variable qui contient le numéro de ligne actuellement scanée}
        mot:string;        {variable qui contient successivement les identificateurs contenus dans la chaine}
        reel: real;        {variable qui contient successivement les valeurs numériques réelles contenues dans la chaine}
        longueur:longint;  {longueur de la chaine}
        chaine: String;    {variable qui contient le texte en cours d'analyse}

{===== lecture d'un identificateur, indice pointe sur l'initiale dans chaine ========}
 procedure LireIdentificateur;
 var k:longint;
 begin
      k:=indice;
      while (indice<=longueur) and (chaine[indice] in set_nom) do inc(indice);
      mot:=Copy(chaine,k,indice-k)
 end;

{=======lecture d'un message (délimité par " et "), indice pointe sur le 1er caractère du message (qui suit ") ===}
procedure LireMessage;
var
    stop,ok:boolean;
    car:char;
    first,firstlg:longint;
begin
     if AnalyseError then exit;  {s'il y avait une erreur avant, il n'y a rien à faire}
     mot:='';                    {on pointe sur la première case de mot}
     stop:=(Indice>longueur);    {le booléen stop permettra de stopper la lecture}
     ok:=false;                  {le booléen ok permettra de savoir si le message se termine correctement}
     first:=indice; firstlg:=lg; {mémorisation du début de chaine}
     while not stop do
           begin
           car:=chaine[Indice];
           if car=#10 then Inc(lg);
           mot:=mot+car; {on copie le caractère de chaine dans mot}
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
                               inc(Indice);ok:=true; delete(mot,length(mot),1);
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
     AnalyseError:=not ok;      {une erreur si le message n'était pas correct}
     if AnalyseError
        then
            begin
                 ErrorMessage:=TgStringError+': '+mot;
                 ErrorPos:=first;
                 ErrorLg:=firstlg
            end;
end;
{=============== procedure pour la lecture d'une valeur numérique réelle ============}
procedure LireReel;
var aux:string;
    first,Error:longint;
    sortie:extended;
    stop:boolean;
    car:char;
begin
     aux:='';  {cette chaine standard reçoit les caractères constituant la valeur numérique à lire}
     stop:=false;
     first:=indice;
     car:=chaine[Indice];
     while (not stop) and (indice<=longueur) and (chaine[indice] in set_num) do
           begin
                if car=#10 then Inc(lg);
                if (indice>first) and
                    ((car='-') or (car='+')) and
                    (chaine[indice-1]<>'E')
                   then begin stop:=true;dec(indice) end
                                {si on a un + ou un - et le caractère précédent
                                                n'est pas E, alors on n'est plus dans une
                                                expression numérique}
                   else if not (car in [#10,#9,#13])
                        then aux:=aux+car;       {sinon on ajoute le caractère lu à aux}
                inc(indice);                    {on passe au suivant}
                car:=chaine[Indice];
           end;
     val(aux,sortie,Error);                     {on convertit aux en réel}
     if Error<>0
        then
            begin                               {erreur de conversion}
                 AnalyseError:=true;
                 ErrorMessage:=aux+': '+TgNumericError;
                 ErrorPos:=indice;
                 ErrorLg:=lg
            end
        else
            if abs(sortie)>Reel_Max
               then
                   begin                    {valeur trop grande}
                        AnalyseError:=true;
                        ErrorMessage:=aux+': '+TgValueOutOfLimits;
                        ErrorPos:=indice;
                        ErrorLg:=lg
                   end
               else reel:=sortie;
end;
{==============================}
function TokCode(LToken:Tlist;j:longint):integer;
begin
     TokCode:=-1;
     if j<Ltoken.Count
        then
     if Ltoken.Items[j]<>nil then
        TokCode:=PToken(LToken.Items[j]).code;
end;
{============================}
procedure decoupage(LToken:Tlist;Const Unechaine:string; IsFile:boolean);

var comptParO,comptCrO,comptIf,comptDo,
    comptUntil,k,first,firstlg,comptAcc:longint;{compteurs}
    car:char;
    inMap: boolean;
    {================================}
    function TokCont(j:longint): string; //contenu du token
    begin
     TokCont:='';
     if j<Ltoken.Count
     then
     if Ltoken.Items[j]<>nil then
        TokCont:=PToken(LToken.Items[j]).contenu;
    end;
    {==============================}
    procedure AddTok(code:integer;const contenu:string;val:real; index:longint);
    var token:Ptoken;
    begin
     new(token);token.code:=code; token.contenu:=contenu;token.val:=val;token.index:=index;
     token.lg:=lg;
     Ltoken.add(token)
    end;
    {==============================}
begin //découpage
     if Isfile then lg:=2 //c'est un fichier qui a été lu  la première ligne a été enlevée
     else  lg:=1;
     chaine:=Unechaine;
     longueur:=length(chaine);
     if AnalyseError or (chaine='') then exit;
     if MacroStatut=usermac
        then initial_car:=initial_car1
        else initial_car := initial_car2; //initial identificateur
     k:=1; comptParO:=0;comptCrO:=0; comptIf:=0; comptDo:=0;comptUntil:=0;
     while (not AnalyseError) and (k<=longueur) do    {tant qu'on n'est pas en fin de chaine}
       begin
         car:=chaine[k];
         case car of
      #10: begin Inc(lg);  {on compte les sauts de lignes}
           end;
      #9, #13: ;         {on passe  les tabulations et les cr}
         '{' :   begin      {début d'un commentaire}
                       first:=k;firstlg:=lg;
                       comptAcc:=1; inc(k);
                       while (comptAcc<>0) and (k<=longueur) do
                                begin
                                        car:=chaine[k];
                                        if car='{' then Inc(comptAcc);
                                        if car='}' then Dec(comptAcc);
                                        if car=#10 then inc(lg);
                                        inc(k);  {on avance dans chaine jusqu'à
                                        la fin du commentaire ou de la chaine}
                                end;
                       if (comptAcc<>0)
                                  then
                                      begin
                                           AnalyseError:=true;
                                           ErrorMessage:=TgAccFMissing;
                                           ErrorPos:=first;
                                           ErrorLg:=firstlg;
                                           exit;
                                      end else dec(k); {si on est en bout de chaine, alors il y a une erreur, sinon on passe
                                                                                     au caractère suivant}
                  end;
           '}': begin
                    AnalyseError:=true;
                    ErrorMessage:=TgAccOMissing;
                    ErrorPos:=k;
                    ErrorLg:=lg;
                    exit;
                end;
           '"': begin {debut d'un message}
                      indice:=k+1; first:=k;
                      LireMessage; k:=indice-1;
                      if AnalyseError then exit;
                      AddTok(Tmess,mot,0,first);
                 end;

       ':': If (k=longueur) or (chaine[k+1]<>'=')
               then begin
                         AnalyseError:=true;
                         ErrorMessage:=TgEqualMissing+' '+TokCont(Ltoken.count)+':';
                         ErrorPos:=k+1;
                         ErrorLg:=lg;
                         exit
                    end
               else begin AddTok(Tope,'Recoit',0,k);inc(k) end;
               
       ';': AddTok(Tend,'',0,k);

       '[': begin
                 If (k>0) and (chaine[k-1]in set_nom) then{ raccourci pour Copy: c[1] pour Copy(c,1,1), c est un identificateur }
                        AddTok(Tope,'Extract',0,k);
                 AddTok(Tid,'List',0,k); {fonction Liste }
                 Inc(comptCrO);
                 AddTok(Tpo,'',0,k)
            end;
       '=': AddTok(Tope,'Egal',0,k);

       '<': if (k<longueur)
               then if (chaine[k+1]='=')        {inférieur ou égal}
                       then begin AddTok(Tope,'<=',0,k);inc(k) end
                       else if (chaine[k+1]='>')  {différent de}
                            then begin AddTok(Tope,'NEgal',0,k);inc(k) end
                            else AddTok(Tope,'<',0,k)  {inférieur strict}
               else AddTok(Tope,'<',0,k);

       '>': if (k<longueur) and (chaine[k+1]<>'=')
               then AddTok(Tope,'>',0,k)           {supérieur strict}
               else begin AddTok(Tope,'>=',0,k);inc(k) end;  {supérieur ou égal}

       ']': if comptCrO=0 then
             begin
                  AnalyseError:=true;
                  ErrorMessage:=(TgCrochetsNonEquilibres);
                  ErrorPos:=k;
                  ErrorLg:=lg;
                  exit;
             end
             else
                 begin dec(comptCrO);
                 AddTok(Tpf,'',0,k);  {fin de l'argument d'une fonction Liste}
                 end;

     'a'..'z','A'..'Z': begin
                        indice:=k; first:=k;
                        LireIdentificateur;
                        k:=indice-1;
                        if (mot='And') or (mot='Or') or (mot='Inter') or (mot='InterL') or (mot='CutA') or
                        (mot='CutB') or (mot='Inside')
                         then  Addtok(Tope,mot,0,first)
                                        else
                         if (mot='for') then { for <variable> from (dep> to <fin> step <pas> do <action> od}
                                             { for <variable> in <liste> do <action> od}
                           begin
                                Addtok(Tid,'For',0,first);
                                Addtok(Tpo,'',0,k);
                           end else
                        if mot='from' then
                           begin
                                inMap:=false;
                                Addtok(Tsep,'',0,first);
                                {Addtok(Tid,'Seq',0,first);
                                Addtok(Tpo,'',0,first);
                                Addtok(Tvarloc,'k',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tid,'k',0,first);
                                Addtok(Tsep,'',0,first);}
                                Addtok(Tid,'Range',0,first);
                                Addtok(Tpo,'',0,first);

                           end else
                        if (mot='in') then
                           begin
                                Addtok(Tsep,'',0,first);
                                Addtok(Tpo,'',0,first);
                                inMap:=true;
                                {Addtok(Tsep,'',0,first);
                                Addtok(Tid,'Map',0,first);
                                Addtok(Tpo,'',0,first);
                                Addtok(Tvarloc,'k',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tid,'k',0,first);
                                Addtok(Tsep,'',0,first); }
                        end else
                        if (mot='to') then
                           begin
                                Addtok(Tsep,'',0,first);
                           end else
                        if  (mot='step') then
                            begin
                                 if inMap then Addtok(Tpf,'',0,first);
                                 Addtok(Tsep,'',0,first);
                                 if inMap then Addtok(Tpo,'',0,first);  //équilibrage avec do
                            end else
                        if (mot='by') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tpo,'',0,first);
                                Addtok(Tid,'i',0,first);
                                Addtok(Tope,'+',0,first);
                           end else
                        if (mot='By') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tpo,'',0,first);
                                Addtok(Tope,'-',0,first);
                                Addtok(Tid,'i',0,first);
                                Addtok(Tope,'+',0,first);
                           end else
                        if mot='if' then    { if <condition1> then <action1> elif <condition2> then .... else <action> fi }
                           begin
                                Addtok(Tid,'If',0,first);
                                Addtok(Tpo,'',0,first);Inc(comptIf)
                           end else
                        if (mot='then') then
                           begin
                                Addtok(Tsep,'',0,first);
                                Addtok(Tid,'List',0,first);
                                Addtok(Tpo,'',0,first);
                           end else
                        if (mot='andif') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tid,'If',0,first);
                                Addtok(Tpo,'',0,first);
                                Addtok(Tid,'List',0,first);
                                Addtok(Tpo,'',0,first);
                                Inc(comptIf)
                           end else
                        if (mot='elif') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tsep,'',0,first);
                           end else
                        if (mot='else') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tid,'List',0,first);
                                Addtok(Tpo,'',0,first);
                           end else
                        if (mot='do') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tid,'List',0,first);
                                Addtok(Tpo,'',0,first);
                                Inc(comptdo)
                           end else
                        if (mot='odfi') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tpf,'',0,first);
                                Addtok(Tpf,'',0,first);
                                if comptIf=0 then
                                begin
                                  AnalyseError:=true;
                                  ErrorMessage:=(TgOdfiSansAndfi);
                                  ErrorPos:=k;
                                  ErrorLg:=lg;
                                  exit;
                                end else dec(comptIf);
                                if comptDo=0 then
                                begin
                                  AnalyseError:=true;
                                  ErrorMessage:=(TgOdfiSansDo);
                                  ErrorPos:=k;
                                  ErrorLg:=lg;
                                  exit;
                                end else dec(comptDo)
                           end else
                        if (mot='fi') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tpf,'',0,first);
                                if comptIf=0 then
                                begin
                                  AnalyseError:=true;
                                  ErrorMessage:=(TgFiSansIf);
                                  ErrorPos:=k;
                                  ErrorLg:=lg;
                                  exit;
                                end else dec(comptIf)
                           end else
                        if (mot='od') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tpf,'',0,first);
                                if comptDo=0 then
                                begin
                                  AnalyseError:=true;
                                  ErrorMessage:=TgOdSansDo;
                                  ErrorPos:=k;
                                  ErrorLg:=lg;
                                  exit;
                                end else dec(comptDo)
                           end else
                        if (mot='while') then  { while <condition> do <action> od }
                           begin
                                Addtok(Tid,'While',0,first);
                                Addtok(Tpo,'',0,k);Addtok(Tpo,'',0,k);
                           end else
                        if (mot='repeat') then  { repeat <action> until <condition> od }
                           begin
                                Addtok(Tid,'Loop',0,first);
                                Addtok(Tpo,'',0,k);
                                Addtok(Tid,'List',0,first);
                                Addtok(Tpo,'',0,first);
                                Inc(comptDo,1);
                           end else
                        if (mot='until') then
                           begin
                                Addtok(Tpf,'',0,first);
                                Addtok(Tsep,'',0,first);
                                Addtok(Tpo,'',0,first);
                           end else
                        if (mot='Include') or (mot='Var') or (mot='Mac') or (mot='Graph')
                           or (mot='Cmd') then
                                        Addtok(Trubrique,mot,0,first)
                              else
                            Addtok(Tid,mot,0,first);
                        end;
     ',' : AddTok(Tsep,'',0,k);
     '(': begin Inc(comptParO); AddTok(Tpo,'',0,k); end;
     ')': if comptParO=0 then
             begin
                  AnalyseError:=true;
                  ErrorMessage:=TgParenthesesNonEquilibrees;
                  ErrorPos:=k;
                  ErrorLg:=lg;
                  exit;
             end
             else
                 begin dec(comptParO);
                       AddTok(Tpf,'',0,k);
                 end;
    '%': if k<longueur
         then begin
              indice:=k+1;first:=indice;
              LireReel;
              k:=indice-1;
              if (not AnalyseError) and (reel=Trunc(Reel))   {si on lit un entier}
                 then
                     AddTok(Tparam,'',reel,first-1)
                 else
                         begin
                                 AnalyseError:=true;
                                 ErrorMessage:=TgErrorAfterPourcent;
                                 ErrorPos:=first;
                                 ErrorLg:=lg;
                                 exit
                            end                                 {sinon, erreur de syntaxe}
            end
            else begin
                                 AnalyseError:=true;
                                 ErrorMessage:=TgErrorAfterPourcent;
                                 ErrorPos:=k;
                                 ErrorLg:=lg;
                                 exit
                 end;
    '$': if k<longueur then
         if chaine[k+1] in initial_car   {si  l'initiale est valable}
                     then
                         begin
                              indice:=k+1;first:=indice;
                              LireIdentificateur;
                              k:=indice-1;
                              Addtok(Tvarloc,mot,0,first);
                         end
                     else
                         begin
                              AnalyseError:=true;
                              ErrorMessage:=TgInvalidCharAfter+' "$"';
                              ErrorPos:=k+1;
                              ErrorLg:=lg;
                              exit;
                         end
         else
             begin
                  AnalyseError:=true;
                  ErrorMessage:=TgIdentifierAfter+' "$"';
                  ErrorPos:=k;
                  exit
             end;                                 {sinon, erreur de syntaxe}
 '\':  if k<longueur then
              if chaine[k+1]in initial_car      {on teste l'initial}
                     then
                         begin
                              indice:=k+1;first:=indice;
                              LireIdentificateur;
                              k:=indice-1;
                              Addtok(Tmac,mot,0,first-1)  {Si le premier premier caractère est ok}
                         end
               else
                         begin
                              AnalyseError:=true;
                              ErrorMessage:=TgInvalidCharAfter+' "'+car+'"';
                              ErrorPos:=k+1;
                              ErrorLg:=lg;
                              exit
                         end  {si le premier caractère n'est pas valide,  il y a une erreur}
            else
                         begin
                              AnalyseError:=true;
                              ErrorMessage:=TgIdentifierAfter+' "'+car+'"';
                              ErrorPos:=k;ErrorLg:=lg;
                              exit
                         end;
                         
  '@':  if k<longueur then    //macro - chaine
              if chaine[k+1] in initial_car
                     then
                         begin
                              indice:=k+1;first:=indice;
                              LireIdentificateur;
                              k:=indice-1;
                              Addtok(TmacString,mot,0,first-1)  {Si le premier premier caractère est ok}
                         end
               else
                         begin
                              AnalyseError:=true;
                              ErrorMessage:=TgInvalidCharAfter+' "'+car+'"';
                              ErrorPos:=k+1;
                              ErrorLg:=lg;
                              exit
                         end  {si le premier caractère n'est pas valide,  il y a une erreur}
               else
                         begin
                              AnalyseError:=true;
                              ErrorMessage:=TgIdentifierAfter+' "'+car+'"';
                              ErrorPos:=k;ErrorLg:=lg;
                              exit
                         end;
  '/':  If (k=longueur) or (chaine[k+1]<>'/')  then AddTok(Tope,chaine[k],0,k)
               else begin
                         repeat   //commentaire jusqu'à la fin de la ligne
                         Inc(k); car:=chaine[k]
                         until car in [#10, #13];
                         dec(k)
                         end;

'+','-','*','^': AddTok(Tope,chaine[k],0,k);

  '0'..'9','.': begin
                indice:=k;first:=k;
                LireReel;
                k:=indice-1;
                if AnalyseError
                   then begin ErrorPos:=first; exit end
                   else AddTok(Tnum,'',reel,first)
                end;
   ' ': ;
   else
       if car in initial_car then    //initial d'un identificateur ?
           begin
                indice:=k; first:=k;
                LireIdentificateur;
                k:=indice-1;
                Addtok(Tid,mot,0,first);
           end
       else
           begin
                AnalyseError:=true;
                ErrorMessage:='"'+chaine[k]+'" '+TgUnknownChar;
                ErrorLg:=lg;
                ErrorPos:=k;
                exit;
           end;
       end; {fin du case}
       inc(k); {on avance d'une case}
       end;
       if (not AnalyseError) and (comptParO>0) then
          begin
               AnalyseError:=true;
               ErrorMessage:=(TgParenthesesNonEquilibrees);
               ErrorPos:=k-1;
               ErrorLg:=lg;
          end;
       if (not AnalyseError) and (comptCrO>0) then
          begin
               AnalyseError:=true;
               ErrorMessage:=(TgCrochetsNonEquilibres);
               ErrorPos:=k-1;
               ErrorLg:=lg;
          end;
       if (not AnalyseError) and (comptIf>0) then
          begin
               AnalyseError:=true;
               ErrorMessage:=('"fi" '+TgIsMissing);
               ErrorPos:=k-1;
               ErrorLg:=lg;
          end;
       if (not AnalyseError) and (comptDo>0) then
          begin
               AnalyseError:=true;
               ErrorMessage:=('"od" ' +TgIsMissing);
               ErrorPos:=k-1;
               ErrorLg:=lg;
          end;
end;

{============================================= analyse de la liste de tokens ====================================}

{ on cherche l'opérateur de priorité minimale entre les indices i et j de chaine, en retour on a
  k1 et k2 qui sont les indices de debut et fin du nom de l'opération dans chaine, et ope qui est un pointeur
  sur l'opération touvée, si aucun opérateur n'est trouvé, ope vaut Nil}

procedure trouve_operation(Ltoken:Tlist;i,j:longint; var k:longint; var ope: Poperation);
var c:longint;       {pour parcourir la chaine de i à j}
    compt:integer;   {compteur de parenthèses}
    priorite:integer;{pour comparer les priorités}
    aux:Poperation;  {pour la recherche dans la liste des opérations}
    nom:Tnom;        {pour stocker le nom de l'opération}
    token:Ptoken;
begin
     ope:=nil;priorite:=255; {initialisation}
     c:=i;
     while (c<=j) and (not AnalyseError) do
           begin
                token:=Ptoken(Ltoken.Items[c]);
                case token^.code of

                Tpo: begin               {il faut aller jusqu'à la parenthèse fermante correspondante}
                           compt:=1;
                           while (compt<>0) and (c<j) do
                                 begin
                                      inc(c);token:=Ptoken(Ltoken.Items[c]);
                                      if token^.code=Tpo then inc(compt);
                                      if token^.code=Tpf then dec(compt);
                                 end;
                   end;
            Tope : begin                         {on a une véritable opération + ou -}
                        nom:=token^.contenu;     {on stocke le nom}
                        aux:=operation(nom);          {on recherche le nom dans la liste des opérations}
                        if (aux^.priorite<=priorite)  {si la priorité est inférieure à la dernière en date}
                           then
                               begin
                                    ope:=aux;         {on mémorise cette opération}
                                    k:=c;      {indice de l'opération}
                                    priorite:=aux^.priorite; {mise à jour de la priorité}
                               end;
                      end;

                end;{du case}
                inc(c)
           end;
end;
{========================================}
procedure analyser(Ltoken:Tlist;debut,fin:longint;var p: Pcorps);  {analyse de la portion allant de debut à fin, p doit contenir
                                                                    l'arbre construit en retour}
var k1,k2,k3,k,nb_arg:longint;
    ope:Poperation;
    arg1,arg2,q:Pcorps;
    fonct:Pfonction;
    c:Pconstante;
    command:Pcommande;
    stop,developp:boolean;
    tok:Ptoken;
    {========= procedure locale ==}
    procedure LireMacro;
    var
       num:word;
       mac:Pmacros;
    begin
          mot:=tok^.contenu;
          mac:=macros(mot);  {on cherche si elle existe déjà dans le liste des macros}
          developp:=(mac<>nil) and developp;  {developpement immédiat?}
          if developp
             then      {si oui}
                 begin
                      p:=mac^.contenu^.corps^.dupliquer;  {on duplique le corps de la macro}
                      p^.BrancherLocales;                 {on branche ses variables locales sur la liste LesVarLoc}
                 end
             else  {développement différé, on crée une macro dont le contenu pointe sur Nil}
                 p:=new(Pcorps,init(cat_macro,new(PPmac,init(tok^.contenu, mac))));
          if (debut=fin) then exit;  {pas d'argument}
          k1:=debut+1; k2:=k1;          {indices délimitant les différents arguments de la macro}
          k3:=1;                       {compteur de parenthèses ouvrantes non équilibrées,
                                        le token d'indice k1 en contient une}
          stop:=false;                 {pour s'arrêter}
          num:=1;                     {numérotation des paramètres}
          if (tokCode(LToken,debut+1)=Tpo) then
          repeat
                inc(k2);tok:=Ptoken(Ltoken.Items[k2]);
                case tok^.code of
                Tpo: inc(k3); {une parenthèse ouvrante de plus}
           Tsep,Tpf: if (k3=1)    {on a le bon nombre de parenthèses et on est au bout d'un argument}
                        then
                            if k1+1>k2-1 then stop:=true {argument vide}
                            else
                            begin
                                 analyser(Ltoken,k1+1,k2-1,arg1);  {on analyse l'argument délimité par k1 et k2 dans arg1}
                                 if not AnalyseError
                                    then
                                        if developp    {developpement immédiat}
                                           then
                                               begin
                                                    p^.SubsParam(num,arg1); {le paramètre numero num est remplacé
                                                                             par une copie de arg1}
                                                    inc(num);               {on passe au paramètre suivant}
                                                    dispose(arg1,detruire); arg1:=Nil {on détruit arg1}
                                               end
                                           else p^.ajouter_arg(arg1) {développement différé,
                                                                      on ajoute arg1 à la liste des arguments de p}
                                    else
                                        begin
                                             dispose(p,detruire); p:=Nil;
                                             exit; {il y a une erreur, on arrête}
                                        end;
                                 if tok^.code=Tpf
                                    then stop:=true {c'est la fin de la lecture de la macro}
                                    else k1:=k2     {on se prépare à lire un autre argument}
                            end
                        else
                            if tok^.code=Tpf then dec(k3);  {mise à jour du compteur k3}
                    end;{of case}

          until stop or (k2=fin);
          if (k2<fin)           {il ne devrait rien avoir après la macro}
             then
                 begin
                      AnalyseError:=true;
                      if tok^.code=Tpf then
                              ErrorMessage:=TgMissingCommaAfter+' "'+mot+'"?'
                      else ErrorMessage:=TgEmptyArg+'?';
                      ErrorPos:=Ptoken(Ltoken.Items[k2])^.index;
                      ErrorLg:=Ptoken(Ltoken.Items[k2])^.lg;
                      dispose(p,detruire); p:=Nil
                 end;
    end;
  {========}
begin    {procedure analyse}
 p:=nil;
 if AnalyseError then exit;
 if fin<debut
    then
        begin
             AnalyseError:=true;
             ErrorMessage:=TgEmptyArg;
             if (fin>=0) then ErrorPos:=Ptoken(Ltoken.Items[fin])^.index
                         else ErrorPos:=Ptoken(Ltoken.Items[debut])^.index;
             if (fin>=0) then ErrorLg:=Ptoken(Ltoken.Items[fin])^.lg
                         else ErrorLg:=Ptoken(Ltoken.Items[debut])^.lg;
             exit
        end;
 trouve_operation(Ltoken,debut,fin,k,ope);  {opération?}
 if AnalyseError then exit;
 if ope<>nil                {il y a une opération}
    then
        begin {*}
              arg1:=nil;
              if (k>debut) then  analyser(Ltoken,debut,k-1,arg1);  {on analyse le premier argument}
              if not AnalyseError
                 then
                     begin {**}
                           arg2:=nil;
                           analyser(Ltoken,k+1,fin,arg2);          {on analyse le second argument}
                           if not AnalyseError
                              then
                                  begin {***}
                                        if (k=debut) and (Ptoken(Ltoken.items[k])^.contenu='-')   {l'expression commençait par un moins}
                                           then
                                                      begin
                                                           p:=new(Pcorps,init(cat_fonction,fonction('opp')));
                                                           p^.ajouter_arg(arg2);
                                                      end
                                           else
                                        if (k=debut) and (Ptoken(Ltoken.items[k])^.contenu='+')   {l'expression commençait par un plus}
                                           then   p:=arg2
                                           else       {on a une opération ope et deux arguments arg1 et arg2}
                                               begin
                                                    if ope^.nom='Recoit'  {:= correspond à la commande Set}
                                                       then
                                                           p:=new(Pcorps,init(cat_commande,commande('Set')))
                                                       else
                                                    if ope^.nom='Egal'  {= correspond à la commande Egal}
                                                       then
                                                           p:=new(Pcorps,init(cat_commande,commande('Egal')))
                                                       else
                                                    if ope^.nom='NEgal'  {<> correspond à la commande NEgal}
                                                       then
                                                           p:=new(Pcorps,init(cat_commande,commande('NEgal')))
                                                       else
                                                       if ope^.nom='Or'  {= correspond à la commande Or}
                                                          then
                                                              p:=new(Pcorps,init(cat_commande,commande('Or')))
                                                          else
                                                       if ope^.nom='And'  {<> correspond à la commande And}
                                                          then
                                                              p:=new(Pcorps,init(cat_commande,commande('And')))
                                                          else
                                                    if ope^.nom='Extract'  {correspond à la commande Copy}
                                                       then p:=new(Pcorps,init(cat_commande,commande('Copy')))
                                                       else
                                                           p:=new(Pcorps,init(cat_operateur,ope));
                                                    p^.ajouter_arg(arg1);
                                                    p^.ajouter_arg(arg2);
                                               end
                                  end {***}
                              else begin
                                   if arg1<>nil then begin dispose(arg1,detruire); arg1:=Nil end; {il y a une erreur, on détruit arg1}
                                   end;
                     end {**}
        end {*}
    else
    begin
        tok:=Ptoken(Ltoken.Items[debut]);
        case tok^.code of
        Tmess: begin
               p:=new(Pcorps,init(cat_string,new(Pstring,init(tok^.contenu))));
               if fin>debut then
                  begin
                       AnalyseError:=true;
                       ErrorMessage:=TgSyntaxErrorAfter+' "'+tok^.contenu+'"';
                       Errorpos:=tok^.index;
                       ErrorLg:=tok^.lg;
                       exit
                  end;                      {sinon, erreur de syntaxe}
             end;
        Tparam: if (fin=debut)
                then
                p:=new(Pcorps,init(cat_parametre,new(Pparametre,init(round(tok^.val)))))  {on crée un paramètre}
                else
                    begin
                       AnalyseError:=true;
                       ErrorMessage:=TgSyntaxErrorAfter+' "%'+Streel(tok^.val)+'"';
                       Errorpos:=tok^.index;
                       ErrorLg:=tok^.lg;
                       exit
                  end;
        Tvarloc: if (fin=debut)      {normalement l'identificateur doit se terminer à l'indice fin}
                     then
                         begin
                              c:=VarLocale(tok^.contenu);
                              {on cherche si cette variable locale existe déjà}
                              if (c=nil)
                                 then               {sinon il faut la créer et l'ajouter à la liste}
                                    begin
                                         c:=new(Pconstante,init(tok^.contenu,nil,true));
                                         LesVarLoc^.ajouter_fin(PNoeud(c));
                                    end;
                              p:=new(Pcorps,init(cat_constante,c))  {le contenu de p pointe sur cette
                                                                                 variable locale dans la liste LesVarLoc}
                         end
                     else
                         begin
                              AnalyseError:=true;
                              ErrorMessage:=TgSyntaxErrorAfter+' "'+tok^.contenu+'"';
                              Errorpos:=tok^.index;
                              ErrorLg:=tok^.lg;
                              exit;
                         end;

        Tmac: begin                  {annonce une macro en développement immédiat}
              developp:=true; LireMacro;  {on lit une macro en développement immédiat}
              if AnalyseError then exit;
             end;
             
     TmacString: begin                  {annonce une macro -chaine}
              developp:=false; LireMacro;  {on lit une macro}
              if AnalyseError then exit;
              q:=new(Pcorps,init(cat_commande,commande('GetStr')));
              q^.ajouter_arg(p);
              p:=q
             end;

        Tpo: analyser(Ltoken,debut+1,fin-1,p);      {on analyse ce qui est entre les parenthèses}

        Tnum: if(debut=fin)   {on lit une valeur réelle, il ne doit rien avoir derrière}
                 then
                      p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(Tok^.val,0))))
                 else
                     begin
                          AnalyseError:=true;
                          ErrorMessage:=TgSyntaxErrorAfter+' "'+Streel(tok^.val)+'"';
                          Errorpos:=tok^.index;
                          ErrorLg:=tok^.lg;
                          exit
                     end;

        Tid: begin       {c'est un identificateur}
                         if (debut<fin) and (tokCode(Ltoken,debut+1)<>Tpo)
                            then
                                begin
                                     AnalyseError:=true; {s'il y a autre chose qu'une parenthèse, erreur}
                                     ErrorMessage:=TgMissingParenthesisAfter+' "'+tok^.contenu+'"';
                                     Errorpos:=tok^.index;
                                     ErrorLg:=tok^.lg;
                                     exit;
                                end;
                         if (debut=fin)
                            then
                                begin                {s'il n'y a rien derrière}
                                      c:=VarLocale(tok^.contenu);   {c'est une variable}
                                      if c=nil
                                         then         {elle n'est pas encore déclarée locale}
                                              begin
                                                   c:=constante(tok^.contenu);
                                                   if c=nil            {ce n'est pas une variable globale}
                                                      then
                                                          begin        {on la crée en locale}
                                                               c:=new(Pconstante,init(tok^.contenu,nil,true));
                                                               LesVarLoc^.ajouter_fin(PNoeud(c));
                                                          end;
                                              end;
                                      p:=new(Pcorps,init(cat_constante,c))
                                end
                            else
                                begin {ce n'est pas une variable. Est-ce une fonction?commande?macro?}
                                     fonct:=fonction(tok^.contenu);
                                     command:=commande(tok^.contenu);
                                     if (fonct<>nil) or (command<>nil)    {si c'est une fonction ou une commande}
                                        then
                                            begin
                                                 if fonct<>nil
                                                    then
                                                        p:=new(Pcorps,init(cat_fonction,fonct))
                                                    else
                                                        p:=new(Pcorps,init(cat_commande,command));

                                                 k1:=debut+1;       {sinon on lit les arguments}
                                                 k2:=k1;           {comme dans la procédure LireMacro}
                                                 k3:=1;
                                                 stop:=false; nb_arg:=0;
                                                 repeat
                                                       inc(k2);tok:=Ptoken(Ltoken.Items[k2]);
                                                       case tok^.code of
                                                       Tpo: inc(k3);

                                                   Tsep,Tpf: if (k3=1)
                                                               then
                                                                if k1+1>k2-1 then stop:=true {argument vide}
                                                                  else
                                                                   begin
                                                                        analyser(Ltoken,k1+1,k2-1,arg1);
                                                                        Inc(nb_arg);
                                                                        if not AnalyseError
                                                                           then p^.ajouter_arg(arg1)
                                                                           else
                                                                               begin
                                                                                    dispose(p,detruire); p:=Nil;
                                                                                    exit;
                                                                               end;
                                                                        if tok^.code=Tpf
                                                                           then stop:=true
                                                                           else k1:=k2
                                                                   end
                                                               else
                                                                   if tok^.code=Tpf then dec(k3);
                                                       end;{du case}
                                                 until stop or (k2=fin);
                                                 if (k2<fin)
                                                    then
                                                        begin
                                                             AnalyseError:=true;
                                                             dispose(p,detruire); p:=Nil;
                                                             if tok^.code=Tpf then
                                                             ErrorMessage:=TgMissingCommaAfter+' "'+Ptoken(Ltoken.Items[debut])^.contenu+'"?'
                                                             else ErrorMessage:=TgEmptyArg+'?';
                                                             Errorpos:=Ptoken(Ltoken.Items[k2])^.index;
                                                             ErrorLg:=tok^.lg;
                                                             exit
                                                        end
                                                    else   //si c'est une liste à un élément, on peut simplifier
                                                       if (p^.categorie=cat_commande) and
                                                          (Pcommande(p^.contenu)^.nom='List') and
                                                           (nb_arg=1) then
                                                       begin
                                                            q:=Pcorps(p^.arguments^.tete);
                                                            p^.arguments^.init;
                                                            dispose(p,detruire); p:=Nil;
                                                            p:=q
                                                       end;
                                             end
                                            else
                                                begin
                                                     developp:=false;
                                                     LireMacro  {sinon on considère que c'est une macro}
                                                end
                                end;
                    end
                    end;
 end;
end;

{==La fonction suivante lance l'analyse syntaxique d'une chaine contenue dans le parametre Unechaine et retourne
 l'arbre correspondant}

function DefCorps(Const UneChaine:string):Pcorps;
var p:Pcorps;
    i:longint;
    Ltoken:Tlist;
begin
      AnalyseError:=false; ErrorMessage:='';  {initialisation pour la gestion des erreurs}

      Ltoken:=Tlist.create;
      decoupage(Ltoken, UneChaine,false);

      p:=nil;                                          {initialisation du resultat}
      If (not AnalyseError) and (Ltoken.Count>0)
         then
             begin                                     {si la chaine nettoyée n'est pas vide}
                  //indice:=0;
                  analyser(Ltoken,0,Ltoken.Count-1,p);      {on l'analyse}
                  if AnalyseError then p:=nil;
             end
          else if not AnaLyseError
               then ErrorMessage:=TgEmptyString;
      DefCorps:=p ;                                     {on renvoie le résultat}
      for i:=0 to Ltoken.Count-1 do dispose(Ptoken(Ltoken.Items[i]));
      Ltoken.free
end;

{============= Deuxième partie: implémentation de toutes les données de la partie INTERFACE ==}

{=========================== Tparametre =================================}
 constructor Tparametre.init(UnNum:byte);
 begin
      TCellule.init;
      num:=UnNum;      {chaque paramètre porte un numéro}
 end;
{=========================== Tstring =================================}
 constructor Tstring.init(const UneChaine:string);
 begin
      TCellule.init;
      chaine:=UneChaine;
 end;
{==================}
 destructor Tstring.detruire;
 begin
 end;

{=========================== Tconstante =================================}
constructor Tconstante.init(const Aname:string;UneValeur:Presult;loc:boolean);
begin
     TNoeud.init(Aname);
     affixe:=UneValeur;
     predefinie:=ConstPredefinie;
     locale:=loc                 {ce champ permet de savoir si la variable est locale ou non, sans connaitre
                                  l'expression qui contient cette variable}
end;
{==================}
destructor Tconstante.detruire;
begin
     Kill(Pcellule(affixe));
end;

{================ TPmac ================}
constructor TPmac.init;
begin
      TNoeud.init(Aname);
      mac:=Amac
end;
{======================== TVarGlob =======================}
constructor TVarGlob.init;
var f: Pexpression;
begin
     TCellule.init;
     new(f,init);
     statut:=MacroStatut;
     if statut=0
        then commande:=UneCommande                                        {c'est la commande saisie par l'utilisateur}
        else commande:='';                                               {pour définir la variable globale}
     if f^.definir(Unecommande)
        then variable:=New(Pconstante,init(UnNom,f^.evaluer,false))  {la variable globale est créée dans la liste
                                                                           LesConstantes et le champ <variable> pointe
                                                                           dans cette liste}
        else variable:=New(Pconstante,init(UnNom,nil,false));
     LesConstantes.ajouter_fin(variable);
     dispose(f,detruire);
end;
{============================}
procedure TVarGlob.recalculer;
var f:Pexpression;
begin
     if (statut=1) or (commande='') then exit;
     new(f,init);
     Kill(Pcellule(variable^.affixe));
     if f^.definir(commande) then
        begin
             variable^.affixe:=f^.evaluer;
        end;
     dispose(f,detruire);
     ChangeVarG:=true
end;
{============================}
destructor TVarGlob.detruire;
begin
     LesConstantes.supprimer(PNoeud(variable));
     variable:=nil;
end;
{=========================== Toperation =================================}
constructor Toperation.init(const Aname:string;prior:integer);
begin
     TNoeud.init(Aname);
     priorite:=prior
end;
{==================}
function Toperation.evaluer(arg1,arg2:Paffixe):Paffixe;
begin
     evaluer:=nil;
end;
{==================
function Toperation.StrEval(arg1,arg2:Paffixe):string;
var T:Paffixe;
begin
     T:=evaluer(arg1,arg2);
     if T=Nil then result:='' else result:=T^.en_chaine;
     Kill(Pcellule(T))
end;
==================}
function Toperation.deriver(arg:Pliste;const variable:string):Pcorps;   {arg contient la liste des arguments}
begin
     deriver:=nil;
end;
{==================}
function Toperation.simplifier(arg:Pliste):Pcorps;
var
   p,aux,aux1:Pcorps;
   r:Pliste;
begin
     simplifier:=nil;
     if arg=nil then exit;
     new(r,init);
     aux:=Pcorps(arg^.tete);
     while aux<>nil do          {on passe les arguments en revue et on les simplifie}
           begin
               aux1:=aux^.simplifier;
               if aux1<>nil
                  then r^.ajouter_fin(Pcellule(aux1))    {la liste r contiendra les arguments simplifiés}
                  else
                      begin
                           dispose(r,detruire);exit      {s'il y a une erreur, on detruit la liste r et on sort}
                      end;
           end;
     p:=new(Pcorps,init(cat_operateur,operation(nom)));  {il n'y a pas d'erreur, on crée un nouvel arbre avec la
                                                          même opération}
     p^.arguments:=r;                                    {et les arguments simplifiés}
     simplifier:=p;                                      {on retourne le nouvel arbre}
end;                                                     
{=========================== Tfonction =================================}
function Tfonction.evaluer(arg:Paffixe):Paffixe;
begin
     evaluer:=nil;         
end;
{==================
function Tfonction.StrEval(arg:Paffixe):string;
var T:Paffixe;
begin
     T:=evaluer(arg);
     if T=Nil then result:='' else result:=T^.en_chaine;
     Kill(Pcellule(T))
end;
==================}
function Tfonction.deriver(arg:Pliste;variable:string):Pcorps;
begin
     deriver:=nil;
end;
{=========================== T_commande =================================}
function TCommande.executer(arg:PListe):Presult;
begin
     executer:=nil;         
end;
{==================
function TCommande.StrEval(arg:Pliste):string;
var T:Presult;
begin
     T:=executer(arg);
     if T=Nil then result:='' else result:=T^.StrEval;
     Kill(Pcellule(T))
end;
====================}
function Tcommande.deriver(arg:Pliste;variable:string):Pcorps;
begin
     deriver:=nil;
end;
{=========================== Tcorps : c'est un arbre =================================}
constructor Tcorps.init(Acat:integer; Acontenu:pointer);
begin
     TCellule.init;
     categorie:=Acat;
     contenu:=Acontenu;
     arguments:=nil;
end;
{====================}
procedure Tcorps.ajouter_arg(arg:pointer);     {ajoute un nouvel argument}
begin
     if arg=nil then exit;
     if arguments=nil then arguments:=new(Pliste,init);
     arguments^.ajouter_fin(PCellule(arg));
end;
{====================}
procedure Tcorps.SubsParam(parametre:word; Par: Pcorps);  {remplace un paramètre par un arbre}
var
    aux:PCellule;
    arbre:Pcorps;
    p:Pparametre;
begin
     if (categorie=cat_parametre) and (Pparametre(contenu)^.num=parametre)
        then
            begin                         {le noeud courant est un paramètre dont le numero correspond}
                 arbre:=Par^.dupliquer;   {on fait une copie de l'arbre par}
                 p:=PParametre(contenu);  {on pointe sur le contenu du noeud (qui est un parametre)}
                 dispose(p,detruire);     {on détruit ce paramètre}            
                 categorie:=arbre^.categorie; {on prend la même catégorie que l'arbre}
                 contenu:=arbre^.contenu;      {on prend le même contenu que l'arbre}
                 arguments:=arbre^.arguments;  {on prend les mêmes arguments que l'arbre}
                 dispose(arbre);               {on libère la mémoire occupée par l'arbre mais sans appeler
                                                le destructor, sinon les données seraient perdues}
            end
        else
            if arguments<>nil             {le noeud courant n'est pas le paramètre, on fait la substitution
                                           dans toute la descendance s'il y en a une}
               then 
                    begin
                         aux:=arguments^.tete;
                         while (aux<>nil) do
                               begin
                                    Pcorps(aux)^.SubsParam(parametre,par);
                                    aux:=aux^.suivant
                               end;
                    end;
end;
{====================}
procedure Tcorps.composer(const variable:string; Par: Pcorps);    {remplace une variable par un arbre, comme ci-dessus}
var aux:PCellule;
    arbre:Pcorps;
begin
     if (categorie=cat_constante) and (Pconstante(contenu)^.nom=variable)
        then
            begin
                 arbre:=Par^.dupliquer;
                 categorie:=arbre^.categorie;
                 contenu:=arbre^.contenu;
                 arguments:=arbre^.arguments;
                 dispose(arbre);
            end
        else
            if arguments<>nil
               then 
                    begin
                         aux:=arguments^.tete;
                         while (aux<>nil) do
                               begin
                                    Pcorps(aux)^.composer(variable,par);
                                    aux:=aux^.suivant
                               end;
                    end;
end;
{====================}
procedure Tcorps.substituer(const variable,par:string);           {remplace une variable par une autre}
var aux:PCellule;
    c:Pconstante;                             
begin
     if (categorie=cat_constante) and (Pconstante(contenu)^.nom=variable)
        then
            begin                   {c'est la bonne variable}
                 c:=VarLocale(par);
                 if c=nil           {la nouvelle ne fait pas partie des variables locales} 
                    then
                        begin
                             c:=constante(par);
                             if c=nil            {elle ne fait pas partie non plus des globales}
                                then
                                    begin
                                         c:=new(Pconstante,init(par,nil,true));   {alors on l'ajoute aux variables locales}
                                         LesVarLoc^.ajouter_fin(PNoeud(c))
                                    end;
                        end;
                 Pconstante(contenu):=c  {on fait pointer le contenu du noeud courant vers la nouvelle variable}
            end
        else
            if arguments<>nil            {on fait le même chose dans toute la descendance}
               then 
                    begin
                         aux:=arguments^.tete;
                         while (aux<>nil) do
                               begin
                                    Pcorps(aux)^.substituer(variable,par);
                                    aux:=aux^.suivant
                               end;
                    end;
end;
{====================}
function Tcorps.en_chaine:string;     {transforme un arbre en chaine string }
var
   resultat:string;
   aux2:Pcorps;
   aux:string;
begin
     case categorie of

     cat_parametre: resultat:='%'+streel(Pparametre(contenu)^.num);   {un paramètre est un entier précédé de %}

     cat_affixe   :  resultat:=Paffixe(contenu)^.en_chaine;
                 
     cat_string   : resultat:='"'+ StringReplace(Pstring(contenu)^.chaine,'"','""',[rfReplaceAll, rfIgnoreCase])+'"';

     cat_constante: begin 
                          if KeepVarLocName
                             or (not Pconstante(contenu)^.locale)       {Si la constante est globale ou si
                                                                         son contenu est vide}
                             or (Pconstante(contenu)^.affixe=nil)
                          then resultat:=Pconstante(contenu)^.nom
                          else
                                 begin                               {elle est locale, son contenu n'est pas
                                                                      vide}
                                      aux:=Pconstante(contenu)^.affixe^.en_chaine;
                                      if aux[1]<>'[' then resultat:='('
                                                    else resultat:='';
                                      resultat:=resultat+aux;
                                      if resultat[1]='(' then resultat:=resultat+')';
                                 end
                    end;

     cat_fonction,cat_commande,cat_macro:
                    if  (Pfonction(contenu)^.nom='Egal') or (Pfonction(contenu)^.nom='NEgal') or (Pfonction(contenu)^.nom='Set') then
                        begin
                             aux2:=Pcorps(arguments^.tete);
                             resultat:=resultat+Pcorps(aux2)^.en_chaine;
                             aux2:=Pcorps(aux2^.suivant);
                             if (Pfonction(contenu)^.nom='Egal') then resultat:=resultat+'='
                             else
                             if (Pfonction(contenu)^.nom='NEgal') then resultat:=resultat+'<>'
                             else resultat:=resultat+':=';
                             resultat:=resultat+Pcorps(aux2)^.en_chaine;
                        end
                    else
                    begin 
                          if (Pfonction(contenu)^.nom='Liste') or
                             (Pfonction(contenu)^.nom='List') then resultat:='['
                             else resultat:=Pfonction(contenu)^.nom+'(';
                          if arguments<>nil
                             then
                                 begin
                                      aux2:=Pcorps(arguments^.tete);
                                      while aux2<> nil do
                                            begin
                                                 resultat:=resultat+Pcorps(aux2)^.en_chaine;
                                                 aux2:=Pcorps(aux2^.suivant);
                                                 if aux2<>nil then resultat:=resultat+',';
                                            end;
                                 end;
                          if (Pfonction(contenu)^.nom='Liste') or
                             (Pfonction(contenu)^.nom='List') then resultat:=resultat+']'
                          else resultat:=resultat+')';
                    end;

    cat_operateur: begin
                        resultat:='';
                        if ((Pcorps(arguments^.tete)^.categorie=cat_operateur)
                              and (Poperation(Pcorps(arguments^.tete)^.contenu)^.priorite<Poperation(contenu)^.priorite))
                           or ((Pcorps(arguments^.tete)^.categorie=cat_affixe)
                                and (Paffixe(Pcorps(arguments^.tete)^.contenu)^.x<>0)
                                and (Paffixe(Pcorps(arguments^.tete)^.contenu)^.y<>0))
                           then     {si l'argument suivant est un opérateur de priorité inférieure, ou si
                                     c'est un complexe de parties réelle et imaginaire non nulles alors
                                     on met des parenthèses autour}
                               begin
                                    resultat:='('+Pcorps(arguments^.tete)^.en_chaine+')'
                               end
                           else
                               begin
                                    resultat:=resultat+Pcorps(arguments^.tete)^.en_chaine;
                               end;
                        if Length(Poperation(contenu)^.nom)=1
                           then resultat:=resultat+Poperation(contenu)^.nom
                           else
                               begin                                  {le nom d'un opérateur de plus d'un caractère
                                                                       doit être encadré par 2 espaces}
                                    resultat:=resultat+' '+ Poperation(contenu)^.nom+' ';
                               end;
                               {on passe maintenant au 2ième opérateur}
                        if ((Pcorps(arguments^.tete^.suivant)^.categorie=cat_operateur)
                             and (Poperation(Pcorps(arguments^.tete^.suivant)^.contenu)^.priorite<=
                                                                                     Poperation(contenu)^.priorite))
                           or ((Pcorps(arguments^.tete^.suivant)^.categorie=cat_affixe)
                                and (Paffixe(Pcorps(arguments^.tete^.suivant)^.contenu)^.x<>0)
                                and (Paffixe(Pcorps(arguments^.tete^.suivant)^.contenu)^.y<>0))
                           then
                               begin
                                    resultat:=resultat+'('+Pcorps(arguments^.tete^.suivant)^.en_chaine+')'
                               end
                           else
                               begin
                                    resultat:=resultat+Pcorps(arguments^.tete^.suivant)^.en_chaine;
                               end
                  end;
     else resultat:='';
     end;

     en_chaine:=resultat;
end;
{====================}
function Tcorps.evaluer:Presult;              {évaluation d'un arbre}
var r1,r2:Paffixe;
    resultat:Presult;
    arg1:type_liste;
    index:PCellule;
    ok,KillArg1,KillArg2:boolean;
begin
     resultat:= nil;
     case categorie of
     cat_constante: if Pconstante(contenu)^.affixe<>nil
                       then  resultat:=Pconstante(contenu)^.affixe^.evaluer; {la valeur est dupliquée}
     cat_affixe   : resultat:=Paffixe(contenu)^.evaluer;                     {idem}
     cat_string   : resultat:=new(Pchaine,init(Pstring(contenu)^.chaine));
     cat_commande : resultat:=Pcommande(contenu)^.executer(arguments);
     cat_macro    : begin
                         if (PPmac(contenu)^.mac=nil) then
                            PPmac(contenu)^.mac:=macros(PPmac(contenu)^.nom);
                         if PPmac(contenu)^.mac=nil
                            then
                            else resultat:=PPmac(contenu)^.mac^.executer(arguments);
                     end;
     cat_fonction:   if arguments<>nil
                            then
                                begin
                                     arg1.init;index:=arguments^.tete;
                                     ok:=true;
                                     while ok and (index<>nil) do  {on évalue les arguments, on fait la liste
                                                                            des résultats}
                                           begin
                                                r1:= Pcorps(index)^.evalNum;
                                                if r1=nil
                                                   then ok:=false         {s'il y a une erreur on arrête}
                                                   else arg1.ajouter_fin(PCellule(r1));
                                                index:=index^.suivant;
                                           end;
                                     if ok  then resultat:=Pfonction(contenu)^.evaluer(Paffixe(arg1.tete));
                                     arg1.detruire;   { on détruit la liste des résultats}
                                end
                            else resultat:=Pfonction(contenu)^.evaluer(nil);
 cat_operateur:  if arguments<>nil
                    then
                        begin
                             index:=arguments^.tete;
                             if Pcorps(index)^.categorie=cat_constante
                                then        {si le premier argument est une constante, on ne la duplique pas}
                                    begin
                                         r1:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe);
                                         KillArg1:=false;
                                    end
                                else
                                    begin
                                         r1:= Paffixe(Pcorps(index)^.evaluer);//evalNum;   {sinon on duplique}
                                         KillArg1:=true;
                                    end;
                             {if true //r1<>nil
                                then
                                    begin }
                                         index:=index^.suivant;r2:=nil;KillArg2:=false;
                                         if index<>nil
                                            then
                                                if Pcorps(index)^.categorie=cat_constante
                                                   then
                                                       begin
                                                            r2:=Paffixe(Pconstante(Pcorps(index)^.contenu)^.affixe);
                                                            KillArg2:=false;
                                                       end
                                                   else
                                                       begin
                                                            r2:= Paffixe(Pcorps(index)^.evaluer);//evalNum;
                                                            KillArg2:=true;
                                                       end;
                                         {if true //r2<>nil
                                            then }
                                         resultat:=Poperation(contenu)^.evaluer(r1,r2);
                                         If KillArg1 then Kill(Pcellule(r1));
                                         If KillArg2 then Kill(Pcellule(r2));
                                    {end;}
                        end;
     end;{du case}
     evaluer:=resultat;
end;
{====================}
function Tcorps.StrEval:String;              {évaluation d'un arbre}
var r1,r2:Paffixe;
    resultat:String;
    arg1:type_liste;
    index:PCellule;
    ok,KillArg1,KillArg2:boolean;
    T:Presult;
    f: Pcorps;
begin
     resultat:= '';
     case categorie of
     cat_constante: if Pconstante(contenu)^.affixe<>nil
                       then  begin
                             resultat:=Pconstante(contenu)^.affixe^.StrEval; {la valeur est dupliquée}
                             //Messagedlg(resultat,mtWarning,[mbok,mbcancel],0)
                       end;
     cat_affixe   : resultat:=Paffixe(contenu)^.en_chaine; //idem
     cat_string   : resultat:=Pstring(contenu)^.chaine;
     else
         begin
              T := evaluer;
              if T<>Nil then resultat:=T^.StrConcat else resultat:='';
              Kill(Pcellule(T));
         end;
     end;
     StrEval:=resultat
end;
{====================}
function Tcorps.evalNum:Paffixe;
var T:Presult;
begin
     T:=evaluer;
     if T=Nil then result:=Nil else result:=T^.evalNum;
     Kill(Pcellule(T))
end;
{====================}
function Tcorps.assigner(const variable:string; valeur: Presult):boolean;  {donne une valeur à une variable}
var aux:Pcorps;
    c:Pconstante;
    stop:boolean;
begin
     assigner:=false;
     if (categorie=cat_constante)
        and (Pconstante(contenu)^.nom=variable)
        and (not Pconstante(contenu)^.predefinie)            {si on a la bonne variable et qu'elle n'est pas prédéfinie}
        then
            begin
                 c:=Pconstante(contenu);                     {c pointe sur le contenu}
                 Kill(Pcellule(c^.affixe));                  {on détruit l'ancien affixe}
                 //v:=VarGlob(variable);
                 //if v<>nil then v.commande:='';
                 c^.affixe:=Valeur;                          {on affecte le nouvel affixe}
                 assigner:=true;
            end
        else
            if arguments<>nil                                {si on n'a pas la bonne variable,
                                                              il faut aller dans les arguments}
               then
                   begin
                        aux:=Pcorps(arguments^.tete);
                        stop:=false;
                        while (not stop) and (aux<>nil) do
                              begin
                                   stop:=Pcorps(aux)^.assigner(variable,valeur); {on sarrête dès qu'une
                                                                                  assignation a été faite}
                                   aux:=Pcorps(aux^.suivant)
                              end;
                        assigner:=stop
                   end;
end;
{====================}
function Tcorps.desassigner(const variable:string):boolean;            {met une variable à nil}
var aux:Pcorps;
    c:Pconstante;
    stop:boolean;
begin
     desassigner:=false;
     if (categorie=cat_constante) and (Pconstante(contenu)^.nom=variable)
        and (not Pconstante(contenu)^.predefinie)
        then
            begin
                 c:=Pconstante(contenu);
                 c^.affixe:=nil;              {l'ancien contenu n'est pas détruit}
                 desassigner:=true;
            end
        else
            if arguments<>nil
               then
                   begin
                        aux:=Pcorps(arguments^.tete);stop:=false;
                        while (not stop) and (aux<>nil) do
                              begin
                                   stop:=Pcorps(aux)^.desassigner(variable);
                                   aux:=Pcorps(aux^.suivant)
                              end;
                        desassigner:=stop
                   end;
end;
{====================}
function Tcorps.simplifier:Pcorps;
var p:Pcorps;
    r:Paffixe;
begin
     if free
        then
            begin
                 r:=evalNum;
                 if r<>nil
                    then p:=new(Pcorps,init(cat_affixe,r))
                    else p:=nil;
            end
        else
            case categorie of
            cat_operateur: p:=Poperation(contenu)^.simplifier(arguments);
            else p:=dupliquer;
            end;
     simplifier:=p;
end;
{====================}
function Tcorps.free: boolean;
var ok:boolean;
    aux:Pcorps;
begin
     ok:=true;
     case categorie of
     cat_constante: if not Pconstante(contenu)^.predefinie
                       then ok:=false;
     cat_macro: ok:=(PPmac(contenu)^.mac<>nil) and (PPmac(contenu)^.mac^.contenu<>nil) and (PPmac(contenu)^.mac^.contenu^.corps^.free);
     cat_parametre: ok:=false;
     end;
     if arguments<>nil
        then
            begin
                 aux:=Pcorps(arguments^.tete);
                 while ok and (aux<>nil) do
                        begin
                             ok:=ok and aux^.free;
                             aux:=Pcorps(aux^.suivant)
                        end;
            end;
     free:=ok;
end;
{====================}
function Tcorps.dupliquer:Pcorps;
var p,aux:Pcorps;
begin
     p:=new(Pcorps,init(categorie,nil));
     case categorie of
     cat_affixe   : p^.contenu:=Presult(contenu)^.evaluer;//new(Paffixe,init(Paffixe(contenu)^.x,Paffixe(contenu)^.y));

     cat_parametre: p^.contenu:=new(Pparametre,init(Pparametre(contenu)^.num));

     cat_constante,cat_operateur,cat_fonction,cat_commande: p^.contenu:=contenu;

     cat_macro: p^.contenu:=new(PPmac,init(PPmac(contenu)^.nom,PPmac(contenu)^.mac));

     cat_string: p^.contenu:=new(Pstring,init(Pstring(contenu)^.chaine));
     end;
     if arguments <>nil then
        begin
             aux:=Pcorps(arguments^.tete);
             while aux<>nil do
                   begin
                        p^.ajouter_arg(aux^.dupliquer);
                        aux:=Pcorps(aux^.suivant)
                   end
        end;
     dupliquer:=p
end;
{====================}
procedure Tcorps.brancherLocales;         {connecte les variables locales de l'arbre sur la liste LesVarLoc}
var aux:Pconstante;
    aux2:Pcorps;
    res:Presult;
begin
      if (categorie=cat_constante) and (Pconstante(contenu)^.locale)
         then
             begin
                  aux:=VarLocale((Pconstante(contenu)^.nom));
                  if aux=nil
                     then               {si elle n'existait pas, il faut la créer}
                          begin
                               if Pconstante(contenu)^.affixe=Nil then res:=Nil
                               else res:=Pconstante(contenu)^.affixe^.evaluer;
                               aux:=new(Pconstante,init(Pconstante(contenu)^.nom,res,true));
                               LesVarLoc^.ajouter_fin(PNoeud(aux))
                          end;
                  contenu:=aux         {on se connecte}
             end;
      if arguments<>nil                {on en fait autant pour la descendance}
         then
             begin
                  aux2:=Pcorps(arguments^.tete);
                  while aux2<>nil do
                        begin
                             aux2^.brancherLocales;
                             aux2:=Pcorps(aux2^.suivant)
                        end;
             end; 
end;
{=======================}
procedure Tcorps.ConvertLocale(Const variable:string);         {transforme une variable en locale}
var aux:Pconstante;
    aux2:Pcorps;
    res:Presult;
begin
      if (categorie=cat_constante) And (Pconstante(contenu)^.nom=variable) {and (not Pconstante(contenu)^.locale)}
         then
             begin
                  aux:=VarLocale((Pconstante(contenu)^.nom));
                  if aux=nil
                     then               {si elle n'existait pas, il faut la créer}
                          begin
                               if Pconstante(contenu)^.affixe=Nil then res:=Nil
                               else res:=Pconstante(contenu)^.affixe^.evaluer;
                               aux:=new(Pconstante,init(Pconstante(contenu)^.nom,res,true));
                               LesVarLoc^.ajouter_fin(PNoeud(aux))
                          end;
                  contenu:=aux         {on se connecte}
             end;
      if arguments<>nil                {on en fait autant pour la descendance}
         then
             begin
                  aux2:=Pcorps(arguments^.tete);
                  while aux2<>nil do
                        begin
                             aux2^.ConvertLocale(variable);
                             aux2:=Pcorps(aux2^.suivant)
                        end;
             end; 
end;
{====================}
function Tcorps.deriver(const variable:string):Pcorps;
var p:Pcorps;
begin
     case categorie of
     cat_affixe:    p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(0,0))));

     cat_constante: If (Pconstante(contenu)^.nom<>variable)
                       then p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(0,0))))
                       else p:=new(Pcorps,init(cat_affixe,new(Paffixe,init(1,0))));

     cat_operateur: p:=Poperation(contenu)^.deriver(arguments,variable);

     cat_fonction:  p:=Pfonction(contenu)^.deriver(arguments,variable);

     cat_macro:   begin
                         if PPmac(contenu)^.mac=nil then
                            PPmac(contenu)^.mac:=macros(PPmac(contenu)^.nom);
                         if PPmac(contenu)^.mac=nil
                            then p:=nil
                            else p:=PPmac(contenu)^.mac^.deriver(arguments,variable);
                 end;

     cat_commande:  p:=Pcommande(contenu)^.deriver(arguments,variable);

     else p:=nil;
     end;
     deriver:=p;
end;
{====================}
function Tcorps.dependDe(const variable:string):boolean;
var ok:boolean;
    aux:Pcorps;
begin
      ok:=false;
      case categorie of

     cat_constante: ok:= (Pconstante(contenu)^.nom=variable);
         
     cat_macro    : ok:= (PPmac(contenu)^.mac<>nil) and (PPmac(contenu)^.mac^.contenu<>nil) and
                         PPmac(contenu)^.mac^.contenu^.corps^.dependDe(variable);
      end; {du case}
      if arguments<>nil
         then
             begin
                  aux:=Pcorps(arguments^.tete);
                  while (not ok) and (aux<>nil) do
                        begin
                             ok:=ok or (aux^.dependDe(variable));
                             aux:=Pcorps(aux^.suivant)
                        end;
             end;
      dependDe:=ok
end;
{====================}
destructor Tcorps.detruire;
begin
     case categorie of
     cat_affixe : Kill(Pcellule(Paffixe(contenu)));

   cat_parametre: dispose(Pparametre(contenu),detruire);

      cat_macro : dispose(PPmac(contenu),detruire);

     cat_string : dispose(Pstring(contenu),detruire);
     end;

     if arguments<>nil then dispose(arguments,detruire);
end;

{================================================ Texpression ==========================================}
constructor Texpression.init;
begin
     new(VarLoc,init);            {on initialise la liste des variables locales de l'expression}
     //VarLoc:=nil;
     corps:=nil;                  {ainsi que l'arbre}
end;
{====================}
function Texpression.definir(const chaine:string):boolean;
var aux:Pliste;
begin
     aux:=LesVarLoc;                 {on sauvegarde la liste LesVarLoc}
     LesVarLoc:=VarLoc;              {on réinitialise LesVarLoc}
     corps:=DefCorps(chaine);        {on analyse la chaine en arbre}
     VarLoc:=LesVarLoc;              {on récupère les variables locales qui ont été crées pendant l'analyse}
     LesVarLoc:=aux;                 {on restaure LesVarLoc}
     definir:=corps<>nil;
end;
{====================}
procedure Texpression.assigner(const variable:string; valeur:Paffixe);
var aux:Pliste;
    c:Pconstante;
begin
     aux:=LesVarLoc;                {on sauvegarde la liste LesVarLoc}
     LesVarLoc:=VarLoc;             {on <branche> LesVarLoc sur les variables locales de l'expression}
     c:=VarLocale(variable);    {on cherche la variable dans la liste, c pointe sur celle-ci}
     if c<>nil
        then
            begin
                 c^.predefinie:=true;  {une variable assignée  est non modifiable
                                        le temps de l'assignement}
                 c^.affixe:=valeur;    {on lui donne la nouvelle valeur}
            end;
     LesVarLoc:=aux;
end;
{====================}
procedure Texpression.desassigner(const variable:string);
var aux:Pliste;
    c:Pconstante;
begin
     aux:=LesVarLoc;
     LesVarLoc:=VarLoc;
     c:=VarLocale(variable);
     if c<>nil
        then
            begin
                 c^.predefinie:=false;
                 c^.affixe:=nil;
            end;
     LesVarLoc:=aux;
end;
{====================}
function Texpression.evaluer: Presult;
var r:Presult;
    aux:Pliste;
begin
     ExitBloc:=StopAll;
     aux:=LesVarLoc;
     LesVarloc:=VarLoc;
     if corps<>nil
        then r:=corps^.evaluer
        else r:=nil;
     evaluer:=r;
     LesVarLoc:=aux;
     ExitBloc:=StopAll;
end;
{====================}
function Texpression.evalNum: Paffixe;
var r:Presult;
begin
     r:=evaluer;
     if r=Nil then result:=Nil else result:=r^.evalNum;
     Kill(Pcellule(r))
end;
{====================
function Texpression.StrEval: String;
var aux:Pliste;
begin
     ExitBloc:=StopAll;
     aux:=LesVarLoc;
     LesVarloc:=VarLoc;
     if corps<>nil
        then result:=corps^.StrEval
        else result:='';
     LesVarLoc:=aux;
     ExitBloc:=StopAll;
end;
====================}
function Texpression.deriver(const variable:string): Pexpression;
var aux:Pliste;
    p:Pexpression;
begin
     deriver:=nil;
     if corps<>nil
        then
            begin
                 new(p,init);
                 p^.corps:=corps^.deriver(variable);
                 p^.simplifier;
                 if p^.corps=nil
                    then dispose(p,detruire)
                    else
                        begin
                             aux:=LesVarLoc;
                             LesVarLoc:=p^.VarLoc;
                             p^.corps^.brancherLocales;
                             LesVarLoc:=aux;
                             deriver:=p;
                        end;
            end;
end;
{====================}
procedure Texpression.simplifier;
var p:PCorps;
begin
     if corps<>nil
        then
            begin
                 p:=corps^.simplifier;
                 dispose(corps,detruire);
                 corps:=p;
            end;
end;
{====================}
function Texpression.dupliquer:Pexpression;
var r:Pexpression;
    aux:Pconstante;
    aux2:Pliste;
    T:Presult;
begin
     new(r,init);                    {on crée une nouvelle expression}
     aux:=Pconstante(VarLoc^.tete);
     while aux<>nil do
           begin
                if aux^.affixe<>nil                {on duplique les variables locales}
                   then T:=aux^.affixe^.evaluer
                   else T:=nil;
                r^.VarLoc^.ajouter_fin(PCellule(new(Pconstante,init(aux^.nom,T,true))));
                aux:=Pconstante(aux^.suivant);
           end;
     if corps<>nil 
        then r^.corps:=corps^.dupliquer;                  {on duplique l'arbre}
     aux2:=LesVarLoc;
     LesVarLoc:=r^.VarLoc;
     r^.corps^.brancherLocales;                   {on <branche> les variables locales}
     LesVarLoc:=aux2;
     dupliquer:=r;                                {on envoie la nouvelle expression}
end;
{====================}
destructor Texpression.detruire;
begin
     dispose(VarLoc,detruire);
     If corps<>nil
        then dispose(corps,detruire);
end;
{================ Les macros  ====}
Constructor Tmacros.init;
begin
     TNoeud.init(Aname);
     contenu:=UnContenu;
     statut:=MacroStatut;
     commande:='';                  {commande définie par l'utilisateur}
end;
{====================}
procedure Tmacros.SetCommande;
begin
     commande:=CleanString(UneCommande);
end;
{====================}
function Tmacros.executer(arg:PListe):Presult;
var aux1:Pcorps;
    aux2:Pexpression;
    aux3,oldArgs:Pliste;
    num,oldNargs:longint;
begin
     executer:=nil;
     ExitBloc:=StopAll;
     if (contenu=nil) or (contenu^.corps=nil) then exit;           {si c'est vide, rien à faire}
     aux2:=contenu^.dupliquer;
     {aux2:=contenu^.corps^.dupliquer;}
     oldNargs:=Nargs;
     oldArgs:=Args;
     num:=0;
     Args:=arg;
     if (arg<>nil) then                  {s'il y a des arguments, il faut les substituer aux paramètres}
        begin
             aux1:=Pcorps(arg^.tete);
             while  aux1<>nil do
                    begin
                         inc(num);
                         aux2^.corps.SubsParam(num,Pcorps(aux1));
                         aux1:=Pcorps(aux1^.suivant);
                    end;
        end;
     Nargs:=num;
     aux3:=LesVarLoc;
     LesVarloc:=aux2^.varloc;
     executer:=aux2^.corps^.evaluer;          {on évalue l'arbre après substitution}
     LesVarLoc:=aux3;
     dispose(aux2,detruire);
     Nargs:=oldNargs;
     Args:=oldArgs;
     ExitBloc:=StopAll;
end;
{====================
function Tmacros.StrEval(arg:PListe):string;
var aux1:Pcorps;
    aux2:Pexpression;
    aux3,oldArgs:Pliste;
    num,oldNargs:longint;
begin
     result:='';
     ExitBloc:=StopAll;
     if (contenu=nil) or (contenu^.corps=nil) then exit;    //si c'est vide, rien à faire
     aux2:=contenu^.dupliquer;
     oldNargs:=Nargs;
     oldArgs:=Args;
     num:=0;
     Args:=arg;
     if (arg<>nil) then             //s'il y a des arguments, il faut les substituer aux paramètres
        begin
             aux1:=Pcorps(arg^.tete);
             while  aux1<>nil do
                    begin
                         inc(num);
                         aux2^.corps.SubsParam(num,Pcorps(aux1));
                         aux1:=Pcorps(aux1^.suivant);
                    end;
        end;
     Nargs:=num;
     aux3:=LesVarLoc;
     LesVarloc:=aux2^.varloc;
     result:=aux2^.corps^.StrEval;        //on évalue l'arbre après substitution
     LesVarLoc:=aux3;
     dispose(aux2,detruire);
     Nargs:=oldNargs;
     Args:=oldArgs;
     ExitBloc:=StopAll;
end;
====================}
function Tmacros.deriver(arg:Pliste;const variable:string):Pcorps;
var aux1,aux2:Pcorps;
    num:word;
begin
     deriver:=nil;
     if (contenu=nil) or (contenu^.corps=nil) then exit;
     aux2:=contenu^.corps^.dupliquer;
     if (arg<>nil) then
        begin
             aux1:=Pcorps(arg^.tete);num:=1;
             while  aux1<>nil do
                    begin
                         aux2^.SubsParam(num,Pcorps(aux1));
                         aux1:=Pcorps(aux1^.suivant);
                         inc(num)
                    end;
        end;
     deriver:=aux2^.deriver(variable);
     dispose(aux2,detruire);
     //dispose(contenu,detruire);
     //contenu:=nil;
end;
{====================}
Procedure Tmacros.Recompiler;        {redéfinit la macro à partir de la commande saisie par l'utilisateur}
begin
     if statut=0
        then
            begin
                 If contenu<>nil
                    then dispose(contenu,detruire);
                 new(contenu,init);
                 contenu^.definir(commande);
            end;
end;
{====================}
function Tmacros.dupliquer:Pmacros;          {fait une copie de la macro}
var r:Pmacros;
begin
     if contenu=nil
        then dupliquer:=new(Pmacros,init(nom,nil))
        else
            begin
                 r:=new(Pmacros,init(nom,nil{new(Pexpression,init)}));
                 r^.contenu:=contenu^.dupliquer;
                 dupliquer:=r;
            end;
end;
{====================}
destructor Tmacros.detruire;
begin
     if contenu<>nil
        then dispose(contenu,detruire);
     contenu:=nil;
end;
{================================================}
function Trouver(const Aname:string; Uneliste:Pliste):PNoeud;         //Cherche un nom dans une liste
var aux, aux2: PNoeud;
    fini: boolean;
begin
     Trouver:=nil;
     if UneListe<>nil
        then
            begin
                 aux:=PNoeud(UneListe^.tete);
                 aux2:=PNoeud(UneListe^.queue);
                 fini:=(aux=Nil);
                 while  not fini do
                     begin
                          if (aux <> Nil) and (aux^.nom=Aname)
                             then begin
                                       Trouver := aux;
                                       fini := True
                                  end
                          else
                          if (aux2 <> Nil) and (aux2^.nom = Aname)
                              then begin
                                        Trouver := aux2;
                                        fini := True;
                              end
                          else
                              begin
                                  fini := (aux=aux2);
                                  if aux<>Nil then aux := PNoeud(aux^.suivant);
                                  if aux2<>Nil then aux2 := PNoeud(aux2^.precedent);
                              end;
                  end;
            end;
end;

{function Trouver3(const Aname:string; Uneliste:Pliste):PNoeud;         //Cherche un nom dans une liste
var aux: PNoeud;
begin
     Trouver2:=nil;
     if UneListe<>nil
        then
            begin
                 aux:=PNoeud(UneListe^.tete);
                 while ((aux<>nil) and (aux^.nom<>Aname))
                       do begin
                          if aux <> Nil then aux:=PNoeud(aux^.suivant);
                       end;
                 Trouver2:=aux
            end;
end; }

function Trouver2(const Aname:string; Uneliste: THashlist):PNoeud;
var I: longint;
begin
     I := UneListe.Find(Aname);
     if I>-1 then
        Result := PNoeud(UneListe.List[I]^.data)
     else
         Result := Nil
end;

{========== cherche constante ===========}
function constante(const nom:string):Pconstante;
begin
      constante:=Pconstante(Trouver2(nom,LesConstantes));
end;
{========== cherche variable locale ===========}
function VarLocale(const nom:string):Pconstante;
begin
     Varlocale:=Pconstante(Trouver(nom,LesVarLoc));
end;

{============ cherche operation ==============}
function operation(const nom:string):Poperation;
begin
     operation:=Poperation(Trouver2(nom,LesOperations));
end;

{============= cherche fonction ============}
function fonction(const nom:string):Pfonction;
begin
     fonction:=Pfonction(Trouver2(nom,LesFonctions));
end;

{============= cherche commande ===========}
function commande(const nom:string):Pcommande;
begin
     commande:=Pcommande(Trouver2(nom,LesCommandes));
     //commande := testCommandes.Getdata(nom)
end;

{============ cherche Macros ==============}
function Macros(const nom:string):PMacros;
begin
     Macros:=PMacros(Trouver2(nom,LesMacros));
end;
{============ cherche VarGlob ==============}
function VarGlob(const nom:string):PVarGlob;
var aux:PVarGlob;
begin
     aux:=PVarGlob(VariablesGlobales^.tete);
     while (aux<>nil) and (aux^.variable^.nom<>nom)
                       do aux:=PVarGlob(aux^.suivant);
     VarGlob:=aux;
end;
{============ detruit les macros non predefinies ==============}
procedure detruireMacNonPredef;
var p:PMacros;
    I : longint;
begin
      I := 0;
      while I < LesMacros.Count-1 do
          begin
               p:=PMacros(LesMacros.List[I]^.Data);
               if p^.statut<2
                  then LesMacros.supprimer(p)
               else I += 1
          end;
end;
{=========== ajouter_macros ==========}
function ajouter_macros(UneMacro:Pmacros):boolean;
var p:Pmacros;
    aux:Pexpression;
begin
     ajouter_macros:=true;
     p:=Pmacros(Trouver2(UneMacro^.nom,LesMacros));
     if (p=Nil) or (p^.statut=0) then  // n'existe pas ou macro utilisateur
         if p<>nil then   // p existe donc macro utilisateur
                begin
                     aux:=p^.contenu;
                     p^.contenu:=UneMacro^.contenu;
                     UneMacro^.contenu:=aux;
                     p^.statut:=UneMacro^.statut;
                     p^.commande:=UneMacro^.commande;
                     dispose(UneMacro,detruire)
                end
                else  // la macro n'existe pas
                    Lesmacros.ajouter_fin(Unemacro)

        else begin dispose(UneMacro,detruire); ajouter_macros:=false; end;
end;
{=======================}
function MakeString(f: Pcorps): string;
var res : Presult;
    arg: Pcorps;
begin
     result:='';
     if f=Nil then exit;
     result:=f^.StrEval;
end;
{================================}
Initialization
     LesOperations := THashList.Create; LesConstantes := THashList.create;
     LesFonctions := THashList.create;  LesCommandes := THashList.create;
     LesMacros := THashList.Create;
     new(LesVarLoc,init);
     new(VariablesGlobales,init);
     new(ExitMacros,init);
     Args:=nil;
{======== sortie  propre =============}
Finalization
     LesOperations.Destroy; LesConstantes.Destroy;
     LesFonctions.Destroy;  LesCommandes.Destroy;
     LesMacros.Destroy;
     dispose(VariablesGlobales,detruire);
     dispose(LesVarLoc,detruire);
     dispose(ExitMacros,detruire);
END.
