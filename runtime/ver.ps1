#	AutOx190 PS verify ver 0.1.3
#
$delay = get-content logs\dly.cfg
$ldelay = [int]$delay * 3
$usrn = get-content logs\usr.cfg -TotalCount 1
$pssd = get-content logs\ps.cfg -TotalCount 1
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('AutOx190')
#	Move focus to AutOx190 ^
#
Add-Type -AssemblyName System.Windows.Forms
#
sleep -milliseconds $delay
[System.Windows.Forms.SendKeys]::SendWait($usrn)
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait($pssd)
#
# [System.Windows.Forms.SendKeys]::SendWait((get-content logs\cache.cfg -TotalCount 2)[-1])
#
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep -milliseconds $delay
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
#
#	Auto login using user input ^
#
#
start-process "ver.cmd"
exit
