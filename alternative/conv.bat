@ECHO OFF
ECHO.
ECHO EXE compiler is runing...
ECHO.
ml /nologo /c /Fl /Sn /Sc /coff /ID:\MASM32\INCLUDE *.asm
IF ERRORLEVEL 1 GOTO ASMError

IF NOT EXIST rs.res GOTO ASMToEXE_nores
ECHO  Compile:    rs.res
CVTRES /machine:ix86 rs.res > NUL

:ASMToEXE_nores
ECHO  Create:     %~n0.exe
link /nologo /out:%~n0.exe /SUBSYSTEM:WINDOWS /LIBPATH:D:\masm32\LIB *.obj
IF ERRORLEVEL 1 GOTO LINKError
DEL *.obj
ECHO.
ECHO EXE compile complited.
ECHO.
PAUSE > NUL
GOTO TheEnd



:ASMError
ECHO.
ECHO.
ECHO ERROR: Assembly error.
ECHO.
ECHO Press any key for exit.
ECHO.
PAUSE > NUL
GOTO TheEnd



:LINKError
ECHO.
ECHO.
ECHO ERROR: Link error.
ECHO.
ECHO Press any key for exit.
ECHO.
PAUSE > NUL
GOTO TheEnd



:TheEnd
