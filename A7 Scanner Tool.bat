@echo off
title A7 Scanner Tool
echo  +---------------------------------------------------------------------+
echo  +                           A7 Scanner Tool                           +
echo  +---------------------------------------------------------------------+
if not exist "%systemdrive%\Program Files (x86)\Nmap" echo You must download NMAP software to use this tool
if not exist "%systemdrive%\Program Files (x86)\Nmap" %windir%\System32\choice.exe /m "Do You Want to download NMAP software?"
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 1 start https://nmap.org/dist/nmap-7.94-setup.exe
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 1 echo ---End of A7 Scanner Tool---
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 1 pause > nul & exit
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 2 echo ---End of A7 Scanner Tool---
if not exist "%systemdrive%\Program Files (x86)\Nmap" IF %ERRORLEVEL% EQU 2 pause > nul & exit
for /f "tokens=2,3,4,5,6 usebackq delims=:/ " %%a in ('%date% %time%') do set CurrentTime=%%b-%%a-%%c %%d:%%e
set scanninglog=Start scanning all devices connected to the network at %CurrentTime%
echo  Start scanning all devices connected to the network at %CurrentTime%
echo.
echo.
for /f "tokens=2,3 delims={,}" %%a in ('"WMIC NICConfig where IPEnabled="True" get DefaultIPGateway /value | find "I" "') do if not defined ip set ip=%%~a
set ip3=%ip:~0,-1%
nmap -sn %ip%/24 | findstr /v /l "Host is up" | findstr /v /l "addresses" | findstr /v /l "Starting" > "%temp%\Network Devices"
:restart1
type "%temp%\Network Devices"
echo.
echo.
:ReEnterTargetIP
set /p TargetIP=Type the last three digits of the target's IP address:
if "%TargetIP%"=="" goto ReEnterTargetIP
if defined TargetIP if "%TargetIP:~3,1%"=="" (goto true) else (goto ReEnterTargetIP)
:true
cls
echo  +---------------------------------------------------------------------+
echo  +                           A7 Scanner Tool                           +
echo  +---------------------------------------------------------------------+
echo              Start scanning the IP address at %CurrentTime%
echo                         IP Address : %ip3%%TargetIP%
echo.
echo.
if not exist "A7 Scanner Tool Results" md "A7 Scanner Tool Results"
nmap -sV "%ip3%%TargetIP%"> "A7 Scanner Tool Results\%ip3%%TargetIP%.txt"
type "A7 Scanner Tool Results\%ip3%%TargetIP%.txt"
echo ----End of the scan----
echo.
echo.
echo If you find any vulnerability, list it here, and if you don't find a vulnerability, press the ENTER button directly
echo.
:research
set search=
set /p search=Type the name of the vulnerability:
if "%search%"=="" goto restart
set search=%search: =+%
start https://www.google.com/search?q=%search%+vulnerabilities
goto research
:restart
cls
echo  +---------------------------------------------------------------------+
echo  +                           A7 Scanner Tool                           +
echo  +---------------------------------------------------------------------+
echo  %scanninglog%
echo.
echo.
goto restart1
