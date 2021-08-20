Get-SmbSession | Close-SmbSession -Confirm:$false
Get-SMBOpenFile | Close-SmbOpenFile -Confirm:$false
Set-SmbServerConfiguration -EnableSMB2Protocol $false -Confirm:$false