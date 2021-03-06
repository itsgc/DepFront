@echo off

REM Controlla l'architettura. Se si è su x86, lancia automaticamente l'ambiente nativo. Se si è su AMD64, permette di scegliere tra l'ambiente nativo e quello per x86.
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
goto 64BIT
) else (
goto 32BIT
)
REM ATTENZIONE! Il sistema di script che crea/gestisce la console AIK è un tuttuno organico con il tree delle directory in cui è collocato. Tutto avviene tramite dei path relativi pertanto è possibile spostare la root dove si vuole ma non è possibile spostare i file al suo interno o gli script cesseranno di funzionare.

:32BIT
goto CON_NATCHK

:64BIT
goto CON_MENUCHK

:CON_NATCHK
IF EXIST %~dp0\AIKConsole_native.cmd (
goto NATIVELAUNCH ) else goto CON_NATERROR

:CON_NATERROR
echo.
echo AIKConsole_native.cmd could not be found. Are you using a working distribution of the Deployment Frontend?
echo.
goto END

:CON_MENUCHK
IF EXIST %~dp0\AIKConsole_menu.cmd (
goto MENULAUNCH ) else goto CON_MENUERROR

:CON_MENUERROR
echo.
echo AIKConsole_menu.cmd could not be found. Are you using a working distribution of the Deployment Frontend?
echo.
goto END

:NATIVELAUNCH
call %~dp0\AIKConsole_native.cmd
goto END

:MENULAUNCH
REM Il menu verrà lanciato solo se viene rilevata una architettura amd64. Lo scopo e' permettere la selezione dell'ambiente dato che i sistemi a 64 bit possono creare dischi di boot e di installazione per entrambe le architetture.
call %~dp0\AIKConsole_menu.cmd
goto END

:END
