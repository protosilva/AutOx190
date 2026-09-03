$delay = get-content ../../logs/dly.cfg
$ldelay = [int]$delay * 3
#	Add delay to variables ^
#
$date = Get-Date -Format "mm-dd-yyyy_hhmmss"
if (test-path ../../../Output/temp.csv) {
	echo "File found, continuing."
} else {
	New-Item -Path ../../../Output/temp.csv -ItemType File
}
#
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('AutOx190')
#	Switch focus to AutOx190 ^
#
$file = "../../../Input/*.txt"
$lines = Get-Content $file -Raw
$lines = $lines -Split "\r\n"
#	Retrieve File Data ^
#
Add-Type -AssemblyName System.Windows.Forms
#	load module for SendKeys ^
#
$auto = get-content ../../logs/auto.cfg
if ($auto -eq "n") {del ../../logs/usr.cfg, ../../logs/ps.cfg}
#	delete cache files ^
#
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep -milliseconds $delay
for ($var = 1; $var -le 2; $var++) {[System.Windows.Forms.SendKeys]::SendWait("{TAB}")}
[System.Windows.Forms.SendKeys]::SendWait("1")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep -milliseconds $delay
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
[System.Windows.Forms.SendKeys]::SendWait("1")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
sleep -milliseconds $delay
[System.Windows.Forms.SendKeys]::SendWait("{F1}")
#
#
echo "Stock #,Loc 1,Qty 1,Loc 2,Qty 2,Loc 3,Qty 3,Loc 4,Qty 4,Loc 5,Qty 5,Loc 6,Qty 6,">> ../../../Output/temp.csv
echo ",,,,,,,,,,,,,">> ../../../Output/temp.csv
#
#
# foreach ($line in $lines) {
#	sleep -milliseconds $delay
#	for ($var = 1; $var -le 12; $var++) {[System.Windows.Forms.SendKeys]::SendWait("{DEL}")}
#	[System.Windows.Forms.SendKeys]::SendWait("$line")
#	[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
#	$pagecont = $true
#	while ($pagecont) {
#		sleep -milliseconds $delay
#	}
#}
#	Input File Data and Copy Result to Output File ^
#
sleep -milliseconds $delay
[System.Windows.Forms.SendKeys]::SendWait("{F1}")
sleep -milliseconds $ldelay
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
#	Auto Logout to Signify Completion ^
#
Get-Content -Path ../../../Output/temp.csv | Set-Content -Path ../../../Output/$date.csv -encoding UTF8
Remove-Item -path ../../../Output/temp.csv
#
cd ../..
start-process "exit.cmd"
exit
