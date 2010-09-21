Unit unManager;
Interface

//{$DEFINE LOG}

Uses
  Windows, Messages, SysUtils, Classes;

Type
  TOnFinish = procedure (Sender: TObject; Error: boolean) of object;
  TOnSetProgress = procedure(Sender: TObject; Progress: integer) of object;
  TAnalyseProc = procedure(s: string; var progress: integer) of object;

  TCustomConverter = class
  Private
    FOnFinish: TOnFinish;
    FOnSetProgress: TOnSetProgress;
    hThread, hStopEvent: THandle;
    lpOldWndProc: pointer;
    hScyWnd: HWND;
    FStarted: boolean;
    FError: boolean;
    FErrorString: string;
    FUserCancel: boolean;
  Protected
    FInFileName, FOutFileName: string;
  Public
    Constructor Create(const FileName: string); virtual;
    Destructor Destroy; override;
    Procedure Start;
    Procedure Stop;
    Procedure Run(const AppName, CmdLine: string; AnalyseProc: TAnalyseProc);
    Procedure Convert; virtual; abstract;
    Property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    Property OnSetProgress: TOnSetProgress read FOnSetProgress write FOnSetProgress;
    Property Started: boolean read FStarted;
    Property ErrorString: string read FErrorString;
    Property UserCancel: boolean read FUserCancel;
    Property InFileName: string read FInFileName;
    Property OutFileName: string read FOutFileName;
  End;

  TTasks_OnStatus = procedure (Sender: TObject; ID: integer; Error: boolean) of object;
  TTasks_OnNext = procedure (Sender: TObject; ID: integer) of object;
  TTasks_OnSetProgress = procedure(Sender: TObject; ID, Progress: integer) of object;

  TTasks = class
  Private
    FList: TList;
    FOnStatus: TTasks_OnStatus;
    FOnNext: TTasks_OnNext;
    FOnSetProgress: TTasks_OnSetProgress;
    FStarted: boolean;
    FParent: THandle;
    FCurID: integer;
    FObject: TCustomConverter;
  Protected
    Procedure OnFinish(Sender: TObject; Error: boolean);
    Procedure OnSetProgress_(Sender: TObject; Progress: integer);
  Public
    Constructor Create(Parent: THandle);
    Destructor Destroy; override;
    Procedure AddTask(FileName: string);
    Function DeleteTask(ID: integer): boolean;
    Procedure Run;
    Property OnStatus: TTasks_OnStatus read FOnStatus write FOnStatus;
    Property OnNext: TTasks_OnNext read FOnNext write FOnNext;
    Property OnSetProgress: TTasks_OnSetProgress read FOnSetProgress
      write FOnSetProgress;
    Property Started: boolean read FStarted;
    Property ConvObject: TCustomConverter read FObject;
  End;

Var
  FolderToSave: string = '';
  OutNameFormat: string = '';
  ProgramPath: string;
  TempPath: string;
  {$IFDEF LOG} LogFile: Text; {$ENDIF}

Function psInitialize(const Name, Cmd: string; out PI: TProcessInformation): THandle;
Procedure psKill(var PI: TProcessInformation);
Function RunAndReadAll(const szApplication, szParams: string): string;
Function CreateTempFileName(prefix: PChar): string;
Procedure LogStr(const S: string);

Implementation

uses pl_T72X;

Function psInitialize(const Name, Cmd: string; out PI: TProcessInformation): THandle;
Var
  SI: TStartupInfo;
  PSA: TSecurityAttributes;
  hRPipe, hWPipe: THandle;
Begin
  hRPipe := 0; hWPipe := 0;
  ZeroMemory(@PI, SizeOf(PI));
  ZeroMemory(@SI, SizeOf(SI));
  PI.hProcess := INVALID_HANDLE_VALUE;
  With PSA do
  Begin
    nLength := SizeOf(PSA);
    lpSecurityDescriptor := nil;
    bInheritHandle := true;
  End;
  IF not CreatePipe(hRPipe, hWPipe, @PSA, 4096) then
    raise Exception.Create('Не могу создать объект "pipe".');
  With SI do
  Begin
    cb := SizeOf(SI);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEOFFFEEDBACK or STARTF_USESTDHANDLES;
    wShowWindow := SW_HIDE;
    hStdOutput := hWPipe;
    hStdError := hWPipe;
  End;
  Try
    Try
      IF not CreateProcess(PChar(ProgramPath+Name), PChar(cmd),
        nil, nil, true,
        CREATE_DEFAULT_ERROR_MODE or CREATE_SUSPENDED or IDLE_PRIORITY_CLASS,
        nil, nil, SI, PI) then
          raise Exception.Create('Не могу создать дочерний процесс.');
    Finally
      CloseHandle(hWPipe);
    End;
  Except
    On E: Exception do
    Begin
      CloseHandle(hRPipe);
      raise Exception.Create(E.Message);
    End;
  End;
  ResumeThread(PI.hProcess);
  ResumeThread(PI.hThread);
  Result := hRPipe;
End;

Procedure psKill(var PI: TProcessInformation);
Begin
  IF PI.hProcess <> INVALID_HANDLE_VALUE then
    TerminateProcess(PI.hProcess, $FFFFFFFF);
  CloseHandle(PI.hProcess);    PI.hProcess := INVALID_HANDLE_VALUE;
  CloseHandle(PI.hThread);     PI.hThread := INVALID_HANDLE_VALUE;
End;

Function RunAndReadAll(const szApplication, szParams: string): string;
Var
  PI: TProcessInformation;
  hRPipe: THandle;

  Buffer: string;
  cbRead: cardinal;
  B: boolean;
Begin
  hRPipe := INVALID_HANDLE_VALUE;
  Try
    hRPipe := psInitialize(szApplication, szParams, PI);
    SetLength(Buffer, 1024);
    Result := '';
    Repeat
      B := ReadFile(hRPipe, Buffer[1], 1024, cbRead, nil);
      Result := Result + Copy(Buffer, 1, cbRead);
    Until (WaitForSingleObject(PI.hProcess, 0) = WAIT_OBJECT_0) and not B;
  Finally
    psKill(PI);
    CloseHandle(hRPipe);
  End;
End;

Function CreateTempFileName(prefix: PChar): string;
Var
  P: PChar;
Begin
  GetMem(P, MAX_PATH*2);
  IF GetTempFileName(PChar(TempPath), prefix, 0, P) = 0 then
    Result := 'temp'
  else
    Result := P;
  DeleteFile(P);
  FreeMem(P);
End;

Procedure LogStr(const S: string);
Begin
  {$IFDEF LOG}
  Writeln(LogFile, TimeToStr(Time)+' '+DateToStr(Date)+' >> '+S);
  {$ENDIF}
End;




{ *** TCustomConverter = class ***}

Const
  WM_FINISHED = WM_USER + $300;
  WM_SETPROGRESS = WM_USER + $301;

Function ScyWndProc(Handle: HWND; uMsg: cardinal; wParam, lParam: integer): integer; stdcall; forward;
Function TaskThread(obj: TCustomConverter): integer; stdcall; forward;

Constructor TCustomConverter.Create(const FileName: string);
Begin
  inherited Create;
  FInFileName := FileName;
  IF FolderToSave = '' then
    FOutFileName := ExtractFilePath(FileName)
  else
    FOutFileName := FolderToSave+'\';
  FOutFileName := FOutFileName +
    Format(OutNameFormat, [ChangeFileExt(ExtractFileName(FileName), '')]);

  hStopEvent := CreateEvent(nil, false, false, nil);
  IF hStopEvent = 0 then
    raise Exception.Create('Не могу создать объект "event"');
  hScyWnd := CreateWindowEx(0, 'EDIT', nil, 0, 0, 0, 0, 0, HWND_DESKTOP, 0, HInstance, nil);
  IF hScyWnd = 0 then
    raise Exception.Create('Ошибка при создании окна, обрабатывающего сообщения');
  integer(lpOldWndProc) := SetWindowLong(hScyWnd, GWL_WNDPROC, integer(@ScyWndProc));
  SetWindowLong(hScyWnd, GWL_USERDATA, integer(TCustomConverter(self)));
End;

Destructor TCustomConverter.Destroy;
Begin
  Stop;
  SetWindowLong(hScyWnd, GWL_WNDPROC, integer(lpOldWndProc));
  DestroyWindow(hScyWnd);
  CloseHandle(hStopEvent);
  inherited;
End;

Procedure TCustomConverter.Start;
Var
  ThreadID: cardinal;
Begin
  IF FStarted then Exit;
  hThread := CreateThread(nil, 0, @TaskThread, TCustomConverter(self), 0, ThreadID);
  IF hThread = 0 then
    raise Exception.Create('Не могу создать поток.');
  FStarted := true;
End;

Function TaskThread(obj: TCustomConverter): integer; stdcall;
Begin
  Try
    obj.Convert;
  Except
    On E: Exception do
    Begin
      obj.FError := true;
      obj.FErrorString := E.Message;
    End;
  End;
  IF not obj.FUserCancel then
    PostMessage(obj.hScyWnd, WM_FINISHED, 0, 0);
  Result := 0;
End;

Procedure TCustomConverter.Stop;
Begin
  IF not FStarted then Exit;
  FUserCancel := true;
  SetEvent(hStopEvent);
  IF WaitForSingleObject(hThread, 5000) = WAIT_TIMEOUT then
  Begin
    TerminateThread(hThread, $FFFFFFFF);
    FErrorString := 'Зависание потока.';
  End;
  CloseHandle(hThread);
  FStarted := false;
End;

Function ScyWndProc(Handle: HWND; uMsg: cardinal; wParam, lParam: integer): integer;
Var
  obj: TCustomConverter;
Begin
  IF uMsg = WM_SETPROGRESS then
  Begin
    integer(obj) := GetWindowLong(Handle, GWL_USERDATA);
    IF Assigned(obj.FOnSetProgress) then
      obj.FOnSetProgress(obj, wParam);
    Result := 0;
  End else
  IF uMsg = WM_FINISHED then
  Begin
    integer(obj) := GetWindowLong(Handle, GWL_USERDATA);
    IF Assigned(obj.FOnFinish) then
      obj.FOnFinish(obj, obj.FError);
    Result := 0;
  End else
    Result := DefWindowProc(Handle, uMsg, wParam, lParam);
End;

Procedure TCustomConverter.Run(const AppName, CmdLine: string; AnalyseProc: TAnalyseProc);
Var
  PI: TProcessInformation;
  hRPipe: THandle;
  Buffer, S: string;
  Temp: cardinal;
  lastprogress, saved: integer;
Begin
  hRPipe := psInitialize(AppName, CmdLine, PI);
  SetLength(Buffer, 4096);
  Try
    Repeat
      Temp := 0;
      ReadFile(hRPipe, Buffer[1], 4096, Temp, nil);
      S := Copy(Buffer, 1, Temp);
      saved := lastprogress;
      AnalyseProc(s, lastprogress);
      IF saved <> lastprogress then
        SendMessage(hScyWnd, WM_SETPROGRESS, lastprogress, 0);
      IF WaitForSingleObject(PI.hProcess, 0) = WAIT_OBJECT_0 then
      Begin
        Temp := 0;
        GetExitCodeProcess(PI.hProcess, Temp);
        IF Temp <> 0 then
          raise Exception.Create('Дочерний процесс завершился с ошибкой '+IntToStr(Temp));
        Break;
      End;
      IF WaitForSingleObject(hStopEvent, 0) = WAIT_OBJECT_0 then
        raise Exception.Create('Прервано пользователем.');
    Until False;  // need some condiditon!! Fix me!
  Finally
    CloseHandle(hRPipe);
    psKill(PI);
    Buffer := '';
  End;
End;



{ *** TTasks = class *** }

Type
  PTaskRec = ^TTaskRec;
  TTaskRec = record
    FileName: string;
  End;

Constructor TTasks.Create(Parent: THandle);
Begin
  inherited Create;
  FParent := Parent;
  FList := TList.Create;
  FCurID := -1;
End;

Destructor TTasks.Destroy;
Var
  i: integer;
Begin
  For i := 0 to Pred(FList.Count) do
    Dispose(PTaskRec(FList[i]));
  FObject.Free;
  FList.Free;
  inherited;
End;

Procedure TTasks.AddTask(FileName: string);
Var
  p: PTaskRec;
Begin
  New(p);
  p^.FileName := FileName;
  FList.Add(p);
End;

Function TTasks.DeleteTask(ID: integer): boolean;
Begin
  Result := false;
  IF Assigned(FObject) and (FCurID = ID) then
  Begin
    IF (MessageBox(FParent,
      'Вы действительно хотите преврать текущее задание и удалить его?',
      'Предупреждение',
      MB_ICONQUESTION or MB_YESNO) = IDNO) then Exit;
    FObject.Stop;
    IF FObject.UserCancel then
      OnFinish(nil, true);
  End;
  FList.Delete(ID);
  IF ID <= FCurID then Dec(FCurID);
  Result := true;
End;

Procedure TTasks.Run;
Begin
  IF FStarted then Exit;
  IF Assigned(FObject) then
  Begin
    FObject.Free;
    FObject := nil;
  End;
  IF FCurID >= FList.Count-1 then
    FStarted := false
  else Begin
    Inc(FCurID);
    FObject := T72X.Create(PTaskRec(FList[FCurID])^.FileName);
    FObject.OnFinish := OnFinish;
    FObject.OnSetProgress := OnSetProgress_;
    IF Assigned(FOnNext) then
      FOnNext(Self, FCurID);
    FObject.Start;
    FStarted := true;
  End;
End;

Procedure TTasks.OnFinish(Sender: TObject; Error: boolean);
Begin
  IF Assigned(FOnStatus) then
    FOnStatus(Self, FCurID, Error);
  FObject.Free;
  FObject := nil;
  FStarted := false;
  Run;
End;

Procedure TTasks.OnSetProgress_(Sender: TObject; Progress: integer);
Begin
  IF Assigned(FOnSetProgress) then
    FOnSetProgress(Self, FCurID, Progress);
End;



// ==================== INITIALIZATION ========================================

Procedure Init;
Var
  S: string;
Begin
  ProgramPath := ExtractFilePath(ParamStr(0));
  SetLength(S, MAX_PATH*2);
  TempPath := Copy(S, 1, GetTempPath(MAX_PATH*2, @S[1]));
  {$IFDEF LOG}
  Assign(LogFile, ChangeFileExt(ParamStr(0), '.log'));
  {$I-} Append(LogFile); {$I+}
  IF IOResult <> 0 then
    Rewrite(LogFile);
  {$ENDIF}
End;

Initialization
  Init;

Finalization
  {$IFDEF LOG} Close(LogFile); {$ENDIF LOG}

End.
