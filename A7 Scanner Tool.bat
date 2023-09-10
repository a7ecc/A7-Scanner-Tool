@echo off
title A7 Scanner Tool
echo  +---------------------------------------------------------------------+
echo  +                           A7 Scanner Tool                           +
echo  +---------------------------------------------------------------------+
if not exist "%systemdrive%\Program Files (x86)\Nmap" echo You must download NMAP software to use this tool
if not exist "%systemdrive%\Program Files (x86)\Nmap" %windir%\System32\choice.exe /m "Do You Want to download NMAP software?"
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 1 start https://nmap.org/dist/nmap-7.94-setup.exe
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 1 echo ---End of Tool---
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 1 pause > nul & exit
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 2 echo ---End of Tool---
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 2 pause > nul & exit
for /f "tokens=2,3,4,5,6 usebackq delims=:/ " %%a in ('%date% %time%') do set CurrentTime=%%b-%%a-%%c %%d:%%e
echo  Start scanning all devices connected to the network at %CurrentTime%
echo.
echo.
for /f "tokens=2,3 delims={,}" %%a in ('"WMIC NICConfig where IPEnabled="True" get DefaultIPGateway /value | find "I" "') do if not defined ip set ip=%%~a
nmap -sn %ip%/24 | findstr /v /l "Host is up" | findstr /v /l "addresses" | findstr /v /l "Starting" > "%temp%\Network Devices"
:restart1
type "%temp%\Network Devices"
echo.
echo.
echo.
set /p TargetIP=Type the IP address of the target device:
cls
echo  +---------------------------------------------------------------------+
echo  +                           A7 Scanner Tool                           +
echo  +---------------------------------------------------------------------+
echo              Start scanning the IP address at %CurrentTime%
echo                         IP Address : %TargetIP%
echo.
echo.
if not exist "A7 Scanner Tool Results" md "A7 Scanner Tool Results"
nmap -A "%TargetIP%"> "A7 Scanner Tool Results\%TargetIP%.txt"
type "A7 Scanner Tool Results\%TargetIP%.txt"
echo.
echo.
echo ----End of the scan----
echo.
echo.
%windir%\System32\choice.exe /m "Did you find any vulnerabilities?"
IF %ERRORLEVEL% EQU 1 goto yes
IF %ERRORLEVEL% EQU 2 goto restart

:yes
set /p search=Type the name of the vulnerability:
set search=%search: =+%
start www.google.com/search?q=%search%+vulnerabilities
echo.
echo.
echo ---End of Tool---

:loop
pause > nul
goto loop

:restart
cls
echo  +---------------------------------------------------------------------+
echo  +                           A7 Scanner Tool                           +
echo  +---------------------------------------------------------------------+
echo.
goto restart1