program Project1;

uses
  Forms,
  Windows,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2};

{$R *.RES}

begin
//  If (FindWindow('TForm1','Easter''s Lamb v1.0')=0) Or
//     (FindWindow('TForm2','Form2')=0) Then
    Begin
      Application.Initialize;
//      Application.Title:='';
      Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
    End
end.
