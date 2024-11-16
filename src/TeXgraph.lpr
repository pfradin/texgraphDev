program TeXgraph;

{$mode Delphi}
//{$codepage utf8}// -Fcutf8
//{$DEFINE EnableUTF8RTL}// -dEnableUTF8RTL

uses
  
  //{$ifdef unix}
    //cthreads,
  //{$endif}
  Interfaces,
  Forms, sysUtils,
  calculs1 in 'calculs1.pas',
  command5 in 'command5.pas',
  graph1_6 in 'graph1_6.pas',
  graph2_7 in 'graph2_7.pas',
  saisies in 'saisies.pas',
  Fenetre in 'Fenetre.pas' {FenetreForm},
  Marges in 'Marges.pas' {MargesForm},
  Editeur in 'Editeur.pas' {EditForm},
  Attributs in 'Attributs.pas' {AttributsForm},
  Input in 'Input.pas' {InputForm},
  Apropos in 'Apropos.pas' {AproposForm},
  analyse4 in 'analyse4.pas',
  PressePap in 'PressePap.pas' {PressePapier},

  command53d in 'command53d.pas',
  command10 in 'command10.pas',
  Unit1 in 'Unit1.pas' {MainForm},
  command11, Snapshot, LResources, update13, untres, complex3, command9;
//{$IFDEF MSWINDOWS}
//{$R icon.res}
//{$ENDIF}
//qtobjects.pas
//{$IFDEF WINDOWS}{$R TeXgraph.rc}{$ENDIF}

var I:integer;
    fichier: string;

begin
      {$I TeXgraph.lrs}
      DefaultFormatSettings.DecimalSeparator:='.';
  Application.Title:='TeXgraph 2.0';
      Application.Initialize;
      Application.CreateForm(TMainForm, MainForm);
      for I := 1 to ParamCount do
      begin
        fichier:=ParamStr(I);
        if (fichier<>'') and (fichier[1]<>'-') then
           If not FileExists(fichier) then AfficheMessage(TgNotExist+ParamStr(I))
                    else  begin
                                if ExtractFileExt(fichier)='.mac' then
                                   begin macroStatut:=predefMac;
                                         MainForm.lire_fichier(fichier)
                                   end
                                else with MainForm do
                                     begin
                                          macroStatut:=userMac;
                                          AddRecentFile;
                                          FileName:=fichier;
                                          CleanRecentFile(fichier);
                                          CurrentDir:=ExtractFilePath(fichier);
                                          ChDir(CurrentDir);
                                          LoadFile
                                     end

                          end;
     end;
     MainForm.dessiner;
     MainForm.invalidate;
     Application.Run;
end.
