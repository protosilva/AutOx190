::	AutOx190 verification check ver 0.1.8
::
::
@echo off
setlocal enabledelayedexpansion
::
set /p log=<logs\log.cfg
%log% STATUS: ver.cmd Logging Initialized>> logs\log.txt
%log% START: ver.cmd>> logs\log.txt
::
%log% STATUS: Load Autologin Status>> logs\log.txt
set /p autol=<logs\auto.cfg && %log% Success.>> logs\log.txt
::
%log% STATUS: Load Preset>> logs\log.txt
set /p preset=<logs\pre.cfg && %log% Success.>> logs\log.txt
::
type runenv\ws.cfg
%log% STATUS: -User- Successful Login Query>> logs\log.txt
set /p "didwork=Login succesful? [Y/n]: " && %log% Success.>> logs\log.txt
::
if /i %didwork% EQU Y (
	%log% STATUS: -User- Successful Login Confirmed>> logs\log.txt
	echo.
	echo 	^^!^^! WARNING - DO NOT INTERRUPT AUTOx190 DURING RUNTIME ^^!^^!
	timeout 5 > nul
	if /i %autol% EQU N (
		%log% STATUS: Delete User ^& Password Files>> logs\log.txt
		del /q "logs\usr.cfg" && %log% Success.>> logs\log.txt
		del /q "logs\ps.cfg" && %log% Success.>> logs\log.txt
	)
	%log% STATUS: Minimize Window>> logs\log.txt
	cls
	Powershell -window minimized -command "" && %log% Success.>> logs\log.txt
	%log% STATUS: Launch Preset>> logs\log.txt
	cd runenv/scripts
	start powershell -NoProfile -ExecutionPolicy Bypass -Window Minimized -Command "& './%preset%'" && %log% Success.>> logs\log.txt
	rem PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './%preset%'" && %log% Success.>> logs\log.txt
	cd ../..
) else (
	%log% WARN: -User- Login Unsuccessful>> logs\log.txt
	echo.
	echo Attempting Exit, Please wait...
	echo.
	timeout 2 > nul
	%log% STATUS: Minimize Window>> logs\log.txt
	Powershell -window minimized -command "" && %log% Success.>> logs\log.txt
	%log% STATUS: Launch OnFail Script>> logs\log.txt
	start powershell -NoProfile -ExecutionPolicy Bypass -Window Minimized -Command "& './onfail.ps1'"
	rem PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './onfail.ps1'" && %log% Success.>> logs\log.txt
)
%log% END: ver.cmd>> logs\log.txt
endlocal
exit
