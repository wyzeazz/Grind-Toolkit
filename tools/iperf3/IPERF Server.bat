@echo off
color 0C
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b

echo     ________  __________  ______   _____ __________ __   ____________ 
echo    /  _/ __ \/ ____/ __ \/ ____/  / ___// ____/ __ \ /  / / ____/ __ \
echo    / // /_/ / __/ / /_/ / /_      \__ \/ __/ / /_/ / / / / __/ / /_/ /
echo  _/ // ____/ /___/ _, _/ __/     ___/ / /___/ _, _// \/ / /___/ _, _/ 
echo /___/_/   /_____/_/ /_/_/       /____/_____/_/ /_/  \__/_____/_/ /_/  
echo.
ipconfig | findstr IPv4 > ipadd.txt
for /F "tokens=14" %%i in (ipadd.txt) do ( 
@echo The IP Address for this IPERF Server is: %%i 
)
del ipadd.txt
C:\Grind-Toolkit\tools\iperf3\iperf3.exe -s
pause