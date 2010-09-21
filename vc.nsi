LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"

!define COMPANYNAME "Нападовский Вячеслав"
!define APP_NAME 'Texet_72x_73x_74x'
!define APP_DESC 'Конвертер видео teXet для плееров T-72X, T-73X, T-74X'
!define APP_LINK 'Конвертер teXet для плееров T-72X, T-73X, T-74X'
!define UNINSTALLREG 'Software\Microsoft\Windows\CurrentVersion\Uninstall\'

Name "${APP_DESC}"
OutFile "TexetInst.exe"
InstallDir "$PROGRAMFILES\${APP_NAME}"
InstallDirRegKey HKLM "Software\${APP_NAME}" "Install_Dir"

XPStyle on

RequestExecutionLevel admin

;--------------------------------

; Pages

;Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

SetCompressor /SOLID lzma

Icon "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
UninstallIcon "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

;--------------------------------

Section ""
  SectionIn RO
  SetOutPath $INSTDIR
  
  File "vc.exe"
  File "mencoder.exe"
  File "mplayer.exe"
  File "ffmpeg.exe"
  SetOutPath $INSTDIR\mplayer
  File mplayer\*.*
  SetOutPath $INSTDIR\codecs
  File codecs\*.*
  
  WriteRegStr HKLM "SOFTWARE\Texet" "MencoderDir" "$INSTDIR"
  
  WriteRegStr HKLM "SOFTWARE\${APP_NAME}" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTALLREG}${APP_NAME}" "DisplayName" "${APP_DESC}"
  WriteRegStr HKLM "${UNINSTALLREG}${APP_NAME}" "DisplayIcon" "$INSTDIR\vc.exe,0"
  WriteRegStr HKLM "${UNINSTALLREG}${APP_NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "${UNINSTALLREG}${APP_NAME}" "NoModify" 1
  WriteRegDWORD HKLM "${UNINSTALLREG}${APP_NAME}" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  ;CreateDirectory "$SMPROGRAMS\teXet"
  CreateShortCut "$SMPROGRAMS\${APP_LINK}.lnk" "$INSTDIR\vc.exe" "" "$INSTDIR\vc.exe" 0
  
SectionEnd

;--------------------------------

Section "Uninstall"
  DeleteRegKey HKLM "SOFTWARE\${APP_NAME}"
  DeleteRegKey HKLM "${UNINSTALLREG}${APP_NAME}"

  Delete "$INSTDIR\vc.exe"
  Delete "$INSTDIR\mencoder.exe"
  Delete "$INSTDIR\mplayer.exe"
  Delete "$INSTDIR\ffmpeg.exe"
  Delete "$INSTDIR\mplayer\*.*"
  RMDir "$INSTDIR\mplayer"
  Delete "$INSTDIR\codecs\*.*"
  RMDir "$INSTDIR\codecs"

  Delete "$INSTDIR\uninstall.exe"

  Delete "$SMPROGRAMS\${APP_LINK}.lnk"
  ;RMDir "$SMPROGRAMS\teXet"
  RMDir "$INSTDIR"
SectionEnd