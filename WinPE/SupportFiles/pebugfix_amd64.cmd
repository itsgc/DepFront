REM In AIK 3.0 e 3.1 è presente un bug per il quale la directory dove viene creato il file .wim di WinPE è diversa da quella dove viene cercato durante la creazione della ISO. Questo script offre un semplice workaround, spostando il file in questione.
set sourcedir=..\WinPE_amd64
set sourcefile=winpe.wim
set targetfile=boot.wim
set targetdir=..\WinPE_amd64\ISO\sources
echo FIXSTART
goto SRCCHK

:SRCCHK
REM Controlla che winpe.wim sia presente e in caso negativo, invita a riavviare la procedura di creazione della distribuzione WinPE
IF NOT EXIST "%~dp0%sourcedir%\%sourcefile%" (
goto SRCERROR
) else goto DUPECHK

:SRCERROR
echo winpe.wim could not be found. Have you ran peprep or copype properly? Please check your WinPE preparation directory.
goto END

:DUPECHK
REM Controlla se è gia presente un'immagine wim con lo stesso nome, in modo da evitare di sovrascriverla.
IF EXIST "%~dp0%targetdir%\%targetfile%" (
goto DUPEWARN
) else goto BUFIX

:DUPEWARN
cls
echo.
echo %targetfile% already exists in. If you want to overwrite, press any key. To abort, press Control-C
PAUSE > NUL
goto BUFIX

:BUFIX
move "%~dp0%sourcedir%\%sourcefile%" "%~dp0%targetdir%\%targetfile%"
goto END

:END
