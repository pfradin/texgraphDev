unit Apropos;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,
 
  {Windows, Messages,} Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  LResources, Buttons,untres;
  


type

  { TAproposForm }

  TAproposForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel3: TBevel;
    Label5: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure TranslateVisual;
  public
    { Déclarations publiques }
  end;

var
  AproposForm: TAproposForm;

implementation
uses calculs1, unit1;

procedure TAproposForm.TranslateVisual;
begin
     Caption:=TgApropos;
     Label5.caption:=TgLicence;
end;

procedure TAproposForm.FormCreate(Sender: TObject);
begin
     TranslateVisual;
     Font:=DefaultFont;
     label1.Caption:='TeXgraph version '+calculs1.version
end;

initialization
    {$i Apropos.lrs}

end.
