#	AutOx190 Onfail ver 0.1.3
#
$delay = get-content logs\dly.cfg
$ldelay = [int]$delay * 3
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('AutOx190')
#
#
Add-Type -AssemblyName System.Windows.Forms
#
sleep -milliseconds $ldelay
[System.Windows.Forms.SendKeys]::SendWait("{F3}")
sleep -milliseconds $ldelay
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
