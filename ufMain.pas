Unit ufMain;
Interface
// Все поддерживаемые форматы|*.avi;*.rm;*.rmvb;*.mpg;*.mpeg;*.mp4;*.asf;*.wmv;*.mkv;*.dat;*.vob;*.flv|Файл AVI (*.avi)|*.avi|Файл Real (*.rm;*.rmvb)|*.rm;*.rmvb|Файл Mpeg (*.mpg;*.mpeg;*.mp4)|*.mpg;*.mpeg;*.mp4|Файл Asf (*.asf)|*.asf|Файл WMV (*.wmv)|*.wmv|Файл Mkv (*.mkv)|*.mkv|Файл VCD (*.dat)|*.dat|Файл DVD (*.vob)|*.vob|FlashVideo (*.flv;*.flac)|*.flv;*.flac|Все файлы (*.*)|*.*
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, Buttons, StdCtrls, ComCtrls, ActnList, ImgList,
  unParams, unProControl;

Const
  IM_OK = 7;
  IM_ERROR = 6;
  IM_WAIT = 5;
  FIELDS = 4;
  IM_RUN = 1;
  IM_PAUSE = 2;

Type
  TForm1 = class(TForm)
    GroupBox: TGroupBox;
    btExit: TButton;
    Label1: TLabel;
    edInFile: TEdit;
    Label2: TLabel;
    edOutFile: TEdit;
    Label4: TLabel;
    cbSize: TComboBox;
    Label5: TLabel;
    cbAudioQuality: TComboBox;
    sbSelSource: TSpeedButton;
    sbSelDisk: TSpeedButton;
    sbSelDest: TSpeedButton;
    sbPlay: TSpeedButton;
    List: TListView;
    lbDVDTrack: TLabel;
    edDVDTrack: TEdit;
    udDVDTrack: TUpDown;
    ImageList: TImageList;
    ActionList1: TActionList;
    acAdd: TAction;
    acDouble: TAction;
    acDelete: TAction;
    acPlaySource: TAction;
    acStart: TAction;
    acStop: TAction;
    acSelectSource: TAction;
    acSelectDest: TAction;
    acSelectSourceDisk: TAction;
    btAdd: TSpeedButton;
    btDouble: TSpeedButton;
    btDelete: TSpeedButton;
    btRun: TSpeedButton;
    btPause: TSpeedButton;
    btStop: TSpeedButton;
    progress: TProgressBar;
    lbTimeLeft: TLabel;
    lbProgress: TLabel;
    acPause: TAction;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    procedure acDoubleExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acPlaySourceExecute(Sender: TObject);
    procedure acStartExecute(Sender: TObject);
    procedure acStopExecute(Sender: TObject);
    procedure acSelectSourceExecute(Sender: TObject);
    procedure acSelectDestExecute(Sender: TObject);
    procedure acSelectSourceDiskExecute(Sender: TObject);
    procedure btExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acPauseExecute(Sender: TObject);
    procedure acAddExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure edInFileChange(Sender: TObject);
    procedure cbAudioQualityChange(Sender: TObject);
    procedure cbSizeChange(Sender: TObject);
    procedure edDVDTrackChange(Sender: TObject);
    procedure edOutFileChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  Private
    EditEnableState: boolean;
    Task: TConverter;
    CurItem: integer;
    Params: TConvParams;
    RunItem: integer;

    bRun: boolean;
    ftFilesElapsed: integer;
    Function AddItem: integer;
    Procedure DeleteItem(i: integer);
    Procedure LoadItem(i: integer);
    Procedure RefreshWindow;
    Procedure RefreshTable(i: integer);
    Procedure EditEnable(Value: boolean);
    Procedure RefreshButtons;
    Function GetCanItem: integer;
    Function GetProgress(procent: integer): integer;
    Procedure ClearProgress;
  Public
    Procedure OnChangeProgress(sender: TObject; Procent, TimeLeft: integer);
    Procedure OnChangeStatus(sender: TObject; status: TConvStatus; fError: boolean);
  End;

Var
  Form1: TForm1;

Implementation

{$R *.dfm}

Function TForm1.AddItem: integer;
Var
  LI: TListItem;
  I: integer;
  P: PConvParams;
Begin
  LI := List.Items.Add;
  Result := LI.Index;
  LI.Caption := '';
  For i:=1 to FIELDS-1 do
    LI.SubItems.Add('');
  New(P);
  P^ := ZeroParams;
  LI.Data := P;
  LI.ImageIndex := IM_WAIT;
End;

Procedure TForm1.DeleteItem(i: integer);
Begin
  Dispose(PConvParams(List.Items[i].Data));
  List.Items.Delete(i);
End;

Procedure TForm1.LoadItem(i: integer);
Begin
  Params := PConvParams(List.Items[i].Data)^;
  RefreshWindow;
End;

Procedure TForm1.RefreshWindow;
Begin
  edInFile.Text := Params.szInFile;
  edOutFile.Text := Params.szOutFile;
  cbAudioQuality.ItemIndex := byte(Params.AudioQuality);
  cbSize.ItemIndex := byte(Params.SizeType);

  udDVDTrack.Position := Params.nDVDTrack;
  lbDVDTrack.Visible := Params.nDVDTrack >= 0;
  edDVDTrack.Visible := Params.nDVDTrack >= 0;
  udDVDTrack.Visible := Params.nDVDTrack >= 0;
End;

Procedure TForm1.RefreshTable(i: integer);

  Function GetCaption: string;
  Begin
    IF Params.nDVDTrack < 0 then
      GetCaption := ExtractFileName(Params.szInFile)
    else
      GetCaption := 'DVD трек #'+IntToStr(Params.nDVDTrack)+' на '+Params.szInFile;
  End;

Const
  AQuality: array [TAudioQuality] of string =
    ('Высокое', 'Среднее', 'Низкое');
  Sizes: array [TSizeType] of string =
    ('Авто', 'Максимум', '4 : 3', '16 : 9');

Begin
  List.Items[i].Caption := GetCaption;
  List.Items[i].SubItems[0] := AQuality[Params.AudioQuality];
  List.Items[i].SubItems[1] := Sizes[Params.SizeType];
  PConvParams(List.Items[i].Data)^ := Params;
End;

Procedure TForm1.EditEnable(Value: boolean);
Var
  i: integer;
Begin
  IF Value = EditEnableState then Exit;
  EditEnableState := Value;

  {edInFile.Enabled := Value;
  sbSelSource.Enabled := Value;
  sbSelDisk.Enabled := Value;
  edOutFile.Enabled := Value;
  sbSelDest.Enabled := Value;
  cbAudioQuality.Enabled := Value;
  cbSize.Enabled := Value;
  edDVDTrack.Enabled := Value;
  udDVDTrack.Enabled := Value;}

  With GroupBox do
    For i:=0 to Pred(ControlCount) do
      TControl(Controls[i]).Enabled := Value;
End;

Procedure TForm1.RefreshButtons;
Begin
  IF Assigned(List.Selected) then
    CurItem := List.Selected.Index
  else
    CurItem := -1;
  btDouble.Enabled := CurItem <> -1;
  btDelete.Enabled := CurItem <> -1;
  btRun.Enabled := (Task.Status in [csPause, csStop]) and
    ((GetCanItem <> -1) or bRun);
  btPause.Enabled := Task.Status = csRun;
  btStop.Enabled := Task.Status in [csRun, csPause];
  EditEnable((CurItem <> -1) and (List.Selected.ImageIndex = IM_WAIT));
End;

Function TForm1.GetProgress(procent: integer): integer;
Begin
  Result := Round((ftFilesElapsed + procent/100)/(ftFilesElapsed + List.Items.Count - RunItem)*1000);
End;

Procedure TForm1.ClearProgress;
Begin
  ftFilesElapsed := -1;
  bRun := false;
  Progress.Position := 1000;
  lbProgress.Caption := '100 %';
  lbTimeLeft.Caption := '';
End;



// ---------------------------------------------------------------------------

Procedure TForm1.acAddExecute(Sender: TObject);
Begin
  CurItem := AddItem;
  List.Items[CurItem].Selected := true;
  acSelectSource.Execute;
  RefreshTable(CurItem);
End;

Procedure TForm1.acDoubleExecute(Sender: TObject);
Var
  i: integer;
Begin
  i := AddItem;
  PConvParams(List.Items[i].Data)^ := PConvParams(List.Items[CurItem].Data)^;
  CurItem := i;
  List.Items[CurItem].Selected := true;
  RefreshTable(CurItem);
End;

Procedure TForm1.acDeleteExecute(Sender: TObject);
Var
  i: integer;
Begin
  i := CurItem;
  IF (CurItem = RunItem) then
  Begin
    IF MessageBox(Handle,
      'Вы уверены, что хотите прервать и удалить это задание?',
      'Предупреждение', MB_ICONWARNING or MB_YESNO) = IDNO then
      Exit;
    bRun := false;
    Task.Status := csStop;
    Dec(ftFilesElapsed);
    DeleteItem(CurItem);
    bRun := true;
    acStartExecute(nil);
  End else Begin
    IF RunItem > CurItem then
      Dec(RunItem);
    DeleteItem(CurItem);
  End;
  IF i = List.Items.Count then
    Dec(i);
  IF i <> -1 then
    List.Items[i].Selected := true;
  RefreshButtons;
End;

Procedure TForm1.acPlaySourceExecute(Sender: TObject);
Var
  s: string;
Begin
  s := 'mplayer.exe '+GetPlayerCmdLine(Params);
  WinExec(PChar(s), SW_SHOWNORMAL);
End;

Procedure TForm1.acSelectSourceExecute(Sender: TObject);
Var
  Path: string;
Begin
  OpenDlg.FileName := Params.szInFile;
  IF OpenDlg.Execute and edInFile.Enabled then
  Begin
    Params.szInFile := OpenDlg.FileName;
    IF Params.szOutFile = '' then
      Path := Params.szInFile
    else
      Path := Params.szOutFile;
    Path := ExtractFilePath(Path);
    Params.szOutFile := Path + ChangeFileExt(ExtractFileName(Params.szInFile), '_converted.avi');
    Params.nDVDTrack := -1;

    edInFile.Text := Params.szInFile;
    edOutFile.Text := Params.szOutFile;
    RefreshWindow;
  End;
End;

Procedure TForm1.acSelectSourceDiskExecute(Sender: TObject);
Const
  DTFormat: TFormatSettings =
    (ShortDateFormat: 'yymmdd';
     LongTimeFormat: 'hh-nn');
Var
  Path: string;
  st: TSystemTime;
  S: string;
Begin
  S := Params.szInFile;
  IF BrowseForFolder(S, Handle, 'Выберите DVD диск или папку с его содержимым') and
    (S <> '') and edOutFile.Enabled then
  Begin
    IF (S[length(S)]='\') then Delete(S, length(S), 1);
    IF Params.szOutFile = '' then
      Path := 'C:\'
    else
      Path := ExtractFilePath(Params.szOutFile);
    GetSystemTime(st);
    Params.nDVDTrack := 0;
    Params.szInFile := S;
    Params.szOutFile := Path +
      ChangeFileExt('DVDdump_'+DateToStr(Date, DTFormat)+'_'+TimeToStr(Time, DTFormat), '.avi');

    edInFile.Text := Params.szInFile;
    edOutFile.Text := Params.szOutFile;
    RefreshWindow;
  End;
End;

Procedure TForm1.acSelectDestExecute(Sender: TObject);
Begin
  SaveDlg.FileName := Params.szOutFile;
  IF SaveDlg.Execute then
    edOutFile.Text := SaveDlg.FileName;
  RefreshWindow;
End;

// ---------------------------------------------------------------------------

Function TForm1.GetCanItem: integer;
Var
  i: integer;
Begin
  Result := -1;
  For i := 0 to Pred(List.Items.Count) do
    IF List.Items[i].ImageIndex = IM_WAIT then
    Begin
      Result := i;
      Exit;
    End;
End;

Procedure TForm1.acStartExecute(Sender: TObject);
Begin
  IF RunItem = -1 then
  Begin
    RunItem := GetCanItem;
    IF RunItem <> -1 then
    Begin
      bRun := true;
      Inc(ftFilesElapsed);
      Task.Initialize(GetCmdLine(PConvParams(List.Items[RunItem].Data)^));
    End else Begin
      Task.Status := csStop;
      Windows.MessageBox(Handle, 'Конвертация завершена!', 'Сообщение', MB_ICONINFORMATION);
      ClearProgress;
      RefreshButtons;
      Exit;
    End;
  End;
  List.Items[RunItem].ImageIndex := IM_RUN;
  Task.Status := csRun;
  RefreshButtons;
End;

Procedure TForm1.acPauseExecute(Sender: TObject);
Begin
  Task.Status := csPause;
  List.Items[RunItem].ImageIndex := IM_PAUSE;
  RefreshButtons;
End;

Procedure TForm1.acStopExecute(Sender: TObject);
Var
  s: TConvStatus;
Begin
  bRun := false;
  s := Task.Status;
  Task.Status := csStop;
  IF s <> csStop then
    MessageBox(Handle, 'Конвертация была прервана!', 'Сообщение', MB_ICONWARNING);
  ClearProgress;
  RefreshButtons;
End;

Function GetMyTime(i: cardinal): string;
Var
  a: cardinal;
Begin
  a := i div 3600000;
  IF a > 9 then Result := IntToStr(a)+':'
           else Result := '0'+IntToStr(a)+':';
  i := i mod 3600000;
  a := i div 60000;
  IF a > 9 then Result := Result + IntToStr(a)+':'
           else Result := Result + '0'+IntToStr(a)+':';
  i := i mod 60000;
  a := i div 1000;
  IF a > 9 then Result := Result + IntToStr(a)
           else Result := Result + '0'+IntToStr(a);
End;

Procedure TForm1.OnChangeProgress(sender: TObject; Procent, TimeLeft: integer);
Var
  i: integer;
  s: string;
Begin
  IF not bRun then Exit;
  List.Items[RunItem].SubItems[2] := IntToStr(procent)+' %';
  i := GetProgress(procent);
  Progress.Position := i;
  lbProgress.Caption := IntToStr(i div 10)+' %';
  s := 'Файл, осталось подождать ';
  IF TimeLeft = 0 then
    s := s+'несколько секунд'
  else Begin
    s := s+IntToStr(TimeLeft)+' минут';
    IF (TimeLeft mod 100 div 10) <> 1 then
      Case TimeLeft mod 10 of
        1: s := s+'у';
        2..4: s := s+'ы';
      End;
  End;
  lbTimeLeft.Caption := s+'.';
End;

Procedure TForm1.OnChangeStatus(sender: TObject; status: TConvStatus; fError: boolean);
Begin
  IF (status = csStop) then
  Begin
    With List.Items[RunItem] do
      IF fError then
      Begin
        ImageIndex := IM_ERROR;
        SubItems[2] := 'Ошибка';
      End else Begin
        ImageIndex := IM_OK;
        SubItems[2] := 'OK';
      End;
    RunItem := -1;
    IF bRun then acStartExecute(nil);
  End;
End;


Procedure TForm1.btExitClick(Sender: TObject);
Begin
  Close;
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
  EditEnableState := true;
  Task := TConverter.Create;
  Task.OnChangeProgress := OnChangeProgress;
  Task.OnChangeStatus := OnChangeStatus;
  Params := ZeroParams;
  RefreshWindow;
  CurItem := -1;
  RunItem := -1;
  ftFilesElapsed := -1;
  RefreshButtons;
End;

Procedure TForm1.FormDestroy(Sender: TObject);
Begin
  Task.Free;
End;

Procedure TForm1.ListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
Begin
  RefreshButtons;
  IF CurItem <> -1 then
    LoadItem(CurItem);
End;

Procedure TForm1.edInFileChange(Sender: TObject);
Begin
  Params.szInFile := edInFile.Text;
  RefreshTable(CurItem);
End;

Procedure TForm1.edOutFileChange(Sender: TObject);
Begin
  Params.szOutFile := edOutFile.Text;
  RefreshTable(CurItem);
End;

Procedure TForm1.cbAudioQualityChange(Sender: TObject);
Begin
  byte(Params.AudioQuality) := cbAudioQuality.ItemIndex;
  RefreshTable(CurItem);
End;

Procedure TForm1.cbSizeChange(Sender: TObject);
Begin
  byte(Params.SizeType) := cbSize.ItemIndex;
  RefreshTable(CurItem);
End;

Procedure TForm1.edDVDTrackChange(Sender: TObject);
Begin
  Params.nDVDTrack := udDVDTrack.Position;
  RefreshTable(CurItem);
End;

Procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Begin
  IF bRun then
  Begin
    CanClose := MessageBox(Handle, 'Вы уверены, что хотите прервать конвертацию и выйти?',
      'Предупреждение', MB_ICONWARNING or MB_YESNO) = IDYES;
    IF CanClose then
    Begin
      bRun := false;
      Task.Status := csStop;
    End;
  End;
End;

End.
