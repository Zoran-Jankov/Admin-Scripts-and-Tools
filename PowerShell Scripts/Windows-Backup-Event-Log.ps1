function Send-Notification {
    param (
        $Subject,
        $Body
    )
    process {
        $SMTP = "smtp.company.com"
        $From = "backup-event@.company.com"
        $Password = "PlainTextPassword"
        $To = "sysadmins@company.com"
        $Email = New-Object Net.Mail.SmtpClient($SMTP, 587)
        $Email.EnableSsl = $true
        $Email.Credentials = New-Object System.Net.NetworkCredential($From, $Password)
        $Email.Send($From, $To, $Subject, $Body)
    }
}

$WindowsBackupEvent = Get-WinEvent -LogName "Microsoft-Windows-Backup" -MaxEvents 1
$Timestamp = Get-Date -Date $WindowsBackupEvent.TimeCreated -Format "yyyy.MM.dd. HH:mm:ss:fff"
$Level = $WindowsBackupEvent.LevelDisplayName
$Message = $WindowsBackupEvent.Message
$EventID = $WindowsBackupEvent.Id

$LogEntry = "$Timestamp - [$Level] Server: '$env:COMPUTERNAME' - 'Event ID: [$EventID]' $Message"
Add-Content -Path "\\vega.local\IT Administration\Logs\Windows-Backup-Events.log" -Value $LogEntry

if (($Level -ne "Information") -and ($Level -ne "Verbose")) {
    $Subject = "$Level level Windows Backup event on $env:COMPUTERNAME server"
    $Body = "$LogEntry`n`r`n`rLogin to $env:COMPUTERNAME server to fix the problem."
    Send-Notification -Subject $Subject -Body $Body
}
