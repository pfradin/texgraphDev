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

unit SimpleGraph;
{$MODE Delphi}
 //droite cercle point spline bezier implicit
interface
 uses
  SysUtils, Classes, LcLType,
  
  {Windows, Messages,} Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  LResources, Buttons,untres;
  
const    
    fbsSizeable=bsSizeable;
   
type

  { TSimpleGraphForm }

  TSimpleGraphForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label7: TLabel;
    Edit3: TEdit;
    CheckBox1: TCheckBox;
    //Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Déclarations privées }
    procedure TranslateVisual;
  public
    { Déclarations publiques }
    function Valider: Boolean;
  end;

var
  SimpleGraphForm: TSimpleGraphForm;

implementation
uses calculs1, listes2, complex3, analyse4, command5, graph1_6, graph2_7, saisies, Unit1;


  

procedure TSimpleGraphForm.Button1Click(Sender: TObject);
begin
     if Valider then ModalResult:=mrOk else ModalResult:=mrNone;
end;

procedure TSimpleGraphForm.Button3Click(Sender: TObject);
begin
     MainForm.GestionAttributs(Edit1.text);
     Button1.SetFocus
end;

procedure TSimpleGraphForm.TranslateVisual;
begin
     Label1.Caption:=TgName;
     Label2.Caption:=Tg10CarMax;
     Label3.Caption:=TgCommandLine;
     Label7.Caption:=TgText;
     Button3.Caption:=TgAttributes;
     CheckBox1.Caption:=TgClosed;
     RadioGroup1.Caption:=TgRepresent;
end;

procedure TSimpleGraphForm.FormCreate(Sender: TObject);
var p:Pelement;
begin
     TranslateVisual;
     Font:=DefaultFont;
     {$IFDEF WINDOWS}
     Memo2.ParentFont:=true;
     {$ENDIF}

     digits:=12;
     p:=CurrentGraph;
     if currentCat=cat_utilisateur
                    then
                        begin
                                Width:=650;
                                BorderStyle:=fbsSizeable
                        end;
     Edit1.Text:=CurrentName;
     if p<>nil
        then
            begin
                 Edit2.text:=p^.LigneCommande;
                 case currentCat of
                 cat_label: edit3.text:=PLabel(p)^.texte;
                 cat_polygone: begin
                                 edit3.text:=Streel(PLigne(p)^.rayon);
                                 Checkbox1.checked:=(Pligne(p)^.fermee=1);
                               end;
                 cat_path: Checkbox1.checked:=(PPath(p)^.closelastpath);
                 cat_ellipticarc: Checkbox1.checked:=(Pellipticarc(p)^.sens=1);
                 cat_equadif: RadioGroup1.ItemIndex:=Pequadif(p)^.mode;
                 end;
                 p^.lireAttributs;
            end else
                    begin
                         DefaultSettings;
                         Edit2.Text:='[  ]';
                         case currentCat of
                         cat_label: edit3.text:='';
                         cat_polygone: begin
                                            edit3.text:='0';
                                            Checkbox1.checked:=false;
                                       end;
                         cat_path: Checkbox1.checked:=false;
                         cat_ellipticarc: Checkbox1.checked:=true;
                         cat_equadif: RadioGroup1.ItemIndex:=0;
                         end;

                    end;
     Case CurrentCat of
     cat_dot: begin
                      Caption:=TgCat_dotCaption;
                      memo2.text:=TgCat_dotHelp;
               end;
     cat_droite: begin
                      Caption:=TgDroiteCaption;
                      memo2.text:=TgDroiteHelp;
                 end;
     cat_ellipse: begin
                      Caption:=TgEllipseCaption;
                      memo2.text:=TgEllipseHelp;
                 end;
     cat_Spline: begin
                      Caption:=TgSplineCaption;
                      memo2.text:=TgSplineHelp;
                 end;
     cat_bezier: begin
                      Caption:=TgBezierCaption;
                      memo2.text:=TgBezierHelp;
                 end;
     cat_implicit: begin
                      Caption:=TgImplicitCaption;
                      memo2.text:=TgImplicitHelp;
                 end;
     cat_Label: begin
                      Caption:=TgLabelCaption;
                      Label3.Caption:=TgLabelCaption3;
                      Edit2.left:=edit1.Left; edit2.width:=edit1.width;
                      memo2.top:=Edit3.top+Edit3.Height+2;
                      memo2.Height:=-memo2.top+Button1.top-7;
                      memo2.text:=TgLabelHelp;
                      Label7.Caption:=TgLabelCaption7;
                      Label7.visible:=true;
                      Edit3.visible:=true;
                 end;
     cat_polygone: begin
                      Caption:=TgPolylineCaption;
                      checkBox1.caption:=TgPolylineCaption1;
                      checkBox1.visible:=true;
                      Label7.Caption:=TgPolylineCaption7;
                      Edit3.Width:=Edit1.Width;
                      memo2.top:=Edit3.top+Edit3.Height+2;
                      memo2.Height:=-memo2.top+Button1.top-5;
                      memo2.text:=TgPolylineHelp;
                      Label7.visible:=true;
                      Edit3.visible:=true;
                      checkBox1.visible:=true;
                 end;
     cat_path: begin
                      Caption:=TgPathCaption;
                      checkBox1.caption:=TgPathCaption1;
                      CheckBox1.left:=Edit1.left;
                      checkBox1.visible:=false;
                      checkBox1.anchors:=[akTop, akLeft];
                      checkBox1.left:=Edit1.left;
                      memo2.top:=Edit3.top+Edit3.Height+2;
                      memo2.Height:=-memo2.top+Button1.top-5;
                      memo2.text:=TgPathHelp;
                      checkBox1.visible:=true;
                 end;
     cat_ellipticArc: begin
                      Caption:=TgEllipticArcCaption;
                      CheckBox1.left:=Edit1.left;
                      checkBox1.visible:=true;
                      checkBox1.anchors:=[akTop, akLeft];
                      CheckBox1.Caption:=TgEllipticArcCaption1;
                      memo2.top:=Edit3.top+Edit3.Height+2;
                      memo2.Height:=-memo2.top+Button1.top-7;
                      memo2.text:=TgEllipticArcHelp;
                      CheckBox1.visible:=true;
                 end;

     cat_Equadif: begin
                      Caption:=TgEquaDiffCaption;
                      RadioGroup1.visible:=true;
                      RadioGroup1.top:=memo2.top-7;
                      RadioGroup1.height:=memo2.height+7;
                      memo2.left:=RadioGroup1.left+Radiogroup1.Width+2;
                      memo2.Width:=Edit3.left+Edit3.width-memo2.left;
                      memo2.text:=TgEquaDiffHelp;
                 end;
     end;
     digits:=4;
end;

{procedure TSimpleGraphForm.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key=VK_tab then
     begin
          Button1.SetFocus;
          Key:=0
     end;
end;}

function TSimpleGraphForm.Valider:boolean;
var nom:Tnom;
    p,q:Pelement;
    f:Pexpression;
    R:real;
    sens:integer;
    commande:string;
begin
     Valider:=true;
     nom:=Edit1.text;
     p:=CurrentGraph;
     if NomValide(nom,p<>nil) then
           begin
                 new(f,init);
                 commande:=Edit2.text;
                 if not f^.definir(commande)
                    then
                        begin
                             Messagedlg(ErrorMessage,mtWarning,[mbok],0);
                             Edit2.selStart:=ErrorPos-1;
                             Edit2.SelLength:=1;
                             Edit2.SetFocus;
                             Valider:=false
                        end
                    else
                         begin
                              //if p<>nil then liste_element.supprimer(Pcellule(p));
                              case CurrentCat of
                              cat_dot: q:=new(PDot,init(Nom,Edit2.Text));
                              cat_droite: q:=new(PDroite,init(Nom,Edit2.Text));
                              cat_ellipse: q:=new(Pellipse,init(Nom,Edit2.Text));
                              cat_implicit: q:=new(PImplicit,init(Nom,Edit2.Text));
                              cat_bezier: q:=new(PBezier,init(Nom,Edit2.Text));
                              cat_spline: q:=new(PSpline,init(Nom,Edit2.Text));
                              cat_label: q:=new(PLabel,init(Nom,Edit2.Text,Edit3.text));
                              cat_path:  q:=new(PPath,init(Nom,Edit2.text,byte(Checkbox1.checked)));
                              cat_polygone:  if validReal(edit3,0,reel_Max,R) then
                                            q:=new(Pligne,init(Nom,Edit2.text,byte(Checkbox1.checked),R))
                                            else begin Valider:=false; dispose(f,detruire); exit end;
                              cat_ellipticarc:  begin
                                               if checkbox1.checked then sens:=1 else sens:=-1;
                                               q:=new(PEllipticArc,init(Nom,Edit2.Text,sens));
                                        end;
                              cat_equadif:  q:=new(PEquadif,init(Nom,Edit2.Text,RadioGroup1.ItemIndex));
                              end;
                              if p=nil then ajouter_element(q)
                                       else begin
                                                 liste_element.inserer(q,p);
                                                 liste_element.supprimer(Pcellule(p));
                                            end;
                         end;
                 dispose(f,detruire)
           end
           else begin
                     Messagedlg(Edit1.text+': nom invalide ou déjà pris!',mtWarning,[mbok],0);
                     Edit1.selectAll; Edit1.SetFocus; Valider:=false
                end
end;

initialization

  {$i SimpleGraph.lrs}

end.
