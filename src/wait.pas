unit wait;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TPleaseWait }

  TPleaseWait = class(TForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  PleaseWait: TPleaseWait;

implementation
uses Unit1;

{ TPleaseWait }

procedure TPleaseWait.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CalculusDone:=true;
end;

procedure TPleaseWait.FormCreate(Sender: TObject);
begin
  font:=DefaultFont;
end;

procedure TPleaseWait.FormPaint(Sender: TObject);
begin
  MyThread.start;
  repeat Application.ProcessMessages; Sleep(100) until CalculusDone;
  Close
end;

procedure TPleaseWait.FormShow(Sender: TObject);
begin

end;



initialization
  {$I wait.lrs}
end.

