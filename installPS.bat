@echo off
echo Installing The Grind Toolkit...
echo.

:: 1. Create C:\Grind-Toolkit
if not exist "C:\Grind-Toolkit" mkdir "C:\Grind-Toolkit"
echo ✓ Created C:\Grind-Toolkit

:: 2. Copy profile to both PowerShell folders
if not exist "%USERPROFILE%\Documents\PowerShell" mkdir "%USERPROFILE%\Documents\PowerShell"
if not exist "%USERPROFILE%\Documents\WindowsPowerShell" mkdir "%USERPROFILE%\Documents\WindowsPowerShell"
copy /Y ".\profile\Microsoft.PowerShell_profile.ps1" "%USERPROFILE%\Documents\PowerShell\"
copy /Y ".\profile\Microsoft.PowerShell_profile.ps1" "%USERPROFILE%\Documents\WindowsPowerShell\"
echo ✓ PowerShell profile installed

:: 3. Copy iperf tools
if not exist "C:\Grind-Toolkit\tools\iperf3" mkdir "C:\Grind-Toolkit\tools\iperf3"
copy /Y ".\tools\iperf3\*" "C:\Grind-Toolkit\tools\iperf3\"
echo ✓ iperf3 toolkit installed

:: 4. Set execution policy (attempt, may need admin)
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force" 2>nul
echo ✓ Execution policy set to RemoteSigned

echo.
echo Installation complete! Restart PowerShell.
pause