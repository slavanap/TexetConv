LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"

Name "Конвертер видео teXet для плееров T-66x"
OutFile "TexetInst.exe"
InstallDir "$PROGRAMFILES\Конвертер видео teXet для плееров T-66x"
InstallDirRegKey HKLM "Software\Texet_66x" "Install_Dir"

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

Section "Файлы конвертера"
  SectionIn RO
  SetOutPath $INSTDIR
  
  File "texetconv.exe"
  File "mencoder.exe"
  File "mplayer.exe"
  SetOutPath $INSTDIR\mplayer
  File mplayer\*.*
  SetOutPath $INSTDIR\codecs
  File codecs\*.*
  
  WriteRegStr HKLM SOFTWARE\Texet_66x "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Texet_66x" "DisplayName" "Конвертер видео teXet для плееров T-66x"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Texet_66x" "DisplayIcon" "$INSTDIR\texetconv.exe,0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Texet_66x" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Texet_66x" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Texet_66x" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  CreateDirectory "$SMPROGRAMS\teXet"
  CreateShortCut "$SMPROGRAMS\teXet\Конвертер teXet для T-66x.lnk" "$INSTDIR\texetconv.exe" "" "$INSTDIR\texetconv.exe" 0
  
SectionEnd

;--------------------------------

Section "Uninstall"
  DeleteRegKey HKLM SOFTWARE\Texet_66x
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Texet_66x"

  Delete "$INSTDIR\texetconv.exe"
  Delete "$INSTDIR\mencoder.exe"
  Delete "$INSTDIR\mplayer.exe"
  Delete "$INSTDIR\mplayer\*.*"
  RMDir "$INSTDIR\mplayer"
  Delete "$INSTDIR\codecs\*.*"
  RMDir "$INSTDIR\codecs"

  Delete "$INSTDIR\uninstall.exe"

  Delete "$SMPROGRAMS\teXet\Конвертер teXet для T-66x.lnk"
  RMDir "$SMPROGRAMS\teXet"
  RMDir "$INSTDIR"
SectionEnd