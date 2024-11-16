unit camera;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls,untres;

type

  { TCameraForm }

  TCameraForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { private declarations }
    procedure TranslateVisual;
  public
    { public declarations }
    function valider: boolean;
  end; 

var
  CameraForm: TCameraForm;

implementation
uses calculs1, complex3, command53d, saisies,unit1;
{ TCameraForm }

procedure TCameraForm.TranslateVisual;
begin
     Caption:=TgCamera;
     Label1.Caption:=TgCameraHelp;
     RadioGroup1.CAption:=TgDefinition;
     GroupBox1.Caption:=TgPosition;
     GroupBox2.Caption:=TgDistance;
end;

procedure TCameraForm.FormCreate(Sender: TObject);
begin
  TranslateVisual;
  font:=DefaultFont;
  CalculerN;
  digits:=12;
  Edit1.text:=Streel(posCam.x);
  Edit2.text:=Streel(posCam.y);
  Edit3.text:=Streel(posCam.z);
  Edit4.text:=Streel(Dcamera);
  digits:=4;
  RadioGroup1.ItemIndex:=0;
  GroupBox2.Enabled:=false;
end;

procedure TCameraForm.RadioGroup1Click(Sender: TObject);
begin
     if RadioGroup1.ItemIndex=0 then
        begin
             GroupBox1.enabled:=true;
             GroupBox2.enabled:=false;
        end
     else
         begin
             GroupBox2.enabled:=true;
             GroupBox1.enabled:=false;
        end
end;

procedure TCameraForm.Button1Click(Sender: TObject);
begin
  if Valider then ModalResult:=mrOK else ModalResult:=mrNone
end;


function TCameraForm.valider:boolean;
var M:Tpt3d;
    dist:real;
begin
  if ((RadioGroup1.ItemIndex=0) //position
       and validReal(edit1,-reel_Max,reel_Max,M.x) and
           validReal(edit2,-reel_Max,reel_Max,M.y) and
           validReal(edit3,-reel_Max,reel_Max,M.z))
     or
      ((RadioGroup1.ItemIndex=1) and validReal(edit4,0,reel_Max,dist)) then
    begin
          if RadioGroup1.ItemIndex=1
             then
              begin
                   M.x:=dist*N.x; M.y:=dist*N.y; M.z:=dist*N.z;
              end;
          Valider:=deplaceCam(M)
    end
    else Valider:=false
end;


initialization
  {$I camera.lrs}

end.

