# Set variables for source and destination paths
$SourcePath = "C:\Source"
$DestinationPath = "\\network\destination"

# Set variable for log file path and create log file if it doesn't exist
$LogFilePath = "\\network\logs\backuplog.txt"
if (-not (Test-Path $LogFilePath)) {
    New-Item $LogFilePath -ItemType File
}

# Set variable for email parameters
$EmailFrom = "sender@example.com"
$EmailTo = "recipient@example.com"
$EmailSubject = "Backup Report"
$EmailSMTPServer = "smtp.gmail.com"
$EmailSMTPPort = 587
$EmailUsername = "sender@example.com"
$EmailPassword = "password"

# Set up email credentials and SSL encryption
$SecurePassword = ConvertTo-SecureString $EmailPassword -AsPlainText -Force
$EmailCredentials = New-Object System.Management.Automation.PSCredential ($EmailUsername, $SecurePassword)
$EmailSMTP = New-Object Net.Mail.SmtpClient($EmailSMTPServer, $EmailSMTPPort)
$EmailSMTP.EnableSsl = $true
$EmailSMTP.Credentials = $EmailCredentials

# Copy files with robocopy, log every step, and append to log file
$RobocopyOptions = "/E /LOG+:$LogFilePath /TEE /NP /R:1 /W:1"
$RobocopyCommand = "robocopy `"$SourcePath`" `"$DestinationPath`" $RobocopyOptions"
Invoke-Expression $RobocopyCommand

# If any errors occurred during the copy, send email report
if (Select-String $LogFilePath -Pattern "ERROR") {
    $EmailBody = "Errors occurred during backup. Please review the log file at $LogFilePath."
    $EmailMessage = New-Object System.Net.Mail.MailMessage ($EmailFrom, $EmailTo, $EmailSubject, $EmailBody)
    $EmailSMTP.Send($EmailMessage)
}
