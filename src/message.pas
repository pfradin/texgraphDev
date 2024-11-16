unit Message;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, LCLType, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SynMemo, untres;

type

  { TMessageForm }

  TMessageForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Memo1: TSynMemo;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    procedure TranslateVisual;
    function savefile: boolean;
  public
    { public declarations }
  end; 

var
  MessageForm: TMessageForm;

implementation
uses ClipBrd,unit1;

{ TMessageForm }

procedure TMessageForm.TranslateVisual;
begin
     Button1.Caption:=TgClose;
     Button2.Caption:=TgCopyClose;
     Button3.Caption:=TgSaveClose;
end;

procedure TMessageForm.FormCreate(Sender: TObject);
begin
   TranslateVisual;
   font:=DefaultFont;
   with memo1.font do
        begin
         name:=EditDefaultFont.name;
         height:=EditDefaultFont.height;
         quality:=fqAntialiased;
        end;
end;

procedure TMessageForm.Button2Click(Sender: TObject);//copie presse-papier
begin
  ClipBoard.asTeXt:=memo1.text;
  ModalResult:=mrOK
end;

function TMessageForm.savefile:boolean;
var Nom: string;
begin
     Result:=false;
     if MainForm.GetSaveFile(TgSaveAFile,
                    TgFile+' |*',
                    '', Nom)

        then begin
                        Memo1.Lines.SaveToFile(Nom);
                        Result:=true;
             end
end;

procedure TMessageForm.Button3Click(Sender: TObject);//copie fichier
begin
     if savefile then ModalResult:=mrOK else ModalResult:=mrNone;
end;

initialization
  {$I message.lrs}

end.

