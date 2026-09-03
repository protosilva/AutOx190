# AutOx190 Throbber ver 0.1.0
#
# And yes, it's actually called a throbber oficially, ask microslop or sum
#
param(
    [int]$DurationSeconds = 3
)
# please work pretty plz
# update hell yeah called it
try {
    [Console]::CursorVisible = $false
    $frames = @('\', '|', '/', '-')
    $delay = 120
    $stopTime = (Get-Date).AddSeconds($DurationSeconds)
    while((Get-Date) -lt $stopTime) {
        foreach($frame in $frames) {
            Write-Host $frame -NoNewLine
            Start-Sleep -milliseconds $delay
            Write-Host ([char]8) -NoNewline
            if((Get-Date) -ge $stopTime) {
                break
            }
        }
    }
    # Hopefully this adds a new line after the fact but oh well
    # Write-Host "Done `n" 
} finally {
    [Console]::CursorVisible = $true
}
exit
