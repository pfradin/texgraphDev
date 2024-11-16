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
unit config;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, untres;

type

  { TConfigFile }

  TConfigFile = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { private declarations }
    procedure TranslateVisual;
  public
    { public declarations }
    function valider:boolean;
  end; 

var
  ConfigFile: TConfigFile;
  workdir,pdfreader,ImageViewer,javaviewdir,webload:string;

implementation
uses complex3,analyse4,command10,unit1;

{ TConfigFile }

procedure TConfigFile.SpeedButton1Click(Sender: TObject);
begin
     if SelectDirectoryDialog1.Execute
        then begin
                   workdir:=SelectDirectoryDialog1.FileName;
                   Edit1.text:=workdir;
             end;
end;

procedure TConfigFile.SpeedButton2Click(Sender: TObject);
var nom:TfileName;
begin
    Nom:='';
    if MainForm.GetOpenFile('PdfReader',TgProgrammes,'',Nom)
    and (Nom<>'') then Edit2.text:=Nom
end;

procedure TConfigFile.SpeedButton3Click(Sender: TObject);
begin
   FontDialog1.font.name:=DefaultFont.name;
   FontDialog1.font.height:=DefaultFont.height;
   if FontDialog1.execute then
           begin
                DefaultFont.name:=FontDialog1.font.name;
                DefaultFont.height:=FontDialog1.font.height;
                Edit3.text:=DefaultFont.Name
           end;
end;

procedure TConfigFile.SpeedButton5Click(Sender: TObject);
begin
     if SelectDirectoryDialog1.Execute
        then begin
                   javaviewdir:=SelectDirectoryDialog1.FileName;
                   Edit5.text:=javaviewdir;
             end;
end;

procedure TConfigFile.SpeedButton6Click(Sender: TObject);
var nom:TfileName;
begin
    Nom:='';
    if MainForm.GetOpenFile('ImageViewer',TgProgrammes,'',Nom)
    and (Nom<>'') then Edit7.text:=Nom
end;

procedure TConfigFile.TranslateVisual;
begin
     Caption:=TgConfigFileForm;
     Label1.Caption:=TgWorkDir+' =';
     Label3.Caption:=TgInterfaceFont+' =';
     Label5.Caption:=TgJavaviewDir+' =';
     Label6.Caption:=TgDownLoads+' =';
end;

procedure TConfigFile.FormCreate(Sender: TObject);
begin
     TranslateVisual;
     Font:=DefaultFont;
     Edit1.text:=workdir;
     Edit2.Text:=pdfreader;
     Edit3.text:=DefaultFont.name;
     Edit5.text:=javaviewdir;
     Edit6.text:=webload;
     Edit7.text:=ImageViewer;
end;


procedure TConfigFile.Button1Click(Sender: TObject);
begin
   if Valider then ModalResult:=mrOk else ModalResult:=mrNone;
end;

function TConfigFile.valider:boolean;
var m:Pconstante;
begin
    Valider:=false;
    if not DirectoryExists(Edit1.text) then
       begin
            Messagedlg(TgWorkDirNotValid,mtWarning,[mbOk],0);
            Edit1.selectall;
            Edit1.setfocus
       end
    else
    if (Edit5.text<>'') and (not DirectoryExists(Edit5.text)) then
       begin
            Messagedlg(TgJavaViewDirNotValid,mtWarning,[mbOk],0);
            Edit5.selectall;
            Edit5.setfocus
       end
    else
       begin
            Valider:=true;
            workdir:=Edit1.text;
            pdfreader:=Edit2.text; m:=constante('PdfReader'); Pchaine(m^.affixe)^.chaine:=pdfreader;
            ImageViewer:=Edit7.text; m:=constante('ImageViewer'); Pchaine(m^.affixe)^.chaine:=ImageViewer;
            javaviewdir:=Edit5.text; m:=constante('JavaviewPath');
            if (javaviewdir='') or (javaviewdir[length(javaviewdir)]=sep) then Pchaine(m^.affixe)^.chaine:= javaviewdir
               else Pchaine(m^.affixe)^.chaine:= javaviewdir+sep;
            if Edit6.text='' then webload:='wget --no-check-certificate'
               else  webload:=Edit6.text;
            m:=constante('WebLoad'); Pchaine(m^.affixe)^.chaine:=webload;
       end;
end;

initialization
  {$I config.lrs}
  pdfreader:='';
  javaviewdir:='';
  webload:='wget --no-check-certificate'
end.

