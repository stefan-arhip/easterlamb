unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, CoolForm, Registry, StdCtrls, ShellApi, _Easysize_;

Const LanguageName:String ='EN';
      GhostPercent:Integer=30;
      AllGhostWindows:Boolean=True;
      HeartBeat:Integer=100;
      BlinkEyes:Integer=50;
      SizeForm:Real=1.0;
      wm_IconNotification = wm_User + 1909;
      WS_EX_LAYERED       = $80000;
      LWA_COLORKEY        = 1;
      LWA_ALPHA           = 2;

type
 TSetLayeredWindowAttributes = function (
     hwnd : HWND;         // handle to the layered window
     crKey : TColor;      // specifies the color key
     bAlpha : byte;       // value for the blend function
     dwFlags : DWORD      // action
     ): BOOL; stdcall;

procedure SetTransparentForm(AHandle : THandle; AValue : byte);

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    About1: TMenuItem;
    N1: TMenuItem;
    OnTop1: TMenuItem;
    StartUp1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Easter2: TMenuItem;
    N5: TMenuItem;
    Language1: TMenuItem;
    English1: TMenuItem;
    Romanian1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    About2: TMenuItem;
    Exit2: TMenuItem;
    Timer1: TTimer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Taskbar1: TMenuItem;
    Showin1: TMenuItem;
    N4: TMenuItem;
    None1: TMenuItem;
    Tray1: TMenuItem;
    ImageList1: TImageList;
    History1: TMenuItem;
    Ghost1: TMenuItem;
    Label3: TLabel;
    N001: TMenuItem;
    N101: TMenuItem;
    N201: TMenuItem;
    N301: TMenuItem;
    N401: TMenuItem;
    N501: TMenuItem;
    N601: TMenuItem;
    N701: TMenuItem;
    N801: TMenuItem;
    N901: TMenuItem;
    Easter1: TMenuItem;
    N6: TMenuItem;
    History2: TMenuItem;
    N7: TMenuItem;
    OnTop2: TMenuItem;
    StartUp2: TMenuItem;
    Ghost2: TMenuItem;
    N8: TMenuItem;
    N3: TMenuItem;
    Language2: TMenuItem;
    Showin2: TMenuItem;
    Size1: TMenuItem;
    Size2: TMenuItem;
    N05x1: TMenuItem;
    N10x1: TMenuItem;
    N15x1: TMenuItem;
    Refresh1: TMenuItem;
    Refresh2: TMenuItem;
    FormResizer1: TFormResizer;
    CoolForm10: TCoolForm;
    CoolForm15: TCoolForm;
    CoolForm05: TCoolForm;
    Timer2: TTimer;
    procedure OnTop1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure StartUp1Click(Sender: TObject);
    procedure Easter1Click(Sender: TObject);
    procedure English1Click(Sender: TObject);
    procedure Romanian1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Taskbar1Click(Sender: TObject);
    procedure Tray1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure History1Click(Sender: TObject);
    procedure N001Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure N201Click(Sender: TObject);
    procedure N301Click(Sender: TObject);
    procedure N401Click(Sender: TObject);
    procedure N501Click(Sender: TObject);
    procedure N601Click(Sender: TObject);
    procedure N701Click(Sender: TObject);
    procedure N801Click(Sender: TObject);
    procedure N901Click(Sender: TObject);
    procedure Ghost2Click(Sender: TObject);
    procedure Language2Click(Sender: TObject);
    procedure Showin2Click(Sender: TObject);
    procedure Refresh2Click(Sender: TObject);
    procedure N05x1Click(Sender: TObject);
    procedure N10x1Click(Sender: TObject);
    procedure N15x1Click(Sender: TObject);
    procedure Size2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    nid: TNOTIFYICONDATA;
    TrayIconId: UINT;
    procedure doMinimize(Sender:TObject);
    function AddTrayIconId(iconId: UINT; icon: THandle; tip: PChar): boolean;
    function DeleteTrayIconId(iconId: UINT): boolean;
    Procedure CitireSetariRegistri;
    Procedure SalvareSetariRegistri;
    Procedure SetDimension(Size:Extended);
  public
    { Public declarations }
    ICO:TIcon;
  protected
    procedure WMIconNotification(var Msg: TMessage); message wm_IconNotification;
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.DFM}

Var DataPasti:TDate;
    ZilePanaLaPasti:Integer;

procedure SetTransparentForm(AHandle : THandle; AValue : byte);
var
 Info: TOSVersionInfo;
 SetLayeredWindowAttributes: TSetLayeredWindowAttributes;
begin
 Info.dwOSVersionInfoSize := SizeOf(Info);                            //Check Windows version
 GetVersionEx(Info);
 if (Info.dwPlatformId = VER_PLATFORM_WIN32_NT) and (Info.dwMajorVersion >= 5) then
   begin
     SetLayeredWindowAttributes := GetProcAddress(GetModulehandle(user32), 'SetLayeredWindowAttributes');
      if Assigned(SetLayeredWindowAttributes) then
        begin
          SetWindowLong(AHandle, GWL_EXSTYLE, GetWindowLong(AHandle, GWL_EXSTYLE) or WS_EX_LAYERED);
          SetLayeredWindowAttributes(AHandle, 0, AValue, LWA_ALPHA);  //Make form transparent
        end;
   end;
end;

Procedure TForm1.SetDimension(Size:Extended);
Begin
  CoolForm05.Visible:=Size=0.5;
  CoolForm10.Visible:=Size=1.0;
  CoolForm15.Visible:=Size=1.5;
  If Size=0.5 Then CoolForm05.RefreshRegion;
  If Size=1.0 Then CoolForm10.RefreshRegion;
  If Size=1.5 Then CoolForm15.RefreshRegion;
  With Form1 Do
    Begin
      Width:=Round(72*Size);
      Height:=Round(102*Size);
    End;
  With Image1 Do
    Begin
      Width:=Round(30*Size);
      Height:=Round(20*Size);
      Left:=Round(36*Size);
      Top:=Round(16*Size);
      Stretch:=True;
    End;
  With Image2 Do
    Begin
      Width:=Round(30*Size);
      Height:=Round(20*Size);
      Left:=Round(36*Size);
      Top:=Round(16*Size);
      Stretch:=True;
    End;
  With Image3 Do
    Begin
      Width:=Round(30*Size);
      Height:=Round(20*Size);
      Left:=Round(36*Size);
      Top:=Round(16*Size);
      Stretch:=True;
    End;
End;

procedure TForm1.doMinimize(Sender:TObject);
begin
  ImageList1.GetIcon(0, ICO);
  If LanguageName='EN' Then
    AddTrayIconId(0, ICO.Handle,PChar('Easter''s Lamb '+Label3.Caption))
  Else
    AddTrayIconId(0, ICO.Handle,PChar('Mielul de Pasti '+Label3.Caption));
  Hide;
end;

function TForm1.AddTrayIconId(iconId: UINT; icon: THandle; tip: PChar): boolean;
begin
  nid.uID := iconId;
  nid.hIcon := icon;
  if tip <> nil then
    StrLCopy(nid.szTip, tip, SizeOf(nid.szTip))
  else
    nid.szTip[0] := #0;
  Result := Shell_NotifyIcon(NIM_ADD, @nid);
end;

function TForm1.DeleteTrayIconId(iconId: UINT): boolean;
begin
  nid.uId := iconId;
  Result := Shell_NotifyIcon(NIM_DELETE, @nid);
  nid.hIcon:=0;
end;

procedure TForm1.WMIconNotification(var Msg: TMessage);
var
  MouseMsg: longint;
  Pt: TPoint;
begin
  MouseMsg := Msg.LParam;
  case MouseMsg of
    wm_RButtonUp:
      begin
        GetCursorPos(Pt);
        popupmenu1.PopUp(Pt.X,Pt.Y);
      end;
    wm_LButtonDblClk:  //popShowClick(Self);
      Easter1Click(Self);
  end;
end;

Procedure RestartApplication;
Var FullProgPath:PChar;
Begin
  Form1.Caption:='Easter''s Lamb '+Form1.Label3.Caption+' - modificat ca sa poata reporni aplicatia';
  FullProgPath:=PChar(Application.ExeName);
  WinExec(FullProgPath, SW_SHOW); // Or better use the CreateProcess function
  Application.Terminate;// or:Close;
End;

Function FormatareData:Integer;//String;
Var i,k:Integer;
    si:String;
    s:Array[1..3]Of String;
begin
  For k:=1 To 3 Do
    s[k]:='';
  si:=ShortDateFormat;
  k:=1;
  For i:=1 To Length(si) Do
    Begin
      If si[i]=DateSeparator Then
        Inc(k)
      Else
        s[k]:=s[k]+si[i];
    End;
  Result:=0;
  If (s[1][1]='d') And (s[2][1]='M') And (s[3][1]='y') Then Result:=123;//'dMy';
  If (s[1][1]='d') And (s[2][1]='y') And (s[3][1]='M') Then Result:=132;//'dyM';
  If (s[1][1]='M') And (s[2][1]='d') And (s[3][1]='y') Then Result:=213;//'Mdy';
  If (s[1][1]='M') And (s[2][1]='y') And (s[3][1]='d') Then Result:=231;//'Myd';
  If (s[1][1]='y') And (s[2][1]='d') And (s[3][1]='M') Then Result:=312;//'ydM';
  If (s[1][1]='y') And (s[2][1]='M') And (s[3][1]='d') Then Result:=321;//'yMd';
end;

Function UrmatorulPasti:TDate;
Label Reluare;
Var d,e:Real;
    An,Zi,Lu:Integer;
Begin
  An:=StrToInt(FormatDateTime('yyyy',Now));
Reluare:
  d:=(((An Mod 19)*19)+15) Mod 30;
  e:=Round(((an Mod 4)*2+(an Mod 7)*4)+6*d+6) Mod 7;
  Zi:=4+Round(d+e);
  Lu:=4;
  If Zi>30
    Then
      Begin
        Zi:=Zi-30;
        Lu:=5;
      End;
  Case FormatareData Of
    123:
      Result:=StrToDate(IntToStr(Zi)+DateSeparator+IntToStr(Lu)+DateSeparator+IntToStr(An));//dMy
    132:
      Result:=StrToDate(IntToStr(Zi)+DateSeparator+IntToStr(An)+DateSeparator+IntToStr(Lu));//dyM
    213:
      Result:=StrToDate(IntToStr(Lu)+DateSeparator+IntToStr(Zi)+DateSeparator+IntToStr(An));//Mdy
    231:
      Result:=StrToDate(IntToStr(Lu)+DateSeparator+IntToStr(An)+DateSeparator+IntToStr(Zi));//Myd
    312:
      Result:=StrToDate(IntToStr(An)+DateSeparator+IntToStr(Zi)+DateSeparator+IntToStr(Lu));//ydM
    321:
      Result:=StrToDate(IntToStr(An)+DateSeparator+IntToStr(Lu)+DateSeparator+IntToStr(Zi));//yMd
    Else
      Result:=0;
  End;
  If Round(Result-Now+3)<0 Then  //adaug 3 ca sa pot sa pot afisa ca
    Begin                        //e prima, a doua, a treia zi de Pasti
      Inc(An);
      Goto Reluare;
    End;
End;

Procedure TForm1.CitireSetariRegistri;
Begin
  With TRegistry.Create Do
    Try
      Begin
        RootKey:=HKEY_CURRENT_USER;
        If OpenKey('Software\Easter''s Lamb',TRUE) Then
          Begin
            OnTop1.Checked:=Not ReadBool('OnTop');
            OnTop1Click(Self);
            StartUp1.Checked:=ReadBool('StartUp');
            GhostPercent:=ReadInteger('Ghost');
            //SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
            Case GhostPercent Of
               0:N001Click(Self);
              10:N101Click(Self);
              20:N201Click(Self);
              30:N301Click(Self);
              40:N401Click(Self);
              50:N501Click(Self);
              60:N601Click(Self);
              70:N701Click(Self);
              80:N801Click(Self);
              90:N901Click(Self);
            End;
            AllGhostWindows:=ReadBool('All ghost windows');
            None1.Checked:=ReadBool('None');
            Tray1.Checked:=ReadBool('Tray');
            Taskbar1.Checked:=ReadBool('Taskbar');
            Left:=ReadInteger('Left');
            Top:=ReadInteger('Top');
            LanguageName:=ReadString('Language');
            HeartBeat:=ReadInteger('Heartbeat');
            Timer1.Interval:=HeartBeat;
            BlinkEyes:=ReadInteger('BlinkEyes');
          End
        Else
          MessageDlg('Registry read error',mtError,[mbOk],0);
        CloseKey;
      End;
    Except
      SalvareSetariRegistri;
    End;
End;

Procedure TForm1.SalvareSetariRegistri;
Begin
  With TRegistry.Create Do
    Try
      Begin
        RootKey:=HKEY_CURRENT_USER;
        If OpenKey('Software\Easter''s Lamb',TRUE) Then
          Begin
            WriteBool('OnTop',OnTop1.Checked);
            WriteBool('StartUp',StartUp1.Checked);
            WriteInteger('Ghost',GhostPercent);
            WriteBool('All ghost windows',AllGhostWindows);
            WriteBool('None',None1.Checked);
            WriteBool('Tray',Tray1.Checked);
            WriteBool('Taskbar',Taskbar1.Checked);
            WriteInteger('Left',Left);
            WriteInteger('Top',Top);
            WriteString('Language',LanguageName);
            WriteInteger('Heartbeat',HeartBeat);
            WriteInteger('BlinkEyes',BlinkEyes);
          End
        Else
          MessageDlg('Registry read error',mtError,[mbOk],0);
        CloseKey;
        If StartUp1.Checked Then
          If OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',TRUE) Then
            WriteString('Easter''s Lamb','"'+Application.ExeName+'"')
          Else
            MessageDlg('Registry read error',mtError,[mbOk],0)
        Else
          If OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',TRUE) Then
            WriteString('Easter''s Lamb','')
          Else
            MessageDlg('Registry read error',mtError,[mbOk],0);
        CloseKey;
      End;
    Except
      //SalvareSetariRegistri;
    End;
End;

procedure TForm1.OnTop1Click(Sender: TObject);
begin
  OnTop1.Checked:=Not OnTop1.Checked;
  If OnTop1.Checked Then
    FormStyle:=fsStayOnTop
  Else
    FormStyle:=fsNormal;
  If CoolForm05.Visible Then CoolForm05.RefreshRegion;
  If CoolForm10.Visible Then CoolForm10.RefreshRegion;
  If CoolForm15.Visible Then CoolForm15.RefreshRegion;
  Repaint;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  SalvareSetariRegistri;
  DeleteTrayIconId(TrayIconID);
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption:='Easter''s Lamb '+Label3.Caption;//modificat din nou pentru a putea relansa aplicatia
  Width:=72;
  Height:=102;
  CitireSetariRegistri;
  ICO:=TIcon.Create;
  nid.cbSize := SizeOf(TNOTIFYICONDATA);
  nid.Wnd := Handle;
  nid.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  nid.uCallbackMessage := wm_IconNotification;
  If None1.Checked Then
    SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW)
  Else
    If Tray1.Checked Then
      Begin
        SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);
        doMinimize(Self);
      End
    Else ;//
  If LanguageName='EN' Then
    English1Click(Sender)
  Else
    Romanian1Click(Sender);
  Refresh2Click(Sender);  
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  Refresh2Click(Sender);
  Form2.Label1.Visible:=True;
  Form2.Label2.Visible:=False;
  Form2.Left:=Form1.Left+Form1.Width;//+Round(70*SizeForm);
  Form2.Top:=Form1.Top-Form2.Height+Round(30*SizeForm);//Round(60*SizeForm);
  Form2.ShowModal;
end;

procedure TForm1.StartUp1Click(Sender: TObject);
begin
  StartUp1.Checked:=Not StartUp1.Checked;
end;

procedure TForm1.Easter1Click(Sender: TObject);
begin
  Refresh2Click(Sender);
  Form2.Label1.Visible:=False;
  Form2.Label2.Caption:=Form1.Hint;
  Form2.Label2.Visible:=True;
  Form2.Left:=Form1.Left+Form1.Width;//+Round(70*SizeForm);
  Form2.Top:=Form1.Top-Form2.Height+Round(30*SizeForm);//Round(60*SizeForm);
  Form2.ShowModal;
end;

procedure TForm1.English1Click(Sender: TObject);
begin
  LanguageName:='EN';
  English1.Checked:=True;
  About1.Caption:='&About';
  History1.Caption:='&History';
  Easter1.Caption:='&Easter';
  OnTop1.Caption:='&OnTop';
  StartUp1.Caption:='Start&Up';
  Size1.Caption:='&Size';
  Ghost1.Caption:='&Ghost';
  Showin1.Caption:='&Show in';
  None1.Caption:='&None';
  Tray1.Caption:='&Tray';
  Taskbar1.Caption:='Task&bar';
  Language1.Caption:='&Language';
  English1.Caption:='&English';
  Romanian1.Caption:='&Romanian';
  Exit1.Caption:='&Close';
  DataPasti:=UrmatorulPasti;///////////////////////////////////
  ZilePanaLaPasti:=Round(UrmatorulPasti-Now);
  If ZilePanaLaPasti=0 Then
    Form1.Hint:=#13'Today is'#13'Easter''s eve'
  Else
    If ZilePanaLaPasti=-1 Then
      Form1.Hint:=#13'Today is'#13'1st Easter''s day'
    Else
      If ZilePanaLaPasti=-2 Then
        Form1.Hint:=#13'Today is'#13'2nd Easter''s day'
      Else
        If ZilePanaLaPasti=-3 Then
          Form1.Hint:=#13'Today is'#13'3rd Easter''s day'
        Else
          Form1.Hint:='Next Easter''s day'#13+
                      'will be on '#13+FormatDateTime('dd-mmm-yyyy',DataPasti)+#13+
                      IntToStr(ZilePanaLaPasti)+' days until then!';
  //Refresh2Click(Sender);
end;

procedure TForm1.Romanian1Click(Sender: TObject);
begin
  LanguageName:='RO';
  Romanian1.Checked:=True;
  About1.Caption:='&Despre';
  History1.Caption:='&Istoric';
  Easter1.Caption:='&Pasti';
  OnTop1.Caption:='Deas&upra';
  StartUp1.Caption:='Po&rnire';
  Size1.Caption:='&Scara';
  Ghost1.Caption:='&Fantoma';
  Showin1.Caption:='&Arata in';
  None1.Caption:='&Nicaieri';
  Tray1.Caption:='&Tray';
  Taskbar1.Caption:='Task&bar';
  Language1.Caption:='&Limba';
  English1.Caption:='&Engleza';
  Romanian1.Caption:='&Romana';
  Exit1.Caption:='Inc&hide';
  DataPasti:=UrmatorulPasti;/////////////////////////////////// 
  ZilePanaLaPasti:=Round(UrmatorulPasti-Now);
  If ZilePanaLaPasti=0 Then
    Form1.Hint:=#13'Astazi este'#13'ajunul Pastelui'
  Else
    If ZilePanaLaPasti=-1 Then
      Form1.Hint:=#13'Astazi este'#13'prima zi de Pasti'
    Else
      If ZilePanaLaPasti=-2 Then
        Form1.Hint:=#13'Astazi este'#13'a doua zi de Pasti'
      Else
        If ZilePanaLaPasti=-3 Then
          Form1.Hint:=#13'Astazi este'#13'a treia zi de Pasti'
        Else
          Form1.Hint:='Ziua urmatorului Pasti'#13+
                      'va fi pe '+FormatDateTime('dd-mmm-yyyy',DataPasti)+#13+
                      'Mai sunt '+IntToStr(ZilePanaLaPasti)+' zile pana atunci!';
  //Refresh2Click(Sender);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Image1.Visible:=Timer1.Tag=1;
  Image2.Visible:=(Timer1.Tag=2) Or (Timer1.Tag=4);
  Image3.Visible:=Timer1.Tag=3;
  Timer1.Tag:=Timer1.Tag+1;
  If Timer1.Tag>BlinkEyes Then
    Timer1.Tag:=0;
end;

procedure TForm1.Taskbar1Click(Sender: TObject);
begin
  TaskBar1.Checked:=Not Taskbar1.Checked;
  SalvareSetariRegistri;
  DeleteTrayIconId(TrayIconID);
  RestartApplication;
end;

procedure TForm1.Tray1Click(Sender: TObject);
begin
  Tray1.Checked:=Not Tray1.Checked;
  SalvareSetariRegistri;
  DeleteTrayIconId(TrayIconID);
  RestartApplication;
end;

procedure TForm1.None1Click(Sender: TObject);
begin
  None1.Checked:=Not None1.Checked;
  SalvareSetariRegistri;
  DeleteTrayIconId(TrayIconID);
  RestartApplication;
end;

procedure TForm1.History1Click(Sender: TObject);
begin
  Form2.Label1.Visible:=False;
  Form2.Label2.Visible:=False;
  Form2.Left:=Form1.Left+70;
  Form2.Top:=Form1.Top-60;
  Form2.ShowModal;
end;

procedure TForm1.N001Click(Sender: TObject);
begin
  N001.Checked:=True;
  GhostPercent:=0;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N101Click(Sender: TObject);
begin
  N101.Checked:=True;
  GhostPercent:=10;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N201Click(Sender: TObject);
begin
  N201.Checked:=True;
  GhostPercent:=20;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N301Click(Sender: TObject);
begin
  N301.Checked:=True;
  GhostPercent:=30;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N401Click(Sender: TObject);
begin
  N401.Checked:=True;
  GhostPercent:=40;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N501Click(Sender: TObject);
begin
  N501.Checked:=True;
  GhostPercent:=50;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N601Click(Sender: TObject);
begin
  N601.Checked:=True;
  GhostPercent:=60;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N701Click(Sender: TObject);
begin
  N701.Checked:=True;
  GhostPercent:=70;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N801Click(Sender: TObject);
begin
  N801.Checked:=True;
  GhostPercent:=80;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N901Click(Sender: TObject);
begin
  N901.Checked:=True;
  GhostPercent:=90;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.Ghost2Click(Sender: TObject);
begin
  GhostPercent:=(GhostPercent+10) Mod 100;
  Case GhostPercent Of
     0:N001Click(Self);
    10:N101Click(Self);
    20:N201Click(Self);
    30:N301Click(Self);
    40:N401Click(Self);
    50:N501Click(Self);
    60:N601Click(Self);
    70:N701Click(Self);
    80:N801Click(Self);
    90:N901Click(Self);
  End;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.Language2Click(Sender: TObject);
begin
  If English1.Checked Then
    Romanian1Click(Sender)
  Else
    If Romanian1.Checked Then
      English1Click(Sender);
end;

procedure TForm1.Showin2Click(Sender: TObject);
begin
  If None1.Checked Then
    Tray1Click(Sender)
  Else
    If Tray1.Checked Then
      Taskbar1Click(Sender)
    Else
      If Taskbar1.Checked Then
        None1Click(Sender);
end;

procedure TForm1.Refresh2Click(Sender: TObject);
begin
  Timer2Timer(Sender);
  If CoolForm05.Visible Then CoolForm05.RefreshRegion;
  If CoolForm10.Visible Then CoolForm10.RefreshRegion;
  If CoolForm15.Visible Then CoolForm15.RefreshRegion;
//  Language2Click(Sender);
  CoolForm05.Hint:=Form1.Hint;
  CoolForm10.Hint:=Form1.Hint;
  CoolForm15.Hint:=Form1.Hint;
  Repaint;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N05x1Click(Sender: TObject);
begin
  N05x1.Checked:=True;
  SizeForm:=0.5;
  SetDimension(SizeForm);
  Refresh2Click(Sender);
  Repaint;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N10x1Click(Sender: TObject);
begin
  N10x1.Checked:=True;
  SizeForm:=1.0;
  SetDimension(SizeForm);
  If CoolForm05.Visible Then CoolForm05.RefreshRegion;
  If CoolForm10.Visible Then CoolForm10.RefreshRegion;
  If CoolForm15.Visible Then CoolForm15.RefreshRegion;
  Repaint;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.N15x1Click(Sender: TObject);
begin
  N15x1.Checked:=True;
  SizeForm:=1.5;
  SetDimension(SizeForm);
  If CoolForm05.Visible Then CoolForm05.RefreshRegion;
  If CoolForm10.Visible Then CoolForm10.RefreshRegion;
  If CoolForm15.Visible Then CoolForm15.RefreshRegion;
  Repaint;
  SetTransparentForm(Handle,255*(100-GhostPercent) Div 100);
end;

procedure TForm1.Size2Click(Sender: TObject);
begin
  If N05x1.Checked Then
    N10x1Click(Sender)
  Else
    If N10x1.Checked Then
      N15x1Click(Sender)
    Else
      If N15x1.Checked Then
        N05x1Click(Sender);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  If LanguageName='EN' Then
    English1Click(Sender)
  Else
    Romanian1Click(Sender);
//  Language2Click(Sender);
end;

end.

