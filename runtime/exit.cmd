::	AutOx190 Exit File ver 0.1.6
::
@echo off
setlocal enabledelayedexpansion
set /p log=<logs\log.cfg
%log% STATUS: exit.cmd Logging Initialized>> logs\log.txt
%log% START: exit.cmd>> logs\log.txt
::
set exit=0
set rerun=0
::
:nope
cls
echo 	~~ AutOx190 Exit Check ~~
echo.
%log% STATUS: -User Response- Execution Query>> logs\log.txt
set /p "exit=Execution Complete. Task Sucessful? [Y/n]: "
if /i %exit% EQU Y (
	%log% SUCCESS: -User Response- Execution Success>> logs\log.txt
	goto :next
)
if /i %exit% EQU N (
	%log% WARN: -User Response- Execution Failed>> logs\log.txt
	goto :next
)
%log% WARN: User Response Invalid.>> logs\log.txt
cls
echo Invalid Response.
timeout 2 > nul
goto :nope
::
:next
cls
%log% STATUS: -User Response- Restart Query>> logs\log.txt
set /p "rerun=Restart AutOx190? [Y/n]: "
%log% COPMLETE: -User Response- Restart Query>> logs\log.txt
if /i %rerun% EQU Y (
	%log% STATUS: Restart Query Confirmed>> logs\log.txt
	%log% STATUS: Restart AutOx190>> logs\log.txt
	start init.cmd
	%log% COMPLETE: Restart AutOx190>> logs\log.txt
	goto :end
)
if /i %rerun% EQU N (
	%log% STATUS: Exit>> logs\log.txt
	cls
	echo Thank You For Using AutOx190^^!
	%log% STATUS: Exit Script Complete, Exiting>> logs\log.txt
	timeout 2
	goto :end
)
%log% WARN: User Response Invalid>> logs\log.txt
cls
echo Invalid Response.
timeout 2 > nul
goto :next
::
:end
%log% END: exit.cmd>> logs\log.txt
endlocal
exit
