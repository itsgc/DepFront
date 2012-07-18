@ECHO OFF
REM Per semplicità, lo script di dismount è uguale a quello di mount, fatta eccezione per gli argomenti.
REM Chiama DISM e monta l'immagine WIM del disco di boot di WinPE per l'architettura specificata
REM Tutti i path e i valori che possono cambiare sono impostati come variabili così da permettere una relativa espandibilità e scalabilità in futuro.
SetLocal
set arch=amd64
REM La Directory della distribuzione WinPE
set perootdir=..\WinPE_%arch%\ISO\sources
REM Il nome dell'immagine Wim di WinPE. 
set pefile=boot.wim
REM La directory dove l'immagine verrà montata
set pemountdir=..\WinPE_%arch%\mount
REM La directory dove si trova il motore (in questo caso DISM)
set enginedir=..\..\Windows AIK\Tools\%arch%\Servicing
REM Il nome del motore
set enginefile=dism.exe
goto INDEXSET

:INDEXSET
set indexid=1
goto ENGINECHK

:ENGINECHK
REM Controlla l'esistenza del motore (in questo caso dism.exe)
IF NOT EXIST "%~dp0%enginedir%\%enginefile%" (
goto ENGINEERROR
) else goto SRCCHK

:ENGINEERROR
echo %enginefile% could not be found for the relevant architecture. Do you have a proper Windows AIK installation? 
echo.
echo Please check the path to %enginefile% for %arch% and either move it to %~dp0%enginedir% or modify this script accordingly. 
goto END

:SRCCHK
REM Controlla che boot.wim sia presente nella directory sorgente e in caso negativo, invita a riavviare la procedura di creazione della distribuzione WinPE
IF NOT EXIST "%~dp0%perootdir%\%pefile%" (
goto SRCERROR
) else goto EMPTYCHK

:SRCERROR
echo %pefile% could not be found. Please run peprep.cmd again or double check your WinPE distribution.
goto END

:EMPTYCHK
REM Controlla che la directory dove l'immagine verrà montata sia vuota. Questo controllo da una minima garanzia che non ci siano altre istanze di DISM attivate da questo script (dato che la destinazione è hardcoded). Al momento non è possibile con uno script batch controllare direttamente lo stato del database DISM delle immagini montate. E' in ogni caso consigliabile non montare MAI piu di una immagine alla volta
if not "%~dp0%pemountdir%"=="" for /f %%e in ('dir "%~dp0%pemountdir%\*" /b/a') do goto DISMOUNT
goto FULLERROR

:FULLERROR
echo.
echo %~dp0%pemountdir% is empty! Have you run the relevant mount script for %arch%? Double check %~dp0%pemountdir%.
echo.
goto END

:DISMOUNT 
REM Gli apici in %enginedir% sono necessari perchè il path per Windows AIK contiene degli spazi.
echo.
echo WARNING: This procedure can take a _LONG_ time and a LOT of space. 
echo.
echo Please don't interrupt it and be sure to have enough space to complete it. %enginefile% will provide text feedback.
call %~dp0"%enginedir%"\%enginefile% /UnMount-Wim /mountdir:%~dp0%pemountdir% /commit
goto END

:END
EndLocal