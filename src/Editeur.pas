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
unit Editeur;

{$MODE Delphi}

interface

uses
  SysUtils, Classes, LcLType,
  Graphics, Controls, Forms, Dialogs, StdCtrls,
  analyse4, LResources, Buttons, SynEditTypes,SynEdit, Menus, SynCompletion,
  SynHighlighterTeX, {SynExportHTML,} ExtCtrls, ComCtrls, complex3, graph1_6, untres;

type

  { TEditForm }

  TEditForm = class(TForm)
    Button3: TButton;
    Button4: TButton;
    FindDialog1: TFindDialog;
    RemplacerRegExp: TMenuItem;
    ReplaceDialog1: TReplaceDialog;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    MainMenu1: TMainMenu;
    Memo1: TSynEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Chercher: TMenuItem;
    Copier: TMenuItem;
    Couper: TMenuItem;
    Coller: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Defaire: TMenuItem;
    Effacer: TMenuItem;
    Copier_en_TeX: TMenuItem;
    MenuItem5: TMenuItem;
    Execute: TMenuItem;
    ChercherRegExp: TMenuItem;
    SaveAs: TMenuItem;
    Police: TMenuItem;
    MenuItem7: TMenuItem;
    source: TMenuItem;
    Ouvrir: TMenuItem;
    Enregistrer: TMenuItem;
    coloration: TRadioGroup;
    Refaire: TMenuItem;
    SelectAll: TMenuItem;
    Remplacer: TMenuItem;
    Completion: TSynCompletion;
    StopButton: TSpeedButton;
    StatusBar1: TStatusBar;
    SynTeXSyn1: TSynTeXSyn;

    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CollerClick(Sender: TObject);
    procedure CopierClick(Sender: TObject);
    procedure Copier_en_TeXClick(Sender: TObject);
    procedure CouperClick(Sender: TObject);
    procedure DefaireClick(Sender: TObject);
    procedure EnregistrerClick(Sender: TObject);
    procedure ExecuteClick(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ChercherClick(Sender: TObject);
    procedure ChercherRegExpClick(Sender: TObject);
    procedure Memo1StatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure Copier_en_HtmlClick(Sender: TObject);
    procedure RemplacerRegExpClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure PoliceClick(Sender: TObject);
    procedure OuvrirClick(Sender: TObject);
    procedure RefaireClick(Sender: TObject);
    procedure RemplacerClick(Sender: TObject);
    procedure ReplaceDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    procedure EffacerClick(Sender: TObject);
    procedure colorationClick(Sender: TObject);
    procedure lireClick(Sender: TObject);
    procedure sourceClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure Executer;
  private
    { Déclarations privées }
     cat_Current:integer;
     graph_current:Pelement;
     mac_current: Pmacros;
     attrib: TAttr;
     useRegExp : boolean;
     procedure TranslateVisual;
  public
    { Déclarations publiques }

    Nom: TFileName;
    modal:boolean;

    function Valider: Boolean;
    function fEnregistrer:Boolean;
    Procedure StatusBarUpDate;
    function savefile:boolean;
  end;

implementation
uses ClipBrd,listes2,graph2_7,command10, Unit1;

{
VAR userDone, Interrupted:boolean;
TYPE

TMyThread = class(TThread)
protected
  procedure Execute; override;
public
  Constructor Create(CreateSuspended : boolean);
  procedure myrep;
end;

var
    nom:Tnom;
    commande:string;
    q:Pelement;
    MyThread: TMyThread;

constructor TMyThread.Create(CreateSuspended : boolean);
begin
      FreeOnTerminate := True;
      inherited Create(CreateSuspended);
end;

procedure TMyThread.myrep;
begin
     UserDone:=True;
end;

procedure TMyThread.Execute;
begin
   q:=new(Putilisateur,init(nom,commande,-1));
   synchronize(myrep)
end;
}
{===============================}
procedure TEditForm.TranslateVisual;
begin
    Label1.caption:=TgName;
    Label2.caption:=Tg10CarMax;
    Label3.caption:=TgCommand;
    Button3.caption:=TgAttributes;
    Button4.caption:=TgExecuter;
    Coloration.caption:=TgColoration;
    MenuItem1.caption:=TgFile;
    with MenuItem1 do
            begin
               Ouvrir.caption:=TgOpen;
               source.caption:=TgSource;
               Enregistrer.caption:=TgSave;
               SaveAs.caption:=TgSaveAs;
               effacer.caption:=TgEffacer;
               Execute.caption:=TgExecuter;
            end;
    MenuItem2.caption:=TgEdit;
     with MenuItem2 do
             begin
                 Defaire.caption:=TgUndo;
                 Refaire.caption:=TgRedo;
                 SelectAll.caption:=TgSelectAll;
                 Couper.caption:=TgCouper;
                 Copier.caption:=TgCopier;
                 Coller.caption:=TgColler;
                 Copier_en_TeX.caption:=TgCopier_en_TeX;
                 MenuItem5.caption:=TgCopier_en_Html;
                 chercher.caption:=TgChercher;
                 chercherRegExp.caption:=TgChercherRegExp;
                 remplacer.caption:=TgRemplacer;
                 remplacerRegExp.caption:=TgRemplacerRegExp;
                 Police.caption:=TgEditionFont;
             end;
end;

procedure TEditForm.FormCreate(Sender: TObject);
var aux:string;
    I:longint;
    p:Pcellule;
begin
   TranslateVisual;
   font:=DefaultFont;
   with memo1.font do
        begin
         name:=EditDefaultFont.name;
         height:=EditDefaultFont.height;
         quality:=fqAntialiased;
        end;
   Nom:='';
   Memo1.Modified:=false;
   modal:=false;
   cat_current:=currentCat;
   if cat_current=cat_VarGlob then
      begin
          button3.visible:=false;
          if CurrentVarGlob=nil
        then
            begin
                 edit1.text:='';
                 Memo1.text:='';
            end
        else
            begin
                 edit1.text:=CurrentVarGlob^.variable^.nom;
                 if CurrentVarGlob^.commande='' then
                    begin
                    If CurrentVarGlob^.variable^.affixe<>nil
                       then CurrentVarGlob^.commande:=CurrentVarGlob^.variable^.affixe^.en_chaine
                       else CurrentVarGlob^.commande:='Nil'
                    end;
                 Memo1.text:=CurrentVarGlob^.commande;
            end
        end
   else
   if cat_current=cat_macro then {saisie d'une macro}
     begin
     mac_current:=CurrentMac;
     graph_current:=nil;
     button3.visible:=false;
     //coloration.visible:=true;
     if mac_current=nil
        then
            begin
                 edit1.text:='';
                 Memo1.text:='';
            end
        else
            begin
                 edit1.text:=mac_current^.nom;
                 if mac_current^.commande=''
                    then if mac_current^.contenu<>nil
                            then begin
                                 aux:=mac_current^.contenu^.corps^.en_chaine;
                                 Memo1.text:=aux;
                                 end
                            else Memo1.text:=''
                    else Memo1.text:=mac_current^.commande;
            end
        end
    else
    if cat_current=cat_utilisateur then
     begin
     mac_current:=nil;
     graph_current:=CurrentGraph;
     if graph_current=nil
        then
            begin
                 edit1.text:=CurrentName;
                 Memo1.text:='[//command'+LF+LF+']';
                 DefaultSettings;
            end
        else
            begin
                 edit1.text:=graph_current^.nom;
                 Memo1.text:=graph_current^.LigneCommande;
                 graph_current^.lireAttributs;
            end;
      SaveAttr;  //on sauve les attributs
      Attrib:=PAttr(ListAttr.Items[0])^;
      ListAttr.delete(0)
      end
     else {edition d'un texte}
          begin
               button3.visible:=false; edit1.visible:=false; label1.visible:=false; StopButton.visible:=false;
               label2.visible:=false; coloration.visible:=true; button4.visible:=true;
               button2.caption:=TgSave;
               with MenuItem1 do begin Execute.enabled:=True; Enregistrer.enabled:=True end;
               Memo1.text:='';
               Button1.Caption:=TgFermer
          end;
    Completion:=TSynCompletion.Create(self);
    Completion.ShortCut:=VK_F2;
    Completion.AddEditor(Memo1);
    With MainForm.synAnySyn1 do
              for i:=0 to Keywords.Count-1 do  Completion.ItemList.add(Keywords[i]);

    with LesFonctions do
             for I:=0 to Count-1 do Completion.ItemList.add(List[I].Key+'(');

    with LesConstantes do
             for I:=0 to Count-1 do Completion.ItemList.add(List[I].Key);

    with LesCommandes do
             for I:=0 to Count-1 do Completion.ItemList.add(List[I].Key+'(');

    with LesMacros do
             for I:=0 to Count-1 do Completion.ItemList.add(List[I].Key+'(');

    TStringList(completion.ItemList).sort();
end;

procedure TEditForm.ReplaceDialog1Find(Sender: TObject);
var options: TSynSearchOptions;
begin
     if useRegExp then options:=[ssoRegExpr] else options := [];
     if frMatchCase in ReplaceDialog1.Options then
        options:=options+[ssoMatchCase];
     if frWholeWord in ReplaceDialog1.Options then
        options:=options+[ssoWholeWord];
     if not (frDown in ReplaceDialog1.Options) then
        options:=options+[ssoBackwards];
     Memo1.SearchReplace(ReplaceDialog1.FindText,'' ,options);
     //Memo1.SetFocus;
end;

procedure TEditForm.ReplaceDialog1Replace(Sender: TObject);
var options: TSynSearchOptions;
begin
     if useRegExp then options:=[ssoRegExpr] else options := [];
     if frMatchCase in ReplaceDialog1.Options then
        options:=options+[ssoMatchCase];
     if frWholeWord in ReplaceDialog1.Options then
        options:=options+[ssoWholeWord];
     if not (frDown in ReplaceDialog1.Options) then
        options:=options+[ssoBackwards];
     if (frReplace in ReplaceDialog1.Options) then
             options:=options+[ssoReplace];
     if (frReplaceAll in ReplaceDialog1.Options) then
                options:=options+[ssoReplaceAll];
     Memo1.SearchReplace(ReplaceDialog1.FindText, ReplaceDialog1.ReplaceText,options);
     //Memo1.SetFocus;
end;

procedure TEditForm.SelectAllClick(Sender: TObject);
begin
     Memo1.SelectAll
end;

procedure TEditForm.EffacerClick(Sender: TObject);
begin
  Memo1.ClearAll
end;

procedure TEditForm.colorationClick(Sender: TObject);
begin
    case coloration.itemindex of
    1: Memo1.HighLighter:=synTeXsyn1;
    0: Memo1.HighLighter:=MainForm.SynAnySyn1;
    2: Memo1.HighLighter:=nil;
    end
end;

procedure TEditForm.lireClick(Sender: TObject);
//lit le contenu de la fen^etre comme un fichier source texgraph
var SelectionCopy:integer;
    T:TStringList;
    f:textfile;
begin
     T:=TstringList.Create;
     if pos('TeXgraph', memo1.Lines[0])=0 then T.Add('TeXgraph#');
     T.Add(memo1.text);
     T.SaveToFile(TmpPath+'temp.teg');
     with MainForm do
     if AskSave
        then begin
                AddRecentFile;
                FileName:=TmpPath+'temp.teg';
                CleanRecentFile(FileName);
                LoadFile
             end;
     T.free
end;

procedure TEditForm.sourceClick(Sender: TObject);
begin
     ExportName:=TmpPath+'temp.teg';
     enregistrer_elements(teg,cadre,ExportName);
     memo1.Lines.LoadFromFile(TmpPath+'temp.teg');
end;

procedure TEditForm.StopButtonClick(Sender: TObject);
begin
  //ExitBloc:=true;
  //Interrupted:=true;
  //ShowMessage(TgMessageInterrupted);
end;

procedure TEditForm.FindDialog1Find(Sender: TObject);
var options: TSynSearchOptions;
begin
     if useRegExp then options:=[ssoRegExpr] else options := [];
     if frMatchCase in FindDialog1.Options then
        options:=options+[ssoMatchCase];
     if frWholeWord in FindDialog1.Options then
        options:=options+[ssoWholeWord];
     if not (frDown in FindDialog1.Options) then
        options:=options+[ssoBackwards];
     Memo1.SearchReplace(FindDialog1.FindText, '',options);
     //Memo1.SetFocus;
end;



procedure TEditForm.CopierClick(Sender: TObject);
begin
     Memo1.CopyToClipBoard
end;

procedure TEditForm.Copier_en_TeXClick(Sender: TObject);
var T:TStringList;
begin
    ExportName:= TmpPath+'clipboard.txt';
    Export2PrettyLaTeX(Memo1.text);
    T:=TStringList.Create;
    T.LoadFromFile(ExportName);
    ClipBoard.asTeXt:=T.text;
    T.free
end;

procedure TEditForm.CouperClick(Sender: TObject);
begin
  Memo1.CutToClipBoard;
end;

procedure TEditForm.DefaireClick(Sender: TObject);
begin
   Memo1.Undo
end;

procedure TEditForm.CollerClick(Sender: TObject);
begin
  Memo1.PasteFromClipBoard;
end;

procedure TEditForm.Button3Click(Sender: TObject);
var T:Pattr;
begin
     T:=DuplicAttr(Attrib);  //on restaure les attributs
     ListAttr.Insert(0,T);
     RestoreAttr;
     if MainForm.GestionAttributs(Edit1.Text) then
          begin
              SaveAttr;  //on sauve les attributs
              CleanAttr(Attrib);
              Attrib:=PAttr(ListAttr.Items[0])^;
              ListAttr.delete(0);
          end;
     Button1.SetFocus
end;

procedure TEditForm.Executer;//run
//lit le contenu de la fen^etre comme un fichier source texgraph
var SelectionCopy:integer;
    T:TStringList;
    f:textfile;
    namefile : string;
begin
     T:=TstringList.Create;
     if pos('TeXgraph', memo1.Lines[0])=0 then T.Add('TeXgraph#');
     T.Add(memo1.text);
     if Nom='' then namefile:=TmpPath+'temp.teg' else namefile:=Nom;
     T.SaveToFile(namefile);
     T.free;
     with MainForm do
     if AskSave
        then begin
                AddRecentFile;
                FileName:=namefile;
                CleanRecentFile(FileName);
                CurrentDir:=ExtractFilePath(FileName);
                ChDir(CurrentDir);
                LoadFile;
             end;
end;

procedure TEditForm.Button4Click(Sender: TObject);
begin
     Executer;
end;

function TEditForm.Valider:boolean;
var nom:Tnom;
    commande:string;
    f:Pexpression;
    q:Pelement;
    T:Pattr;
    s:Pmacros;
    res:Presult;
    oldCurs: Tcursor;
    I:longint;
begin
     Valider:=true;
     nom:=Edit1.text;
     commande:=string(Memo1.text);
     if cat_current=cat_VarGlob then
        begin
          if NomValide(nom,CurrentVarGlob<>nil) then
           begin
                 new(f,init);
                 if not f^.definir(commande)
                    then begin
                              Messagedlg(ErrorMessage,mtWarning,[mbok],0);
                              Memo1.selStart:=ErrorPos-1;
                              Memo1.SelEnd:=ErrorPos;
                              Memo1.setfocus;
                              result:=false;
                         end
                    else
                              if CurrentVarGlob<>nil then
                                 begin
                                        res:=f^.evaluer;
                                        Kill(Pcellule(CurrentVarGlob^.variable^.affixe));
                                        CurrentVarGlob^.variable^.affixe:=res;
                                        CurrentVarGlob^.variable^.nom:=nom;
                                        CurrentVarGlob^.commande:=commande;
                                 end else
                                             begin
                              VariablesGlobales^.ajouter_fin(new(PVarGlob,init(nom,commande)));
                                             end;
                 dispose(f,detruire)
           end
           else
               begin
                    Messagedlg(Edit1.text+': '+TgInvalidName,mtWarning,[mbok],0);
                    Edit1.selectAll;Edit1.setfocus;result:=false
               end
        end
     else
     if ((cat_current=cat_macro) and NomMacroValide(nom,mac_current<>nil)) or
        ((cat_current=cat_utilisateur) and NomValide(nom,graph_current<>nil)) then
           begin
                 new(f,init);
                 if not f^.definir(commande)
                    then begin
                              Messagedlg(ErrorMessage,mtWarning,[mbok],0);
                              dispose(f,detruire);
                              Memo1.selStart:=ErrorPos-1;
                              Memo1.SelEnd:=ErrorPos;
                              Memo1.setfocus;
                              Valider:=false;
                         end
                    else
                        begin
                          if cat_current=cat_macro then //il ne faut pas détruire f
                            begin
                              if mac_current<>nil then
                                 begin
                                       LesMacros.remove(mac_current^.nom);
                                       dispose(PMacros(mac_current),detruire);
                                 end;
                                       s:=new(PMacros,init(nom,f));
                                       s^.SetCommande(commande);
                                       ajouter_macros(s);
                            end
                          else
                          if cat_current=cat_utilisateur then //il faut détruire f
                              begin
                                  T:=DuplicAttr(Attrib);  //on restaure les attributs
                                  ListAttr.Insert(0,T);
                                  restoreAttr;
                                  //Interrupted:=false;
                                  //q:=Nil;
                                  oldCurs:=memo1.Cursor; memo1.Cursor:=crHourGlass;
                                  q:=new(Putilisateur,init(nom,commande,-1));
                                  {oldCurs:=memo1.Cursor; memo1.Cursor:=crHourGlass;
                                   UserDone:=false; InThread:=True; DifferedMessage:='';
                                  StopButton.enabled:=true;
                                  MyThread := TMyThread.Create(True);
                                  MyThread.start;
                                  repeat Application.ProcessMessages; Sleep(100) until UserDone; //fin de la tâche
                                  StopButton.enabled:=false;}
                                  memo1.Cursor:=oldCurs;
                                  //if not interrupted then
                                     //begin
                                          q.nom:=nom;
                                          if graph_current=nil then ajouter_element(q)
                                          else begin
                                                 liste_element.inserer(q,graph_current);
                                                 liste_element.supprimer(Pcellule(graph_current));
                                          end;
                                     //end
                                  //else begin
                                     //if q<>Nil then dispose(q,detruire);Valider:=False
                                  //end;
                                  dispose(f,detruire);
                                  InThread:=false;
                                  if DifferedMessage<>'' then {Messagedlg(DifferedMessage,mtWarning,[mbOk],0)}
                                     MainForm.AfficherMessage('Message',DifferedMessage);
                              end;

                        end
           end
           else
               begin
                    Messagedlg(TgInvalidName,mtWarning,[mbok],0);
                    edit1.selectAll;
                    edit1.setfocus;
                    Valider:=false;
               end

end;

procedure TEditForm.Button1Click(Sender: TObject);
begin
     if cat_current=-1 then  //fenetre édition
              if (not Memo1.Modified) or fEnregistrer then Close else
        else
     begin
     if Valider then
        begin
         ModalResult:=mrOk;
         if not modal then Close;
         if cat_current=cat_VarGlob then
            begin
            end
         else
         if cat_current=cat_macro then
            begin
                 MainForm.ValiderSaisieMacro(mac_current=nil);
                 //MainForm.ListBox3.SetFocus
            end
         else
            begin
                 MainForm.ValiderSaisieGraph(graph_current=nil);
                 //MainForm.ListBox1.SetFocus
            end;
        end
        else ModalResult:=mrNone
     end;
end;

procedure TEditForm.Button2Click(Sender: TObject);
begin
    if cat_current=-1 then //fenetre édition de fichier à sauvegarder
        if Nom='' then savefile
        else
        begin
             Memo1.Lines.SaveToFile(Nom);
             Memo1.Modified:=false;
             StatusBarUpDate;
        end
    else
    begin  // cancel (hors édition de fichier)
     Close;
     if cat_current=cat_macro then //MainForm.ListBox3.SetFocus
                              else
     if (cat_current=cat_utilisateur) and (graph_current=nil) and (PcomptGraph^.affixe^.getx>0) then
        begin
             PcomptGraph^.affixe^.setx(PcomptGraph^.affixe^.getx-1);//on décompte
             //MainForm.ListBox1.SetFocus
        end;
    end;
end;

procedure TEditForm.FormDestroy(Sender: TObject);
begin
     Completion.free
end;

procedure TEditForm.Memo1Change(Sender: TObject);
begin

end;

procedure TEditForm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {$IFDEF Windows}
  if (key=VK_Tab) and (ssCtrl in Shift) then
     begin
          Button1.setfocus;
          Key:=0
     end
  else
  {$ENDIF}
  if (key=VK_F) and (ssCtrl in Shift) then
     begin
          FindDialog1.execute;
          Key:=0
     end
  else
  if (key=VK_R) and (ssCtrl in Shift) then
     begin
          ReplaceDialog1.execute;
          Key:=0
     end
end;

procedure TEditForm.ChercherClick(Sender: TObject);
begin
     useRegExp := False;
     FindDialog1.execute
end;

procedure TEditForm.ChercherRegExpClick(Sender: TObject);
begin
     useRegExp := True;
     FindDialog1.execute
end;

Procedure TEditForm.StatusBarUpDate;
begin
     with StatusBar1 do
          begin
             if Memo1.Modified then Panels[0].text:=TgModified else
                              Panels[0].text:='';
             Panels[1].text:=Nom
          end;
end;

procedure TEditForm.Memo1StatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
    if scModified in Changes then
       begin
            StatusBarUpDate;
       end
end;

procedure TEditForm.Copier_en_HtmlClick(Sender: TObject);
var T:TStringList;
begin
    ExportName:= TmpPath+'clipboard.txt';
    Export2PrettyHtml(Memo1.text);
    T:=TStringList.Create;
    T.LoadFromFile(ExportName);
    ClipBoard.asTeXt:=FormatString(T.text,100);
    T.free
end;

procedure TEditForm.PoliceClick(Sender: TObject);
begin
       FontDialog1.font.name:=EditDefaultFont.name;
       FontDialog1.font.height:=EditDefaultFont.height;
       if FontDialog1.execute then
               begin
                    EditDefaultFont.name:=FontDialog1.font.name;
                    EditDefaultFont.height:=FontDialog1.font.height;
                    with memo1.font do
                         begin
                              name:=EditDefaultFont.name;
                              height:=EditDefaultFont.height;
                              quality:=fqAntialiased;
                         end;
               end;

end;

procedure TEditForm.OuvrirClick(Sender: TObject);
begin
     if Memo1.modified then fenregistrer;
     if MainForm.GetOpenFile(TgOpenAFile,
                    'TeXgraph (teg, mod, mac)|*.teg;*.mod;*.mac|TeX (tex)|*.tex|Texte (txt)|*.txt|Script (sh, bat)|*.sh;*.bat|All|*',
                    '', Nom)
        then begin
                        Memo1.Lines.LoadFromFile(Nom);
                        Memo1.Modified:=false;
                        StatusBarUpDate;
             end
end;

function TEditForm.savefile:boolean; // on demande un nom
begin
     Result:=false;
     if MainForm.GetSaveFile(TgSaveAfile,
                    TgFile+' |*',
                    '', Nom)

        then begin
                        Memo1.Lines.SaveToFile(Nom);
                        Result:=true;
                        Memo1.Modified:=false;
                        StatusBarUpDate;
             end
end;


function TEditForm.fEnregistrer:boolean;
begin
     result:=true;
     case MessageDlg(TgWantToSave,
                      mtConfirmation,[mbYes,mbNo,mbCancel],0)
      of
     mrCancel: begin result:=false; exit end;
     mrNo: exit;
     end;
     result:=savefile
end;

procedure TEditForm.SaveAsClick(Sender: TObject);
begin
     savefile // demande un nom
end;

procedure TEditForm.EnregistrerClick(Sender: TObject);
begin
     Button2Click(Sender); // enregistrement direct en édition de fichier
end;

procedure TEditForm.ExecuteClick(Sender: TObject);
begin
     Executer;
end;

procedure TEditForm.RefaireClick(Sender: TObject);
begin
  Memo1.Redo
end;

procedure TEditForm.RemplacerClick(Sender: TObject);
begin
    UseRegExp := False;
    ReplaceDialog1.execute
end;

procedure TEditForm.RemplacerRegExpClick(Sender: TObject);
begin
    UseRegExp := True;
    ReplaceDialog1.execute
end;

initialization

  {$i Editeur.lrs}
  
end.
