unit Fenetre;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,
  
  {Windows, Messages,} Graphics, Controls, Forms, Dialogs, StdCtrls, LResources,
  Buttons,untres;
  

type
  TFenetreForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure TranslateVisual;
  public
    { Déclarations publiques }
    function Valider: Boolean;
  end;

var
FenetreForm: TFenetreForm;

implementation
uses calculs1{calculs},complex3,command5,graph1_6,saisies,unit1;

procedure TFenetreForm.TranslateVisual;
begin
     Caption:=TgView;
     Label2.Caption:=TgViewHelp;
     Label10.Caption:=TgHeightAndWidth;
     Label11.Caption:=TgWidth;
     Label12.Caption:=TgHeight;
end;

procedure TFenetreForm.FormCreate(Sender: TObject);
begin
     TranslateVisual;
     font:=DefaultFont;
     digits:=12;
     edit1.text:=Streel(Xmin);
     edit2.text:=Streel(Xmax);
     edit3.text:=Streel(Ymin);
     edit4.text:=Streel(Ymax);
     edit5.text:=Streel(Xscale);
     edit6.text:=Streel(Yscale);
     digits:=4;
end;



procedure TFenetreForm.Button1Click(Sender: TObject);
begin
     if Valider then ModalResult:=mrOk else ModalResult:=mrNone;
end;

function TFenetreForm.Valider:boolean;
var x1,x2,y1,y2,xs,ys:real;
begin
          if validReal(edit1,-reel_Max,reel_Max,x1) and
             validReal(edit2,-reel_Max,reel_Max,x2) and
             validReal(edit3,-reel_Max,reel_Max,y1) and
             validReal(edit4,-reel_Max,reel_Max,y2) and
             validReal(edit5,0,reel_Max,xs) and
             validReal(edit6,0,reel_Max,ys)
             then
                 if (x1>=x2) or (y1>=y2)
                    then begin
                         Messagedlg('La fenêtre n''est pas valide',mtWarning,[mbOk],0);
                         Valider:=false;
                         end
                    else
                 if (xs=0) or (ys=0)
                    then begin
                         Messagedlg('Une des échelles n''est pas valide',mtWarning,[mbOk],0);
                         Valider:=false;
                         end
                    else
                        begin
                             graph1_6.fenetre(x1,y1,x2,y2,xs,ys);
                             Valider:=true;
                        end
              else valider:=false;
end;

initialization

  {$i Fenetre.lrs}

end.
