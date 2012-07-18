@echo off
cls
goto MENU

:MENU
echo.
echo What would you like to do?
echo.
echo Choice
echo.
REM Selezionare questa opzione se si vuole creare immagini per sistemi amd64
echo 1 AIK Console - amd64 Native Prompt
REM Selezionare questa opzione se il proprio computer di laboratorio è amd64 ma si vuole creare immagini x86
echo 2 AIK Console - x86 on amd64 Prompt
echo 3 Quit
echo.


:CHOICE
set /P C=[1,2,3]?
if "%C%"=="3" goto QUIT
REM Aggiungiamo un ciclo di controllo qui dato che 32o64 è l'ultimo file della console che non è stato validato.
if "%C%"=="2" goto 32O64CHK
if "%C%"=="1" goto NATIVE
goto CHOICE

:NATIVE
call %~dp0\AIKConsole_native.cmd
goto QUIT	

:32O64CHK
IF EXIST %~dp0\AIKConsole_32o64.cmd (
goto 32O64
) else goto 32O64ERROR

:32O64ERROR
echo.
echo AIKConsole_32o64.cmd could not be found, do you have a working Deployment Frontend distribution?
echo.
goto END

:32O64
call %~dp0\AIKConsole_32o64.cmd
goto QUIT

:QUIT
exit

:end
