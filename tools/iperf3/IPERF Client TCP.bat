@ECHO OFF
setlocal enabledelayedexpansion
color 0A
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

ECHO     ________  __________  ______   ________________     _______________________
ECHO    /  _/ __ \/ ____/ __ \/ ____/  /_  __/ ____/ __ \   /_  __/ ____/ ___/_  __/
ECHO    / // /_/ / __/ / /_/ / /_       / / / /   / /_/ /    / / / __/  \__ \ / /   
ECHO  _/ // ____/ /___/ _, _/ __/      / / / /___/ ____/    / / / /___ ___/ // /    
ECHO /___/_/   /_____/_/ /_/_/        /_/  \____/_/        /_/ /_____//____//_/     
ECHO.

set /p INPUT=Enter the IP Address of the Iperf Server:
if "!INPUT!"=="" (
    echo No IP address entered. Exiting.
    pause
    exit /b
)

set /p BANDWIDTH=Enter bandwidth limit (e.g., 100M) [leave blank for unlimited]: 
if not "!BANDWIDTH!"=="" set BANDWIDTH_FLAG=-b !BANDWIDTH!

set /p REVERSE=Run reverse test (server sends to client)? [Y/N]: 
if /I "!REVERSE!" EQU "Y" set REVERSE_FLAG=-R

:rerun
C:/Grind-Toolkit/tools/iperf3/iperf3 -c !INPUT! !BANDWIDTH_FLAG! !REVERSE_FLAG! -t 5 -O 1 -V

:choice
set /P c=Would you like to Create a Logfile[Y/N]?
if /I "!c!" EQU "Y" goto :ChoiceA
if /I "!c!" EQU "N" goto :ChoiceB
goto :choice

:ChoiceA
set /p INPUT2=ENTER THE SITE NAME:
set TIMESTAMP=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=!TIMESTAMP: =0!
ECHO "Creating !INPUT2!_TCP_!TIMESTAMP!.log on Desktop. Please wait 60 sec"
C:/Grind-Toolkit/tools/iperf3/iperf3 -c !INPUT! !BANDWIDTH_FLAG! !REVERSE_FLAG! -t 60 -O 1 -V --logfile "%USERPROFILE%\Desktop\!INPUT2!_TCP_!TIMESTAMP!.log"
goto :choice1

:ChoiceB
:choice1
set /P d=Would you like to RERUN this test?[Y/N]?
if /I "!d!" EQU "Y" goto :ChoiceC
if /I "!d!" EQU "N" goto :ChoiceD
goto :choice1

:ChoiceC
goto :rerun

:ChoiceD
ECHO "Exit"
exit