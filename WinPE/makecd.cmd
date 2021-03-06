@ECHO OFF
REM SetLocal si assicura che le variabili impostate rimangano locali a questo script e non vengano esportate.
SetLocal
REM arch sar� la nostra variabile per stabilire l'architettura. Le opzioni possibili sono amd64 e x86
set arch=%1
REM addargument ci permette di aggiungere dei label al nome dell'iso finale, cosi da sapere immediatamente quali opzioni siano implementate al suo interno.
set addargument=%2
set OUTFILE=WinPE_%arch%_imagex_inteldrv_athdrv_vmdrv_chksum_itkey%addargument%.iso
set enginedir=..\Windows AIK\tools\%arch%
set enginefile=oscdimg.exe
goto :ARG1CHK 

:ARG1CHK
REM Valida il contenuto di arch
IF "%1"=="" goto ARCH_ERROR
IF "%1"=="amd64" goto ARG2CHK
IF "%1"=="x86" (
goto ARG2CHK 
) else goto ARCH_ERROR

:MAKEISO
REM Il motore dello script. Chiama l'imager di AIK con le opzioni corrette per creare un CD di Boot di tipo ElTorito.
echo.
echo Creating WinPE disk for %arch%.
echo.
echo The output file will be WinPE_%arch%_imagex_inteldrv_athdrv_vmdrv_chksum_itkey%addargument%.iso
REM Gli apici in %enginedir% sono necessari perch� il path per Windows AIK contiene degli spazi.
call %~dp0"%enginedir%"\%enginefile% -n -bWinPE_%arch%\etfsboot.com WinPE_%arch%\ISO ISOs\%OUTFILE%
goto END

:ARCH_ERROR
echo.
echo You must define an architecture. Viable options are amd64 and x86
goto END

:ARGUMENT_WARN
echo.
echo If you added packages to the WinPE image, you should a label to the iso filename. 
echo.
echo You can do that by adding a second argument to this script. (Eg: makecd.cmd amd64 _satadrivers)
echo.
echo PLEASE NOTE: Use underscores to separate different packages. If you want to continue, press any key. To abort, press Control-C.
PAUSE > NUL
goto DUPECHK

:ARG2CHK
REM Controlla la presenza di label aggiuntivi e, se mancanti, invita l'utente ad aggiungerli.
IF "%2"=="" (
goto ARGUMENT_WARN 
) ELSE ( 
goto DUPECHK
)

:DUPECHK
REM Controlla se � gia presente una ISO con lo stesso nome, in modo da evitare di sovrascriverla.
IF EXIST ""%~dp0"\ISOs\"%OUTFILE%"" goto DUPEWARN
goto ENGINECHK

:DUPEWARN
cls
echo.
echo %OUTFILE% already exists. If you want to overwrite, press any key. To abort, press Control-C
PAUSE > NUL
goto ENGINECHK

:ENGINECHK

:END
EndLocal
