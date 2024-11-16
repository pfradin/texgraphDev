unit Attributs;

{$MODE Delphi}

interface

uses
  SysUtils, Classes,
  
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Spin,
  LResources, Buttons, ComCtrls,untres;

type

  { TAttributsForm }

  TAttributsForm = class(TForm)
    CheckBox17: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBoxEofill: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBoxForMinToMax: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    EditDotSize: TEdit;
    EditDotAngle: TEdit;
    EditDotscale: TEdit;
    EditFillopacity: TEdit;
    EditMatrix: TEdit;
    EditStrokeOpacity: TEdit;
    EditDashpattern: TEdit;
    EditMiterlimit: TEdit;
    Groupwidth: TGroupBox;
    Grouplabelstyle: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    LabelDashPatternHelp: TLabel;
    LabeldotsizeHelp: TLabel;
    LabeldotscaleHelp: TLabel;
    LabeldotangleHelp: TLabel;
    LabelDotSize: TLabel;
    LabelDotAngle: TLabel;
    LabelDotScale: TLabel;
    LabelFillOpacity: TLabel;
    LabelStrokeOpacity: TLabel;
    LabelMiterlimit: TLabel;
    LabelDashPattern: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    PageControl1: TPageControl;
    RadioGroupDot: TRadioGroup;
    RadioGroupFillStyle: TRadioGroup;
    Radiolinestyle: TRadioGroup;
    Radioarrows: TRadioGroup;
    CheckBoxReCalc: TCheckBox;
    GroupBoxColors: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    ColorDialog1: TColorDialog;
    Radiolinecap: TRadioGroup;
    RadioGroup7: TRadioGroup;
    RadioGroup8: TRadioGroup;
    Radiolinejoin: TRadioGroup;
    Shape1: TShape;
    Shape2: TShape;
    Radiolabelsize: TRadioGroup;
    Grouplabelangle: TGroupBox;
    Edit5: TEdit;
    Label8: TLabel;
    GroupBoxModify: TGroupBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBoxEstVisible: TCheckBox;
    CheckBox19: TCheckBox;
    TabParametert: TTabSheet;
    TabLabel: TTabSheet;
    TabLine: TTabSheet;
    TabFill: TTabSheet;
    TabMatrix: TTabSheet;
    TabDot: TTabSheet;
    procedure ButtonOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBoxForMinToMaxClick(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure CheckBox12Click(Sender: TObject);
    procedure CheckBox13Click(Sender: TObject);
    procedure CheckBox14Click(Sender: TObject);
    procedure CheckBox15Click(Sender: TObject);
    procedure CheckBox16Click(Sender: TObject);
    procedure RadiolinestyleClick(Sender: TObject);
    procedure RadioGroupFillStyleClick(Sender: TObject);
    procedure CheckBox19Click(Sender: TObject);
    //procedure RadiolinestyleClick(Sender: TObject);
  private
    { Déclarations privées }
    TheColor, TheFillColor:longint;
    procedure TranslateVisual;
  public
    { Déclarations publiques }
    function Valider: Boolean;
  end;

var
  AttributsForm: TAttributsForm;
  multiselection:boolean;

implementation
uses calculs1{calculs},listes2, complex3,analyse4,command5, graph1_6,saisies, unit1;




procedure TAttributsForm.ButtonOkClick(Sender: TObject);
begin
     if Valider then ModalResult:=mrOk else ModalResult:=mrNone;
end;

procedure TAttributsForm.TranslateVisual;
begin
     Caption:=TgAttributes;
     TabParametert.Caption:=TgParametert;
     CheckBoxForMinToMax.caption:=TgInterval+' [Xmin,Xmax]';
     Label9.Caption:=TgDotHelp;
     Label10.Caption:=TgMatrixHelp;
end;

procedure TAttributsForm.FormCreate(Sender: TObject);
var f:Pexpression;
    T:Presult;
begin
     TranslateVisual;
     font:=DefaultFont;
     digits:=12;
     if not multiselection then
        begin
                GroupBoxModify.visible:=false;
                width:= GroupBoxModify.left;
        end
        else begin
               checkBox6.checked:= false; TabParametert.enabled:=false;
               checkBox7.checked:= false; TabDot.enabled:=false;
               checkBox8.checked:= false; Radiolinestyle.enabled:=false;
               checkBox9.checked:= false; Groupwidth.enabled:=false;
               checkBox10.checked:= false; Radioarrows.enabled:=false;
               checkBox11.checked:= false; RadioGroupFillStyle.enabled:=false;
               checkBox12.checked:= false; Grouplabelstyle.enabled:=false;
               checkBox13.checked:= false; Grouplabelangle.enabled:=false;
               checkBox14.checked:= false; Radiolabelsize.enabled:=false;
               checkBox15.checked:= false; Button1.enabled:=false;
               checkBox16.checked:= false; Button2.enabled:=false;
               checkBox17.checked:= false;
               checkBox19.checked:= false; TabMatrix.enabled:=false;
             end;

     Edit1.text:=Streel(Tmin);
     Edit2.text:=Streel(Tmax);
     Edit3.text:=Streel(NbPoints);
     Edit4.text:=Streel(graph1_6.linewidth);
     Edit5.text:=Streel(Labelangle);
     EditFillopacity.text:=Streel(FillOpacity);
     EditStrokeOpacity.text:=Streel(StrokeOpacity);
     EditDashPattern.text:=CurrentPattern^.en_chaine;
     EditMiterLimit.text:=Streel(miterlimit);
     if Dotscale<>Nil then EditDotScale.text:=DotScale^.en_chaine else EditDotScale.text:='1+i';
     if DotSize<>Nil then EditDotSize.text:=DotSize^.en_chaine else EditDotSize.text:='2+2*i';
     EditDotAngle.text:=Streel(DotAngle);

     new(f,init);
     f^.definir('['+Streel(Currentmatrix[5])+'+i*('+Streel(Currentmatrix[6])+'),'+
                           Streel(Currentmatrix[1])+'+i*('+Streel(Currentmatrix[2])+'),'+
                           Streel(Currentmatrix[3])+'+i*('+Streel(Currentmatrix[4])+')]');
     if f<>Nil then T:=f^.evaluer else T:=Nil;
     if T<>Nil then EditMatrix.text:=T^.en_chaine else EditMatrix.text:='[0,1,i]';
     Kill(Pcellule(T));
     dispose(f,detruire);
     RadioLineJoin.ItemIndex:=LineJoin;
     RadioLineCap.ItemIndex:=LineCap;

     RadioGroupDot.ItemIndex:=DotStyle;
     Radiolinestyle.ItemIndex:=1+LineStyle;
     Radiolabelsize.ItemIndex:=LabelSize;
     Radioarrows.ItemIndex:= Arrows;
     CheckBoxReCalc.checked:=  (AutoReCalc=1);
     CheckBoxEstVisible.checked:= EstVisible;
     CheckBoxEofill.checked:= EOfill;
     RadioGroupFillStyle.ItemIndex:=FillStyle;
     RadioGroup7.ItemIndex:= (LabelStyle And 3); //style horizontal, 2 premiers octets
     RadioGroup8.ItemIndex:= (LabelStyle And 12) div 4; //style vertical, 2 octets suivants
     CheckBox2.checked:=  (LabelStyle And 16=16); //style framed: octet suivant
     CheckBox3.checked:=  (LabelStyle And 32=32); //style stacked: octet suivant
     CheckBox4.checked:=  (LabelStyle And 64=64); //spécial: octet suivant
     CheckBoxForMinToMax.checked:=  ForMinToMax;
     checkBox17.checked:= TeXLabel;
     EditFillOpacity.enabled:=  (RadioGroupFillStyle.ItemIndex=1);
     EditStrokeOpacity.enabled:=  (Radiolinestyle.ItemIndex>0);
     EditDashPattern.enabled:= (Radiolinestyle.ItemIndex=4);
     CheckBoxEofill.enabled:= (RadioGroupFillStyle.ItemIndex>0);

     if ForMinToMax then
        begin
                Edit1.enabled:=false; Edit2.enabled:=false;
        end;
     Thecolor:=Linecolor;
     TheFillcolor:=Fillcolor;
     shape1.brush.color:=Thecolor;
     shape2.brush.color:=Thefillcolor;
     digits:=4;

end;

function TAttributsForm.Valider:boolean;
var f:Pexpression;
    T:paffixe;
begin
     Valider:=true;
     if
        (checkBox6.checked and not(validReal(edit1,-reel_Max,reel_Max,Tmin) and validReal(edit2,-reel_Max,reel_Max,Tmax)
             and validInteger(edit3,0,1000000,NbPoints)))
        or
        (checkBox7.checked and not(validReal(editDotAngle,-360,360,Dotangle)))
        or
        (checkBox9.checked and (not validInteger(edit4,1,32767,graph1_6.linewidth)))
        or
        (checkBox13.checked and (not validreal(edit5,-360,360,Labelangle)))
        or
        (checkBox11.checked and (not validreal(EditFillopacity,0,1,FillOpacity)))
         or
        (not validInteger(editMiterLimit,0,2500,MiterLimit))
        or
        (checkBox8.checked and (not validreal(EditStrokeOpacity,0,1,StrokeOpacity)))
             then
     begin  Valider:=false end
     else begin
     if checkBox7.checked then Dotstyle:=RadioGroupDot.ItemIndex;
     if checkBox8.checked then Linestyle:=Radiolinestyle.ItemIndex-1;
     LineJoin:=RadiolineJoin.ItemIndex; LineCap:=RadiolineCap.ItemIndex;
     if EditDashPattern.enabled then begin
                                        new(f,init); f^.definir(EditDashPattern.text);
                                        T:=f^.evalNum;
                                        if (T<>Nil) and (T^.suivant<>Nil) then
                                           begin
                                                Kill(pcellule(currentPattern));
                                                currentPattern:=T
                                           end
                                        else Kill(pcellule(T));
                                        dispose(f,detruire)
                                   end;
     if checkBox7.enabled then begin
                                        new(f,init); f^.definir(EditDotScale.text);
                                        T:=f^.evalNum;
                                        if (T<>Nil) then
                                            begin
                                                Kill(pcellule(DotScale));
                                                DotScale:=T
                                           end
                                        else Kill(pcellule(T));
                                        dispose(f,detruire);
                                        new(f,init); f^.definir(EditDotSize.text);
                                        T:=f^.evalNum;
                                        if (T<>Nil) then
                                            begin
                                                Kill(pcellule(DotSize));
                                                DotSize:=T
                                           end
                                        else Kill(pcellule(T));
                                        dispose(f,detruire)
                                   end;
     if checkBox10.checked then Arrows:=Radioarrows.ItemIndex;
     AutoReCalc:=byte(CheckBoxReCalc.checked);
     EstVisible:=CheckBoxEstVisible.checked;
     Eofill:=CheckBoxEofill.checked;
     if checkBox11.checked then FillStyle:=RadioGroupFillStyle.ItemIndex;
     if checkBox12.checked then
                                begin
                                LabelStyle:= RadioGroup7.ItemIndex+4*RadioGroup8.ItemIndex+
                               16*byte(CheckBox2.checked)+32*byte(CheckBox3.checked)+64*byte(CheckBox4.checked);
                                TeXLabel:= CheckBox17.checked;
                                end;
     if checkBox14.checked then LabelSize:=Radiolabelsize.ItemIndex;
     if checkBox15.checked then LineColor:=TheColor;
     if checkBox16.checked then FillColor:=TheFillColor;
     if checkBox6.checked then ForMinToMax:=CheckBoxForMinToMax.checked;
     if checkBox19.checked then Executer('SetMatrix('+EditMatrix.text+')');
     if not multiselection then SetAttributs;
     end;

end;

procedure TAttributsForm.Button1Click(Sender: TObject);
begin
       Colordialog1.Color:=TheColor;
       if ColorDialog1.Execute
          then begin
                    TheColor:=Colordialog1.Color;
                    Shape1.brush.color:=theColor;
                    ButtonOk.setFocus
                end;
end;

procedure TAttributsForm.Button2Click(Sender: TObject);
begin
       Colordialog1.Color:=TheFillColor;
       if ColorDialog1.Execute
          then begin
                    TheFillColor:=Colordialog1.Color;
                    Shape2.brush.color:=ThefillColor;
                    ButtonOk.setFocus
               end;
end;

procedure TAttributsForm.CheckBoxForMinToMaxClick(Sender: TObject);
begin
      if CheckBoxForMinToMax.checked
        then
        begin
                Edit1.text:=Streel(Xmin);
                Edit2.text:=Streel(Xmax);
                Edit1.enabled:=false; Edit2.enabled:=false;
        end else
        begin
                Edit1.enabled:=true; Edit2.enabled:=true;
        end;
end;


procedure TAttributsForm.CheckBox6Click(Sender: TObject);
begin
      TabParametert.enabled:=checkBox6.checked;
end;

procedure TAttributsForm.CheckBox7Click(Sender: TObject);
begin
      TabDot.enabled:=checkBox7.checked;
end;

procedure TAttributsForm.CheckBox8Click(Sender: TObject);
begin
      Radiolinestyle.enabled:=checkBox8.checked;
end;

procedure TAttributsForm.CheckBox9Click(Sender: TObject);
begin
       Groupwidth.enabled:=checkBox9.checked;
end;

procedure TAttributsForm.CheckBox10Click(Sender: TObject);
begin
      Radioarrows.enabled:=checkBox10.checked;
end;

procedure TAttributsForm.CheckBox11Click(Sender: TObject);
begin
     RadioGroupFillStyle.enabled:=checkBox11.checked;
end;

procedure TAttributsForm.CheckBox12Click(Sender: TObject);
begin
     Grouplabelstyle.enabled:=checkBox12.checked;
end;

procedure TAttributsForm.CheckBox13Click(Sender: TObject);
begin
     Grouplabelangle.enabled:=checkBox13.checked;
end;

procedure TAttributsForm.CheckBox14Click(Sender: TObject);
begin
      Radiolabelsize.enabled:=checkBox14.checked;
end;

procedure TAttributsForm.CheckBox15Click(Sender: TObject);
begin
      Button1.enabled:=checkBox15.checked;
end;

procedure TAttributsForm.CheckBox16Click(Sender: TObject);
begin
     Button2.enabled:=checkBox16.checked;
end;

procedure TAttributsForm.RadioGroupFillStyleClick(Sender: TObject);
begin
      EditFillopacity.enabled:=RadioGroupFillStyle.ItemIndex=1;
      CheckBoxEofill.enabled:=  RadioGroupFillStyle.ItemIndex>0
end;

procedure TAttributsForm.CheckBox19Click(Sender: TObject);
begin
     TabMatrix.enabled:=checkBox19.checked;
end;

procedure TAttributsForm.RadiolinestyleClick(Sender: TObject);
begin
      EditDashPattern.enabled:=Radiolinestyle.ItemIndex=4;
      EditStrokeOpacity.enabled:=  Radiolinestyle.ItemIndex>0
end;

initialization
  {$i Attributs.lrs}
end.
