@echo off
cls
goto menu
:menu
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


:choice
set /P C=[1,2,3]?
if "%C%"=="3" goto quit
if "%C%"=="2" goto 32o64
if "%C%"=="1" goto native
goto choice

:native
call %~dp0\AIKConsole_native.cmd
goto quit

:32o64
call %~dp0\AIKConsole_32o64.cmd
goto quit

:quit
exit

:end
