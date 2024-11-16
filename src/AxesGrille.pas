unit AxesGrille;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,
 
  {Windows, Messages,} Graphics, Controls, Forms, Dialogs, StdCtrls,Graph1_6,Graph2_7, ExtCtrls,
  LResources, Buttons,untres;
 


type
  TAxesGrilleForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    GroupBox4: TGroupBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    Label7: TLabel;
    Edit7: TEdit;
    Label8: TLabel;
    GroupBox5: TGroupBox;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure TranslateVisual;
  public
    { Déclarations publiques }
    function Valider: Boolean;
  end;

var
  AxesGrilleForm: TAxesGrilleForm;

implementation
uses calculs1,listes2,complex3,analyse4,command5, saisies, Unit1;




procedure TAxesGrilleForm.Button1Click(Sender: TObject);
begin
     if Valider then ModalResult:=mrOk else ModalResult:=mrNone;;
end;

procedure TAxesGrilleForm.Button3Click(Sender: TObject);
begin
     MainForm.GestionAttributs(Edit7.text);
     Button1.SetFocus;
end;

procedure TAxesGrilleForm.TranslateVisual;
begin
     Label7.Caption:=TgName;
     Label8.Caption:=Tg10CarMax;
     GroupBox1.Caption:=TgOrigin;
     GroupBox2.Caption:=TgGraduations;
     GroupBox3.Caption:=TgAxesParameters;
     GroupBox5.Caption:=TgLabelsOrigin;
     RadioGroup1.Caption:=TgOnOxAxe;
     RadioGroup2.Caption:=TgOnOyAxe;
     RadioGroup3.Caption:=TgOnOxAxe;
     RadioGroup4.Caption:=TgOnOyAxe;
     Button3.Caption:=TgAttributes;
end;

procedure TAxesGrilleForm.FormCreate(Sender: TObject);
var p: Pelement;
begin
     TranslateVisual;
     font:=DefaultFont;
     Edit7.Text:=CurrentName;
     if CurrentCat=cat_axes
        then p:=Paxes(CurrentGraph)
        else
            begin
                 p:=Pgrille(Currentgraph);
                 Height:=Height-(GroupBox4.Height+GroupBox5.Height);

                 Button1.Top:=Button1.Top-(GroupBox4.Height+GroupBox5.Height);
                 Button2.Top:=Button1.Top;
                 Button3.Top:=Button1.Top;

                 GroupBox3.visible:=false;
                 GroupBox4.visible:=false;
                 GroupBox5.visible:=false;
                 Caption:= TgGrilleCaption;
            end;

     if p<>nil then
     begin
   p^.lireAttributs;
   Edit1.text:=Streels(Pgrille(p)^.O_x);
   Edit2.text:=Streels(Pgrille(p)^.O_y);
   Edit3.Text:=Streels(Pgrille(p)^.GradX);
   Edit4.text:=Streels(Pgrille(p)^.GradY);
   if CurrentCat=cat_axes then
      begin
           Edit5.text:= Streels(xyticks);
           Edit6.text:= Streels(xylabelsep);
           Radiogroup1.itemIndex:=(xylabelpos And 12) div 4;
           Radiogroup2.itemIndex:=(xylabelpos And 3);
           Radiogroup3.itemIndex:=Paxes(p)^.OriginLabelPosX;
           Radiogroup4.itemIndex:=Paxes(p)^.OriginLabelPosY;
      end
     end else
    begin
     if (Xmin<=0) and (0<=Xmax)
        then Edit1.Text:='0' else Edit1.Text:=Streels((Xmin+Xmax)/2);
     If (Ymin<=0) and (0<=Ymax)
        then Edit2.Text:='0' else Edit2.Text:=Streels((Ymin+Ymax)/2);
     DefaultSettings;
     if CurrentCat=cat_grille then begin
                                   Edit3.Text:='0.25';
                                   Edit4.Text:='0.25';
                                   LineColor:=Rgb(192,192,192);
                                   PColor^.affixe^.setx(graph1_6.LineColor)
                            end
                       else begin  Edit3.Text:='1';
                                   Edit4.Text:='1';
                                   Edit5.text:= Streels(xyticks);
                                   Edit6.text:= Streels(xylabelsep);
                                   Radiogroup1.itemIndex:=(xylabelpos and 12) div 4;
                                   Radiogroup2.itemIndex:=(xylabelpos and 3);
                                   Radiogroup3.itemIndex:=2;
                                   Radiogroup4.itemIndex:=2;
                            end;
   end;
end;

function TAxesGrilleForm.Valider:boolean;
var    Ox,Oy,Gx,Gy,ticks,labelsep:real;
    Chaine:string;
    nom:Tnom;
begin
     Valider:=true;
     if validreal(Edit1,Xmin,Xmax,Ox) and
        validreal(Edit2,Ymin,Ymax,Oy) and
        validreal(Edit3,0,reel_Max,Gx) and
        validreal(Edit4,0,reel_Max,Gy)
        then
            begin
                 nom:=Edit7.text;
                 if CurrentCat=cat_grille
                    then begin
                         chaine:='['+Streels(Ox)+'+i*('+Streels(Oy)+'),'+
                         Streels(Gx)+'+i*('+Streels(Gy)+')]';
                         liste_element.inserer(new(Pgrille,init(nom,chaine)),CurrentGraph);
                         liste_element.supprimer(Pcellule(CurrentGraph));
                         end
                     else
                     if  validreal(Edit5,0,reel_Max,ticks) and
                         validreal(Edit6,0,reel_Max,labelsep) then
                       begin
                          chaine:='['+Streels(Ox)+'+i*('+Streels(Oy)+'),'+
                                  Streels(Gx)+'+i*('+Streels(Gy)+'),'+Streels(Radiogroup3.itemIndex)+
                                  '+i*('+Streels(Radiogroup4.itemIndex)+')]';
                          PxyTicks^.affixe^.setx(ticks);
                          Pxylabelsep^.affixe^.setx(labelsep);
                          PxyLabelpos^.affixe^.setx(Radiogroup2.itemIndex +4*Radiogroup1.ItemIndex);
                          liste_element.inserer(new(Paxes,init(nom,chaine)),CurrentGraph);
                          liste_element.supprimer(Pcellule(CurrentGraph));
                       end
                       else Valider:=false
            end
        else Valider:=false
end;

initialization
   {$i AxesGrille.lrs}

end.
