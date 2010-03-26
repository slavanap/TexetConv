.386
.MODEL flat, stdcall
OPTION casemap: none

; ############### Includes & libraries ##################################################

  .NOLIST

  INCLUDE windows.inc
  INCLUDE kernel32.inc
  INCLUDE user32.inc
  INCLUDE ComCtl32.inc
  INCLUDE advapi32.inc

  INCLUDELIB kernel32.lib
  INCLUDELIB user32.lib
  INCLUDELIB ComCtl32.lib
  INCLUDELIB ComDlg32.lib
  INCLUDELIB advapi32.lib

  INCLUDE default.inc

  .LISTALL

; ############### Constants Section #####################################################

  DIALOG_MAIN		EQU		1
  ICON_MAIN		EQU		1
  ID_PROGRESS		EQU		1
  ID_CANCEL		EQU		2

  AUDIO_QUALITY		EQU		128
  VIDEO_QUALITY		EQU		700

  WM_SETPROGRESS	EQU		WM_USER + 500
  WM_EXITPROCESS	EQU		WM_USER + 501
  WM_SETTIMELEFT	EQU		WM_USER + 502
  CREATE_DEFAULT_ERROR_MODE	EQU	4000000h

  OPENFILENAMEW		EQU		<OPENFILENAMEA>


; ############### Data Section ##########################################################

.CONST
  szAdded		DW		' ','(','c','o','n','v','e','r','t','e','d',')','.','a','v','i',0
  slAdded		=		($-szAdded)/2
  
  szCmdLineFormat	DB		'-noodml -of avi "%s" -o "%s" '
    DB '-oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=%u -channels 2 '
    DB '-ovc xvid -xvidencopts bitrate=%u:max_bframes=0:quant_type=h263:vhq=0:me_quality=0:rc_buffer=1000000 -ofps 15 '
    DB '-vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1',0
    ; InFile, OutFile, AQ, VQ
  slCmdLineFormat	=		$-szCmdLineFormat

  szPathKey1		DB		'SOFTWARE\Texet_66x',0
  szPathKey2		DB		'SOFTWARE\Texet_56x_59x',0
  szPathKey3		DB		'SOFTWARE\Texet',0
  szInstallDir		DB		'Install_Dir',0
  szMencoderDir		DB		'MencoderDir',0
  rcKeys		DD		OFFSET szPathKey1, OFFSET szInstallDir, OFFSET szPathKey2, OFFSET szInstallDir, \
					OFFSET szPathKey3, OFFSET szMencoderDir
  nKeysCount		=		($-rcKeys)/8
  szMencoderExe		DB		'\mencoder.exe',0
  slMencoderExe		=		$-szMencoderExe
  szMsgSuccess		DB		'Конвертация успешно завершена!',0
  szMsgError		DB		'В процессе конвертации произошли ошибки!',0
  szMessage		DB		'Сообщение',0
  szFilterData		DB		'Все поддерживаемые форматы',0,'*.avi;*.rm;*.rmvb;*.mpg;*.mpeg;*.mp4;*.asf;*.wmv;*.mkv;*.dat;*.vob;*.flv',0
			DB		'Файл AVI (*.avi)',0,'*.avi',0
			DB		'Файл Real (*.rm;*.rmvb)',0,'*.rm;*.rmvb',0
			DB		'Файл Mpeg (*.mpg;*.mpeg;*.mp4)',0,'*.mpg;*.mpeg;*.mp4',0
			DB		'Файл Asf (*.asf)',0,'*.asf',0
			DB		'Файл WMV (*.wmv)',0,'*.wmv',0
			DB		'Файл Mkv (*.mkv)',0,'*.mkv',0
			DB		'Файл VCD (*.dat)',0,'*.dat',0
			DB		'Файл DVD (*.vob)',0,'*.vob',0
			DB		'FlashVideo (*.flv;*.flac)',0,'*.flv;*.flac',0
			DB		'Все файлы (*.*)',0,'*.*',0,0
  slFilterData		=		$-szFilterData
  szSelectFileMsg	DB		'Выберите файл для конвертации',0
  slSelectFileMsg	=		$-szSelectFileMsg
  szInitialDir		DB		'.',0,0,0
  szNoMencoderMsg	DB		'Сначала установите стандартный конвертер',0


.DATA?
  hInstance		DD		?
  hMain			DD		?
  dwResult		DD		?
  hMainIcon		DD		?
  szInFile		DW		MAX_PATH*2 DUP(?)
  szOutFile		DW		MAX_PATH*2 DUP(?)
  szDosInFile		DW		MAX_PATH*2 DUP(?)
  szDosOutFile		DW		MAX_PATH*2 DUP(?)
  szMencoderFile	DB		MAX_PATH*2 DUP(?)
  szCmdLine		DB		MAX_PATH*3 DUP(?)
  szFilter		DW		slFilterData DUP(?)
  szSelectFile		DW		slSelectFileMsg DUP(?)

  hStopEvent		DD		?
  hRPipe		DD		?
  PI			PROCESS_INFORMATION <>
  hTimerThread		DD		?
  dwError		DD		?
  bRun			DB		?

; ############### Procedures declarations ###############################################

  GetCommandLineW	PROTO
  CreateFileW		PROTO		:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
  MessageBoxW		PROTO		:DWORD,:DWORD,:DWORD,:DWORD
  GetShortPathNameW	PROTO		:DWORD,:DWORD,:DWORD
  DialogBoxParamW	PROTO		:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
  GetOpenFileNameW	PROTO		:DWORD
  
  MainProc		PROTO		Handle:DWORD, Msg:DWORD, wParam:DWORD, lParam:DWORD
  PercentThread		PROTO		:DWORD
  CloseChildProcess	PROTO

; ############### Module declarations ###################################################
; ############### Code Section ##########################################################

.CODE

OpenDlgW proc Handle:DWORD, nIndex:DWORD, lpFilter:DWORD, lpFileName:DWORD, lpExtension:DWORD, lpTitle:DWORD
      MOV  EAX, ESP				; ---------------------- OPENFILENAMEW struct stack
      PUSH nil					; lpTemplateName
      PUSH nil					; lpfnHook
      PUSH 0					; lCustData
      PUSH lpExtension				; lpstrDefExt
      PUSH 0					; nFileExtension, nFileOffset
      PUSH ofnFlags				; Flags
      PUSH lpTitle				; lpstrTitle
      PUSH OFFSET szInitialDir			; lpstrInitialDir
      PUSH 0					; nMaxFileTitle
      PUSH nil					; lpstrFileTitle
      PUSH MAX_PATH*2				; nMaxFile
      PUSH lpFileName				; lpstrFile
      PUSH nIndex				; nFilterIndex
      PUSH 0					; nMaxCustFilter
      PUSH nil					; lpstrCustomFilter
      PUSH lpFilter				; lpstrFilter
      PUSH hInstance				; hInstance
      PUSH Handle				; hwndOwner
      PUSH SIZEOF OPENFILENAME			; lStructSize
      MOV  EDX, ESP
      PUSH EAX					; ---------------------- OPENFILENAMEW ends
      INVOKE GetOpenFileNameW, EDX
      TEST EAX, EAX
      JZ   @F
      MOV  EAX, (OPENFILENAMEW PTR [ESP+4]).nFilterIndex
  @@: POP  ESP
      RET
OpenDlgW Endp

CheckCmdLine proc
      MOV  EBX, OFFSET szMencoderFile
      MOV  ESI, OFFSET rcKeys
      XOR  ECX, ECX
      MOV  CL, nKeysCount
  @CheckLoop:
      PUSH ECX
      PUSH 0h
      INVOKE RegOpenKeyEx, HKEY_LOCAL_MACHINE, [ESI], 0, KEY_READ, ESP
      POP  EDI
      TEST EAX, EAX
      JNE  @CheckNext
      PUSH 0h
      PUSH MAX_PATH
      INVOKE RegQueryValueEx, EDI, [ESI+4], 0, ADDR [ESP+12], EBX, ESP
      POP  EDX
      MOV  [ESP], EAX
      INVOKE RegCloseKey, EDI
      POP  EAX
  @CheckNext:
      ADD  ESI, 8
      TEST EAX, EAX
      POP  ECX
      LOOPNE @CheckLoop
      JNE  @ErrorNoMencoder

      INVOKE GetCommandLineW
      MOV  ESI, EAX
      MOV  EBX, OFFSET szInFile

      XOR  ECX, ECX
      MOV  CL, 2
  @Loop:
      MOV  EDI, EBX
  @@: LODSW
      TEST AX, AX
      JE   @ErrorNoFile
      CMP  AX, ' '
      JE   @B
      CMP  AX, '"'
      JE   @1
      STOSW
  @@: LODSW
      STOSW
      CMP  AX, ' '
      JE   @ErrorNoFile
      TEST AX, AX
      JNE  @B
      JMP  @F
  @1: LODSW
      STOSW
      TEST AX, AX
      JE   @ErrorNoFile
      CMP  AX, '"'
      JNE  @1
  @@: LOOP @Loop
      XOR  EAX, EAX
      MOV  [EDI-2], AX

      MOV  ECX, EDI
      ADD  ECX, -2
      SUB  ECX, EBX
      SHR  ECX, 1
      
   @ContinueWithFile:
      MOV  EDI, OFFSET szOutFile
      MOV  ESI, EBX

      PUSH ECX
      REP  MOVSW
      POP  ECX
      PUSH EDI
      STD
      MOV  AX, '.'
      REPNE SCASW
      CLD
      JNE  @F
      ADD  EDI, 2
      MOV  [ESP], EDI
  @@: POP  EDI
      MOV  ESI, OFFSET szAdded
      XOR  ECX, ECX
      MOV  CL, slAdded
      REP  MOVSW
      INVOKE CreateFileW, OFFSET szOutFile, 0, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
      CMP  EAX, INVALID_HANDLE_VALUE
      JE   @Error
      INVOKE GetShortPathNameW, EBX, OFFSET szDosInFile, MAX_PATH*2
      CMP  EAX, MAX_PATH*2
      JAE  @Error
      TEST EAX, EAX
      JE   @Error
      MOV  ESI, OFFSET szDosInFile
      MOV  EDI, ESI
      MOV  ECX, EAX
      INC  ECX
  @@: LODSW
      STOSB
      LOOP @B
      MOV  EBX, OFFSET szDosOutFile
      INVOKE GetShortPathNameW, OFFSET szOutFile, EBX, MAX_PATH*2
      CMP  EAX, MAX_PATH*2
      JAE  @Error
      TEST EAX, EAX
      JE   @Error
      MOV  ESI, EBX
      MOV  EDI, EBX
      MOV  ECX, EAX
      INC  ECX
  @@: LODSW
      STOSB
      LOOP @B

      MOV  EDI, EBX
      XOR  ECX, ECX
      MOV  EAX, ECX
      DEC  ECX
      REPNE SCASB
      DEC  EDI
      MOV  ESI, OFFSET szMencoderExe
      XOR  ECX, ECX
      MOV  CL, slMencoderExe
      REP  MOVSB

      XOR  EAX, EAX
      RET
  @ErrorNoFile:
      CMP  ECX, 1
      JNE  @Error
      XOR  EAX, EAX
      MOV  [EBX], AX
      INVOKE OpenDlgW, 0, 1, OFFSET szFilter, EBX, nil, OFFSET szSelectFile
      TEST EAX, EAX
      JE   @Error
      MOV  EDI, EBX
      XOR  EAX, EAX
      REPNE SCASW
      MOV  ECX, EDI
      ADD  ECX, -2
      SUB  ECX, EBX
      SHR  ECX, 1
      JMP  @ContinueWithFile
      
  @ErrorNoMencoder:
      INVOKE MessageBox, 0, OFFSET szNoMencoderMsg, nil, MB_ICONWARNING

  @Error:
      XOR  EAX, EAX
      ADD  EAX, -2
      RET
CheckCmdLine Endp

StrToInt proc USES EDI ESI EBX, lpStr:DWORD		; output : int64 = EDX:EAX
      MOV  ESI, lpStr
      ; o EDX:EBX, EDI:ECX
      XOR  EAX, EAX
      MOV  EBX, EAX
      MOV  EDX, EAX
  @loop:
      LODSB
      TEST AL, AL
      JE   @1
      CMP  AL, 39h
      JA   @Error
      CMP  AL, 30h
      JB   @Error
      XOR  AL, 30h

      SHLD EDX, EBX, 1
      SHL  EBX, 1
      MOV  EDI, EDX
      MOV  ECX, EBX
      SHLD EDI, EBX, 2
      SHL  ECX, 2

      ADD  EBX, ECX
      ADC  EDX, EDI
      ADD  EBX, EAX
      JNC  @loop
      INC  EDX
      JMP  @loop
  @Error:
      XOR  EBX, EBX
      DEC  EBX
      MOV  EDX, EBX
  @1: MOV  EAX, EBX
      RET
StrToInt Endp

CreateChildProcess proc
  LOCAL rcSI: STARTUPINFO
  LOCAL PSA: SECURITY_ATTRIBUTES
  LOCAL hWPipe: DWORD
  LOCAL ThreadID: DWORD
      INVOKE CreateEvent, nil, false, false, nil
      TEST EAX, EAX
      JE   @Error
      MOV  hStopEvent, EAX
      INVOKE RtlZeroMemory, ADDR ThreadID, SIZEOF STARTUPINFO + SIZEOF SECURITY_ATTRIBUTES + 8
      INVOKE RtlZeroMemory, OFFSET PI, SIZEOF PROCESS_INFORMATION
      MOV  PSA.nLength, SIZEOF SECURITY_ATTRIBUTES
      INC  PSA.bInheritHandle
      MOV  rcSI.cb, SIZEOF STARTUPINFO
      MOV  rcSI.dwFlags, STARTF_USESHOWWINDOW or STARTF_FORCEOFFFEEDBACK or STARTF_USESTDHANDLES
      MOV  rcSI.wShowWindow, SW_HIDE
      INVOKE CreatePipe, OFFSET hRPipe, ADDR hWPipe, ADDR PSA, 4096
      TEST EAX, EAX
      JE   @Error
      MOV  EAX, hWPipe
      MOV  rcSI.hStdOutput, EAX
      MOV  rcSI.hStdError, EAX

      MOV  EDI, OFFSET szCmdLine
      INVOKE wsprintf, EDI, OFFSET szCmdLineFormat, OFFSET szDosInFile, OFFSET szDosOutFile, 
          AUDIO_QUALITY, VIDEO_QUALITY
      INVOKE CreateProcess, OFFSET szMencoderFile, EDI, nil, nil, true, 
          CREATE_DEFAULT_ERROR_MODE or CREATE_SUSPENDED or IDLE_PRIORITY_CLASS, nil, nil, ADDR rcSI, OFFSET PI
      TEST EAX, EAX
      JE   @Error
      INVOKE CloseHandle, hWPipe
      PUSH 0h
      INVOKE CreateThread, nil, 0, OFFSET PercentThread, hRPipe, CREATE_SUSPENDED, ESP
      POP  EDX
      TEST EAX, EAX
      JE   @Error
      MOV  hTimerThread, EAX
      MOV  bRun, 1
      XOR  EAX, EAX
      RET
  @Error:
      INVOKE CloseChildProcess
      XOR  EAX, EAX
      ADD  EAX, -3
      RET
CreateChildProcess Endp

PercentThread proc Handle:DWORD
  LOCAL Procent: DWORD
  LOCAL TimeLeft: DWORD

      XOR  EAX, EAX
      MOV  TimeLeft, EAX
      DEC  EAX
      MOV  Procent, EAX
      INVOKE LocalAlloc, LMEM_FIXED, 4096
      MOV  EDI, EAX

  @Loop:
      PUSH 0h
      MOV  EDX, ESP
      INVOKE ReadFile, Handle, EDI, 4096, EDX, nil

      MOV  ECX, [ESP]
      PUSH EDI
      MOV  AL, '%'
      REPNE SCASB
      JNE  @F
      MOV  BYTE PTR [EDI-1], 0
      XOR  ECX, ECX
      MOV  CL, 10
      STD
      MOV  AL, ' '
      REPNE SCASB
      CLD
      ADD  EDI, 2
      MOV  AL, '('
      SCASB
      JE   @1
      DEC  EDI
  @1: INVOKE StrToInt, EDI
      CMP  EAX, Procent
      JE   @F
      MOV  Procent, EAX
      INVOKE PostMessage, hMain, WM_SETPROGRESS, EAX, 0
  @@: POP  EDI
      POP  ECX

comment ^
      PUSH EDI
  @@: MOV  AL, 'm'
      REPNE SCASB
      JNE  @Next
      MOV  AX, 'ni'
      ADD  ECX, -2
      JS   @Next
      JE   @Next
      SCASW
      JNE  @B

      MOV  BYTE PTR [EDI-3], 0
      XOR  ECX, ECX
      MOV  CL, 10
      STD
      MOV  AL, ' '
      REPNE SCASB
      CLD
      ADD  EDI, 2
      INVOKE StrToInt, EDI
      CMP  EAX, TimeLeft
      JE   @F
      MOV  TimeLeft, EAX
      INVOKE PostMessage, hMain, WM_SETTIMELEFT, EAX, 0
  @@: 
  @Next:
      POP  EDI
^

      INVOKE WaitForSingleObject, PI.hProcess, 0
      CMP  EAX, WAIT_OBJECT_0
      JE   @ProcessComplited
      INVOKE WaitForSingleObject, hStopEvent, 0
      CMP  EAX, WAIT_OBJECT_0
      JNE  @Loop
      JMP  @Exit

  @ProcessComplited:    
      PUSH 0h
      INVOKE GetExitCodeProcess, PI.hProcess, ESP
      POP  EDX
      TEST EAX, EAX
      JNE  @F
      XOR  EDX, EDX
      DEC  EDX
  @@: MOV  dwError, EDX
      MOV  bRun, 0
      INVOKE PostMessage, hMain, WM_EXITPROCESS, 0, 0
      INVOKE WaitForSingleObject, hStopEvent, INFINITE
  @Exit:
      INVOKE LocalFree, EDI
      XOR  EAX, EAX
      RET
PercentThread Endp


RunProcess proc
      INVOKE ResumeThread, hTimerThread
      INVOKE ResumeThread, PI.hProcess
      INVOKE ResumeThread, PI.hThread
      RET
RunProcess Endp

CloseChildProcess proc
      INVOKE SetEvent, hStopEvent
      INVOKE WaitForSingleObject, hTimerThread, 5000
      .IF EAX == WAIT_TIMEOUT
            INVOKE TerminateThread, hTimerThread, -1
      .ENDIF
      .IF bRun == 1
            INVOKE TerminateProcess, PI.hProcess, -1
            XOR  EAX, EAX
            DEC  EAX
            MOV  dwError, EAX
      .ENDIF
      INVOKE CloseHandle, hTimerThread
      INVOKE CloseHandle, PI.hProcess
      INVOKE CloseHandle, PI.hThread
      INVOKE CloseHandle, hRPipe
      RET
CloseChildProcess Endp


MainProc proc Handle:DWORD, Msg:DWORD, wParam:DWORD, lParam:DWORD
      MOV  EAX, Msg
      .IF EAX == WM_INITDIALOG
            m2m  hMain, Handle
            INVOKE SendMessage, Handle, WM_SETICON, ICON_BIG, hMainIcon
            INVOKE GetDlgItem, Handle, ID_PROGRESS
            INVOKE SetFocus, EAX
            INVOKE RunProcess
      .ELSEIF (((EAX == WM_COMMAND) && (WORD PTR wParam == ID_CANCEL)) || (EAX == WM_CLOSE))
            INVOKE CloseChildProcess
            INVOKE EndDialog, Handle, -1
      .ELSEIF EAX == WM_SETPROGRESS
            INVOKE GetDlgItem, Handle, ID_PROGRESS
            INVOKE SendMessage, EAX, PBM_SETPOS, wParam, 0
      .ELSEIF EAX == WM_EXITPROCESS
            INVOKE CloseChildProcess
            INVOKE SendMessage, Handle, WM_SETPROGRESS, 100, 0
            MOV  EAX, dwError
            PUSH EAX		; EndDialog.RetCode
            .IF EAX == 0
                  PUSH MB_ICONINFORMATION	; MessageBox.nIcon
                  PUSH OFFSET szMessage		; MessageBox.Caption
                  PUSH OFFSET szMsgSuccess	; MessageBox.Text
            .ELSE
                  PUSH MB_ICONERROR		; MessageBox.nIcon
                  PUSH nil			; MessageBox.Caption
                  PUSH OFFSET szMsgError	; MessageBox.Text
            .ENDIF
            PUSH Handle		; MessageBox.Handle
            CALL MessageBox	; MessageBox
            PUSH Handle		; EndDialog.Handle
            CALL EndDialog
      .ENDIF
  @1: XOR  EAX, EAX
  @2: RET
MainProc Endp

Start:
      INVOKE InitCommonControls
      INVOKE MultiByteToWideChar, 1251, 0, OFFSET szFilterData, slFilterData, OFFSET szFilter, slFilterData
      INVOKE MultiByteToWideChar, 1251, 0, OFFSET szSelectFileMsg, slSelectFileMsg, OFFSET szSelectFile, slSelectFileMsg
      
      INVOKE GetModuleHandle, 0
      MOV  hInstance, EAX
      INVOKE LoadIcon, EAX, ICON_MAIN
      MOV  hMainIcon, EAX
      INVOKE CheckCmdLine
      TEST EAX, EAX
      JNE  Start_Exit
      INVOKE CreateChildProcess
      TEST EAX, EAX
      JNE  Start_Exit
      INVOKE DialogBoxParamW, hInstance, DIALOG_MAIN, HWND_DESKTOP, OFFSET MainProc, 0
Start_Exit:
      INVOKE ExitProcess, EAX

END Start