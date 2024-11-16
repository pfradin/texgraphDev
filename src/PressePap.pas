unit PressePap;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,
  
  {Windows, Messages,} Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  LResources, Buttons, untres;
  


type

  { TPressePapier }

  TPressePapier = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);

  private
    { Déclarations privées }
    procedure TranslateVisual;
  public
    { Déclarations publiques }
     //function Valider: Boolean;
  end;

var
  PressePapier: TPressePapier;

implementation
Uses Unit1;

{ TPressePapier }

procedure TPressePapier.TranslateVisual;
begin
    Caption:=TgClipBoardCaption;
    RadioGroup1.Caption:=TgFormatCopy;
    RadioGroup1.Items[3]:=TgExportTeg;
    RadioGroup1.Items[4]:=TgExportSrc4LaTeX;
    RadioGroup1.Items[5]:=TgExportSrc;
end;

procedure TPressePapier.FormCreate(Sender: TObject);
begin
  TranslateVisual;
  font:=DefaultFont;
end;

initialization

  {$i PressePap.lrs}

end.
