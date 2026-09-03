::	AutOx190 ver 0.2.0
::
::
@echo off
setlocal enabledelayedexpansion
type runenv\ws.cfg
echo AutOx190 Ver 0.2.0
powershell runenv/throbr -DurationSeconds 1
echo.
echo 			Initializing, Please wait...
if not exist logs\*.cfg (
    if not exist runenv\scripts\*.ps1 (
        echo.
        echo 		I see this is your first time launching AutOx190, Thank you^^!
        powershell runenv/throbr -DurationSeconds 2
    )
    powershell runenv/throbr -DurationSeconds 3
    cls
    type runenv\ws.cfg
    echo.
    echo 			   ~~ Welcome To AutOx190^^! ~~
    echo.
    echo.
    echo 	      First things first, Let's get your settings configured~
    echo.
    echo 		You'll want to have the AS/400 server IP, along with 
    echo 		your device name. ^(the name of the device connecting
    echo 			 to the server, example: warehouse^)
    echo.
    echo 		    Don't worry, you can always change these
    echo 				settings later^^!
    echo.
    pause
    rem reg query "HKCU\Software\IBM\Client Access Express\CurrentVersion\AS400 Operations Navigator\Application_Administration\HostVals"
    rem reg query "HKCU\Software\IBM\Client Access Express\CurrentVersion\Environments\My Connections"
    rem reg query "HKCU\Software\MochaSoft\mtn5250\Version 1.0"
    rem reg query "HKCU\Software\MochaSoft\mtn5250\Version 1.0\1" /v host_name
    for /f "tokens=3" %%a in ('reg query "HKCU\Software\MochaSoft\mtn5250\Version 1.0\1" /v host_name') do set hs=%%a
    :ar0
    cls
    type runenv\ws.cfg
    echo I found a server IP^^! - !hs!
    echo.
    set /p "ir=Does that sound right? [Y/n]: "
    if /i !ir! EQU Y (
        set mip=!hs!
        goto :ar1
    )
    echo.
    echo Enter The AS/400 Server IP-
    echo ^(example- 192.168.1.1^)
    echo.
    set /p "mip=Server IP: "
    echo.
    echo server IP set to !mip!
    echo.
    set /p "mipc=Is that correct? [Y/n]: "
    if /i !mipc! NEQ Y (
        goto :ar0
    )
    :ar1
    for /f "tokens=7 delims=, " %%t in ('ping -n 1 !mip! ^| find "Received"') do (
        set /a ipt=%%t
        if !ipt! NEQ 1 (
            echo.
            echo IP Invalid^^!
            powershell runenv/throbr -DurationSeconds 3
            goto :ar1
        ) else (
            echo.
            echo IP valid^^!
            powershell runenv/throbr -DurationSeconds 2
        )
    )
    echo !mip!> logs\aip.cfg
    :ar2
    for /f "tokens=3" %%a in ('reg query "HKCU\Software\MochaSoft\mtn5250\Version 1.0\1" /v device_name') do set dn=%%a
    cls
    type runenv\ws.cfg
    echo I found a device name^^! - !dn!
    echo.
    set /p "ir=Does that sound right? [Y/n]: "
    if /i !ir! EQU Y (
        echo.
        echo !dn!> logs\adv.cfg
        echo Device name set^^!
        powershell runenv/throbr -DurationSeconds 2
        goto :ar3
    )
    echo.
    echo Enter The AS/400 Device Name-
    echo ^(Example- warehouse^)
    echo.
    set /p "mdv=AS/400 device name: "
    echo.
    echo Device Name set to !mdv!
    echo.
    set /p "mdvc=Is that correct? [Y/n]: "
    if /i !mdvc! NEQ Y (
        goto :ar2
    )
    echo !mdv!> logs\adv.cfg
    :ar3
    cls
    type runenv\ws.cfg
    echo 		Auto Configure delay? ^(Not Recommended for Thin Clients/Edge Devices^)
    echo.
    set /p "ac=Auto Configure delay? [Y/n]: "
    echo.
    set /p "acc=Are you sure? [Y/n]: "
    if /i !acc! NEQ Y (
        goto :ar3
    )
    :ar4
    cls
    type runenv\ws.cfg
    if /i !ac! EQU N (
        set maxl=300
        echo 			Set Delay in ms and / or hit Enter:
        echo.
        echo The default is 300 ^(Max ping x3^) But thin / edge clients may need up to max ping
        echo      x9, especially if they are edge / remote clients; you have been warned.
        echo.
        set /p "maxl=set delay in ms (default is 300): "
        echo.
        echo Auto Delay set to !maxl!
        echo.
        set /p "maxlc=Is that correct? [Y/n]: "
        if /i !maxlc! NEQ Y (
            goto :ar4
        )
        echo !maxl!> logs\dly.cfg
        echo manual> logs\apd.cfg
    )
    cls
    type runenv\ws.cfg
    echo.
    echo 			Configuration complete, Thank You^^!
    powershell runenv/throbr -DurationSeconds 3
)
::
::
if not exist logs\log.txt (
    echo INIT: -Logfile Initialized-> logs\log.txt
)
if not exist logs\log.cfg (
    echo STATUS: Log config not Found, Creating>> logs\log.txt
    echo rem> logs\log.cfg
    echo COMPLETE: Create log.cfg>> logs\log.txt
)
set /p log=<logs\log.cfg
%log% START: init.cmd>> logs\log.txt
::
::
::
::
:: powershell runenv/throbr -DurationSeconds 1
:start
%log% STATUS: Entered Menu0>> logs\log.txt
set opt=0
set stemp=0
cls
type runenv\ws.cfg
type runenv\wtam.cfg
rem echo 			~~ Welcome to AutOx190^^! ~~
rem echo.
rem echo Please choose from the following:
rem echo [0] - Exit
rem echo [1] - Quick setup / Auto Run
rem echo [2] - Configure / Debug
rem echo [3] - Help / About
rem echo.
%log% STATUS: -USER- Menu0 Query>> logs\log.txt
set /p "opt=Select: "
%log% COMPLETE: -USER- Menu0 Query>> logs\log.txt
if %opt% EQU 0 (
    %log% STATUS: Entered Menu0.0, Exiting>> logs\log.txt
    set stemp=1
    echo.
    echo Shutting down...
    powershell runenv/throbr -DurationSeconds 2
    goto :end
)
if %opt% EQU 1 set stemp=1 && goto :qsar
if %opt% EQU 2 set stemp=1 && goto :config
if %opt% EQU 3 set stemp=1 && goto :ha
if %stemp% NEQ 1 (
    %log% WARN: -USER- Menu0 Invalid Selection>> logs\log.txt
    echo.
    echo Invalid selection, choose from options
    powershell runenv/throbr -DurationSeconds 3
    goto :start
)
%log% ERROR: Menu0 bypass>> logs\log.txt
::
::
::
:qsar
%log% STATUS: Entered Menu1>> logs\log.txt
set qsar=0
set qtemp=0
cls
type runenv\ws.cfg
type runenv\qsarm.cfg
rem echo 	~~ Quick Setup / Auto Run ~~
rem echo.
rem echo [0] - Back To Main Menu
rem echo [1] - Run a Preset
rem echo [2] - Create a Preset
rem echo [3] - Delete a Preset
rem echo.
%log% STATUS: -USER- Menu0 Query>> logs\log.txt
set /p "qsar=Select: "
%log% COMPLETE: -USER- Menu0 Query>> logs\log.txt
if %qsar% EQU 0 set "qtemp=1" && goto :start
if %qsar% EQU 1 set "qtemp=1" && goto :runpreset
if %qsar% EQU 2 set "qtemp=1" && goto :cpreset
if %qsar% EQU 3 set "qtemp=1" && goto :dpreset
if %qtemp% NEQ 1 (
    %log% WARN: -USER- Menu1 Invalid Selection>> logs\log.txt
    set qtemp=0
    echo.
    echo Invalid selection, choose from options-
    powershell runenv/throbr -DurationSeconds 3
    goto :qsar
)
%log% ERROR: Menu1 bypass>> logs\log.txt
::
::
:runpreset
%log% STATUS: Entered Menu1.1>> logs\log.txt
set count=0
%log% STATUS: Store ps1 files from runenv>> logs\log.txt
for /f "tokens=*" %%f in ('dir /b /a-d "runenv\scripts\*.ps1"') do (
    set "file_%%~nf=%%f"
)
%log% COMPLETE: Store ps1 files from runenv>> logs\log.txt
%log% STATUS: Order ps1 files>> logs\log.txt
cd runenv\scripts
for %%f in (*.ps1) do (
    set /a count+=1
    set T!count!=%%f
)
cd ..\..
%log% COMPLETE: Order ps1 files>> logs\log.txt
:runpre1
set rpre=0
set count=0
%log% STATUS: Display ps1 files by name>> logs\log.txt
cls
type runenv\ws.cfg
echo Which Preset Do You Want To Run?
echo.
echo [0] - Back To Menu
for /f "tokens=*" %%f in ('dir /b /a-d "runenv\scripts\*.ps1"') do (
    set "file_!count!=%%f"
    set /a count+=1
    echo [!count!] - %%~nf
)
echo.
%log% COMPLETE: Display ps1 files by name>> logs\log.txt
%log% STATUS: -USER- Menu1.1 Query>> logs\log.txt
set /p "rpre=Select: "
%log% COMPLETE: -User- Menu1.1 Query>> logs\log.txt
if %rpre% LSS 0 (
    %log% WARN: User Input Invalid>> logs\log.txt
    echo.
    echo Invalid Selection, Try Again.
    powershell runenv/throbr -DurationSeconds 2
    goto :runpre1
)
if %rpre% EQU 0 (
    goto :qsar
)
if %rpre% GTR %count% (
    %log% WARN: User Input Invalid>> logs\log.txt
    echo.
    echo Invalid Selection, Try Again.
    powershell runenv/throbr -DurationSeconds 2
    goto :runpre1
) else (
    set aor=%rpre%
)
%log% STATUS: set preset as var>> logs\log.txt
set preset=!T%aor%!
%log% COMPLETE: set preset as var>> logs\log.txt
%log% STATUS: Save Preset to Log>> logs\log.txt
echo %preset%> logs\pre.cfg
%log% COMPLETE: Save Preset to Log>> logs\log.txt
goto :autorun
::
::
:cps1
cls
type runenv\ws.cfg
::
:cpreset
%log% STATUS: Entered Menu1.2>> logs\log.txt
echo.
echo Enter the name of your new preset; names can include letters, numbers and some 
echo special characters, but the shorter, the better: - [ ] ? ~ ;
echo.
set /p "nps= Enter Name: "
set /p "npsy=!nps!.ps1 Correct? [Y/n]: "
if exist runenv\scripts\!nps!.ps1 (
    cls
    echo 			^^!^^! Caution ^^!^^! 
    echo There is already a file with that name. If you continue, everything
    echo in the file will be erased and overwritten.
    echo.
    set /p "cpn=Overwrite? [Y/n]: "
    if /i !cpn! NEQ Y (
        goto :cps1
    )
)
if /i !npsy! EQU Y (
    type nul> runenv\scripts\!nps!.ps1 && echo Created^^!
    powershell runenv/throbr -DurationSeconds 1
    goto :cps2
) else (
    goto :cps1
)
%log% STATUS: User Input Invalid>> logs\log.txt
goto :cps1
:cps2
cls
type runenv\cpsnfo.cfg
set /p "cpc=Continue? [Y/n]: "
if /i !cpc! EQU Y (
    Powershell -window minimized -command ""
    start PowerShell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& './cps.ps1'"
    %log% STATUS: Exited Menu1.2>> logs\log.txt
    goto :end
) else (
    goto :qsar
)
::
::
:dpreset
%log% STATUS: Entered Menu1.3>> logs\log.txt
set count=0
%log% STATUS: Store ps1 files from runenv>> logs\log.txt
for /f "tokens=*" %%f in ('dir /b /a-d "runenv\scripts\*.ps1"') do (
    set "file_%%~nf=%%f"
)
%log% COMPLETE: Store ps1 files from runenv>> logs\log.txt
%log% STATUS: Order ps1 files>> logs\log.txt
cd runenv\scripts
for %%f in (*.ps1) do (
    set /a count+=1
    set T!count!=%%f
)
cd ..\..
%log% COMPLETE: Order ps1 files>> logs\log.txt
:delpre1
set rpre=0
set count=0
%log% STATUS: Echo ps1 files by name>> logs\log.txt
cls
type runenv\ws.cfg
echo Which Preset Do You Want To Delete?
echo.
echo [0] - Back To Menu
for /f "tokens=*" %%f in ('dir /b /a-d "runenv\scripts\*.ps1"') do (
    set "file_!count!=%%f"
    set /a count+=1
    echo [!count!] - %%~nf
)
echo.
%log% COMPLETE: Echo ps1 files by name>> logs\log.txt
%log% STATUS: -USER- Menu1.1 Query>> logs\log.txt
set /p "rpre=Select: "
%log% COMPLETE: -USER- Menu1.1 Query>> logs\log.txt
if %rpre% LSS 0 (
    %log% WARN: User Input Invalid>> logs\log.txt
    echo.
    echo Invalid Selection, Try Again.
    powershell runenv/throbr -DurationSeconds 2
    goto :delpre1
)
if %rpre% EQU 0 (
    goto :qsar
)
if %rpre% GTR %count% (
    %log% WARN: User Input Invalid.>> logs\log.txt
    echo.
    echo Invalid Selection, Try Again.
    powershell runenv/throbr -DurationSeconds 2
    goto :delpre1
) else (
    set aor=%rpre%
)
%log% STATUS: set preset as var>> logs\log.txt
set delpreset=!T%AOR%!
%log% COMPLETE: set preset as var>> logs\log.txt
%log% STATUS: -USER- Confirm Delete Query>> logs\log.txt
cls
type runenv\ws.cfg
set /p "delc=Really Delete %delpreset%? [Y/n]: "
%log% COMPLETE: -USER- Confirm Delete Query>> logs\log.txt
if /i "%delc%" == "Y" (
    %log% STATUS: -USER- Confirm Delete>> logs\log.txt
    %log% STATUS: Delete preset>> logs\log.txt
    cd runenv\scripts
    del /q "%delpreset%" && echo Done^^!
    %log% COMPLETE: Delete preset>> logs\log.txt
    powershell runenv/throbr -DurationSeconds 2
    cd ..\..
    %log% STATUS: Exited Menu1.3>> logs\log.txt
    goto :dpreset
) else (
    %log% STATUS: -USER- Deny Delete>> logs\log.txt
    %log% STATUS: Exited Menu1.3>> logs\log.txt
    goto :delpre1
)
%log% ERROR: Menu1.3 bypass>> logs\log.txt
::
::
::
:config
%log% STATUS: Entered Menu2>> logs\log.txt
set con=0
set ctemp=0
cls
type runenv\ws.cfg
type runenv\cdm.cfg
rem echo 	~~ Configure / Debug ~~
rem echo.
rem echo [0] - Back to Main Menu
rem echo [1] - Import RegKey
rem echo [2] - delete / Change AS/400 IP
rem echo [3] - delete / Change AS/400 Device Name
rem echo [4] - delete / Change Username
rem echo [5] - delete / Change User Password
rem echo [6] - delete / Change AutoLogin Status
rem echo [7] - Manually Configure Execute delay
rem echo [8] - Reset AutOx190 Configuration
rem echo [9] - Enable / Disable Logs
rem echo.
set /p "con=Select: "
set "ctemp=0"
if %con% EQU 0 set "ctemp=1" && goto :start
if %con% EQU 1 (
    set ctemp=1
    reg import runenv\dctrl.reg > nul 2>&1 && echo Success^^!
    powershell runenv/throbr -DurationSeconds 2
    goto :config
)
if %con% EQU 2 set "ctemp=1" && goto :cip
if %con% EQU 3 set "ctemp=1" && goto :cdn
if %con% EQU 4 set "ctemp=1" && goto :cusr
if %con% EQU 5 set "ctemp=1" && goto :cps
if %con% EQU 6 set "ctemp=1" && goto :cauto
if %con% EQU 7 set "ctemp=1" && goto :cdelay
if %con% EQU 8 set "ctemp=1" && goto :creset
if %con% EQU 9 set "ctemp=1" && goto :clog
if %ctemp% NEQ 1 (
    %log% WARN: -USER- Menu2 Invalid Selection>> logs\log.txt
    echo.
    echo Invalid Selection, Choose From Options-
    powershell runenv/throbr -DurationSeconds 3
    goto :config
)
%log% ERROR: Menu2 bypass>> logs\log.txt
::
::
:cip
cls
type runenv\ws.cfg
set /p "cip=Enter AS/400 Server IP: "
for /f "tokens=7 delims=, " %%z in ('ping -n 1 !cip! ^| find "Received"') do (
    set /a ipt=%%z
)
if !ipt! NEQ 1 (
    echo.
    echo IP Invalid^^!
    powershell runenv/throbr -DurationSeconds 3
    goto :cip
) else (
    echo.
    echo IP valid^^!
    powershell runenv/throbr -DurationSeconds 2
)
echo.
echo %cip%> logs\aip.cfg && echo Server IP Changed to %cip%
powershell runenv/throbr -DurationSeconds 2
goto :config
::
::
:cdn
cls
type runenv\ws.cfg
set /p "cdv=Enter AS/400 Device Name: "
echo.
echo %cdv%> logs\adv.cfg && echo Device Name Changed to %cdv%
powershell runenv/throbr -DurationSeconds 2
goto :config
::
::
:cusr
cls
type runenv\ws.cfg
set /p "cusr=Enter Username: "
echo.
echo %cusr%> logs\usr.cfg && echo Username Changed to %cusr%
powershell runenv/throbr -DurationSeconds 2
goto :config
::
::
:cps
cls
type runenv\ws.cfg
set /p "cps=Enter Password: "
echo.
echo %cps%> logs\ps.cfg && echo Password Changed^^!
powershell runenv/throbr -DurationSeconds 2
goto :config
::
::
:cauto
cls
type runenv\ws.cfg
set /p "cal=Enter Autologin Status [Y/n]: "
echo.
echo %cal%> logs\auto.cfg && echo Autologin Status Changed To %cal%
powershell runenv/throbr -DurationSeconds 2
goto :config
::
::
:cdelay
cls
type runenv\ws.cfg
set maxl=300
if exist logs\dly.cfg (
    set /p temp=<logs\dly.cfg
    echo.
    echo Current delay: !temp!
)
echo.
echo 			Set Delay in ms and / or hit Enter:
echo.
echo The default is 300 ^(Max ping x3^) But thin / edge clients may need up to max ping
echo      x9, especially if they are edge / remote clients; you have been warned.
echo.
echo.
set /p "maxl=Enter delay in ms (default is 300): "
echo.
echo Delay set to !maxl! ms
echo.
set /p "maxlc=Are you sure? [Y/n]: "
if /i %maxlc% NEQ Y (
    goto :cdelay
)
echo.
echo %maxl%> logs\dly.cfg
echo manual>logs\apd.cfg
goto :config
::
::
:creset
cls
type runenv\ws.cfg
echo.
echo Are You Sure You Want To Reset The Configuration? Note- This Will Also Delete
echo 	      everything in \logs, including the debugging logs.
echo.
set /p "creset=Reset Configuration? [Y/n]: "
echo.
if /i "%creset%" == "Y" (
    echo Resetting...
    echo.
    del /q logs\* && echo Done^^!
) else (
    echo Not Reset.
)
powershell runenv/throbr -DurationSeconds 2
goto :config
::
::
:clog
cls
type runenv\ws.cfg
if %log% EQU rem (
    echo STATUS: Logging Enabled, Restarting>> logs\log.txt
    echo echo> logs\log.cfg
    echo Logs Enabled, Restarting...
    powershell runenv/throbr -DurationSeconds 2
    goto :clog1
)
 if %log% EQU echo (
    echo STATUS: Logging Disabled, Restarting>> logs\log.txt
    echo rem> logs\log.cfg
    echo Logs Disabled, Restarting...
    powershell runenv/throbr -DurationSeconds 2
    goto :clog1
)
echo ERROR: Log.cfg corrupt?>> logs\log.txt
echo Resetting...>> logs\log.txt
echo rem> logs\log.cfg
echo ERROR: Log.cfg Incompatible, Resetting.
powershell runenv/throbr -DurationSeconds 3
:clog1
start init.cmd
echo STATUS: Restart>> logs\log.txt
goto :end
::
::
::
:ha
%log% STATUS: Entered Menu3>> logs\log.txt
set ha=0
set htemp=0
cls
type runenv\ws.cfg
type runenv\ham.cfg
rem echo 	~~ Help / about ~~
rem echo.
rem echo [0] - Back To Main Menu
rem echo [1] - What is AutOx190?
rem echo [2] - How Do I Use AutOx190?
rem echo [3] - Credits
rem echo [4] - Licenses
rem echo.
%log% STATUS: -USER- Menu3 query>> logs\log.txt
set /p "ha=Select: "
%log% COMPLETE: -USER- Menu3 query>> logs\log.txt
if %ha% EQU 0 set "htemp=1" && goto :start
if %ha% EQU 1 set "htemp=1" && goto :what
if %ha% EQU 2 set "htemp=1" && goto :how
if %ha% EQU 3 set "htemp=1" && goto :cred
if %ha% EQU 4 set "htemp=1" && goto :lic
if %htemp% NEQ 1 (
    %log% WARN: -USER- Menu3 Invalid Selection>> logs\log.txt
    echo.
    echo Invalid selection, choose from options
    powershell runenv/throbr -DurationSeconds 3
    goto :ha
)
%log% ERROR: Menu3 bypass>> logs\log.txt
::
::
::
:what
%log% STATUS: Entered Menu3.1>> logs\log.txt
cls
type runenv\ws.cfg
echo 			~~ What is AutOx190? ~~
echo.
echo AutOx190 is intended to be an open source automation tool designed for the 80's
echo  software known as AS/400, based on the open source IBM TN5250 Emulator. Note
echo  that AutOx190 is not an API, merely a middle man of sorts, operating in the
echo 		space between your system and the AS/400 system.
echo.
echo  AutOx190 was born out of a need to automate tasks that were too often 
echo very time-consuming and complex to execute, as often as they were being
echo 				   repeated.
echo.
pause
%log% STATUS: Exited Menu3.1>> logs\log.txt
goto :ha
::
::
:how
%log% STATUS: Entered Menu3.2>> logs\log.txt
cls
type runenv\ws.cfg
echo 			~~ How Do I Use AutOx190? ~~
echo.
echo 				The Basics:
echo AutOx190 *should* prompt you to set it up with everything it needs the very
echo first time you run it; if for whatever reason, it doesn't, try resetting the 
echo 		configuration from the config menu and restart it.
echo.
echo 				    FAQ:
echo Q: Help^^! it won't connect to my server, what happened?
echo A: It depends; is the server IP correct? Is your device name in the server 
echo	   whitelist? And in some cases, the launch config may need adjusted.
echo.
echo Q: 
echo A: 
echo.
pause
%log% STATUS: Exited Menu3.2>> logs\log.txt
goto :ha
::
::
:cred
%log% STATUS: Entered Menu3.3>> logs\log.txt
cls
type runenv\ws.cfg
echo.
echo 		Written Wholly in Windows CMD and Powershell~
echo       Designed to be used in userspace, with 
echo                 limited permissions
echo.
echo 		       Written and developed by Protosilva
echo.
echo 		     ~~ Thank you for using AutOx190^^! ~~
echo.
pause
%log% STATUS: Exited Menu3.3>> logs\log.txt
goto :ha
::
::
:lic
%log% STATUS: Entered Menu3.4>> logs\log.txt
cls
type runenv\ws.cfg
echo AutOx190 is Licensed under the GNU GPL v3.
echo https://github.com/protosilva/AutOx190/
echo.
pause
%log% STATUS: Exited Menu3.4>> logs\log.txt
goto :ha
::
::
::
:autorun
%log% STATUS: Entered Autorun script>> logs\log.txt
cls
type runenv\ws.cfg
reg import runenv\dctrl.reg > nul 2>&1 && echo regkey import success^^!
echo.
powershell runenv/throbr -DurationSeconds 1
set frc=y
if not exist logs\aip.cfg (
    echo 	IP Configuration not found.
    set /p "frc=Is this your first time running AutOx190? [Y/n]: "
    goto :2
)
if not exist logs\adv.cfg (
    echo 	Device ID not set.
    set /p "frc=Is this your first time running AutOx190? [Y/n]: "
    goto :2
)
if not exist logs\dly.cfg (
    echo 	delay File Not Found. 
    set /p "frc=Is this your first time running AutOx190? [Y/n]: "
    goto :2
)
goto :1
:2
echo.
if /i %frc% EQU Y (
    goto :1
)
if /i %frc% NEQ Y (
    echo ^^!^^! Full Configuration not found ^^!^^!
    powershell runenv/throbr -DurationSeconds 2
    :frc1
    cls
    type runenv\ws.cfg
    if not exist logs\aip.cfg (
        set /p "mip=Enter AS/400 server ip: "
        echo.
        echo Server IP set to !mip!
        echo.
        set /p "mipc=Is that correct? [Y/n]: "
        if /i !mipc! NEQ Y (
            goto :frc1
        )
        echo !mip!> logs\aip.cfg
    )
    :frc2
    cls
    type runenv\ws.cfg
    if not exist logs\adv.cfg (
        set /p "mdv=Enter AS/400 device name: "
        echo.
        echo Device Name set to !mdv!
        echo.
        set /p "mdvc=Is that correct? [Y/n]: "
        if /i !mdvc! NEQ Y (
            goto :frc2
        )
        echo !mdv!> logs\adv.cfg
    )
    :frc3
    cls
    type runenv\ws.cfg
    if not exist logs\dly.cfg (
        echo Auto Configure delay? ^(Not Recommended for Thin Clients/Edge Devices^)
        echo.
        set /p "ac=Auto Configure delay? [Y/n]: "
        echo.
        set /p "acc=Are you sure? [Y/n]: "
        if /i !acc! NEQ Y (
            goto :frc3
        )
        :frc4
        cls
        type runenv\ws.cfg
        if /i !ac! EQU N (
            set maxl=300
            echo Set Delay in ms and / or hit Enter:
            echo.
            echo The default is 300 ^(Max ping x3^) But
            echo thin / edge clients may need up to
            echo max ping x9, especially if they are
            echo edge / remote clients;
            echo you have been warned.
            echo.
            set /p "maxl=set delay in ms (default is 300): "
            echo.
            echo Delay set to !maxl!
            echo.
            set /p "maxlc=Is that correct? [Y/n]: "
            if /i !maxlc! NEQ Y (
                goto :frc4
            )
            echo !maxl!> logs\dly.cfg
            echo manual> logs\apd.cfg
        )
    )
)
set /p tip=<logs\aip.cfg
cls
type runenv\ws.cfg
echo 			Server Configuration complete.
echo.
echo 		~~ AutOx190 will no longer ask for this data ~~
echo.
powershell runenv/throbr -DurationSeconds 3
:1
cls
type runenv\ws.cfg
if not exist logs\usr.cfg (
    %log% WARN: usr.cfg Missing>> logs\log.txt
    set /p "usern=Enter AS/400 User: "
) else (
    goto :3
)
%log% STATUS: Save UserName>> logs\log.txt
echo %usern%> logs\usr.cfg && %log% Success.>> logs\log.txt
:3
if not exist logs\ps.cfg (
    %log% WARN: ps.cfg Missing, Querying User>> logs\log.txt
    set /p "passd=Enter AS/400 Password: "
) else (
    goto :4
)
%log% STATUS: Save User Password>> logs\log.txt
echo %passd%> logs\ps.cfg && %log% Success.>> logs\log.txt
:4
cls
type runenv\ws.cfg
if not exist logs\auto.cfg (
    %log% WARN: auto.cfg Missing, Querying User>> logs\log.txt
    set /p "autology=Save User Login? [Y/n]: "
) else (
    goto :5
)
%log% STATUS: Save AutoLogin Status>> logs\log.txt
echo %autology%> logs\auto.cfg && %log% Success.>> logs\log.txt
:5
cls
type runenv\ws.cfg
echo ^^!^^! Preparing to Launch, don't click away ^^!^^!
echo.
%log% STATUS: Load TN5250 Server IP>> logs\log.txt
set /p tip=<logs\aip.cfg && %log% Success.>> logs\log.txt
set maxl=1
if exist logs\apd.cfg (
    set /p apd=<logs\apd.cfg
    if !apd! NEQ manual (
        echo ERROR: AutoIPBench Sytax Error>> logs\log.txt
    )
) else (
    echo Auto Configuring Delay, Please Wait...
    for /f "tokens=9 delims=ms " %%a in ('ping -n 10 %tip% ^| find "Maximum"') do (
        set /a cl=%%a
        if !cl! GTR !maxl! set /a maxl=!cl!
    )
    set /a maxl=!maxl! * 3
    set /a maxl=!maxl! + 50
    echo !maxl!> logs\dly.cfg
)
echo.
echo Launching, Please wait...
powershell runenv/throbr -DurationSeconds 1
%log% STATUS: Minimize Current CMD Window>> logs\log.txt
Powershell -window minimized -command "" && %log% Success.>> logs\log.txt
::
::
%log% STATUS: Load TN5250 Device Name>> logs\log.txt
set /p dv=<logs\adv.cfg && %log% Success.>> logs\log.txt
::
::	--Open TN5250--
%log% STATUS: launch TN5250 With Given Paramters>> logs\log.txt
start runenv\mtn5250 /h %tip% /d %dv% /n "AutOx190" /C10 && %log% Success.>> logs\log.txt
::
%log% STATUS: Launch ver.ps1>> logs\log.txt
::
::	--Launch Powershell script--
start PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './ver.ps1'" && %log% Success.>> logs\log.txt
:: start powershell -NoProfile -ExecutionPolicy Bypass -Window Minimized -Command "& './ver.ps1'" && %log% Success.>> logs\log.txt
:: PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "ver.ps1"'}"
::
::
::
:end
%log% END: init.cmd>> logs\log.txt
endlocal
exit
