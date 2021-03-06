@ECHO OFF
REM Pulisce lo schermo
cls
goto CMDCHECK

:CMDCHECK
REM Controlla che cmd.exe (versione 32bit per sistemi x64) sia presente. Il controllo non e' flessibilissimo ma dovrebbe funzionare in 99 casi su 100.
IF NOT EXIST %windir%\syswow64\cmd.exe ( 
goto CMDERROR
) ELSE goto CMDLAUNCH

:CMDERROR
echo.
echo cmd.exe could not be found, is this a valid Windows 7 x64 Installation?
echo.
goto END

:CMDLAUNCH
REM Chiama cmd.exe e imposta le variabili d'ambiente necessarie per l'utilizzo dei componenti di AIK. NOTA: USMT e VAMT non sono presenti nelle variabili d'ambiente e vanno chiamati separatamente.
call %windir%\syswow64\cmd.exe /K "%~dp0\Scripts\env.cmd"
goto END

:END
