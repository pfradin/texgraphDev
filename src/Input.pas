unit Input;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,
  
  Graphics, Controls, Forms, Dialogs, StdCtrls,
  LResources, Buttons, SynMemo, untres;
 


type

  { TInputForm }

  TInputForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;

    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure TranslateVisusal;
  public
    { Déclarations publiques }
  end;

var
  InputForm: TInputForm;

implementation

uses Unit1;

procedure TInputForm.Button3Click(Sender: TObject);
begin
     MainForm.GestionAttributs('');
     Button1.SetFocus
end;

procedure TInputForm.TranslateVisusal;
begin
     Button3.Caption:=TgAttributes;
end;


procedure TInputForm.FormCreate(Sender: TObject);
begin
     TranslateVisusal;
     font:=DefaultFont;
end;

initialization

  {$i Input.lrs}

end.
