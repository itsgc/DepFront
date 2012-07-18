@ECHO OFF
REM Chiama DISM e monta l'immagine WIM dell'installazione di Windows amd64
REM Tutti i path e i valori che possono cambiare sono impostati come variabili così da permettere una relativa espandibilità e scalabilità in futuro.
SetLocal
set arch=amd64
REM La Directory della distribuzione Windows
set windir=..\..\W7_%arch%_ROOT\sources
REM Il nome dell'immagine Wim dell'installazione. 
set winfile=install.wim
REM La directory dove l'immagine verrà montata
set mountdir=..\..\mount\%arch%
REM La directory dove si trova il motore (in questo caso DISM)
set enginedir=..\..\Windows AIK\Tools\%arch%\Servicing
REM Il nome del motore
set enginefile=dism.exe
goto ARCH_CHK

:ARCH_CHK
REM Valida il contenuto di arch e imposta index.
IF "%arch%"=="" goto ARCH_ERROR
IF "%arch%"=="amd64" goto INDEX64
IF "%arch%"=="x86" (
goto INDEX32 
) else goto ARCH_ERROR

:ARCH_ERROR
echo I could not establish the architecture. Please double check the head of this file.
goto END

:INDEX64
set indexid=4
goto ENGINECHK

:INDEX32
set indexid=5
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
REM Controlla che install.wim sia presente nella directory sorgente e in caso negativo, invita a riavviare la procedura di creazione della distribuzione Windows.
IF NOT EXIST "%~dp0%windir%\%winfile%" (
goto SRCERROR
) else goto EMPTYCHK

:SRCERROR
echo %winfile% could not be found. Do you have a regular copy of a Windows CD or Network distro share? Please check your Windows distribution.
goto END

:EMPTYCHK
REM Controlla che la directory dove l'immagine verrà montata sia vuota. Questo controllo da una minima garanzia che non ci siano altre istanze di DISM attivate da questo script (dato che la destinazione è hardcoded). Al momento non è possibile con uno script batch controllare direttamente lo stato del database DISM delle immagini montate. E' in ogni caso consigliabile non montare MAI piu di una immagine alla volta
if not "%~dp0%mountdir%"=="" for /f %%e in ('dir "%~dp0%mountdir%\*" /b/a') do goto EMPTYERROR
goto MOUNT

:EMPTYERROR
echo.
echo %~dp0%mountdir% is not empty! There could be a %enginefile% instance running or a badly unmounted image. 
echo.
echo Run dismount_%arch%.cmd to clear it. If it fails, use %enginefile% directly.
goto END

:MOUNT 
REM Gli apici in %enginedir% sono necessari perchè il path per Windows AIK contiene degli spazi.
call %~dp0"%enginedir%"\%enginefile% /Mount-Wim /WimFile:%~dp0%windir%\%winfile% /index:%indexid% /mountdir:%~dp0%mountdir%
goto END

:END
EndLocal