@ECHO OFF
REM Chiama lo script di Microsoft che crea l'ambiente di AIK. NOTA BENE: Questo script *deve* essere chiamato da AIKConsole.cmd o non funzionerà. 
call "%~dp0..\Windows AIK\Tools\PETools\pesetenv.cmd"
cd ..\..\..\