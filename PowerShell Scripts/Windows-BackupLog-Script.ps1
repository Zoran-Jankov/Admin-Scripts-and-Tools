# Set variables for the log file location and email settings
$LogFile = "\\NETWORK\SHARE\WindowsBackup.log"
$SmtpServer = "smtp.gmail.com"
$SmtpPort = 587
$EmailFrom = "youremail@gmail.com"
$EmailTo = "recipientemail@domain.com"
$EmailSubject = "Windows Backup Event"
$EmailBody = ""

# Set up the SMTP client with SSL encryption and your Gmail account credentials
$SmtpClient = New-Object System.Net.Mail.SmtpClient($SmtpServer, $SmtpPort)
$SmtpClient.EnableSsl = $true
$SmtpClient.Credentials = New-Object System.Net.NetworkCredential($EmailFrom, "yourGmailpassword")

# Set up the event log watcher to monitor the Windows Backup log for critical, error, or warning events
$EventLog = New-Object System.Diagnostics.EventLog("Microsoft-Windows-Backup")
$EventLogFilter = @{LogName="Microsoft-Windows-Backup"; Level=2,3,4}
$EventLogWatcher = New-Object System.Diagnostics.Eventing.Reader.EventLogWatcher($EventLogFilter)

# Define a function to handle new events and log them to the file and send an email if they meet the criteria
function HandleEvent($EventRecord)
{
    $EventLevel = $EventRecord.LevelDisplayName
    $EventMessage = $EventRecord.Message
    $EventTime = $EventRecord.TimeCreated
    $EventID = $EventRecord.Id

    # Log the event to the file
    Add-Content -Path $LogFile -Value "$EventTime - $EventLevel ($EventID): $EventMessage"

    # If the event is critical, error, or warning, compose an email and send it
    if ($EventLevel -eq "Critical" -or $EventLevel -eq "Error" -or $EventLevel -eq "Warning")
    {
        $EmailBody = "Event: $EventLevel`n`nTime: $EventTime`n`nMessage: $EventMessage`n`nEvent ID: $EventID"

        $EmailMessage = New-Object System.Net.Mail.MailMessage($EmailFrom, $EmailTo, $EmailSubject, $EmailBody)
        $SmtpClient.Send($EmailMessage)
    }
}

# Register the event handler function with the event log watcher
Register-ObjectEvent -InputObject $EventLogWatcher -EventName EventRecordWritten -Action {HandleEvent($EventArgs[1])} | Out-Null

# Start the event log watcher and keep the script running
$EventLogWatcher.Start()
while ($true) { Start-Sleep -Seconds 60 }
