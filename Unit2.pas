unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, CoolForm, Menus, CoolButton, Buttons, StdCtrls, TrMemo,
  _Easysize_;

type
  TForm2 = class(TForm)
    CoolForm1: TCoolForm;
    MainMenu1: TMainMenu;
    Fisier1: TMenuItem;
    Close1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    FormResizer1: TFormResizer;
    procedure CoolForm1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm2.CoolForm1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Width:=126;
  Height:=90;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
  If LanguageName='EN' Then
    Form2.Label1.Caption:='Easter''s Lamb '+Form1.Label3.Caption+' Compiled: '+Form1.Label1.Caption+' Source code: '+Form1.Label2.Caption+' lines www.stedanarh.go.ro'
  Else
    Form2.Label1.Caption:='Mielul de Pasti '+Form1.Label3.Caption+' Compilare: '+Form1.Label1.Caption+' Cod sursa: '+Form1.Label2.Caption+' linii www.stedanarh.go.ro';
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

end.
