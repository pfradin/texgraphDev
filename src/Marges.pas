unit Marges;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,

 
  {Windows, Messages,}Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  
  LResources, Buttons, saisies, untres;

type
  TMargesForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
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
  MargesForm: TMargesForm;

implementation
uses calculs1{calculs},complex3,command5,graph1_6,unit1;

procedure TMargesForm.TranslateVisual;
begin
      Caption:=TgMarginTitle;
      Label1.Caption:=TgLeft+' =';
      Label2.Caption:=TgRight+' =';
      Label3.Caption:=TgTop+' =';
      Label4.Caption:=TgBottom+' =';
end;

procedure TMargesForm.FormCreate(Sender: TObject);
begin
     TranslateVisual;
     font:=DefaultFont;
     digits:=12;
     edit1.text:=Streel(margeG);
     edit2.text:=Streel(margeD);
     edit3.text:=Streel(margeH);
     edit4.text:=Streel(margeB);
     digits:=4;
end;

procedure TMargesForm.Button1Click(Sender: TObject);
begin
     if Valider then ModalResult:=mrOk else ModalResult:=mrNone;
end;


function TMargesForm.Valider:boolean;
var x1,x2,x3,x4:real;
begin
          if validReal(edit1,0,reel_Max,x1) and
             validReal(edit2,0,reel_Max,x2) and
             validReal(edit3,0,reel_Max,x3) and
             validReal(edit4,0,reel_Max,x4)
             then
                 begin
                      graph1_6.marges(x1,x2,x3,x4);
                      Valider:=true;
                 end
             else Valider:=false;
end;

initialization

  {$i Marges.lrs}

end.
