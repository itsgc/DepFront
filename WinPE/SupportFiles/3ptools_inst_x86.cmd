@ECHO OFF
set arch=x86
set suppdir=PEBinaries\%arch%
set sysdir=%WINDIR%\system32
set enginefile=xcopy.exe
set destdir=..\WinPE_%arch%\mount\Windows\system32
goto ENGINECHK

:ENGINECHK
IF NOT EXIST "%sysdir%\%enginefile%" (
goto ENGINEERROR
) else goto SRCCHK

:ENGINEERROR
echo.
echo %enginefile% could not be found. Please double check your Windows 7 installation.
echo.
goto END

:SRCCHK
if not "%~dp0%suppdir%"=="" for /f %%e in ('dir "%~dp0%suppdir%\*" /b/a') do goto COPYCHK
goto SRCERROR

:SRCERROR
echo.
echo %suppdir% could not be found or it's empty! Please check your Deployment distribution.
echo.
goto END

:COPYCHK
IF NOT EXIST "%~dp0%destdir%" (
goto COPYERROR
) else goto INSTALL

:COPYERROR
echo.
echo The destination directory for the tools could not be found. Have you run peprep.cmd?
echo.
goto END

:INSTALL
ECHO SUCCESS
call %sysdir%\%enginefile% /E "%~dp0%suppdir%"\* %destdir%
goto END

:END
