@ECHO OFF
REM arch sarà la nostra variabile per stabilire l'architettura. Le opzioni possibili sono amd64 e x86
set arch=%1
set targetdir=WinPE_%arch%
goto ARG1CHK

:ARG1CHK
REM Valida il contenuto di arch
IF "%1"=="" goto ARCH_ERROR
IF "%1"=="amd64" goto DUPECHK
IF "%1"=="x86" (
goto DUPECHK 
) else goto ARCH_ERROR

:ARCH_ERROR
echo.
echo You must define an architecture. Viable options are amd64 and x86
goto END

:MAKETREE
REM Chiama gli script di AIK per preparare l'ambiente di boot WinPE
call copype %arch% %targetdir%
call %~dp0\SupportFiles\pebugfix_%arch%.cmd
call %~dp0\SupportFiles\pemount_%arch%.cmd
call %~dp0\SupportFiles\petools_inst_%arch%.cmd
call %~dp0\SupportFiles\3ptools_inst_%arch%.cmd
call %~dp0\SupportFiles\pedismount_%arch%.cmd
goto REMOUNTCHK

:DUPECHK
REM Controlla se è gia presente una directory con lo stesso nome, in modo da evitare di sovrascriverla.
IF EXIST "%~dp0\%targetdir%" goto DUPEWARN
goto MAKETREE

:DUPEWARN
cls
echo.
echo %outdir% already exists. If you want to overwrite, press any key. To abort, press Control-C
PAUSE > NUL
goto MAKETREE

:REMOUNTCHK
cls
echo.
echo The WinPE environment for %arch% has been setup in %~dp0\WinPE_%arch%. If you want to mount the WIM file to add packages or driver, press any key. To abort, press Ctrl-C.
PAUSE > NUL
goto REMOUNT

:REMOUNT
cls
echo.
echo WinPE_%arch% will be now mounted. Run %~dp0\SupportFiles\dismount_%arch%.cmd to commit your changes to the wim file. PLEASE NOTE: if you'd like to revert your changes, please run abortmount_%arch%.cmd in the same directory
call %~dp0\SupportFiles\mount_%arch%.cmd
goto END

:END
