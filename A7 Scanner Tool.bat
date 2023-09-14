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
nmap -sn %ip%/24 -oN "%temp%\Network Devices" | findstr /v /l "Host is up" | findstr /v /l "addresses" | findstr /v /l "Starting"
goto start2
:restart1
type "%temp%\Network Devices" | findstr /v /l "Host is up" | findstr /v /l "addresses" | findstr /v /l "Starting" | findstr /v /l "#"
:start2
echo.
echo.
:ReEnterTargetIP
set /p TargetIP=Type the last three digits of the target IP address:
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
nmap -O -sV --script "vulners" "%ip3%%TargetIP%" -oN "A7 Scanner Tool Results\%ip3%%TargetIP%.txt"
echo.
echo ----End of the scan----
echo.
echo.
:loopend
pause > nul
%windir%\System32\choice.exe /m "Do you want to go back to the home page?"
IF %ERRORLEVEL% EQU 1 goto restart
IF %ERRORLEVEL% EQU 2 goto loopend
:restart
cls
echo  +---------------------------------------------------------------------+
echo  +                           A7 Scanner Tool                           +
echo  +---------------------------------------------------------------------+
echo  %scanninglog%
echo.
echo.
goto restart1
