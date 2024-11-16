unit Parametree;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,
  
  {Windows, Messages,} Graphics, Controls, Forms, Dialogs, StdCtrls,
  
  graph2_7, LResources, Buttons, untres;

type
  TParametreeForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Button1: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure TranslateVisual;
  public
    { Déclarations publiques }
    function Valider: Boolean;
  end;

var
  ParametreeForm: TParametreeForm;
implementation
uses listes2,complex3,analyse4,graph1_6,saisies, Unit1;

procedure TParametreeForm.Button1Click(Sender: TObject);
begin
     if Valider then ModalResult:=mrOk else ModalResult:=mrNone;;
end;

procedure TParametreeForm.TranslateVisual;
begin
    Caption:=TgParametricCaption;
    Label1.Caption:=TgName;
    Label2.Caption:=Tg10CarMax;
    Label3.Caption:=TgFunction+' =';
    Label5.Caption:=TgParametricHelp;
    label4.Caption:=TgBreakStep+' =';
    Label6.Caption:=TgBreakHelp;
    CheckBox1.Caption:=TgDiscontinuity;
    Label7.Caption:=TgDiscontinuityHelp;
    Button3.Caption:=TgAttributes;
end;

procedure TParametreeForm.FormCreate(Sender: TObject);
begin
     TranslateVisual;
     font:=DefaultFont;
     Edit1.text:=CurrentName;
     if Pparametree(CurrentGraph)<>nil then
     begin

   Edit2.text:=Pparametree(CurrentGraph)^.LigneCommande;
   checkbox1.checked:=(Pparametree(CurrentGraph)^.saut=1);
   Edit3.text:=Streel(Pparametree(CurrentGraph)^.division);
   Pparametree(CurrentGraph)^.lireAttributs;
     end else
    begin
    Edit2.text:='';
    checkbox1.checked:=False;
    Edit3.text:='5';//5=division du pas par défaut
    DefaultSettings
    end;
    case currentCat of
    cat_cartesienne: begin Caption:=TgCartesianCaption;
    Label3.Caption:=TgCartesianCaption3;
    Label5.Caption:=TgCartesianHelp;
                      end;
    cat_polaire: begin Caption:=TgPolarCaption;
    Label3.Caption:=TgPolarCaption3;
    Label5.Caption:=TgPolarHelp;
                 end;
    end;

end;

function TParametreeForm.Valider:boolean;
var division:longint;
    saut:byte;
    f:Pexpression;
    nom:Tnom;
    q:Pelement;
begin
     Valider:=true;
     nom:=Edit1.text;
     if NomValide(nom,Pparametree(CurrentGraph)<>nil) then
           begin
                 if not ValidInteger(Edit3,0,255,division)
                    then
                        begin
                             Valider:=false;
                             exit;
                        end;
                 if CheckBox1.checked then saut:=1 else saut:=0;
                 new(f,init);
                 if not f^.definir(Edit2.Text) then
                         begin
                              Messagedlg(ErrorMessage,mtWarning,[mbok],0);
                              Valider:=false;
                              Edit2.SelectAll;Edit2.SetFocus;
                         end
                         else
                         begin
                                case cUrrentCat of
                                cat_cartesienne: q:= new(Pcartesienne,init(Nom,edit2.text,division,saut));
                                cat_polaire: q:=new(Ppolaire,init(Nom,edit2.text,division,saut));
                                cat_parametree: q:=new(Pparametree,init(Nom,edit2.text,division,saut));
                                end;
                                 liste_element.inserer(q,CurrentGraph);
                                 liste_element.supprimer(Pcellule(CurrentGraph));
                         end;
                 dispose(f,detruire)
           end
           else
               begin
                    Messagedlg(Edit1.Text+': '+TgInvalidName,mtWarning,[mbok],0);
                    Valider:=false;
                    Edit2.selStart:=ErrorPos-1;
                    Edit2.SelLength:=1; Edit1.setfocus
               end;
end;

procedure TParametreeForm.Button3Click(Sender: TObject);
begin
      MainForm.GestionAttributs(Edit1.text);
      Button1.SetFocus
end;

initialization

  {$i Parametree.lrs}

end.
