{Copyright (C) 2005-2008 (Patrick FRADIN)
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

unit snapshot;

{$mode Delphi}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, untres;

type

  { Tsnapshot }

  Tsnapshot = class(TForm)
    Montrer: TCheckBox;
    Ok: TButton;
    Cancel: TButton;
    choixexport: TRadioGroup;
    choixextension: TRadioGroup;
    choixdensite: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure OkClick(Sender: TObject);
  private
    { private declarations }
    Nom:string;
    procedure TranslateVisual;
  public
    { public declarations }
    function Valider: Boolean;
  end; 

var
  snapshotform: Tsnapshot;
  snapCommande:string;

implementation
uses command5,graph1_6,Unit1;

{ Tsnapshot }
procedure Tsnapshot.TranslateVisual;
begin
    Caption:=TgSnapshotTitle;
    ChoixExport.Caption:=TgChoixExport;
    ChoixExport.Items[0]:=TgExport1;
    ChoixExport.Items[1]:=TgExport2;
    ChoixExport.Items[2]:=TgExport3;
    ChoixExport.Items[3]:=TgExport4;
    ChoixExport.Items[4]:=TgExport5;

    ChoixExtension.Caption:=TgConversion;

    ChoixDensite.Caption:=TgChoixDensite;
    ChoixDensite.Items[0]:=TgDensite1;
    ChoixDensite.Items[1]:=TgDensite2;
    Montrer.Caption:=TgMontrer;
end;

procedure Tsnapshot.FormCreate(Sender: TObject);
begin
  TranslateVisual;
  font:=DefaultFont;
end;

procedure Tsnapshot.OkClick(Sender: TObject);
var rep:integer;
begin
    if Valider then
       begin
              ModalResult:=mrOk;
              Caption:=TgSnapshotWait;
              case choixExport.ItemIndex of
              0: rep:=eps;
              1: rep:=compileeps;
              2: rep:=pdf;
              3: rep:=compilepdf;
              4: begin ExportJpeg:=true; rep:=bmp; end;
              end;
              snapCommande:='\Snapshot('+IntToStr(rep)+','+IntToStr(choixDensite.ItemIndex)+',"'+Nom+'",'+ IntToStr(byte(Montrer.checked))+')';
       end else ModalResult:=mrNone;
end;


function Tsnapshot.Valider:boolean;
var
    ext:string;
begin
    result:=true;

    if choixExtension.ItemIndex=0 then ext:='png' else ext:='jpg';
    Nom :=Filename;
    if Nom='' then Nom:='*.'+ext else Nom:=ChangeFileExt(Nom,'.'+ext); //delete(Nom,Length(Nom)-2,3);
    result:= MainForm.GetSaveFile(TgSaveAFile,'Image',ext, Nom);

end;


initialization
  {$I snapshot.lrs}

end.

