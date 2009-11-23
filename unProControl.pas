Unit unProControl;
Interface

Uses
  Windows, Messages, SysUtils, Types, ShlObj, ActiveX{, unDebug};

Type
  TConvStatus = (csRun, csPause, csStop);
  TOnChangeProgress = procedure (sender: TObject; Procent, TimeLeft: integer) of object;
  TOnChangeStatus = procedure (sender: TObject; status: TConvStatus;
      fError: boolean) of object;

Type
  TConverter = class
  Private
    FOnChangeProgress: TOnChangeProgress;
    FOnChangeStatus: TOnChangeStatus;

    FStatus: TConvStatus;
    FError: boolean;

    hStopEvent: THandle;
    hScyWnd: HWND;
    lpOldWndProc: pointer;

    hRPipe: THandle;
    hTimerThread: THandle;
    PI: TProcessInformation;

    Procedure Run;
    Procedure Pause;
    Procedure Stop;
    Procedure SetStatus(Value: TConvStatus);
  Public
    Constructor Create;
    Destructor Destroy; override;
    Procedure Initialize(const cmd: string);
    Property OnChangeProgress: TOnChangeProgress read FOnChangeProgress
        write FOnChangeProgress;
    Property OnChangeStatus: TOnChangeStatus read FOnChangeStatus
        write FOnChangeStatus;
    Property Status: TConvStatus read FStatus write SetStatus;
  End;

Procedure ExtractTime(tm: cardinal; out h,m,s: word); overload;
Function ExtractTime(h,m,s: word): cardinal; overload;
Function RunAndReadAll(const szApplication, szParams: string): string;
Function BrowseForFolder(var Folder: string; Handle: HWND;
  const szText: string): Boolean;

Implementation


Procedure ExtractTime(tm: cardinal; out h,m,s: word); overload;
Begin
  h := tm div 3600;  tm := tm mod 3600;
  m := tm div 60;    s := tm mod 60;
End;

Function ExtractTime(h,m,s: word): cardinal; overload;
Begin
  Result := h*3600 + m*60 + s;
End;

Function RunAndReadAll(const szApplication, szParams: string): string;
Var
  SI: TStartupInfo;
  PSA: TSecurityAttributes;
  hRPipe, hWPipe: THandle;
  PI: TProcessInformation;

  Buffer: string;
  cbRead: cardinal;
  B: boolean;
Begin
  hRPipe := 0; hWPipe := 0;
  ZeroMemory(@PI, SizeOf(PI));
  ZeroMemory(@SI, SizeOf(SI));
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
    IF not CreateProcess(PChar(szApplication), PChar(szParams), nil, nil, true,
      CREATE_DEFAULT_ERROR_MODE or CREATE_SUSPENDED, nil, nil, SI, PI) then
        raise Exception.Create('Не могу создать дочерний процесс.');
  Finally
    CloseHandle(hWPipe);
  End;

  ResumeThread(PI.hProcess);
  ResumeThread(PI.hThread);

  SetLength(Buffer, 1024);
  Result := '';
  Repeat
    B := ReadFile(hRPipe, Buffer[1], 1024, cbRead, nil);
    Result := Result + Copy(Buffer, 1, cbRead);
  Until (WaitForSingleObject(PI.hProcess, 0) = WAIT_OBJECT_0) and not B;

  CloseHandle(PI.hProcess);
  CloseHandle(PI.hThread);
  CloseHandle(hRPipe);
End;





{ *** Класс TConverter *** }

Function ScyWndProc(Handle: HWND; uMsg: cardinal;
  wParam, lParam: integer): integer; stdcall; forward;
Function ConvStartThread(Conv: TConverter): integer; stdcall; forward;


Constructor TConverter.Create;
Begin
  inherited Create;
  FStatus := csStop;

  hStopEvent := CreateEvent(nil, false, false, nil);
  IF hStopEvent = 0 then
    raise Exception.Create('Не могу создать объект "event"');
  hScyWnd := CreateWindowEx(0, 'EDIT', nil, 0, 0, 0, 0, 0, HWND_DESKTOP, 0, HInstance, nil);
  IF hScyWnd = 0 then
    raise Exception.Create('Не могу создать окно, обрабатывающее сообщения');
  integer(lpOldWndProc) := SetWindowLong(hScyWnd, GWL_WNDPROC, integer(@ScyWndProc));
  SetWindowLong(hScyWnd, GWL_USERDATA, integer(TConverter(self)));
End;

Destructor TConverter.Destroy;
Begin
  IF Status <> csStop then Status := csStop;
  SetWindowLong(hScyWnd, GWL_WNDPROC, integer(lpOldWndProc));
  DestroyWindow(hScyWnd);
  CloseHandle(hStopEvent);
  inherited;
End;

Procedure TConverter.Initialize(const cmd: string);
Var
  SI: TStartupInfo;
  PSA: TSecurityAttributes;
  hWPipe: THandle;
  ThreadID: cardinal;
Begin
  FError := false;
  hRPipe := 0; hWPipe := 0;
  ZeroMemory(@PI, SizeOf(PI));
  ZeroMemory(@SI, SizeOf(SI));
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
      IF not CreateProcess(PChar(ExtractFilePath(ParamStr(0))+'mencoder.exe'),
        PChar(cmd), nil, nil, true,
        CREATE_DEFAULT_ERROR_MODE or CREATE_SUSPENDED or IDLE_PRIORITY_CLASS,
        nil, nil, SI, PI) then
          raise Exception.Create('Не могу создать дочерний процесс.');
    Finally
      CloseHandle(hWPipe);
    End;
    hTimerThread := CreateThread(nil, 0, @ConvStartThread, TConverter(self), 0, ThreadID);
    IF hTimerThread = 0 then
      raise Exception.Create('Не могу создать поток.');
    FStatus := csPause;
  Except
    FError := true;
    Stop;
  End;
  IF Assigned(FOnChangeStatus) then
    FOnChangeStatus(self, csPause, FError);
End;

Procedure TConverter.SetStatus(Value: TConvStatus);
Begin
  IF Value <> FStatus then
    Case Value of
      csRun: Run;
      csPause: Pause;
      csStop: Stop;
    End;
End;




Const
  WM_SETVAR = WM_APP + 1;
  WM_SETPROGRESS = WM_APP + 2;

{ Поток, который производит обработку данных от MEncoder'а }

Function ConvStartThread(Conv: TConverter): integer; stdcall;
Var
  cbRead: cardinal;
  I, Procent, TimeLeft, LastProcent{, LastTimeLeft}: integer;
  Buffer: string;
  S, T: string;
Begin
  LastProcent := -1; Procent := -1;
//  LastTimeLeft := 0;
  TimeLeft := 0;
  SetLength(Buffer, 4096);
  Repeat
    Try
      ReadFile(Conv.hRPipe, Buffer[1], 4096, cbRead, nil);
      S := Copy(Buffer, 1, cbRead);
//      Write(LogFile, S);
      // Поиск наличия ошибки
      I := Pos('Exiting', S);
      IF I <> 0 then
        IF Pos('error', Copy(S, i, length(S)-i+1)) <> 0 then
          Conv.FError := true;
      // Поиск процента выполнения ...
      I := Pos('%)', S);
      IF I >= 3 then
      Begin
        T := Copy(S, I-3, 3);
        Delete(T, 1, Pos('(', T));
        While T[1]=' ' do Delete(T, 1, 1);
        Procent := StrToInt(T);
      End;
      I := Pos('min', S);
      IF I >= 7 then
      Begin
        T := Copy(S, I-7, 7);
        While not (T[1] in ['0'..'9']) do Delete(T, 1, 1);
        TimeLeft := StrToInt(T);
      End;

      IF (Procent <> LastProcent) {or (TimeLeft <> LastTimeLeft)} then
      Begin
        LastProcent := Procent;
//        LastTimeLeft := TimeLeft;
        PostMessage(Conv.hScyWnd, WM_SETPROGRESS, Procent, TimeLeft);
      End;
    Except End;
    IF WaitForSingleObject(Conv.PI.hProcess, 0) = WAIT_OBJECT_0 then
    Begin
      cbRead := 0;
      GetExitCodeProcess(Conv.PI.hProcess, cbRead);
      IF cbRead <> 0 then
        Conv.FError := true;
      PostMessage(Conv.hScyWnd, WM_TIMER, 0, 0);
      WaitForSingleObject(Conv.hStopEvent, INFINITE);
      Break;
    End;
  Until WaitForSingleObject(Conv.hStopEvent, 0) = WAIT_OBJECT_0;
  Result := 0;
End;


{ Окно, для получения сообщений от потока, создано в главном потоке }

Function ScyWndProc(Handle: HWND; uMsg: cardinal; wParam, lParam: integer): integer;
Var
  Conv: TConverter;
Begin
  IF uMsg = WM_TIMER then
  Begin
    integer(Conv) := GetWindowLong(Handle, GWL_USERDATA);
    Conv.FStatus := csStop;
    Conv.Stop;
    Result := 0;
  End else
  IF uMsg = WM_SETPROGRESS then
  Begin
    integer(Conv) := GetWindowLong(Handle, GWL_USERDATA);
    IF Assigned(Conv.FOnChangeProgress) then
      Conv.FOnChangeProgress(Conv, wParam, lParam);
    Result := 0;
  End else
    Result := DefWindowProc(Handle, uMsg, wParam, lParam);
End;



{ Управляющие функции }

Procedure TConverter.Run;
Begin
  FError := FStatus = csStop;
  IF not FError then
  Begin
    ResumeThread(hTimerThread);
    ResumeThread(PI.hProcess);
    ResumeThread(PI.hThread);
    FStatus := csRun;
  End;
  IF Assigned(FOnChangeStatus) then
    FOnChangeStatus(self, csRun, FError);
End;

Procedure TConverter.Pause;
Begin
  FError := FStatus = csStop;
  IF not FError then
  Begin
    SuspendThread(PI.hThread);
    SuspendThread(PI.hProcess);
    SuspendThread(hTimerThread);
    FStatus := csPause;
  End;
  IF Assigned(FOnChangeStatus) then
    FOnChangeStatus(self, csPause, FError);
End;

Procedure TConverter.Stop;
Begin
  SetEvent(hStopEvent); // сработает ф. ожидания в потоке для выхода.
  IF WaitForSingleObject(hTimerThread, 5000) = WAIT_TIMEOUT then
    TerminateThread(hTimerThread, $FFFFFFFF);  // если поток не завершится.
  IF FStatus <> csStop then
  Begin
    TerminateProcess(PI.hProcess, $FFFFFFFF);  // останавливаем принудительно.
    FError := true;
  End;
  CloseHandle(hTimerThread);   hTimerThread := INVALID_HANDLE_VALUE;
  CloseHandle(PI.hProcess);    PI.hProcess := INVALID_HANDLE_VALUE;
  CloseHandle(PI.hThread);     PI.hThread := INVALID_HANDLE_VALUE;
  CloseHandle(hRPipe);         hRPipe := INVALID_HANDLE_VALUE;
  FStatus := csStop;

  IF Assigned(FOnChangeStatus) then
    FOnChangeStatus(self, csStop, FError);
End;


Function BrowseForFolder(var Folder: string; Handle: HWND;
  const szText: string): Boolean;
Var
  BI: TBrowseInfo;
  PIDL: PItemIDList;
  Path: array[0..MAX_PATH-1] of Char;
  ResPIDL: PItemIDList;
  ShMalloc: IMalloc;
Begin
  Result := FALSE;
  IF SHGetMalloc(ShMalloc) <> NO_ERROR then
    Exit;
  SHGetSpecialFolderLocation(0, CSIDL_DRIVES, PIDL);
  FillChar(BI, SizeOf(BI), 0);
  With BI do
  Begin
    hwndOwner := Handle;
    lpszTitle := PChar(szText);
    ulFlags := BIF_RETURNONLYFSDIRS;
    pidlRoot := PIDL;
  End;
  resPIDL := SHBrowseForFolder(BI);
  IF Assigned( resPIDL ) then
  Begin
    SHGetPathFromIDList(ResPIDL, @Path[0]);
    Folder := Path;
    ShMalloc.Free(ResPIDL);
    Result := TRUE;
  End;
  ShMalloc.Free(PIDL);
End;

End.
