@ECHO OFF
REM Pulisce lo schermo
cls
REM Controlla che cmd.exe sia presente. Il controllo non e' accuratissimo ma se la variabile e' presente , in 99 casi su 100 ha il contenuto corretto.
IF %comspec% == "" (

echo cmd.exe could not be found, is this a valid Windows 7 Installation?

) ELSE (
REM Chiama cmd.exe e imposta le variabili d'ambiente necessarie per l'utilizzo dei componenti di AIK. NOTA: USMT e VAMT non sono presenti nelle variabili d'ambiente e vanno chiamati separatametne.
%comspec% /K "%~dp0\Scripts\env.cmd"
goto END

)

:END
