@echo off

REM Controlla l'architettura. Se si è su x86, lancia automaticamente l'ambiente nativo. Se si è su AMD64, permette di scegliere tra l'ambiente nativo e quello per x86.
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
goto 64BIT
) else (
goto 32BIT
)
REM ATTENZIONE! Il sistema di script che crea/gestisce la console AIK è un tuttuno organico con il tree delle directory in cui è collocato. Tutto avviene tramite dei path relativi pertanto è possibile spostare la root dove si vuole ma non è possibile spostare i file al suo interno o gli script cesseranno di funzionare.

:32BIT
call %~dp0\AIKConsole_native.cmd
goto END

:64BIT
call %~dp0\AIKConsole_menu.cmd
goto END

:END
